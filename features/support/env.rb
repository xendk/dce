# frozen_string_literal: true

File.join(Dir.pwd, 'bin')
ENV['PATH'] = "#{File.join(Dir.pwd, 'bin')}:#{ENV['PATH']}"

ENV['COVERAGE'] = '1' if ENV['GITHUB_ACTION']

if ENV['COVERAGE']
  at_exit do
    require 'simplecov'
    SimpleCov.start

    if ENV['GITHUB_ACTION']
      require 'simplecov-cobertura'
      SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
    end
  end
end
