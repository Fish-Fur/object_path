# frozen_string_literal: true

require 'spec_helper'
require 'object_paths/object_path'

RSpec.describe ObjectPaths::ObjectPath do
  let(:dummy_sub_class) do
    Class.new do
      attr_accessor :the_answer

      def initialize(the_answer)
        self.the_answer = the_answer
      end

      def the_answer_indirect
        the_answer + 1
      end
    end
  end

  let(:dummy_class) do
    sub_model_class = dummy_sub_class
    Class.new do
      attr_accessor :sub_model, :sub_models

      define_method(:initialize) do
        self.sub_model = sub_model_class.new(42)
        self.sub_models = [
          sub_model_class.new(47),
          sub_model_class.new(47.11),
          sub_model_class.new('TARDIS')
        ]
      end
    end
  end

  let(:object) { dummy_class.new }

  describe '#initialize' do
    context 'when initialized with a existing ObjectPath' do
      original_path = described_class.new('sub_models/the_answer')
      path = described_class.new(original_path)
      it 'creates a new ObjectPath with the same path steps' do
        expect(path).to be_a(described_class)
      end

      it 'copies the path steps from the original ObjectPath' do
        expect(path.path_steps).to eq(original_path.path_steps)
      end
    end
  end

  describe '#path_steps' do
    it 'returns the path steps as an Array' do
      path = described_class.new('sub_model/the_answer')
      expect(path.path_steps).to eq(%w[sub_model the_answer])
    end
  end

  describe '#resolve' do
    context 'when initializing with a String path' do
      it 'retrieves attributes' do
        path = described_class.new('sub_model/the_answer')
        expect(path.resolve(object)).to eq(42)
      end

      it 'retrieves method results' do
        path = described_class.new('sub_model/the_answer_indirect')
        expect(path.resolve(object)).to eq(43)
      end

      it 'retrieves arrays' do
        path = described_class.new('sub_models/the_answer')
        expect(path.resolve(object)).to eq([47, 47.11, 'TARDIS'])
      end
    end

    context 'when initializing with an Array path' do
      it 'retrieves attributes' do
        path = described_class.new(%w[sub_model the_answer])
        expect(path.resolve(object)).to eq(42)
      end

      it 'retrieves method results' do
        path = described_class.new(%w[sub_model the_answer_indirect])
        expect(path.resolve(object)).to eq(43)
      end

      it 'retrieves arrays' do
        path = described_class.new(%w[sub_models the_answer])
        expect(path.resolve(object)).to eq([47, 47.11, 'TARDIS'])
      end
    end
  end

  describe '#human' do
    context 'when initializing with a String path' do
      it 'returns a human-readable string representation of the path' do
        path = described_class.new('sub_model/the_answer')
        expect(path.human(dummy_class)).to eq('sub_model > the_answer')
      end
    end

    context 'when initializing with an Array path' do
      it 'returns a human-readable string representation of the path' do
        path = described_class.new(%w[sub_model the_answer])
        expect(path.human(dummy_class)).to eq('sub_model > the_answer')
      end
    end
  end
end
