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
