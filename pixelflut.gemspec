# frozen_string_literal: true

require_relative 'lib/pixelflut/version'

Gem::Specification.new do |spec|
  spec.name = 'pixelflut'
  spec.version = Pixelflut::VERSION
  spec.summary = 'A fast Pixelflut client written in Ruby.'
  spec.description = <<~DESCRIPTION
    Based on the idea of a simple server protocol to collaborate on a shared
    canvas named [Pixelflut](https://cccgoe.de/wiki/Pixelflut) this gem
    implements a fast Ruby client version.
  DESCRIPTION

  spec.author = 'Mike Blumtritt'
  spec.homepage = 'https://github.com/mblumtritt/pixelflut'
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 2.7.2'
  spec.add_runtime_dependency 'chunky_png'

  spec.executables = %w[pxf]
  spec.files = Dir['lib/**/*']
  spec.extra_rdoc_files = %w[README.md LICENSE]
end
