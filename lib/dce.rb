# Wishlist:
# Option to delete .dce_container.
# Option for using run instead of exec?

class DCE
  # Run the command
  def run
    parse_args

    @conf_file = File.join(File.dirname(docker_compose_file), '.dce_container')
    config_container = nil
    if File.exists? @conf_file
      config_container = File.read @conf_file
    end

    if @list_containers
      STDOUT.puts(get_containers.join(', '))
      exit
    end

    if @query
      if config_container
        STDOUT.puts(config_container)
        exit
      else
        abort "No container saved."
      end
    end

    if !@container
      @container = config_container ? config_container : query_container
    end

    if @container != config_container
      File.write(@conf_file, @container)
    end

    # If no command given, open a shell.
    if (@command.strip.empty?)
      @command = "if [ -e /usr/bin/fish ]; then /usr/bin/fish; elif [ -e /bin/bash ]; then /bin/bash; else /bin/sh; fi"
    end

    args = '-i'
    args += 't' if STDIN.tty?
    container_id = %x{docker-compose ps -q #{@container}}.chomp

    abort("Container #{@container} not created.") if container_id.empty?

    command = "docker exec #{args} #{container_id} sh -c '#{@command}'"
    STDERR.puts "Exec'ing: " + command if @verbose
    exec command unless @dry_run
  end

  # Return path to the docker-compose.yml file
  # Will exit with an error if not found
  def docker_compose_file
    unless @compose_file
      dir = Dir.pwd()
      while dir != "/"
        file = File.join(dir, 'docker-compose.yml')
        if FileTest.exists?(file)
          @compose_file = file
          break;
        end
        dir = File.dirname(dir)
      end

      if !@compose_file
        abort "No docker-compose.yml file found."
      end
    end

    return @compose_file
  end

  # Parse command line arguments
  def parse_args
    # Not using a proper option parse library, as it will get confused
    # by options for the command given. We use a simple parser.
    while /^-/ =~ ARGV[0]
      option = ARGV.shift
      case option
      when '-c', '--container'
        @container = ARGV.shift
        if !get_containers.include? @container
          abort "Unknown container #{@container}"
        end
      when '-v', '--verbose'
        @verbose = true
      when '-n', '--dry-run'
        @verbose = true
        @dry_run = true
      when '-?', '--print-service'
        @query = true
      when '-l', '--list-containers'
        @list_containers = true
      when '-h', '--help'
        STDERR.puts <<-HEREDOC
Usage: #{File.basename($0)} [OPTIONS]... COMMAND
Runs COMMAND in docker-compose container.

On first run, asks for the service container to use and saves it to .dce_container next
to the docker-compose.yml file.

If no command given, opens a shell.

Options:
  -c, --container SERVICE     use the container of the specified service
                              replaces the selected container in the .dce_container
  -v, --verbose               print exec'ed command
  -n, --dry-run               only print exec'ed command, don't run
  -?, --print-service         print the service saved
  -l, --list-containers       print the containers available
  -h, --help                  print this help and exit

        HEREDOC
        exit
      else
        abort "Unknown option #{option}"
      end
    end

    @command = ARGV.join(' ')
  end

  # Ask the user to select a container
  # The options are taken from the docker-compose.yml file
  def query_container
    containers = get_containers
    STDERR.puts "Please select container [#{containers.join(', ')}]"
    choice = STDIN.gets.strip
    exit if choice.empty?
    if !containers.include?(choice)
      abort "Illegal choice."
    end
    choice
  end

  # Read containers from docker-compose.yml
  def get_containers
    content = YAML::load(File.read(docker_compose_file))
    content.has_key?('version') ? content['services'].keys : content.keys
  end
end
