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
    # Deal with carriage returns and trailing newline.
    @output = %x(#{command}).chomp.gsub(/\r\n/, "\n")
  end
end

Then(/^I should see the output$/) do |string|
  raise "Output \"#{@output}\" does not match expected output" unless @output === string
end

After do |scenario|
  system "docker-compose stop -t 0  2>/dev/null; docker-compose rm -vf  >/dev/null 2>/dev/null" if @project
  Dir.chdir(@old_dir) if @old_dir
end
