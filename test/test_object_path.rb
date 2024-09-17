# frozen_string_literal: true

require 'minitest/autorun'
require 'object_paths/object_path'

class ObjectPathTest < Minitest::Test
  class ObjectPathTestSubclass
    attr_accessor :the_answer

    def initialize(the_answer)
      self.the_answer = the_answer
    end

    def the_answer_indirect
      the_answer + 1
    end
  end

  class ObjectPathTestClass
    attr_accessor :sub_model, :sub_models

    def initialize
      self.sub_model = ObjectPathTestSubclass.new(42)
      self.sub_models = [
        ObjectPathTestSubclass.new(47),
        ObjectPathTestSubclass.new(47.11),
        ObjectPathTestSubclass.new('TARDIS')
      ]
    end
  end

  def setup
    @object = ObjectPathTestClass.new
  end

  # ObjectPaths can retrieve attributes using a String path
  def test_object_paths_can_retrieve_attributes_using_a_string_path
    path = ObjectPaths::ObjectPath.new('sub_model/the_answer')
    assert_equal 42, path.resolve(@object)
  end

  # ObjectPaths can retrieve method result using a String path
  def test_object_paths_can_retrieve_method_result_using_a_string_path
    path = ObjectPaths::ObjectPath.new('sub_model/the_answer_indirect')
    assert_equal 43, path.resolve(@object)
  end

  # ObjectPaths can retrieve Array using an String path
  def test_object_paths_can_retrieve_array_using_a_string_path
    path = ObjectPaths::ObjectPath.new('sub_models/the_answer')
    assert_equal [47, 47.11, 'TARDIS'], path.resolve(@object)
  end

  # ObjectPaths can retrieve attribute using an Array path
  def test_object_paths_can_retrieve_attribute_using_an_array_path
    path = ObjectPaths::ObjectPath.new(%w[sub_model the_answer])
    assert_equal 42, path.resolve(@object)
  end

  # ObjectPaths can retrieve method result using an Array path
  def test_object_paths_can_retrieve_method_result_using_an_array_path
    path = ObjectPaths::ObjectPath.new(%w[sub_model the_answer_indirect])
    assert_equal 43, path.resolve(@object)
  end

  # ObjectPaths can retrieve Array using an Array path
  def test_object_paths_can_retrieve_array_using_an_array_path
    path = ObjectPaths::ObjectPath.new(%w[sub_models the_answer])
    assert_equal [47, 47.11, 'TARDIS'], path.resolve(@object)
  end

  # ObjectPaths can retrieve result using a, existing ObjectPath
  def test_object_paths_can_retrieve_result_using_an_existing_object_path
    original_path = ObjectPaths::ObjectPath.new('sub_models/the_answer')
    path = ObjectPaths::ObjectPath.new(original_path)
    assert_equal [47, 47.11, 'TARDIS'], path.resolve(@object)
  end

  # ObjectPaths can be converted into a human readable form
  def test_object_paths_can_be_converted_into_a_human_readable_form
    path = ObjectPaths::ObjectPath.new('sub_model/the_answer')
    assert_equal 'sub_model > the_answer', path.human(ObjectPathTestClass)
  end

  # String objects can be converted into ObjectPaths
  def test_string_objects_can_be_converted_into_object_paths
    path = 'sub_model/the_answer'.to_object_path
    assert_equal 42, path.resolve(@object)
  end

  # Array objects can be converted into ObjectPaths
  def test_array_objects_can_be_converted_into_object_paths
    path = %w[sub_model the_answer].to_object_path
    assert_equal 42, path.resolve(@object)
  end
end
