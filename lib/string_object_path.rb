# frozen_string_literal: true

# Extends the String class to include a method that converts a string to an ObjectPath
class String
  # Converts a string to an ObjectPath
  #
  # +Returns_ (ObjectPaths::ObjectPath) = the ObjectPath representation of the string
  #
  # Example:
  #  'sub_model/the_answer'.to_object_path
  #  # => #<ObjectPaths::ObjectPath:0x00007f8f9b0b3b08 @path_steps=["sub_model", "the_answer"]>
  #
  # _See_ *ObjectPaths::ObjectPath*
  def to_object_path
    ObjectPaths::ObjectPath.new(self)
  end
end
