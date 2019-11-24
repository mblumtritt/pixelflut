# frozen_string_literal: true

require_relative 'lib/pixelflut/version'

GemSpec = Gem::Specification.new do |spec|
  spec.name = 'pixelflut'
  spec.version = Pixelflut::VERSION
  spec.summary = 'A fast Pixelflut client written in Ruby.'
  spec.description = <<~DESCRIPTION
    Based on the idea of a simple server protocol to collaborate on a shared canvas named
    [Pixel Flut](https://cccgoe.de/wiki/Pixelflut) this gem implements a fast Ruby client version.
  DESCRIPTION
  spec.author = 'Mike Blumtritt'
  spec.email = 'mike.blumtritt@pm.me'
  spec.homepage = 'https://github.com/mblumtritt/pixelflut'
  spec.metadata = {
    'source_code_uri' => 'https://github.com/mblumtritt/pixelflut',
    'bug_tracker_uri' => 'https://github.com/mblumtritt/pixelflut/issues'
  }
  spec.rubyforge_project = spec.name

  spec.add_runtime_dependency 'rmagick'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.platform = Gem::Platform::RUBY
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  spec.required_ruby_version = '>= 2.5.0'

  spec.require_paths = %w[lib]
  spec.bindir = 'bin'
  spec.executables =
    Dir
    .glob(File.expand_path('../bin/*', __FILE__))
    .map!{ |fn| File.basename(fn) }

  all_files = %x(git ls-files -z).split(0.chr)
  spec.test_files = all_files.grep(%r{^(spec|test)/})
  spec.files = all_files - spec.test_files

  spec.extra_rdoc_files = %w[README.md]
end
