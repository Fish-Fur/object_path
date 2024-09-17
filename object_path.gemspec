# frozen_string_literal: true

require File.expand_path('lib/object_paths/version', __dir__)

Gem::Specification.new do |spec|
  spec.name                  = 'object_path'
  spec.version               = ObjectPaths::VERSION
  spec.authors               = ['Drew Thorp']
  spec.email                 = ['gems@fishfur.com']
  spec.summary               = 'Object representing a path through an object graph.'
  spec.description           = 'Also the create of an object that hold the steps through an ' \
                               'object graph to retrieve a value(s).'
  spec.homepage              = 'https://github.com/Fish-Fur/object_path'
  spec.license               = 'Apache-2.0'
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 3.3.0'
  spec.files = Dir[
    'README.md', 'LICENSE',
    'CHANGELOG.md', 'lib/**/*.rb',
    'lib/**/*.rake',
    'object_path.gemspec', '.github/*.md',
    'Gemfile', 'Rakefile'
  ]
  spec.extra_rdoc_files = ['README.md']
  spec.add_development_dependency 'rubocop', '~> 1.6'
end
