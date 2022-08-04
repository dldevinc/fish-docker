function __fish_get_docker_compose_arguments
    set -e argv[1]
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
        -- $argv &> /dev/null
        or return 1
    echo $argv
end


function __fish_is_first_docker_compose_argument
    set -l cmd (__fish_get_docker_compose_arguments (commandline -poc) | tr ' ' \n)
    set -l tokens (string replace -r --filter '^([^-].*)' '$1' -- $cmd)
    test (count $tokens) -eq "0"
end


function __fish_docker_compose_arguments_startswith
    set -l cmd (__fish_get_docker_compose_arguments (commandline -poc) | tr ' ' \n)
    if string match -qr -- "^$argv\b.*" "$cmd"
        return 0
    end
    return 1
end


function __fish_docker_compose_arguments_equals
    set -l cmd (__fish_get_docker_compose_arguments (commandline -poc) | tr ' ' \n)
    if string match -qr -- "^$argv\$" "$cmd"
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
# Usage: docker-compose [-f <arg>...] [--profile <name>...] [options] [--] [COMMAND] [ARGS...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l file -s f -r -d 'Specify an alternate compose file (default: docker-compose.yml)'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l project-name -s p -r -d 'Specify an alternate project name (default: directory name)'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l profile -r -d 'Specify a profile to enable'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l context -s c -r -d 'Specify a context name'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l verbose -d 'Show more output'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l log-level -r -d 'Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l ansi -r -d 'Control when to print ANSI control characters'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l no-ansi -d 'Do not print ANSI control characters (DEPRECATED)'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l version -s v -d 'Print version and exit'
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -l host -s H -r -d 'Daemon socket to connect to'

# docker-compose build
# Usage: build [options] [--build-arg key=val...] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa build -d 'Build or rebuild services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l build-arg -r -d 'Set build-time variables for services.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l compress -d 'Compress the build context using gzip.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l force-rm -d 'Always remove intermediate containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l memory -s m -r -d 'Set memory limit for the build container.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l no-cache -d 'Do not use cache when building the image.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l no-rm -d 'Do not remove intermediate containers after a successful build.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l parallel -d 'Build images in parallel.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l progress -r -d 'Set type of progress output (auto, plain, tty).'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l pull -d 'Always attempt to pull a newer version of the image.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith build' -l quiet -s q -d "Don't print anything to STDOUT"

# docker-compose config
# Usage: config [options]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa config -d 'Validate and view the Compose file'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l resolve-image-digests -d 'Pin image tags to digests.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l no-interpolate -d "Don't interpolate environment variables."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l quiet -s q -d "Only validate the configuration, don't print anything."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l profiles -d 'Print the profile names, one per line.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l services -d 'Print the service names, one per line.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l volumes -d 'Print the volume names, one per line.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith config' -l hash -r -d 'Print the service config hash, one per line. Set "service1,service2" for a list of specified services or use the wildcard symbol to display all services.'

# docker-compose create
# Usage: create [options] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa create -d 'Create services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l force-recreate -d "Recreate containers even if their configuration and image haven't changed. Incompatible with --no-recreate."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l no-recreate -d "If containers already exist, don't recreate them. Incompatible with --force-recreate."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l no-build -d "Don't build an image, even if it's missing."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith create' -l build -d 'Build images before creating containers.'

# docker-compose down
# Usage: down [options]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa down -d 'Stop and remove resources'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l rmi -r -d "Remove images. Type must be one of: 'all': Remove all images used by any service. 'local': Remove only images that don't have a custom tag set by the `image` field."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l volumes -s v -d 'Remove named volumes declared in the `volumes` section of the Compose file and anonymous volumes attached to containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l remove-orphans -d 'Remove containers for services not defined in the Compose file'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith down' -l timeout -s t -r -d 'Specify a shutdown timeout in seconds. (default: 10)'

# docker-compose events
# Usage: events [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa events -d 'Receive real time events from containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith events' -l json -d 'Output events as a stream of json objects'

# docker-compose exec
# Usage: exec [options] [-e KEY=VAL...] [--] SERVICE COMMAND [ARGS...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa exec -d 'Execute a command in a running container'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l detach -s d -d 'Detached mode: Run command in the background.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l privileged -d 'Give extended privileges to the process.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l user -s u -r -d 'Run the command as this user.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -s T -d 'Disable pseudo-tty allocation. By default `docker-compose exec` allocates a TTY.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l index -r -d 'index of the container if there are multiple instances of a service [default: 1]'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l env -s e -r -d 'Set environment variables (can be used multiple times, not supported in API < 1.25)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith exec' -l workdir -s w -r -d 'Path to workdir directory for this command.'

# docker-compose help
# Usage: help [COMMAND]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa help -d 'Get help on a command'

# docker-compose images
# Usage: images [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa images -d 'List images'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith images' -l quiet -s q -d 'Only display IDs'

# docker-compose kill
# Usage: kill [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa kill -d 'Kill containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith kill' -s s -d 'SIGNAL         SIGNAL to send to the container. Default signal is SIGKILL.'

# docker-compose logs
# Usage: logs [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa logs -d 'View output from containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l no-color -d 'Produce monochrome output.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l follow -s f -d 'Follow log output.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l timestamps -s t -d 'Show timestamps.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l tail -r -d 'Number of lines to show from the end of the logs for each container.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith logs' -l no-log-prefix -d "Don't print prefix in logs."

# docker-compose pause
# Usage: pause [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa pause -d 'Pause services'

# docker-compose port
# Usage: port [options] [--] SERVICE PRIVATE_PORT
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa port -d 'Print the public port for a port binding'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith port' -l protocol -r -d 'tcp or udp [default: tcp]'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith port' -l index -r -d 'index of the container if there are multiple instances of a service [default: 1]'

# docker-compose ps
# Usage: ps [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa ps -d 'List containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l quiet -s q -d 'Only display IDs'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l services -d 'Display services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l filter -r -d 'Filter services by a property'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith ps' -l all -s a -d 'Show all stopped containers (including those created by the run command)'

# docker-compose pull
# Usage: pull [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa pull -d 'Pull service images'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l ignore-pull-failures -d 'Pull what it can and ignores images with pull failures.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l parallel -d 'Deprecated, pull multiple images in parallel (enabled by default).'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l no-parallel -d 'Disable parallel pulling.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l quiet -s q -d 'Pull without printing progress information'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith pull' -l include-deps -d 'Also pull services declared as dependencies'

# docker-compose push
# Usage: push [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa push -d 'Push service images'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith push' -l ignore-push-failures -d 'Push what it can and ignores images with push failures.'

# docker-compose restart
# Usage: restart [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa restart -d 'Restart services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith restart' -l timeout -s t -r -d 'Specify a shutdown timeout in seconds. (default: 10)'

# docker-compose rm
# Usage: rm [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa rm -d 'Remove stopped containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -l force -s f -d "Don't ask to confirm removal"
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -l stop -s s -d 'Stop the containers, if required, before removing'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -s v -d 'Remove any anonymous volumes attached to containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith rm' -l all -s a -d 'Deprecated - no effect.'

# docker-compose run
# Usage: run [options] [-v VOLUME...] [-p PORT...] [-e KEY=VAL...] [-l KEY=VALUE...] [--]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa run -d 'Run a one-off command'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l detach -s d -d 'Detached mode: Run container in the background, print new container name.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l name -r -d 'Assign a name to the container'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l entrypoint -r -d 'Override the entrypoint of the image.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -s e -d 'KEY=VAL            Set an environment variable (can be used multiple times)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l label -s l -r -d 'Add or override a label (can be used multiple times)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l user -s u -r -d 'Run as specified username or uid'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l no-deps -d "Don't start linked services."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l rm -d 'Remove container after run. Ignored in detached mode.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l publish -s p -r -d "Publish a container's port(s) to the host"
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l service-ports -d "Run command with the service's ports enabled and mapped to the host."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l use-aliases -d "Use the service's network aliases in the network(s) the container connects to."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l volume -s v -r -d 'Bind mount a volume (default [])'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -s T -d 'Disable pseudo-tty allocation. By default `docker-compose run` allocates a TTY.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith run' -l workdir -s w -r -d 'Working directory inside the container'

# docker-compose scale
# Usage: scale [options] [SERVICE=NUM...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa scale -d 'Set number of containers for a service'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith scale' -l timeout -s t -r -d 'Specify a shutdown timeout in seconds. (default: 10)'

# docker-compose start
# Usage: start [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa start -d 'Start services'

# docker-compose stop
# Usage: stop [options] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa stop -d 'Stop services'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith stop' -l timeout -s t -r -d 'Specify a shutdown timeout in seconds. (default: 10)'

# docker-compose top
# Usage: top [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa top -d 'Display the running processes'

# docker-compose unpause
# Usage: unpause [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa unpause -d 'Unpause services'

# docker-compose up
# Usage: up [options] [--scale SERVICE=NUM...] [--] [SERVICE...]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa up -d 'Create and start containers'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l detach -s d -d 'Detached mode: Run containers in the background, print new container names. Incompatible with --abort-on-container-exit.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-color -d 'Produce monochrome output.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l quiet-pull -d 'Pull without printing progress information'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-deps -d "Don't start linked services."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l force-recreate -d "Recreate containers even if their configuration and image haven't changed."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l always-recreate-deps -d 'Recreate dependent containers. Incompatible with --no-recreate.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-recreate -d "If containers already exist, don't recreate them. Incompatible with --force-recreate and -V."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-build -d "Don't build an image, even if it's missing."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-start -d "Don't start the services after creating them."
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l build -d 'Build images before starting containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l abort-on-container-exit -d 'Stops all containers if any container was stopped. Incompatible with -d.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l attach-dependencies -d 'Attach to dependent containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l timeout -s t -r -d 'Use this timeout in seconds for container shutdown when attached or when containers are already running. (default: 10)'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l renew-anon-volumes -s V -d 'Recreate anonymous volumes instead of retrieving data from the previous containers.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l remove-orphans -d 'Remove containers for services not defined in the Compose file.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l exit-code-from -r -d 'Return the exit code of the selected service container. Implies --abort-on-container-exit.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l scale -r -d 'Scale SERVICE to NUM instances. Overrides the `scale` setting in the Compose file if present.'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith up' -l no-log-prefix -d "Don't print prefix in logs."

# docker-compose version
# Usage: version [--short]
complete -c docker-compose -n '__fish_is_first_docker_compose_argument' -fa version -d 'Show version information and quit'
complete -c docker-compose -n '__fish_docker_compose_arguments_startswith version' -l short -d "Shows only Compose's version number."
