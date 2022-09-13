# frozen_string_literal: true

# Wishlist:
# Option to delete .dce_container.
# Option for using run instead of exec?

# The dce commmand class.
class DCE
  # Run the command
  def run
    parse_args

    @conf_file = File.join(File.dirname(docker_compose_file), '.dce_container')
    config_container = nil
    config_container = File.read(@conf_file) if File.exist? @conf_file

    if @list_containers
      $stdout.puts(containers.join(', '))
      exit
    end

    if @query
      if config_container
        $stdout.puts(config_container)
        exit
      else
        abort 'No container saved.'
      end
    end

    @container ||= config_container || query_container

    File.write(@conf_file, @container) if @container != config_container

    # If no command given, open a shell.
    if @command.strip.empty?
      @command = 'if [ -e /usr/bin/fish ]; then /usr/bin/fish; elif [ -e /bin/bash ]; then /bin/bash; else /bin/sh; fi'
    end

    args = '-i'
    args += 't' if $stdin.tty?
    container_id = `docker-compose ps -q #{@container}`.chomp

    abort("Container #{@container} not created.") if container_id.empty?

    command = "docker exec #{args} #{container_id} sh -c '#{@command}'"
    warn "Exec'ing: #{command}" if @verbose
    exec command unless @dry_run
  end

  # Return path to the docker-compose.yml file
  # Will exit with an error if not found
  def docker_compose_file
    unless @compose_file
      dir = Dir.pwd
      while dir != '/'
        file = Dir.glob('docker-compose.{yml,yaml}', base: dir).first
        if file
          @compose_file = File.join(dir, file)
          break
        end
        dir = File.dirname(dir)
      end

      abort 'No docker-compose.yml file found.' unless @compose_file
    end

    @compose_file
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
        abort "Unknown container #{@container}" unless containers.include? @container
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
        warn <<~HEREDOC
          Usage: #{File.basename($PROGRAM_NAME)} [OPTIONS]... COMMAND
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
    warn "Please select container [#{containers.join(', ')}]"
    choice = $stdin.gets.strip
    exit if choice.empty?

    abort 'Illegal choice.' unless containers.include?(choice)
    choice
  end

  # Read containers from docker-compose.yml
  def containers
    unless @containers
      # Older Psychs took whether to allow YAML aliases as a fourth
      # argument, while newer has a keyword argument. Try both to be
      # compatible with as many versions as possible.
      begin
        content = YAML.safe_load(File.read(docker_compose_file), aliases: true)
      rescue ArgumentError
        content = YAML.safe_load(File.read(docker_compose_file), [], [], true)
      end
      @containers = content.key?('version') ? content['services'].keys : content.keys
    end

    @containers
  end
end
