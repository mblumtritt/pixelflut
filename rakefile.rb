require 'bundler/gem_tasks'

task(:default) { exec "#{$PROGRAM_NAME} --tasks" }
