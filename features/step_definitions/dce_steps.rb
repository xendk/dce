require 'open3'
require 'timeout'

Given(/^I'm in the ([^ ]+) project$/) do |project|
  raise "Already in a project" if @project
  @old_dir = Dir.pwd
  Dir.chdir "features/fixtures/#{project}"
  system "docker-compose up -d 2>/dev/null" or raise "Could not start project #{project}"
  @project = project
end

When(/^I run "([^"]*)"$/) do |command|
  Timeout::timeout 2 do
    @stdout, @stderr, @status = Open3.capture3(command)
    # Deal with carriage returns and trailing newline.
    @stdout = @stdout.chomp.gsub(/\r\n/, "\n")
    @stderr = @stderr.chomp.gsub(/\r\n/, "\n")
  end
end

Then(/^I should see the output$/) do |string|
  raise "Output \"#{@stdout}\" does not match expected output" unless @stdout === string
end

After do
  system "docker-compose stop -t 0  2>/dev/null; docker-compose rm -vf  >/dev/null 2>/dev/null" if @project
  Dir.chdir(@old_dir) if @old_dir
end
