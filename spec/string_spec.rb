# frozen_string_literal: true

require 'spec_helper'
require 'object_paths/object_path'

RSpec.describe String do
  describe '#to_object_path' do
    path = 'sub_model/the_answer'.to_object_path
    it 'converts a string to an ObjectPath' do
      expect(path).to be_a(ObjectPaths::ObjectPath)
    end

    it 'returns the correct path steps' do
      expect(path.path_steps).to eq(%w[sub_model the_answer])
    end
  end
end
