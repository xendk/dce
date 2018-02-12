
File.join(Dir.pwd, 'bin')
ENV['PATH'] = File.join(Dir.pwd, 'bin') + ':' + ENV['PATH']

ENV['COVERAGE'] = '1' if ENV['TRAVIS']

if ENV['COVERAGE']
  at_exit do
    require 'simplecov'
    SimpleCov.start

    if ENV['TRAVIS']
      require 'codecov'
      SimpleCov.formatter = SimpleCov::Formatter::Codecov
    end
  end
end
