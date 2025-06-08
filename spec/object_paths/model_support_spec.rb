# frozen_string_literal: true

require 'spec_helper'
require 'object_paths/model_support'

RSpec.describe ObjectPaths::ModelSupport do
  let(:dummy_sub_class) do
    Class.new do
      attr_accessor :the_answer

      def initialize(the_answer)
        self.the_answer = the_answer
      end
    end
  end

  let(:dummy_class) do
    sub_model_class = dummy_sub_class
    Class.new do
      include ObjectPaths::ModelSupport

      attr_accessor :sub_model

      define_method(:initialize) do
        self.sub_model = sub_model_class.new(42)
      end
    end
  end

  let(:object) { dummy_class.new }

  describe '#object_path' do
    let :string_path do
      object.object_path('sub_model/the_answer')
    end
    let :array_path do
      object.object_path(%w[sub_model the_answer])
    end

    it 'returns an ObjectPath for a given string' do
      expect(string_path).to be_a(ObjectPaths::ObjectPath)
    end

    it 'returns the correct path steps' do
      expect(string_path.path_steps).to eq(%w[sub_model the_answer])
    end

    it 'returns an ObjectPath for a given array' do
      expect(array_path).to be_a(ObjectPaths::ObjectPath)
    end

    it 'returns the correct path steps for an array' do
      expect(array_path.path_steps).to eq(%w[sub_model the_answer])
    end

    context 'when initialized with anything other that a String, Array or ObjectPath' do
      it 'raises an IllegalObjectPathDefinitionType' do
        expect { object.object_path(42) }.to raise_error(ObjectPaths::Errors::IllegalObjectPathDefinitionType)
      end
    end
  end

  describe '#object_path!' do
    context 'when given a String path' do
      it 'returns an the resolution of the path' do
        expect(object.object_path!('sub_model/the_answer')).to eq(42)
      end

      it 'returns nil if the path does not exist' do
        expect(object.object_path!('sub_model/non_existent')).to be_nil
      end
    end

    context 'when given an Array path' do
      it 'returns the resolution of the path' do
        expect(object.object_path!(%w[sub_model the_answer])).to eq(42)
      end

      it 'returns nil if the path does not exist' do
        expect(object.object_path!(%w[sub_model non_existent])).to be_nil
      end
    end

    context 'when given an ObjectPath' do
      it 'returns the resolution of the path' do
        expect(object.object_path!(ObjectPaths::ObjectPath.new('sub_model/the_answer'))).to eq(42)
      end

      it 'returns nil if the path does not exist' do
        expect(object.object_path!(ObjectPaths::ObjectPath.new('sub_model/non_existent'))).to be_nil
      end
    end

    context 'when given an invalid path type' do
      it 'raises an IllegalObjectPathDefinitionType' do
        expect { object.object_path!(42) }.to raise_error(ObjectPaths::Errors::IllegalObjectPathDefinitionType)
      end
    end
  end

  describe '.object_path' do
    let :string_path do
      dummy_class.object_path('sub_model/the_answer')
    end
    let :array_path do
      dummy_class.object_path(%w[sub_model the_answer])
    end

    it 'returns an ObjectPath for a given string' do
      expect(string_path).to be_a(ObjectPaths::ObjectPath)
    end

    it 'returns the correct path steps' do
      expect(string_path.path_steps).to eq(%w[sub_model the_answer])
    end

    it 'returns an ObjectPath for a given array' do
      expect(array_path).to be_a(ObjectPaths::ObjectPath)
    end

    it 'returns the correct path steps for an array' do
      expect(array_path.path_steps).to eq(%w[sub_model the_answer])
    end

    context 'when initialized with anything other that a String, Array or ObjectPath' do
      it 'raises an IllegalObjectPathDefinitionType' do
        expect { dummy_class.object_path(42) }.to raise_error(ObjectPaths::Errors::IllegalObjectPathDefinitionType)
      end
    end
  end
end
