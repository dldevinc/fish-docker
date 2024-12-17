function __fish_get_docker_compose_arguments
  set cmd (commandline -poc)
  set -e cmd[1]

  argparse -s --name=docker-compose \
    'f/file=' \
    'p/project-name=' \
    'profile=' \
    'c/context=' \
    'verbose' \
    'log-level=' \
    'ansi=' \
    'no-ansi' \
    'v/version' \
    'H/host=' \
    'tls' \
    'tlscacert=' \
    'tlscert=' \
    'tlskey=' \
    'tlsverify' \
    'skip-hostname-check' \
    'project-directory=' \
    'compatibility' \
    'env-file=' \
    -- $cmd &> /dev/null
    or return 1

  for arg in $argv
    echo $arg
  end
end


function __fish_is_first_docker_compose_argument
  set -l args (__fish_get_docker_compose_arguments)
  set -l tokens (string replace -r --filter '^([^-].*)' '$1' -- $args)
  test (count $tokens) -eq "0"
end


function __fish_docker_compose_arguments_startswith
  set -l args (__fish_get_docker_compose_arguments)
  if string match -qr -- "^$argv\b.*" "$args"
    return 0
  end
  return 1
end


function __fish_docker_compose_arguments_equals
  set -l args (__fish_get_docker_compose_arguments)
  if string match -qr -- "^$argv\$" "$args"
    return 0
  end
  return 1
end


function __fish_print_docker_compose_services --description 'Print a list of docker compose services'
  docker-compose config --services 2> /dev/null
end


complete -e -c docker-compose


# docker-compose build
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -fa '(__fish_print_docker_compose_services)'

# docker-compose create
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -fa '(__fish_print_docker_compose_services)'

# docker-compose events
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith events' -fa '(__fish_print_docker_compose_services)'

# docker-compose exec
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -a '(__fish_print_docker_compose_services)'

# docker-compose images
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith images' -fa '(__fish_print_docker_compose_services)'

# docker-compose kill
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith kill' -fa '(__fish_print_docker_compose_services)'

# docker-compose logs
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -fa '(__fish_print_docker_compose_services)'

# docker-compose pause
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pause' -fa '(__fish_print_docker_compose_services)'

# docker-compose port
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith port' -fa '(__fish_print_docker_compose_services)'

# docker-compose ps
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -fa '(__fish_print_docker_compose_services)'

# docker-compose pull
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -fa '(__fish_print_docker_compose_services)'

# docker-compose push
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith push' -fa '(__fish_print_docker_compose_services)'

# docker-compose restart
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith restart' -fa '(__fish_print_docker_compose_services)'

# docker-compose rm
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -fa '(__fish_print_docker_compose_services)'

# docker-compose run
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -a '(__fish_print_docker_compose_services)'

# docker-compose start
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith start' -fa '(__fish_print_docker_compose_services)'

# docker-compose stop
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith stop' -fa '(__fish_print_docker_compose_services)'

# docker-compose top
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith top' -fa '(__fish_print_docker_compose_services)'

# docker-compose unpause
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith unpause' -fa '(__fish_print_docker_compose_services)'

# docker-compose up
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -fa '(__fish_print_docker_compose_services)'


# ============================= GENERATED ==============================


# docker-compose
# Usage: docker compose [OPTIONS] COMMAND
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l ansi -r -d 'Control when to print ANSI control characters ("never"|"always"|"auto") (default "auto")'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l compatibility -d 'Run compose in backward compatibility mode'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l env-file -r -d 'Specify an alternate environment file.'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l file -s f -r -d 'Compose configuration files'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l parallel -r -d 'Control max parallelism, -1 for unlimited (default -1)'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l profile -r -d 'Specify a profile to enable'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l progress -r -d 'Set type of progress output (auto, tty, plain, quiet) (default "auto")'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l project-directory -r -d 'Specify an alternate working directory (default: the path of the, first specified, Compose file)'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l project-name -s p -r -d 'Project name'

# docker-compose build
# Usage: docker compose build [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa build -d 'Build or rebuild services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l build-arg -r -d 'Set build-time variables for services.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l builder -r -d 'Set builder to use.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l memory -s m -r -d 'Set memory limit for the build container. Not supported by BuildKit.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l no-cache -d 'Do not use cache when building the image'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l pull -d 'Always attempt to pull a newer version of the image.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l push -d 'Push service images.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l quiet -s q -d "Don't print anything to STDOUT"
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l ssh -r -d "Set SSH authentications used when building service images. (use 'default' for using your default SSH Agent)"

# docker-compose config
# Usage: docker compose config [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa config -d 'Parse, resolve and render compose file in canonical format'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l format -r -d 'Format the output. Values: [yaml | json] (default "yaml")'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l hash -r -d 'Print the service config hash, one per line.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l images -d 'Print the image names, one per line.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l no-consistency -d "Don't check model consistency - warning: may produce invalid Compose output"
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l no-interpolate -d "Don't interpolate environment variables."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l no-normalize -d "Don't normalize compose model."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l no-path-resolution -d "Don't resolve file paths."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l output -s o -r -d 'Save to file (default to stdout)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l profiles -d 'Print the profile names, one per line.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l quiet -s q -d "Only validate the configuration, don't print anything."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l resolve-image-digests -d 'Pin image tags to digests.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l services -d 'Print the service names, one per line.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l volumes -d 'Print the volume names, one per line.'

# docker-compose cp
# Usage: docker compose cp [OPTIONS] SERVICE:SRC_PATH DEST_PATH|-
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa cp -d 'Copy files/folders between a service container and the local filesystem'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith cp' -l archive -s a -d 'Archive mode (copy all uid/gid information)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith cp' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith cp' -l follow-link -s L -d 'Always follow symbol link in SRC_PATH'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith cp' -l index -r -d 'index of the container if service has multiple replicas'

# docker-compose create
# Usage: docker compose create [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa create -d 'Creates containers for a service.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l build -d 'Build images before starting containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l force-recreate -d "Recreate containers even if their configuration and image haven't changed."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l no-build -d "Don't build an image, even if it's missing."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l no-recreate -d "If containers already exist, don't recreate them. Incompatible with --force-recreate."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l pull -r -d 'Pull image before running ("always"|"missing"|"never") (default "missing")'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l remove-orphans -d 'Remove containers for services not defined in the Compose file.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l scale -r -d 'Scale SERVICE to NUM instances. Overrides the scale setting in the Compose file if present.'

# docker-compose down
# Usage: docker compose down [OPTIONS] [SERVICES]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa down -d 'Stop and remove containers, networks'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l remove-orphans -d 'Remove containers for services not defined in the Compose file.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l rmi -r -d "Remove images used by services. "local" remove only images that don't have a custom tag ("local"|"all")" -d "Remove images used by services. "local" remove only images that don't have a custom tag ("local"|"all")"
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l timeout -s t -r -d 'Specify a shutdown timeout in seconds'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l volumes -s v -d 'Remove named volumes declared in the "volumes" section of the Compose file and anonymous volumes attached to containers.'

# docker-compose events
# Usage: docker compose events [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa events -d 'Receive real time events from containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith events' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith events' -l json -d 'Output events as a stream of json objects'

# docker-compose exec
# Usage: docker compose exec [OPTIONS] SERVICE COMMAND [ARGS...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa exec -d 'Execute a command in a running container.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l detach -s d -d 'Detached mode: Run command in the background.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l env -s e -r -d 'Set environment variables'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l index -r -d 'index of the container if service has multiple replicas'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l no-TTY -s T -r -d 'compose exec   Disable pseudo-TTY allocation. By default docker compose exec allocates a TTY. (default true)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l privileged -d 'Give extended privileges to the process.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l user -s u -r -d 'Run the command as this user.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l workdir -s w -r -d 'Path to workdir directory for this command.'

# docker-compose images
# Usage: docker compose images [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa images -d 'List images used by the created containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith images' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith images' -l format -r -d 'Format the output. Values: [table | json]. (default "table")'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith images' -l quiet -s q -d 'Only display IDs'

# docker-compose kill
# Usage: docker compose kill [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa kill -d 'Force stop service containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith kill' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith kill' -l remove-orphans -d 'Remove containers for services not defined in the Compose file.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith kill' -l signal -s s -r -d 'SIGNAL to send to the container. (default "SIGKILL")'

# docker-compose logs
# Usage: docker compose logs [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa logs -d 'View output from containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l follow -s f -d 'Follow log output.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l no-color -d 'Produce monochrome output.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l no-log-prefix -d "Don't print prefix in logs."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l since -r -d 'Show logs since timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l tail -s n -r -d 'Number of lines to show from the end of the logs for each container. (default "all")'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l timestamps -s t -d 'Show timestamps.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l until -r -d 'Show logs before a timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)'

# docker-compose ls
# Usage: docker compose ls [OPTIONS]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa ls -d 'List running compose projects'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ls' -l all -s a -d 'Show all stopped Compose projects'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ls' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ls' -l filter -r -d 'Filter output based on conditions provided.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ls' -l format -r -d 'Format the output. Values: [table | json]. (default "table")'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ls' -l quiet -s q -d 'Only display IDs.'

# docker-compose pause
# Usage: docker compose pause [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa pause -d 'Pause services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pause' -l dry-run -d 'Execute command in dry run mode'

# docker-compose port
# Usage: docker compose port [OPTIONS] SERVICE PRIVATE_PORT
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa port -d 'Print the public port for a port binding.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith port' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith port' -l index -r -d 'index of the container if service has multiple replicas'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith port' -l protocol -r -d 'tcp or udp (default "tcp")'

# docker-compose ps
# Usage: docker compose ps [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa ps -d 'List containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l all -s a -d 'Show all stopped containers (including those created by the run command)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l filter -r -d 'Filter services by a property (supported filters: status).'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l format -r -d 'Format the output. Values: [table | json] (default "table")'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l quiet -s q -d 'Only display IDs'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l services -d 'Display services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l status -r -d 'Filter services by status. Values: [paused | restarting | removing | running | dead | created | exited]'

# docker-compose pull
# Usage: docker compose pull [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa pull -d 'Pull service images'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l ignore-buildable -d 'Ignore images that can be built.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l ignore-pull-failures -d 'Pull what it can and ignores images with pull failures.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l include-deps -d 'Also pull services declared as dependencies.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l quiet -s q -d 'Pull without printing progress information.'

# docker-compose push
# Usage: docker compose push [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa push -d 'Push service images'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith push' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith push' -l ignore-push-failures -d 'Push what it can and ignores images with push failures'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith push' -l include-deps -d 'Also push images of services declared as dependencies'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith push' -l quiet -s q -d 'Push without printing progress information'

# docker-compose restart
# Usage: docker compose restart [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa restart -d 'Restart service containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith restart' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith restart' -l no-deps -d "Don't restart dependent services."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith restart' -l timeout -s t -r -d 'Specify a shutdown timeout in seconds'

# docker-compose rm
# Usage: docker compose rm [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa rm -d 'Removes stopped service containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -l force -s f -d "Don't ask to confirm removal"
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -l stop -s s -d 'Stop the containers, if required, before removing'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -l volumes -s v -d 'Remove any anonymous volumes attached to containers'

# docker-compose run
# Usage: docker compose run [OPTIONS] SERVICE [COMMAND] [ARGS...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa run -d 'Run a one-off command on a service.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l build -d 'Build image before starting container.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l cap-add -r -d 'Add Linux capabilities'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l cap-drop -r -d 'Drop Linux capabilities'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l detach -s d -d 'Run container in background and print container ID'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l entrypoint -r -d 'Override the entrypoint of the image'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l env -s e -r -d 'Set environment variables'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l interactive -s i -d 'Keep STDIN open even if not attached. (default true)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l label -s l -r -d 'Add or override a label'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l name -r -d 'Assign a name to the container'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l no-TTY -s T -d 'Disable pseudo-TTY allocation (default: auto-detected). (default true)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l no-deps -d "Don't start linked services."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l publish -s p -r -d "Publish a container's port(s) to the host."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l quiet-pull -d 'Pull without printing progress information.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l remove-orphans -d 'Remove containers for services not defined in the Compose file.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l rm -d 'Automatically remove the container when it exits'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l service-ports -d "Run command with the service's ports enabled and mapped to the host."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l use-aliases -d "Use the service's network useAliases in the network(s) the container connects to."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l user -s u -r -d 'Run as specified username or uid'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l volume -s v -r -d 'Bind mount a volume.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l workdir -s w -r -d 'Working directory inside the container'

# docker-compose start
# Usage: docker compose start [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa start -d 'Start services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith start' -l dry-run -d 'Execute command in dry run mode'

# docker-compose stop
# Usage: docker compose stop [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa stop -d 'Stop services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith stop' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith stop' -l timeout -s t -r -d 'Specify a shutdown timeout in seconds'

# docker-compose top
# Usage: docker compose top [SERVICES...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa top -d 'Display the running processes'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith top' -l dry-run -d 'Execute command in dry run mode'

# docker-compose unpause
# Usage: docker compose unpause [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa unpause -d 'Unpause services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith unpause' -l dry-run -d 'Execute command in dry run mode'

# docker-compose up
# Usage: docker compose up [OPTIONS] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa up -d 'Create and start containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l abort-on-container-exit -d 'Stops all containers if any container was stopped. Incompatible with -d'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l always-recreate-deps -d 'Recreate dependent containers. Incompatible with --no-recreate.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l attach -r -d 'Attach to service output.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l attach-dependencies -d 'Attach to dependent containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l build -d 'Build images before starting containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l detach -s d -d 'Detached mode: Run containers in the background'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l exit-code-from -r -d 'Return the exit code of the selected service container. Implies --abort-on-container-exit'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l force-recreate -d "Recreate containers even if their configuration and image haven't changed."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-attach -r -d "Don't attach to specified service."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-build -d "Don't build an image, even if it's missing."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-color -d 'Produce monochrome output.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-deps -d "Don't start linked services."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-log-prefix -d "Don't print prefix in logs."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-recreate -d "If containers already exist, don't recreate them. Incompatible with --force-recreate."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-start -d "Don't start the services after creating them."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l pull -r -d 'Pull image before running ("always"|"missing"|"never") (default "missing")'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l quiet-pull -d 'Pull without printing progress information.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l remove-orphans -d 'Remove containers for services not defined in the Compose file.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l renew-anon-volumes -s V -d 'Recreate anonymous volumes instead of retrieving data from the previous containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l scale -r -d 'Scale SERVICE to NUM instances. Overrides the scale setting in the Compose file if present.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l timeout -s t -r -d 'Use this timeout in seconds for container shutdown when attached or when containers are already running.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l timestamps -d 'Show timestamps.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l wait -d 'Wait for services to be running|healthy. Implies detached mode.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l wait-timeout -r -d 'timeout waiting for application to be running|healthy.'

# docker-compose version
# Usage: docker compose version [OPTIONS]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa version -d 'Show the Docker Compose version information'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith version' -l dry-run -d 'Execute command in dry run mode'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith version' -l format -s f -r -d 'Format the output. Values: [pretty | json]. (Default: pretty)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith version' -l short -d "Shows only Compose's version number."

# docker-compose wait
# Usage: docker compose wait SERVICE [SERVICE...] [OPTIONS]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa wait -d 'Block until the first service container stops'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith wait' -l down-project -d 'Drops project when the first container stops'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith wait' -l dry-run -d 'Execute command in dry run mode'
