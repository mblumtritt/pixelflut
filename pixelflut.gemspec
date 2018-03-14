# frozen_string_literal: true

require File.expand_path('../lib/pixelflut/version', __FILE__)

GemSpec = Gem::Specification.new do |spec|
  spec.name = 'pixelflut'
  spec.version = Pixelflut::VERSION
  spec.summary = 'A Pixelflut server & client tool collection written in Ruby.'
  spec.description = <<~EOS
    Based on the idea of a simple server protocol to collaborate on a shared canvas named
    [Pixel Flut](https://cccgoe.de/wiki/Pixelflut) this gem implements a Ruby version.
  EOS
  spec.author = 'Mike Blumtritt'
  spec.email = 'mike.blumtritt@invision.de'
  spec.homepage = 'https://github.com/mblumtritt/pixelflut'
  spec.metadata = {'issue_tracker' => 'https://github.com/mblumtritt/pixelflut/issues'}
  spec.rubyforge_project = spec.name

  spec.add_runtime_dependency 'gosu', '>= 0.13.2'
  spec.add_development_dependency 'bundler', '>= 1.16.0'
  spec.add_development_dependency 'rake', '>= 12.3.0'

  spec.platform = Gem::Platform::RUBY
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  spec.required_ruby_version = '>= 2.5.0'

  spec.require_paths = %w[lib]
  spec.bindir = 'bin'
  spec.executables = Dir.glob(File.expand_path('../bin/*', __FILE__)).map!{ |fn| File.basename(fn) }

  all_files = %x(git ls-files -z).split(0.chr)
  spec.test_files = all_files.grep(%r{^(spec|test)/})
  spec.files = all_files - spec.test_files

  spec.has_rdoc = false
  spec.extra_rdoc_files = %w[README.md]
end
