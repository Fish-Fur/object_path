# frozen_string_literal: true

# Extends the Array class to include a method that converts an array to an ObjectPath
class Array
  # Converts an array to an ObjectPath
  #
  # +Returns_ (ObjectPaths::ObjectPath) = the ObjectPath representation of the array
  #
  # Example:
  #   %w[sub_model the_answer].to_object_path
  #   # => #<ObjectPaths::ObjectPath:0x00007f8f9b0b3b08 @path_steps=["sub_model", "the_answer"]>
  #
  # _See_ *ObjectPaths::ObjectPath*
  def to_object_path
    ObjectPaths::ObjectPath.new(self)
  end
end
