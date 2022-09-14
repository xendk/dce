# frozen_string_literal: true

File.join(Dir.pwd, 'bin')
ENV['PATH'] = "#{File.join(Dir.pwd, 'bin')}:#{ENV['PATH']}"

ENV['COVERAGE'] = '1' if ENV['GITHUB_ACTION']

# See .simplecov file for setup.
require 'simplecov' if ENV['COVERAGE']
