# frozen_string_literal: true

unless SimpleCov.running
  # Use Cobertura formatter in Github Actions so CodeCov can parse it.
  require 'simplecov-cobertura' if ENV['GITHUB_ACTION']

  SimpleCov.start do
    # Suppress error message about aborting due to script exiting with
    # an error. Our SimpleCov.at_exit in bin/dce has merged the
    # coverage anyway.
    SimpleCov.print_error_status = false
    command_name "DCE pid #{Process.pid}"
    root File.dirname(__FILE__)
    formatter SimpleCov::Formatter::CoberturaFormatter if ENV['GITHUB_ACTION']
  end
end
