require 'open3'
require 'timeout'

def filter_output(string)
  lines = string.chomp.split(/\r\n/)
  (lines.nil? or lines.empty?) ? "" : lines.join("\n")
end

def run(command)
  Timeout::timeout 2 do
    stdout, stderr, status = Open3.capture3(command)
    # Deal with carriage returns and trailing newline.
    stdout = filter_output(stdout)
    stderr = filter_output(stderr)
    return stdout, stderr, status
  end
end

Given(/^I'm in the ([^ ]+) project$/) do |project|
  raise "Already in a project" if @project
  @old_dir = Dir.pwd
  Dir.chdir "features/fixtures/#{project}"
  system "docker compose up -d 2>/dev/null" or raise "Could not start project #{project}"
  @project = project
end

Given(/^it has ([^ ]+) installed$/) do |shell|
  stdout, = run("dce install-#{shell}")
  stdout.match(/Installed #{shell}/) or raise "Could not 'install' shell #{shell}"
end

When(/^I run "([^"]*)"$/) do |command|
  @stdout, @stderr, @status = run(command)
end

Then(/^I should see the output$/) do |string|
  raise "Output \"#{@stdout}\" does not match expected output" unless @stdout === string
end

Then(/^I should see the error output$/) do |string|
  raise "Stderr output \"#{@stderr}\" does not match expected output" unless @stderr === string
  @stderr = ''
end

Then(/^I should see the verbose command message$/) do
  raise "No verbose message seen" unless @stderr.match(/^Exec'ing: docker exec/)
  @stderr.gsub!(/^Exec'ing: docker exec.*$/, '');
end

Then(/^I should see no output$/) do
  raise "Unexpected output \"#{@stdout}\"" unless @stdout == ""
end

Then(/^I should only see verbose command message$/) do
  unless @stderr.match(/^Exec'ing: docker exec/) and @stdout.lines.size == 1
    raise "Output \"#{@stderr}\" isn't just the verbose message"
  end
  @stderr.gsub!(/^Exec'ing: docker exec.*$/, '');
end

Given("I have stopped and removed containers") do
  system "docker compose stop -t 0  2>/dev/null; docker compose rm -vf  >/dev/null 2>/dev/null" if @project
end

After do
  system "docker compose stop -t 0  2>/dev/null; docker compose rm -vf  >/dev/null 2>/dev/null" if @project
  Dir.chdir(@old_dir) if @old_dir
  raise "Unexpected stderr output: #{@stderr}" unless @stderr.empty?
end
