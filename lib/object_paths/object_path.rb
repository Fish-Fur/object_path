# frozen_string_literal: true

require_relative 'errors'
require 'string_object_path'
require 'array_object_path'

module ObjectPaths
  # = Object \Graph \Resolver
  #
  # Represents a path to a value in an object graph.  The steps in the path can be attributes,
  # methods, or associations.  The path can be resolved to get the value(s) at the end of the path.
  # If any step in the path is nil, the path resolves to nil.  If the step results in an array, the
  # next step is applied to each element of the array, and the results are flattened.
  #
  # When initializing a ObjectPath, the path can be defined as an array of strings or symbols, a string
  # with the steps separated by slashes, or another ObjectPath.
  #
  # To resolve a ObjectPath, call the resolve method with the root object to start from.  The result
  # will be the value at the end of the path, or an array of values if the path resolves to an array.
  #
  # Example:
  #  class Person
  #    attr_accessor :name, :address
  #  end
  #
  #  class Address
  #    attr_accessor :street, :city
  #  end
  #
  #  person = Person.new
  #  person.name = 'John Doe'
  #  address = Address.new
  #  address.street = '123 Main St'
  #  address.city = 'Anytown'
  #  person.address = address
  #
  #  path = ObjectPaths::ObjectPath.new(%i[address city])
  #  path.resolve(person) # => 'Anytown'
  #
  #  path = ObjectPaths::ObjectPath.new('address/city')
  #  path.resolve(person) # => 'Anytown'
  #
  #  path = ObjectPaths::ObjectPath.new('address/name')
  #  path.resolve(person) # => nil
  class ObjectPath
    attr_reader :path_steps

    # Initializes a ObjectPath with a path definition.  The path definition can be an array of strings or
    # symbols, a string with the steps separated by slashes, or another ObjectPath.
    #
    # Arguments:
    #   +path_definition+ (Array, String, ObjectPath) - The definition of the path.
    def initialize(path_definition)
      case path_definition
      when Array
        @path_steps = path_definition.map(&:to_s)
      when String
        @path_steps = path_definition.split('/')
      when ObjectPath
        @path_steps = path_definition.path_steps
      else
        raise ObjectPaths::Errors::IllegalObjectPathDefinitionType
      end
    end

    # Resolves the path to the value(s) at the end of the path.  If any step in the path is nil, the
    # path resolves to nil.  If the step results in an array, the next step is applied to each
    # element of the array, and the results are flattened.
    #
    # Arguments:
    #   +object+ (Object) - The object to start resolving the path from.
    #
    # _Returns_ (Object) - The value at the end of the path, or an array of values if the path
    # resolves to an array.
    def resolve(object)
      resolve_step(object, path_steps)
    end

    # Returns a human readable representation of the path.  The steps in the path are converted to
    # human readable attribute names using the human_attribute_name method of the class.
    #
    # +klass+ (Class) - The class to use for humanizing the attribute names.
    #
    # _Returns_ (String) - The human readable representation of the path.
    def human(klass)
      path_steps.map do |step|
        readable_attribute_name(klass, step)
      end.join(' > ')
    end

    private

    # Returns a human readable representation of an attribute name.  If the class does not respond
    # to human_attribute_name, the attribute name is returned as a string.
    #
    # +klass+ (Class) - The class to use for humanizing the attribute names.
    # +attribute+ (String) - The attribute name to humanize.
    #
    # _Returns_ (String) - The human readable representation of the attribute name.
    def readable_attribute_name(klass, attribute)
      return attribute.to_s unless klass.respond_to?(:human_attribute_name)

      klass.human_attribute_name(attribute)
    end

    # Resolves a step in the path.  If the object does not respond to the method or attribute in the
    # step, the path resolves to nil.  If the result of the step is an array, the next step is
    # applied to each element of the array, and the results are flattened.
    #
    # +object+ (Object) - The object to resolve the step on.
    # +sub_path+ (Array) - The remaining steps in the path to resolve.
    #
    # _Returns_ (Object) - The value at the end of the path, or an array of values if the path
    # resolves to an array.
    def resolve_step(object, sub_path)
      return nil unless object.respond_to?(sub_path.first)

      result = object.send(sub_path.first)
      sub_path = sub_path.drop(1)
      return result if result.nil? || sub_path.empty?

      return resolve_step(result, sub_path) unless result.is_a?(Enumerable)

      resolve_collection_step(result, sub_path)
    end

    # Resolves a step in the path when the result of the step is an array.  The next step is applied
    # to each element of the array, and the results are flattened.
    #
    # +object+ (Object) - The array to resolve the step on.
    # +sub_path+ (Array) - The remaining steps in the path to resolve.
    #
    # _Returns_ (Array) - The array of values at the end of the path.
    def resolve_collection_step(object, sub_path)
      return unless object.is_a?(Enumerable)

      result = object.map { |item| resolve_step(item, sub_path) }.flatten.compact
      result.empty? ? [] : result
    end
  end
end
