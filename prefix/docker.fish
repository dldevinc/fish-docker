function __fish_get_docker_arguments
    set -e argv[1]
    argparse -s --name=docker \
        'config=' \
        'c/context=' \
        'D/debug' \
        'H/host=' \
        'l/log-level=' \
        'tls' \
        'tlscacert=' \
        'tlscert=' \
        'tlskey=' \
        'tlsverify' \
        'v/version' \
        -- $argv &> /dev/null
        or return 1
    echo $argv
end


function __fish_is_first_docker_argument
    set -l cmd (__fish_get_docker_arguments (commandline -poc) | tr ' ' \n)
    set -l tokens (string replace -r --filter '^([^-].*)' '$1' -- $cmd)
    test (count $tokens) -eq "0"
end


function __fish_docker_arguments_startswith
    set -l cmd (__fish_get_docker_arguments (commandline -poc) | tr ' ' \n)
    if string match -qr -- "^$argv\b.*" "$cmd"
        return 0
    end
    return 1
end


function __fish_docker_arguments_equals
    set -l cmd (__fish_get_docker_arguments (commandline -poc) | tr ' ' \n)
    if string match -qr -- "^$argv\$" "$cmd"
        return 0
    end
    return 1
end


function __fish_print_docker_networks --description 'Print a list of docker networks'
    docker network ls --format "{{.Name}}" | command sort
    docker network ls --format "{{.ID}}\t{{.Name}}" | command sort
end


function __fish_print_docker_images --description 'Print a list of docker images'
    docker images --format "{{.Repository}}:{{.Tag}}" | command grep -v '<none>' | command sort
    docker images --format "{{.ID}}\t{{.Repository}}:{{.Tag}}" | command grep -v '<none>' | command sort
end


function __fish_print_docker_repositories --description 'Print a list of docker repositories'
    docker images --format "{{.Repository}}" | command grep -v '<none>' | command sort | command uniq
end


function __fish_print_docker_containers --description 'Print a list of docker containers'
    if test -n "$argv"
        for stat in $argv
            docker ps -a --filter status=$stat --format "{{.Names}}\t{{.Image}}" | command sort
            docker ps -a --filter status=$stat --format "{{.ID}}\t{{.Image}}" | command sort
        end
    else
        docker ps -a --format "{{.Names}}\t{{.Image}}" | command sort
        docker ps -a --format "{{.ID}}\t{{.Image}}" | command sort
    end
end


function __fish_print_docker_volumes --description 'Print a list of docker volumes'
    docker volume ls --format "{{.Name}}"
end


complete -e -c docker


# docker attach
complete -c docker -n '__fish_docker_arguments_startswith attach' -ka '(__fish_print_docker_containers running)'
complete -c docker -n '__fish_docker_arguments_startswith container attach' -ka '(__fish_print_docker_containers running)'

# docker commit
complete -c docker -n '__fish_docker_arguments_startswith commit' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith container commit' -fka '(__fish_print_docker_containers)'

# docker cp
complete -c docker -n '__fish_docker_arguments_startswith cp' -ka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith container cp' -ka '(__fish_print_docker_containers)'

# docker create
complete -c docker -n '__fish_docker_arguments_startswith create' -ka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -ka '(__fish_print_docker_images)'

# docker diff
complete -c docker -n '__fish_docker_arguments_equals diff' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_equals container diff' -fka '(__fish_print_docker_containers)'

# docker exec
complete -c docker -n '__fish_docker_arguments_startswith exec' -ka '(__fish_print_docker_containers running)'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -ka '(__fish_print_docker_containers running)'

# docker export
complete -c docker -n '__fish_docker_arguments_startswith export' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith export; and __fish_prev_arg_in -o --output' -rF
complete -c docker -n '__fish_docker_arguments_startswith container export' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith container export; and __fish_prev_arg_in -o --output' -rF

# docker history
complete -c docker -n '__fish_docker_arguments_startswith history' -fka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith image history' -fka '(__fish_print_docker_images)'

# docker container inspect
complete -c docker -n '__fish_docker_arguments_startswith container inspect' -fka '(__fish_print_docker_containers)'

# docker image inspect
complete -c docker -n '__fish_docker_arguments_startswith image inspect' -fka '(__fish_print_docker_images)'

# docker kill
complete -c docker -n '__fish_docker_arguments_startswith kill' -fka '(__fish_print_docker_containers running paused)'
complete -c docker -n '__fish_docker_arguments_startswith container kill' -fka '(__fish_print_docker_containers running paused)'

# docker logs
complete -c docker -n '__fish_docker_arguments_startswith logs' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith container logs' -fka '(__fish_print_docker_containers)'

# docker network connect
complete -c docker -n '__fish_docker_arguments_startswith network connect' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith network connect' -fka '(__fish_print_docker_networks)'

# docker network disconnect
complete -c docker -n '__fish_docker_arguments_startswith network disconnect' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith network disconnect' -fka '(__fish_print_docker_networks)'

# docker network inspect
complete -c docker -n '__fish_docker_arguments_startswith network inspect' -fka '(__fish_print_docker_networks)'

# docker network rm
complete -c docker -n '__fish_docker_arguments_startswith network rm' -fka '(__fish_print_docker_networks)'

# docker pause
complete -c docker -n '__fish_docker_arguments_startswith pause' -fka '(__fish_print_docker_containers running)'
complete -c docker -n '__fish_docker_arguments_startswith container pause' -fka '(__fish_print_docker_containers running)'

# docker port
complete -c docker -n '__fish_docker_arguments_equals port' -fka '(__fish_print_docker_containers running paused)'
complete -c docker -n '__fish_docker_arguments_equals container port' -fka '(__fish_print_docker_containers running paused)'

# docker pull
complete -c docker -n '__fish_docker_arguments_startswith pull' -fka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith image pull' -fka '(__fish_print_docker_images)'

# docker push
complete -c docker -n '__fish_docker_arguments_startswith push' -fka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith image push' -fka '(__fish_print_docker_images)'

# docker rename
complete -c docker -n '__fish_docker_arguments_equals rename' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_equals container rename' -fka '(__fish_print_docker_containers)'

# docker restart
complete -c docker -n '__fish_docker_arguments_startswith restart' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith container restart' -fka '(__fish_print_docker_containers)'

# docker rm
complete -c docker -n '__fish_docker_arguments_startswith rm' -fka '(__fish_print_docker_containers exited created dead)'
complete -c docker -n '__fish_docker_arguments_startswith container rm' -fka '(__fish_print_docker_containers exited created dead)'

# docker rmi
complete -c docker -n '__fish_docker_arguments_startswith rmi' -fka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith image rm' -fka '(__fish_print_docker_images)'

# docker run
complete -c docker -n '__fish_docker_arguments_startswith run' -ka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -ka '(__fish_print_docker_images)'

# docker save
complete -c docker -n '__fish_docker_arguments_startswith save' -fka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith save; and __fish_prev_arg_in -o --output' -rF
complete -c docker -n '__fish_docker_arguments_startswith image save' -fka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith image save; and __fish_prev_arg_in -o --output' -rF

# docker start
complete -c docker -n '__fish_docker_arguments_startswith start' -fka '(__fish_print_docker_containers created exited)'
complete -c docker -n '__fish_docker_arguments_startswith container start' -fka '(__fish_print_docker_containers created exited)'

# docker stats
complete -c docker -n '__fish_docker_arguments_startswith stats' -fka '(__fish_print_docker_containers running paused)'
complete -c docker -n '__fish_docker_arguments_startswith container stats' -fka '(__fish_print_docker_containers running paused)'

# docker stop
complete -c docker -n '__fish_docker_arguments_startswith stop' -fka '(__fish_print_docker_containers running paused)'
complete -c docker -n '__fish_docker_arguments_startswith container stop' -fka '(__fish_print_docker_containers running paused)'

# docker tag
complete -c docker -n '__fish_docker_arguments_startswith tag' -fka '(__fish_print_docker_images)'
complete -c docker -n '__fish_docker_arguments_startswith image run' -fka '(__fish_print_docker_images)'

# docker top
complete -c docker -n '__fish_docker_arguments_equals top' -fka '(__fish_print_docker_containers running paused)'
complete -c docker -n '__fish_docker_arguments_equals container top' -fka '(__fish_print_docker_containers running paused)'

# docker unpause
complete -c docker -n '__fish_docker_arguments_startswith unpause' -fka '(__fish_print_docker_containers paused)'
complete -c docker -n '__fish_docker_arguments_startswith container unpause' -fka '(__fish_print_docker_containers paused)'

# docker update
complete -c docker -n '__fish_docker_arguments_startswith update' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith container update' -fka '(__fish_print_docker_containers)'

# docker volume inspect
complete -c docker -n '__fish_docker_arguments_startswith volume inspect' -fka '(__fish_print_docker_volumes)'

# docker volume rm
complete -c docker -n '__fish_docker_arguments_startswith volume rm' -fka '(__fish_print_docker_volumes)'

# docker wait
complete -c docker -n '__fish_docker_arguments_startswith wait' -fka '(__fish_print_docker_containers)'
complete -c docker -n '__fish_docker_arguments_startswith container wait' -fka '(__fish_print_docker_containers)'


# ============================= GENERATED ==============================
