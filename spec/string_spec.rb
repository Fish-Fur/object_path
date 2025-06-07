# frozen_string_literal: true

require 'spec_helper'
require 'string_object_path'

RSpec.describe String do
  describe '#to_object_path' do
    it 'converts a string to an ObjectPath' do
      path = 'sub_model/the_answer'.to_object_path
      expect(path).to be_a(ObjectPaths::ObjectPath)
      expect(path.path_steps).to eq(%w[sub_model the_answer])
    end
  end
end
