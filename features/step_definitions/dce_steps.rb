require 'open3'
require 'timeout'
require 'fileutils'
require 'tmpdir'

def run(command)
  Timeout::timeout 2 do
    stdout, stderr, status = Open3.capture3(command)
    # Deal with carriage returns and trailing newline.
    stdout = stdout.chomp.gsub(/\r\n/, "\n")
    stderr = stderr.chomp.gsub(/\r\n/, "\n")
    return stdout, stderr, status
  end
end

def ensure_ssh
  unless @home
    @home = Dir.mktmpdir
    ENV['HOME'] = @home
    Dir.mkdir File.join(@home, '.ssh')
  end
end

Given(/^I'm in the ([^ ]+) project$/) do |project|
  raise "Already in a project" if @project
  @old_dir = Dir.pwd
  Dir.chdir "features/fixtures/#{project}"
  system "docker-compose up -d 2>/dev/null" or raise "Could not start project #{project}"
  @project = project
end

Given(/^it has ([^ ]+) installed$/) do |shell|
  stdout, = run("dce install-#{shell}")
  stdout.match(/Installed #{shell}/) or raise "Could not 'install' shell #{shell}"
end

When(/^I run "([^"]*)"$/) do |command|
  @stdout, @stderr, @status = run(command)
end

Then(/^I should see the output$/) do |output|
  raise "Output \"#{@stdout}\" does not match expected output" unless @stdout === output
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

Then(/^the output of "([^"]*)" should be$/) do |command, output|
  @stdout, @stderr, @status = run(command)
  raise "Output \"#{@stdout}\" does not match expected output" unless @stdout === output
end

Given(/^I have a "([^"]*)" ssh key$/) do |key|
  ensure_ssh
  File.write(File.join(@home, '.ssh', key), "#{key} file\n")
end

Given(/^I have a "([^"]*)" directory in my ssh directory$/) do |dir|
  ensure_ssh

  Dir.mkdir File.join(@home, '.ssh', dir)
end


After do
  system "docker-compose stop -t 0  2>/dev/null; docker-compose rm -vf  >/dev/null 2>/dev/null" if @project
  Dir.chdir(@old_dir) if @old_dir
  FileUtils.rm_r @home if @ssh
  raise "Unexpected stderr output: #{@stderr}" unless @stderr.empty?
end
