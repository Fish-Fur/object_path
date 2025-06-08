# frozen_string_literal: true

require 'object_paths/object_path'

module ObjectPaths
  # Adds convenience & helper  methods to to models, classes and modules to ease the creation, use
  # and resolution of ObjectPaths.
  module ModelSupport
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Adds a convenience method to the object level for creating ObjectPaths.
    #
    # @param path_definition [String, Array] The path definition to convert into an ObjectPath.
    # @return [ObjectPaths::ObjectPath] The created ObjectPath.
    def object_path(path_definition)
      ObjectPaths::ObjectPath.new(path_definition)
    end

    # Resolves the ObjectPath against the current object.
    #
    # @param path_definition [String, Array] The path definition to resolve.
    # @return [Object, nil] The resolved object or nil if the path cannot be resolved.
    def object_path!(path_definition)
      object_path(path_definition)&.resolve(self)
    end

    # ClassMethods module provides class-level methods for ObjectPaths.
    module ClassMethods
      # Adds a convenience method to the class level for creating ObjectPaths.
      #
      # @param path_definition [String, Array] The path definition to convert into an ObjectPath.
      # @return [ObjectPaths::ObjectPath] The created ObjectPath.
      def object_path(path_definition)
        ObjectPaths::ObjectPath.new(path_definition)
      end
    end
  end
end
