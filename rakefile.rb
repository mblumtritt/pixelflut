# frozen_string_literal: true

require 'bundler/gem_tasks'

$stdout.sync = $stderr.sync = true
task(:default) { exec 'rake --tasks' }
