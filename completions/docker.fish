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


# docker
# Usage: docker [OPTIONS] COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -l config -r -d 'Location of client config files (default "/home/jon/.docker")'
complete -c docker -n '__fish_is_first_docker_argument' -l context -s c -r -d 'Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker context use")'
complete -c docker -n '__fish_is_first_docker_argument' -l debug -s D -d 'Enable debug mode'
complete -c docker -n '__fish_is_first_docker_argument' -l host -s H -r -d 'Daemon socket(s) to connect to'
complete -c docker -n '__fish_is_first_docker_argument' -l log-level -s l -r -d 'Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")'
complete -c docker -n '__fish_is_first_docker_argument' -l tls -d 'Use TLS; implied by --tlsverify'
complete -c docker -n '__fish_is_first_docker_argument' -l tlscacert -r -d 'Trust certs signed only by this CA (default "/home/jon/.docker/ca.pem")'
complete -c docker -n '__fish_is_first_docker_argument' -l tlscert -r -d 'Path to TLS certificate file (default "/home/jon/.docker/cert.pem")'
complete -c docker -n '__fish_is_first_docker_argument' -l tlskey -r -d 'Path to TLS key file (default "/home/jon/.docker/key.pem")'
complete -c docker -n '__fish_is_first_docker_argument' -l tlsverify -d 'Use TLS and verify the remote'
complete -c docker -n '__fish_is_first_docker_argument' -l version -s v -d 'Print version information and quit'

# docker attach
# Usage: docker attach [OPTIONS] CONTAINER
complete -c docker -n '__fish_is_first_docker_argument' -fa attach -d 'Attach local standard input, output, and error streams to a running container'
complete -c docker -n '__fish_docker_arguments_startswith attach' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith attach' -l no-stdin -d 'Do not attach STDIN'
complete -c docker -n '__fish_docker_arguments_startswith attach' -l sig-proxy -d 'Proxy all received signals to the process (default true)'

# docker build
# Usage: docker build [OPTIONS] PATH | URL | -
complete -c docker -n '__fish_is_first_docker_argument' -fa build -d 'Build an image from a Dockerfile'
complete -c docker -n '__fish_docker_arguments_startswith build' -l add-host -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith build' -l build-arg -r -d 'Set build-time variables'
complete -c docker -n '__fish_docker_arguments_startswith build' -l cache-from -r -d 'Images to consider as cache sources'
complete -c docker -n '__fish_docker_arguments_startswith build' -l cgroup-parent -r -d 'Optional parent cgroup for the container'
complete -c docker -n '__fish_docker_arguments_startswith build' -l compress -d 'Compress the build context using gzip'
complete -c docker -n '__fish_docker_arguments_startswith build' -l cpu-period -r -d 'Limit the CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith build' -l cpu-quota -r -d 'Limit the CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith build' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith build' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith build' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith build' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith build' -l file -s f -r -d "Name of the Dockerfile (Default is 'PATH/Dockerfile')"
complete -c docker -n '__fish_docker_arguments_startswith build' -l force-rm -d 'Always remove intermediate containers'
complete -c docker -n '__fish_docker_arguments_startswith build' -l iidfile -r -d 'Write the image ID to the file'
complete -c docker -n '__fish_docker_arguments_startswith build' -l isolation -r -d 'Container isolation technology'
complete -c docker -n '__fish_docker_arguments_startswith build' -l label -r -d 'Set metadata for an image'
complete -c docker -n '__fish_docker_arguments_startswith build' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith build' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith build' -l network -r -d 'Set the networking mode for the RUN instructions during build (default "default")'
complete -c docker -n '__fish_docker_arguments_startswith build' -l no-cache -d 'Do not use cache when building the image'
complete -c docker -n '__fish_docker_arguments_startswith build' -l pull -d 'Always attempt to pull a newer version of the image'
complete -c docker -n '__fish_docker_arguments_startswith build' -l quiet -s q -d 'Suppress the build output and print image ID on success'
complete -c docker -n '__fish_docker_arguments_startswith build' -l rm -d 'Remove intermediate containers after a successful build (default true)'
complete -c docker -n '__fish_docker_arguments_startswith build' -l security-opt -r -d 'Security options'
complete -c docker -n '__fish_docker_arguments_startswith build' -l shm-size -r -d 'Size of /dev/shm'
complete -c docker -n '__fish_docker_arguments_startswith build' -l tag -s t -r -d "Name and optionally a tag in the 'name:tag' format"
complete -c docker -n '__fish_docker_arguments_startswith build' -l target -r -d 'Set the target build stage to build.'
complete -c docker -n '__fish_docker_arguments_startswith build' -l ulimit -r -d 'Ulimit options (default [])'

# docker builder
# Usage: docker builder COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa builder -d 'Manage builds'

# docker builder build
# Usage: docker builder build [OPTIONS] PATH | URL | -
complete -c docker -n '__fish_docker_arguments_equals builder' -fa build -d 'Build an image from a Dockerfile'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l add-host -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l build-arg -r -d 'Set build-time variables'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l cache-from -r -d 'Images to consider as cache sources'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l cgroup-parent -r -d 'Optional parent cgroup for the container'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l compress -d 'Compress the build context using gzip'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l cpu-period -r -d 'Limit the CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l cpu-quota -r -d 'Limit the CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l file -s f -r -d "Name of the Dockerfile (Default is 'PATH/Dockerfile')"
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l force-rm -d 'Always remove intermediate containers'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l iidfile -r -d 'Write the image ID to the file'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l isolation -r -d 'Container isolation technology'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l label -r -d 'Set metadata for an image'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l network -r -d 'Set the networking mode for the RUN instructions during build (default "default")'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l no-cache -d 'Do not use cache when building the image'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l pull -d 'Always attempt to pull a newer version of the image'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l quiet -s q -d 'Suppress the build output and print image ID on success'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l rm -d 'Remove intermediate containers after a successful build (default true)'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l security-opt -r -d 'Security options'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l shm-size -r -d 'Size of /dev/shm'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l tag -s t -r -d "Name and optionally a tag in the 'name:tag' format"
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l target -r -d 'Set the target build stage to build.'
complete -c docker -n '__fish_docker_arguments_startswith builder build' -l ulimit -r -d 'Ulimit options (default [])'

# docker builder prune
# Usage: docker builder prune
complete -c docker -n '__fish_docker_arguments_equals builder' -fa prune -d 'Remove build cache'
complete -c docker -n '__fish_docker_arguments_startswith builder prune' -l all -s a -d 'Remove all unused build cache, not just dangling ones'
complete -c docker -n '__fish_docker_arguments_startswith builder prune' -l filter -r -d "Provide filter values (e.g. 'until=24h')"
complete -c docker -n '__fish_docker_arguments_startswith builder prune' -l force -s f -d 'Do not prompt for confirmation'
complete -c docker -n '__fish_docker_arguments_startswith builder prune' -l keep-storage -r -d 'Amount of disk space to keep for cache'

# docker commit
# Usage: docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
complete -c docker -n '__fish_is_first_docker_argument' -fa commit -d "Create a new image from a container's changes"
complete -c docker -n '__fish_docker_arguments_startswith commit' -l author -s a -r -d 'Author (e.g., "John Hannibal Smith <hannibal@a-team.com>")'
complete -c docker -n '__fish_docker_arguments_startswith commit' -l change -s c -r -d 'Apply Dockerfile instruction to the created image'
complete -c docker -n '__fish_docker_arguments_startswith commit' -l message -s m -r -d 'Commit message'
complete -c docker -n '__fish_docker_arguments_startswith commit' -l pause -s p -d 'Pause container during commit (default true)'

# docker config
# Usage: docker config COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa config -d 'Manage Docker configs'

# docker config create
# Usage: docker config create [OPTIONS] CONFIG file|-
complete -c docker -n '__fish_docker_arguments_equals config' -fa create -d 'Create a config from a file or STDIN'
complete -c docker -n '__fish_docker_arguments_startswith config create' -l label -s l -r -d 'Config labels'
complete -c docker -n '__fish_docker_arguments_startswith config create' -l template-driver -r -d 'Template driver'

# docker config inspect
# Usage: docker config inspect [OPTIONS] CONFIG [CONFIG...]
complete -c docker -n '__fish_docker_arguments_equals config' -fa inspect -d 'Display detailed information on one or more configs'
complete -c docker -n '__fish_docker_arguments_startswith config inspect' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith config inspect' -l pretty -d 'Print the information in a human friendly format'

# docker config ls
# Usage: docker config ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals config' -fa ls -d 'List configs'
complete -c docker -n '__fish_docker_arguments_startswith config ls' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith config ls' -l format -r -d 'Pretty-print configs using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith config ls' -l quiet -s q -d 'Only display IDs'

# docker config rm
# Usage: docker config rm CONFIG [CONFIG...]
complete -c docker -n '__fish_docker_arguments_equals config' -fa rm -d 'Remove one or more configs'

# docker container
# Usage: docker container COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa container -d 'Manage containers'

# docker container attach
# Usage: docker container attach [OPTIONS] CONTAINER
complete -c docker -n '__fish_docker_arguments_equals container' -fa attach -d 'Attach local standard input, output, and error streams to a running container'
complete -c docker -n '__fish_docker_arguments_startswith container attach' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith container attach' -l no-stdin -d 'Do not attach STDIN'
complete -c docker -n '__fish_docker_arguments_startswith container attach' -l sig-proxy -d 'Proxy all received signals to the process (default true)'

# docker container commit
# Usage: docker container commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]
complete -c docker -n '__fish_docker_arguments_equals container' -fa commit -d "Create a new image from a container's changes"
complete -c docker -n '__fish_docker_arguments_startswith container commit' -l author -s a -r -d 'Author (e.g., "John Hannibal Smith <hannibal@a-team.com>")'
complete -c docker -n '__fish_docker_arguments_startswith container commit' -l change -s c -r -d 'Apply Dockerfile instruction to the created image'
complete -c docker -n '__fish_docker_arguments_startswith container commit' -l message -s m -r -d 'Commit message'
complete -c docker -n '__fish_docker_arguments_startswith container commit' -l pause -s p -d 'Pause container during commit (default true)'

# docker container cp
# Usage: docker container cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
complete -c docker -n '__fish_docker_arguments_equals container' -fa cp -d 'Copy files/folders between a container and the local filesystem'
complete -c docker -n '__fish_docker_arguments_startswith container cp' -l archive -s a -d 'Archive mode (copy all uid/gid information)'
complete -c docker -n '__fish_docker_arguments_startswith container cp' -l follow-link -s L -d 'Always follow symbol link in SRC_PATH'

# docker container create
# Usage: docker container create [OPTIONS] IMAGE [COMMAND] [ARG...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa create -d 'Create a new container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l add-host -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l attach -s a -r -d 'Attach to STDIN, STDOUT or STDERR'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l blkio-weight -r -d 'Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l blkio-weight-device -r -d 'Block IO weight (relative device weight) (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cap-add -r -d 'Add Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cap-drop -r -d 'Drop Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cgroup-parent -r -d 'Optional parent cgroup for the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cgroupns -r -d "Cgroup namespace to use (host|private) 'host':    Run the container in the Docker host's cgroup namespace 'private': Run the container in its own private cgroup namespace '':        Use the cgroup namespace as configured by the default-cgroupns-mode option on the daemon (default)"
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cidfile -r -d 'Write the container ID to the file'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpu-period -r -d 'Limit CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpu-quota -r -d 'Limit CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpu-rt-period -r -d 'Limit CPU real-time period in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpu-rt-runtime -r -d 'Limit CPU real-time runtime in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpus -r -d 'Number of CPUs'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l device -r -d 'Add a host device to the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l device-cgroup-rule -r -d 'Add a rule to the cgroup allowed devices list'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l device-read-bps -r -d 'Limit read rate (bytes per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l device-read-iops -r -d 'Limit read rate (IO per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l device-write-bps -r -d 'Limit write rate (bytes per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l device-write-iops -r -d 'Limit write rate (IO per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l dns -r -d 'Set custom DNS servers'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l dns-option -r -d 'Set DNS options'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l dns-search -r -d 'Set custom DNS search domains'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l domainname -r -d 'Container NIS domain name'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l entrypoint -r -d 'Overwrite the default ENTRYPOINT of the image'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l env -s e -r -d 'Set environment variables'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l env-file -r -d 'Read in a file of environment variables'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l expose -r -d 'Expose a port or a range of ports'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l gpus -r -d "GPU devices to add to the container ('all' to pass all GPUs)"
complete -c docker -n '__fish_docker_arguments_startswith container create' -l group-add -r -d 'Add additional groups to join'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l health-cmd -r -d 'Command to run to check health'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l health-interval -r -d 'Time between running the check (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l health-retries -r -d 'Consecutive failures needed to report unhealthy'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l health-start-period -r -d 'Start period for the container to initialize before starting health-retries countdown (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l health-timeout -r -d 'Maximum time to allow one check to run (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l help -d 'Print usage'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l hostname -s h -r -d 'Container host name'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l init -d 'Run an init inside the container that forwards signals and reaps processes'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l interactive -s i -d 'Keep STDIN open even if not attached'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l ip -r -d 'IPv4 address (e.g., 172.30.100.104)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l ip6 -r -d 'IPv6 address (e.g., 2001:db8::33)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l ipc -r -d 'IPC mode to use'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l isolation -r -d 'Container isolation technology'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l kernel-memory -r -d 'Kernel memory limit'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l label -s l -r -d 'Set meta data on a container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l label-file -r -d 'Read in a line delimited file of labels'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l link -r -d 'Add link to another container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l link-local-ip -r -d 'Container IPv4/IPv6 link-local addresses'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l log-driver -r -d 'Logging driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l log-opt -r -d 'Log driver options'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l mac-address -r -d 'Container MAC address (e.g., 92:d0:c6:0a:29:33)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l memory-reservation -r -d 'Memory soft limit'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith container create' -l memory-swappiness -r -d 'Tune container memory swappiness (0 to 100) (default -1)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l mount -r -d 'Attach a filesystem mount to the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l name -r -d 'Assign a name to the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l network -r -d 'Connect a container to a network'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l network-alias -r -d 'Add network-scoped alias for the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l no-healthcheck -d 'Disable any container-specified HEALTHCHECK'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l oom-kill-disable -d 'Disable OOM Killer'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l oom-score-adj -r -d "Tune host's OOM preferences (-1000 to 1000)"
complete -c docker -n '__fish_docker_arguments_startswith container create' -l pid -r -d 'PID namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l pids-limit -r -d 'Tune container pids limit (set -1 for unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l platform -r -d 'Set platform if server is multi-platform capable'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l privileged -d 'Give extended privileges to this container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l publish -s p -r -d "Publish a container's port(s) to the host"
complete -c docker -n '__fish_docker_arguments_startswith container create' -l publish-all -s P -d 'Publish all exposed ports to random ports'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l pull -r -d 'Pull image before creating ("always"|"missing"|"never") (default "missing")'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l read-only -d "Mount the container's root filesystem as read only"
complete -c docker -n '__fish_docker_arguments_startswith container create' -l restart -r -d 'Restart policy to apply when a container exits (default "no")'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l rm -d 'Automatically remove the container when it exits'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l runtime -r -d 'Runtime to use for this container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l security-opt -r -d 'Security Options'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l shm-size -r -d 'Size of /dev/shm'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l stop-signal -r -d 'Signal to stop a container (default "SIGTERM")'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l stop-timeout -r -d 'Timeout (in seconds) to stop a container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l storage-opt -r -d 'Storage driver options for the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l sysctl -r -d 'Sysctl options (default map[])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l tmpfs -r -d 'Mount a tmpfs directory'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l ulimit -r -d 'Ulimit options (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l userns -r -d 'User namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l uts -r -d 'UTS namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l volume -s v -r -d 'Bind mount a volume'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l volume-driver -r -d 'Optional volume driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l volumes-from -r -d 'Mount volumes from the specified container(s)'
complete -c docker -n '__fish_docker_arguments_startswith container create' -l workdir -s w -r -d 'Working directory inside the container'

# docker container diff
# Usage: docker container diff CONTAINER
complete -c docker -n '__fish_docker_arguments_equals container' -fa diff -d "Inspect changes to files or directories on a container's filesystem"

# docker container exec
# Usage: docker container exec [OPTIONS] CONTAINER COMMAND [ARG...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa exec -d 'Run a command in a running container'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l detach -s d -d 'Detached mode: run command in the background'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l env -s e -r -d 'Set environment variables'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l env-file -r -d 'Read in a file of environment variables'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l interactive -s i -d 'Keep STDIN open even if not attached'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l privileged -d 'Give extended privileges to the command'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith container exec' -l workdir -s w -r -d 'Working directory inside the container'

# docker container export
# Usage: docker container export [OPTIONS] CONTAINER
complete -c docker -n '__fish_docker_arguments_equals container' -fa export -d "Export a container's filesystem as a tar archive"
complete -c docker -n '__fish_docker_arguments_startswith container export' -l output -s o -r -d 'Write to a file, instead of STDOUT'

# docker container inspect
# Usage: docker container inspect [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa inspect -d 'Display detailed information on one or more containers'
complete -c docker -n '__fish_docker_arguments_startswith container inspect' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith container inspect' -l size -s s -d 'Display total file sizes'

# docker container kill
# Usage: docker container kill [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa kill -d 'Kill one or more running containers'
complete -c docker -n '__fish_docker_arguments_startswith container kill' -l signal -s s -r -d 'Signal to send to the container (default "KILL")'

# docker container logs
# Usage: docker container logs [OPTIONS] CONTAINER
complete -c docker -n '__fish_docker_arguments_equals container' -fa logs -d 'Fetch the logs of a container'
complete -c docker -n '__fish_docker_arguments_startswith container logs' -l details -d 'Show extra details provided to logs'
complete -c docker -n '__fish_docker_arguments_startswith container logs' -l follow -s f -d 'Follow log output'
complete -c docker -n '__fish_docker_arguments_startswith container logs' -l since -r -d 'Show logs since timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)'
complete -c docker -n '__fish_docker_arguments_startswith container logs' -l tail -s n -r -d 'Number of lines to show from the end of the logs (default "all")'
complete -c docker -n '__fish_docker_arguments_startswith container logs' -l timestamps -s t -d 'Show timestamps'
complete -c docker -n '__fish_docker_arguments_startswith container logs' -l until -r -d 'Show logs before a timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)'

# docker container ls
# Usage: docker container ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals container' -fa ls -d 'List containers'
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l all -s a -d 'Show all containers (default shows just running)'
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l format -r -d 'Pretty-print containers using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l last -s n -r -d 'Show n last created containers (includes all states) (default -1)'
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l latest -s l -d 'Show the latest created container (includes all states)'
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l no-trunc -d "Don't truncate output"
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l quiet -s q -d 'Only display container IDs'
complete -c docker -n '__fish_docker_arguments_startswith container ls' -l size -s s -d 'Display total file sizes'

# docker container pause
# Usage: docker container pause CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa pause -d 'Pause all processes within one or more containers'

# docker container port
# Usage: docker container port CONTAINER [PRIVATE_PORT[/PROTO]]
complete -c docker -n '__fish_docker_arguments_equals container' -fa port -d 'List port mappings or a specific mapping for the container'

# docker container prune
# Usage: docker container prune [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals container' -fa prune -d 'Remove all stopped containers'
complete -c docker -n '__fish_docker_arguments_startswith container prune' -l filter -r -d "Provide filter values (e.g. 'until=<timestamp>')"
complete -c docker -n '__fish_docker_arguments_startswith container prune' -l force -s f -d 'Do not prompt for confirmation'

# docker container rename
# Usage: docker container rename CONTAINER NEW_NAME
complete -c docker -n '__fish_docker_arguments_equals container' -fa rename -d 'Rename a container'

# docker container restart
# Usage: docker container restart [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa restart -d 'Restart one or more containers'
complete -c docker -n '__fish_docker_arguments_startswith container restart' -l time -s t -r -d 'Seconds to wait for stop before killing the container (default 10)'

# docker container rm
# Usage: docker container rm [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa rm -d 'Remove one or more containers'
complete -c docker -n '__fish_docker_arguments_startswith container rm' -l force -s f -d 'Force the removal of a running container (uses SIGKILL)'
complete -c docker -n '__fish_docker_arguments_startswith container rm' -l link -s l -d 'Remove the specified link'
complete -c docker -n '__fish_docker_arguments_startswith container rm' -l volumes -s v -d 'Remove anonymous volumes associated with the container'

# docker container run
# Usage: docker container run [OPTIONS] IMAGE [COMMAND] [ARG...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa run -d 'Run a command in a new container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l add-host -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l attach -s a -r -d 'Attach to STDIN, STDOUT or STDERR'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l blkio-weight -r -d 'Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l blkio-weight-device -r -d 'Block IO weight (relative device weight) (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cap-add -r -d 'Add Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cap-drop -r -d 'Drop Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cgroup-parent -r -d 'Optional parent cgroup for the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cgroupns -r -d "Cgroup namespace to use (host|private) 'host':    Run the container in the Docker host's cgroup namespace 'private': Run the container in its own private cgroup namespace '':        Use the cgroup namespace as configured by the default-cgroupns-mode option on the daemon (default)"
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cidfile -r -d 'Write the container ID to the file'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpu-period -r -d 'Limit CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpu-quota -r -d 'Limit CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpu-rt-period -r -d 'Limit CPU real-time period in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpu-rt-runtime -r -d 'Limit CPU real-time runtime in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpus -r -d 'Number of CPUs'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l detach -s d -d 'Run container in background and print container ID'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l device -r -d 'Add a host device to the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l device-cgroup-rule -r -d 'Add a rule to the cgroup allowed devices list'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l device-read-bps -r -d 'Limit read rate (bytes per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l device-read-iops -r -d 'Limit read rate (IO per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l device-write-bps -r -d 'Limit write rate (bytes per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l device-write-iops -r -d 'Limit write rate (IO per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l dns -r -d 'Set custom DNS servers'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l dns-option -r -d 'Set DNS options'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l dns-search -r -d 'Set custom DNS search domains'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l domainname -r -d 'Container NIS domain name'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l entrypoint -r -d 'Overwrite the default ENTRYPOINT of the image'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l env -s e -r -d 'Set environment variables'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l env-file -r -d 'Read in a file of environment variables'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l expose -r -d 'Expose a port or a range of ports'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l gpus -r -d "GPU devices to add to the container ('all' to pass all GPUs)"
complete -c docker -n '__fish_docker_arguments_startswith container run' -l group-add -r -d 'Add additional groups to join'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l health-cmd -r -d 'Command to run to check health'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l health-interval -r -d 'Time between running the check (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l health-retries -r -d 'Consecutive failures needed to report unhealthy'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l health-start-period -r -d 'Start period for the container to initialize before starting health-retries countdown (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l health-timeout -r -d 'Maximum time to allow one check to run (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l help -d 'Print usage'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l hostname -s h -r -d 'Container host name'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l init -d 'Run an init inside the container that forwards signals and reaps processes'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l interactive -s i -d 'Keep STDIN open even if not attached'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l ip -r -d 'IPv4 address (e.g., 172.30.100.104)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l ip6 -r -d 'IPv6 address (e.g., 2001:db8::33)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l ipc -r -d 'IPC mode to use'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l isolation -r -d 'Container isolation technology'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l kernel-memory -r -d 'Kernel memory limit'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l label -s l -r -d 'Set meta data on a container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l label-file -r -d 'Read in a line delimited file of labels'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l link -r -d 'Add link to another container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l link-local-ip -r -d 'Container IPv4/IPv6 link-local addresses'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l log-driver -r -d 'Logging driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l log-opt -r -d 'Log driver options'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l mac-address -r -d 'Container MAC address (e.g., 92:d0:c6:0a:29:33)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l memory-reservation -r -d 'Memory soft limit'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith container run' -l memory-swappiness -r -d 'Tune container memory swappiness (0 to 100) (default -1)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l mount -r -d 'Attach a filesystem mount to the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l name -r -d 'Assign a name to the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l network -r -d 'Connect a container to a network'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l network-alias -r -d 'Add network-scoped alias for the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l no-healthcheck -d 'Disable any container-specified HEALTHCHECK'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l oom-kill-disable -d 'Disable OOM Killer'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l oom-score-adj -r -d "Tune host's OOM preferences (-1000 to 1000)"
complete -c docker -n '__fish_docker_arguments_startswith container run' -l pid -r -d 'PID namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l pids-limit -r -d 'Tune container pids limit (set -1 for unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l platform -r -d 'Set platform if server is multi-platform capable'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l privileged -d 'Give extended privileges to this container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l publish -s p -r -d "Publish a container's port(s) to the host"
complete -c docker -n '__fish_docker_arguments_startswith container run' -l publish-all -s P -d 'Publish all exposed ports to random ports'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l pull -r -d 'Pull image before running ("always"|"missing"|"never") (default "missing")'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l read-only -d "Mount the container's root filesystem as read only"
complete -c docker -n '__fish_docker_arguments_startswith container run' -l restart -r -d 'Restart policy to apply when a container exits (default "no")'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l rm -d 'Automatically remove the container when it exits'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l runtime -r -d 'Runtime to use for this container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l security-opt -r -d 'Security Options'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l shm-size -r -d 'Size of /dev/shm'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l sig-proxy -d 'Proxy received signals to the process (default true)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l stop-signal -r -d 'Signal to stop a container (default "SIGTERM")'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l stop-timeout -r -d 'Timeout (in seconds) to stop a container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l storage-opt -r -d 'Storage driver options for the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l sysctl -r -d 'Sysctl options (default map[])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l tmpfs -r -d 'Mount a tmpfs directory'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l ulimit -r -d 'Ulimit options (default [])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l userns -r -d 'User namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l uts -r -d 'UTS namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l volume -s v -r -d 'Bind mount a volume'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l volume-driver -r -d 'Optional volume driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l volumes-from -r -d 'Mount volumes from the specified container(s)'
complete -c docker -n '__fish_docker_arguments_startswith container run' -l workdir -s w -r -d 'Working directory inside the container'

# docker container start
# Usage: docker container start [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa start -d 'Start one or more stopped containers'
complete -c docker -n '__fish_docker_arguments_startswith container start' -l attach -s a -d 'Attach STDOUT/STDERR and forward signals'
complete -c docker -n '__fish_docker_arguments_startswith container start' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith container start' -l interactive -s i -d "Attach container's STDIN"

# docker container stats
# Usage: docker container stats [OPTIONS] [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa stats -d 'Display a live stream of container(s) resource usage statistics'
complete -c docker -n '__fish_docker_arguments_startswith container stats' -l all -s a -d 'Show all containers (default shows just running)'
complete -c docker -n '__fish_docker_arguments_startswith container stats' -l format -r -d 'Pretty-print images using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith container stats' -l no-stream -d 'Disable streaming stats and only pull the first result'
complete -c docker -n '__fish_docker_arguments_startswith container stats' -l no-trunc -d 'Do not truncate output'

# docker container stop
# Usage: docker container stop [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa stop -d 'Stop one or more running containers'
complete -c docker -n '__fish_docker_arguments_startswith container stop' -l time -s t -r -d 'Seconds to wait for stop before killing it (default 10)'

# docker container top
# Usage: docker container top CONTAINER [ps OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals container' -fa top -d 'Display the running processes of a container'

# docker container unpause
# Usage: docker container unpause CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa unpause -d 'Unpause all processes within one or more containers'

# docker container update
# Usage: docker container update [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa update -d 'Update configuration of one or more containers'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l blkio-weight -r -d 'Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpu-period -r -d 'Limit CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpu-quota -r -d 'Limit CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpu-rt-period -r -d 'Limit the CPU real-time period in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpu-rt-runtime -r -d 'Limit the CPU real-time runtime in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpus -r -d 'Number of CPUs'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l kernel-memory -r -d 'Kernel memory limit'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l memory-reservation -r -d 'Memory soft limit'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith container update' -l pids-limit -r -d 'Tune container pids limit (set -1 for unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith container update' -l restart -r -d 'Restart policy to apply when a container exits'

# docker container wait
# Usage: docker container wait CONTAINER [CONTAINER...]
complete -c docker -n '__fish_docker_arguments_equals container' -fa wait -d 'Block until one or more containers stop, then print their exit codes'

# docker context
# Usage: docker context COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa context -d 'Manage contexts'

# docker context create
# Usage: docker context create [OPTIONS] CONTEXT
complete -c docker -n '__fish_docker_arguments_equals context' -fa create -d 'Create a context'
complete -c docker -n '__fish_docker_arguments_startswith context create' -l default-stack-orchestrator -r -d 'Default orchestrator for stack operations to use with this context (swarm|kubernetes|all)'
complete -c docker -n '__fish_docker_arguments_startswith context create' -l description -r -d 'Description of the context'
complete -c docker -n '__fish_docker_arguments_startswith context create' -l docker -r -d 'set the docker endpoint (default [])'
complete -c docker -n '__fish_docker_arguments_startswith context create' -l from -r -d 'create context from a named context'
complete -c docker -n '__fish_docker_arguments_startswith context create' -l kubernetes -r -d 'set the kubernetes endpoint (default [])'

# docker context export
# Usage: docker context export [OPTIONS] CONTEXT [FILE|-]
complete -c docker -n '__fish_docker_arguments_equals context' -fa export -d 'Export a context to a tar or kubeconfig file'
complete -c docker -n '__fish_docker_arguments_startswith context export' -l kubeconfig -d 'Export as a kubeconfig file'

# docker context import
# Usage: docker context import CONTEXT FILE|-
complete -c docker -n '__fish_docker_arguments_equals context' -fa import -d 'Import a context from a tar or zip file'

# docker context inspect
# Usage: docker context inspect [OPTIONS] [CONTEXT] [CONTEXT...]
complete -c docker -n '__fish_docker_arguments_equals context' -fa inspect -d 'Display detailed information on one or more contexts'
complete -c docker -n '__fish_docker_arguments_startswith context inspect' -l format -s f -r -d 'Format the output using the given Go template'

# docker context ls
# Usage: docker context ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals context' -fa ls -d 'List contexts'
complete -c docker -n '__fish_docker_arguments_startswith context ls' -l format -r -d 'Pretty-print contexts using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith context ls' -l quiet -s q -d 'Only show context names'

# docker context rm
# Usage: docker context rm CONTEXT [CONTEXT...]
complete -c docker -n '__fish_docker_arguments_equals context' -fa rm -d 'Remove one or more contexts'
complete -c docker -n '__fish_docker_arguments_startswith context rm' -l force -s f -d 'Force the removal of a context in use'

# docker context update
# Usage: docker context update [OPTIONS] CONTEXT
complete -c docker -n '__fish_docker_arguments_equals context' -fa update -d 'Update a context'
complete -c docker -n '__fish_docker_arguments_startswith context update' -l default-stack-orchestrator -r -d 'Default orchestrator for stack operations to use with this context (swarm|kubernetes|all)'
complete -c docker -n '__fish_docker_arguments_startswith context update' -l description -r -d 'Description of the context'
complete -c docker -n '__fish_docker_arguments_startswith context update' -l docker -r -d 'set the docker endpoint (default [])'
complete -c docker -n '__fish_docker_arguments_startswith context update' -l kubernetes -r -d 'set the kubernetes endpoint (default [])'

# docker context use
# Usage: docker context use CONTEXT
complete -c docker -n '__fish_docker_arguments_equals context' -fa use -d 'Set the current docker context'

# docker cp
# Usage: docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
complete -c docker -n '__fish_is_first_docker_argument' -fa cp -d 'Copy files/folders between a container and the local filesystem'
complete -c docker -n '__fish_docker_arguments_startswith cp' -l archive -s a -d 'Archive mode (copy all uid/gid information)'
complete -c docker -n '__fish_docker_arguments_startswith cp' -l follow-link -s L -d 'Always follow symbol link in SRC_PATH'

# docker create
# Usage: docker create [OPTIONS] IMAGE [COMMAND] [ARG...]
complete -c docker -n '__fish_is_first_docker_argument' -fa create -d 'Create a new container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l add-host -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l attach -s a -r -d 'Attach to STDIN, STDOUT or STDERR'
complete -c docker -n '__fish_docker_arguments_startswith create' -l blkio-weight -r -d 'Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l blkio-weight-device -r -d 'Block IO weight (relative device weight) (default [])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cap-add -r -d 'Add Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cap-drop -r -d 'Drop Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cgroup-parent -r -d 'Optional parent cgroup for the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cgroupns -r -d "Cgroup namespace to use (host|private) 'host':    Run the container in the Docker host's cgroup namespace 'private': Run the container in its own private cgroup namespace '':        Use the cgroup namespace as configured by the default-cgroupns-mode option on the daemon (default)"
complete -c docker -n '__fish_docker_arguments_startswith create' -l cidfile -r -d 'Write the container ID to the file'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpu-period -r -d 'Limit CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpu-quota -r -d 'Limit CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpu-rt-period -r -d 'Limit CPU real-time period in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpu-rt-runtime -r -d 'Limit CPU real-time runtime in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpus -r -d 'Number of CPUs'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l device -r -d 'Add a host device to the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l device-cgroup-rule -r -d 'Add a rule to the cgroup allowed devices list'
complete -c docker -n '__fish_docker_arguments_startswith create' -l device-read-bps -r -d 'Limit read rate (bytes per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l device-read-iops -r -d 'Limit read rate (IO per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l device-write-bps -r -d 'Limit write rate (bytes per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l device-write-iops -r -d 'Limit write rate (IO per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l dns -r -d 'Set custom DNS servers'
complete -c docker -n '__fish_docker_arguments_startswith create' -l dns-option -r -d 'Set DNS options'
complete -c docker -n '__fish_docker_arguments_startswith create' -l dns-search -r -d 'Set custom DNS search domains'
complete -c docker -n '__fish_docker_arguments_startswith create' -l domainname -r -d 'Container NIS domain name'
complete -c docker -n '__fish_docker_arguments_startswith create' -l entrypoint -r -d 'Overwrite the default ENTRYPOINT of the image'
complete -c docker -n '__fish_docker_arguments_startswith create' -l env -s e -r -d 'Set environment variables'
complete -c docker -n '__fish_docker_arguments_startswith create' -l env-file -r -d 'Read in a file of environment variables'
complete -c docker -n '__fish_docker_arguments_startswith create' -l expose -r -d 'Expose a port or a range of ports'
complete -c docker -n '__fish_docker_arguments_startswith create' -l gpus -r -d "GPU devices to add to the container ('all' to pass all GPUs)"
complete -c docker -n '__fish_docker_arguments_startswith create' -l group-add -r -d 'Add additional groups to join'
complete -c docker -n '__fish_docker_arguments_startswith create' -l health-cmd -r -d 'Command to run to check health'
complete -c docker -n '__fish_docker_arguments_startswith create' -l health-interval -r -d 'Time between running the check (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l health-retries -r -d 'Consecutive failures needed to report unhealthy'
complete -c docker -n '__fish_docker_arguments_startswith create' -l health-start-period -r -d 'Start period for the container to initialize before starting health-retries countdown (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l health-timeout -r -d 'Maximum time to allow one check to run (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l help -d 'Print usage'
complete -c docker -n '__fish_docker_arguments_startswith create' -l hostname -s h -r -d 'Container host name'
complete -c docker -n '__fish_docker_arguments_startswith create' -l init -d 'Run an init inside the container that forwards signals and reaps processes'
complete -c docker -n '__fish_docker_arguments_startswith create' -l interactive -s i -d 'Keep STDIN open even if not attached'
complete -c docker -n '__fish_docker_arguments_startswith create' -l ip -r -d 'IPv4 address (e.g., 172.30.100.104)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l ip6 -r -d 'IPv6 address (e.g., 2001:db8::33)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l ipc -r -d 'IPC mode to use'
complete -c docker -n '__fish_docker_arguments_startswith create' -l isolation -r -d 'Container isolation technology'
complete -c docker -n '__fish_docker_arguments_startswith create' -l kernel-memory -r -d 'Kernel memory limit'
complete -c docker -n '__fish_docker_arguments_startswith create' -l label -s l -r -d 'Set meta data on a container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l label-file -r -d 'Read in a line delimited file of labels'
complete -c docker -n '__fish_docker_arguments_startswith create' -l link -r -d 'Add link to another container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l link-local-ip -r -d 'Container IPv4/IPv6 link-local addresses'
complete -c docker -n '__fish_docker_arguments_startswith create' -l log-driver -r -d 'Logging driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l log-opt -r -d 'Log driver options'
complete -c docker -n '__fish_docker_arguments_startswith create' -l mac-address -r -d 'Container MAC address (e.g., 92:d0:c6:0a:29:33)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith create' -l memory-reservation -r -d 'Memory soft limit'
complete -c docker -n '__fish_docker_arguments_startswith create' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith create' -l memory-swappiness -r -d 'Tune container memory swappiness (0 to 100) (default -1)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l mount -r -d 'Attach a filesystem mount to the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l name -r -d 'Assign a name to the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l network -r -d 'Connect a container to a network'
complete -c docker -n '__fish_docker_arguments_startswith create' -l network-alias -r -d 'Add network-scoped alias for the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l no-healthcheck -d 'Disable any container-specified HEALTHCHECK'
complete -c docker -n '__fish_docker_arguments_startswith create' -l oom-kill-disable -d 'Disable OOM Killer'
complete -c docker -n '__fish_docker_arguments_startswith create' -l oom-score-adj -r -d "Tune host's OOM preferences (-1000 to 1000)"
complete -c docker -n '__fish_docker_arguments_startswith create' -l pid -r -d 'PID namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith create' -l pids-limit -r -d 'Tune container pids limit (set -1 for unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l platform -r -d 'Set platform if server is multi-platform capable'
complete -c docker -n '__fish_docker_arguments_startswith create' -l privileged -d 'Give extended privileges to this container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l publish -s p -r -d "Publish a container's port(s) to the host"
complete -c docker -n '__fish_docker_arguments_startswith create' -l publish-all -s P -d 'Publish all exposed ports to random ports'
complete -c docker -n '__fish_docker_arguments_startswith create' -l pull -r -d 'Pull image before creating ("always"|"missing"|"never") (default "missing")'
complete -c docker -n '__fish_docker_arguments_startswith create' -l read-only -d "Mount the container's root filesystem as read only"
complete -c docker -n '__fish_docker_arguments_startswith create' -l restart -r -d 'Restart policy to apply when a container exits (default "no")'
complete -c docker -n '__fish_docker_arguments_startswith create' -l rm -d 'Automatically remove the container when it exits'
complete -c docker -n '__fish_docker_arguments_startswith create' -l runtime -r -d 'Runtime to use for this container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l security-opt -r -d 'Security Options'
complete -c docker -n '__fish_docker_arguments_startswith create' -l shm-size -r -d 'Size of /dev/shm'
complete -c docker -n '__fish_docker_arguments_startswith create' -l stop-signal -r -d 'Signal to stop a container (default "SIGTERM")'
complete -c docker -n '__fish_docker_arguments_startswith create' -l stop-timeout -r -d 'Timeout (in seconds) to stop a container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l storage-opt -r -d 'Storage driver options for the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l sysctl -r -d 'Sysctl options (default map[])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l tmpfs -r -d 'Mount a tmpfs directory'
complete -c docker -n '__fish_docker_arguments_startswith create' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith create' -l ulimit -r -d 'Ulimit options (default [])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith create' -l userns -r -d 'User namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith create' -l uts -r -d 'UTS namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith create' -l volume -s v -r -d 'Bind mount a volume'
complete -c docker -n '__fish_docker_arguments_startswith create' -l volume-driver -r -d 'Optional volume driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith create' -l volumes-from -r -d 'Mount volumes from the specified container(s)'
complete -c docker -n '__fish_docker_arguments_startswith create' -l workdir -s w -r -d 'Working directory inside the container'

# docker diff
# Usage: docker diff CONTAINER
complete -c docker -n '__fish_is_first_docker_argument' -fa diff -d "Inspect changes to files or directories on a container's filesystem"

# docker events
# Usage: docker events [OPTIONS]
complete -c docker -n '__fish_is_first_docker_argument' -fa events -d 'Get real time events from the server'
complete -c docker -n '__fish_docker_arguments_startswith events' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith events' -l format -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith events' -l since -r -d 'Show all events created since timestamp'
complete -c docker -n '__fish_docker_arguments_startswith events' -l until -r -d 'Stream events until this timestamp'

# docker exec
# Usage: docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
complete -c docker -n '__fish_is_first_docker_argument' -fa exec -d 'Run a command in a running container'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l detach -s d -d 'Detached mode: run command in the background'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l env -s e -r -d 'Set environment variables'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l env-file -r -d 'Read in a file of environment variables'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l interactive -s i -d 'Keep STDIN open even if not attached'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l privileged -d 'Give extended privileges to the command'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith exec' -l workdir -s w -r -d 'Working directory inside the container'

# docker export
# Usage: docker export [OPTIONS] CONTAINER
complete -c docker -n '__fish_is_first_docker_argument' -fa export -d "Export a container's filesystem as a tar archive"
complete -c docker -n '__fish_docker_arguments_startswith export' -l output -s o -r -d 'Write to a file, instead of STDOUT'

# docker history
# Usage: docker history [OPTIONS] IMAGE
complete -c docker -n '__fish_is_first_docker_argument' -fa history -d 'Show the history of an image'
complete -c docker -n '__fish_docker_arguments_startswith history' -l format -r -d 'Pretty-print images using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith history' -l human -s H -d 'Print sizes and dates in human readable format (default true)'
complete -c docker -n '__fish_docker_arguments_startswith history' -l no-trunc -d "Don't truncate output"
complete -c docker -n '__fish_docker_arguments_startswith history' -l quiet -s q -d 'Only show image IDs'

# docker image
# Usage: docker image COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa image -d 'Manage images'

# docker image build
# Usage: docker image build [OPTIONS] PATH | URL | -
complete -c docker -n '__fish_docker_arguments_equals image' -fa build -d 'Build an image from a Dockerfile'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l add-host -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l build-arg -r -d 'Set build-time variables'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l cache-from -r -d 'Images to consider as cache sources'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l cgroup-parent -r -d 'Optional parent cgroup for the container'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l compress -d 'Compress the build context using gzip'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l cpu-period -r -d 'Limit the CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l cpu-quota -r -d 'Limit the CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l file -s f -r -d "Name of the Dockerfile (Default is 'PATH/Dockerfile')"
complete -c docker -n '__fish_docker_arguments_startswith image build' -l force-rm -d 'Always remove intermediate containers'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l iidfile -r -d 'Write the image ID to the file'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l isolation -r -d 'Container isolation technology'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l label -r -d 'Set metadata for an image'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith image build' -l network -r -d 'Set the networking mode for the RUN instructions during build (default "default")'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l no-cache -d 'Do not use cache when building the image'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l pull -d 'Always attempt to pull a newer version of the image'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l quiet -s q -d 'Suppress the build output and print image ID on success'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l rm -d 'Remove intermediate containers after a successful build (default true)'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l security-opt -r -d 'Security options'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l shm-size -r -d 'Size of /dev/shm'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l tag -s t -r -d "Name and optionally a tag in the 'name:tag' format"
complete -c docker -n '__fish_docker_arguments_startswith image build' -l target -r -d 'Set the target build stage to build.'
complete -c docker -n '__fish_docker_arguments_startswith image build' -l ulimit -r -d 'Ulimit options (default [])'

# docker image history
# Usage: docker image history [OPTIONS] IMAGE
complete -c docker -n '__fish_docker_arguments_equals image' -fa history -d 'Show the history of an image'
complete -c docker -n '__fish_docker_arguments_startswith image history' -l format -r -d 'Pretty-print images using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith image history' -l human -s H -d 'Print sizes and dates in human readable format (default true)'
complete -c docker -n '__fish_docker_arguments_startswith image history' -l no-trunc -d "Don't truncate output"
complete -c docker -n '__fish_docker_arguments_startswith image history' -l quiet -s q -d 'Only show image IDs'

# docker image import
# Usage: docker image import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]
complete -c docker -n '__fish_docker_arguments_equals image' -fa import -d 'Import the contents from a tarball to create a filesystem image'
complete -c docker -n '__fish_docker_arguments_startswith image import' -l change -s c -r -d 'Apply Dockerfile instruction to the created image'
complete -c docker -n '__fish_docker_arguments_startswith image import' -l message -s m -r -d 'Set commit message for imported image'
complete -c docker -n '__fish_docker_arguments_startswith image import' -l platform -r -d 'Set platform if server is multi-platform capable'

# docker image inspect
# Usage: docker image inspect [OPTIONS] IMAGE [IMAGE...]
complete -c docker -n '__fish_docker_arguments_equals image' -fa inspect -d 'Display detailed information on one or more images'
complete -c docker -n '__fish_docker_arguments_startswith image inspect' -l format -s f -r -d 'Format the output using the given Go template'

# docker image load
# Usage: docker image load [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals image' -fa load -d 'Load an image from a tar archive or STDIN'
complete -c docker -n '__fish_docker_arguments_startswith image load' -l input -s i -r -d 'Read from tar archive file, instead of STDIN'
complete -c docker -n '__fish_docker_arguments_startswith image load' -l quiet -s q -d 'Suppress the load output'

# docker image ls
# Usage: docker image ls [OPTIONS] [REPOSITORY[:TAG]]
complete -c docker -n '__fish_docker_arguments_equals image' -fa ls -d 'List images'
complete -c docker -n '__fish_docker_arguments_startswith image ls' -l all -s a -d 'Show all images (default hides intermediate images)'
complete -c docker -n '__fish_docker_arguments_startswith image ls' -l digests -d 'Show digests'
complete -c docker -n '__fish_docker_arguments_startswith image ls' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith image ls' -l format -r -d 'Pretty-print images using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith image ls' -l no-trunc -d "Don't truncate output"
complete -c docker -n '__fish_docker_arguments_startswith image ls' -l quiet -s q -d 'Only show image IDs'

# docker image prune
# Usage: docker image prune [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals image' -fa prune -d 'Remove unused images'
complete -c docker -n '__fish_docker_arguments_startswith image prune' -l all -s a -d 'Remove all unused images, not just dangling ones'
complete -c docker -n '__fish_docker_arguments_startswith image prune' -l filter -r -d "Provide filter values (e.g. 'until=<timestamp>')"
complete -c docker -n '__fish_docker_arguments_startswith image prune' -l force -s f -d 'Do not prompt for confirmation'

# docker image pull
# Usage: docker image pull [OPTIONS] NAME[:TAG|@DIGEST]
complete -c docker -n '__fish_docker_arguments_equals image' -fa pull -d 'Pull an image or a repository from a registry'
complete -c docker -n '__fish_docker_arguments_startswith image pull' -l all-tags -s a -d 'Download all tagged images in the repository'
complete -c docker -n '__fish_docker_arguments_startswith image pull' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith image pull' -l platform -r -d 'Set platform if server is multi-platform capable'
complete -c docker -n '__fish_docker_arguments_startswith image pull' -l quiet -s q -d 'Suppress verbose output'

# docker image push
# Usage: docker image push [OPTIONS] NAME[:TAG]
complete -c docker -n '__fish_docker_arguments_equals image' -fa push -d 'Push an image or a repository to a registry'
complete -c docker -n '__fish_docker_arguments_startswith image push' -l all-tags -s a -d 'Push all tagged images in the repository'
complete -c docker -n '__fish_docker_arguments_startswith image push' -l disable-content-trust -d 'Skip image signing (default true)'
complete -c docker -n '__fish_docker_arguments_startswith image push' -l quiet -s q -d 'Suppress verbose output'

# docker image rm
# Usage: docker image rm [OPTIONS] IMAGE [IMAGE...]
complete -c docker -n '__fish_docker_arguments_equals image' -fa rm -d 'Remove one or more images'
complete -c docker -n '__fish_docker_arguments_startswith image rm' -l force -s f -d 'Force removal of the image'
complete -c docker -n '__fish_docker_arguments_startswith image rm' -l no-prune -d 'Do not delete untagged parents'

# docker image save
# Usage: docker image save [OPTIONS] IMAGE [IMAGE...]
complete -c docker -n '__fish_docker_arguments_equals image' -fa save -d 'Save one or more images to a tar archive (streamed to STDOUT by default)'
complete -c docker -n '__fish_docker_arguments_startswith image save' -l output -s o -r -d 'Write to a file, instead of STDOUT'

# docker image tag
# Usage: docker image tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
complete -c docker -n '__fish_docker_arguments_equals image' -fa tag -d 'Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE'

# docker images
# Usage: docker images [OPTIONS] [REPOSITORY[:TAG]]
complete -c docker -n '__fish_is_first_docker_argument' -fa images -d 'List images'
complete -c docker -n '__fish_docker_arguments_startswith images' -l all -s a -d 'Show all images (default hides intermediate images)'
complete -c docker -n '__fish_docker_arguments_startswith images' -l digests -d 'Show digests'
complete -c docker -n '__fish_docker_arguments_startswith images' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith images' -l format -r -d 'Pretty-print images using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith images' -l no-trunc -d "Don't truncate output"
complete -c docker -n '__fish_docker_arguments_startswith images' -l quiet -s q -d 'Only show image IDs'

# docker import
# Usage: docker import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]
complete -c docker -n '__fish_is_first_docker_argument' -fa import -d 'Import the contents from a tarball to create a filesystem image'
complete -c docker -n '__fish_docker_arguments_startswith import' -l change -s c -r -d 'Apply Dockerfile instruction to the created image'
complete -c docker -n '__fish_docker_arguments_startswith import' -l message -s m -r -d 'Set commit message for imported image'
complete -c docker -n '__fish_docker_arguments_startswith import' -l platform -r -d 'Set platform if server is multi-platform capable'

# docker info
# Usage: docker info [OPTIONS]
complete -c docker -n '__fish_is_first_docker_argument' -fa info -d 'Display system-wide information'
complete -c docker -n '__fish_docker_arguments_startswith info' -l format -s f -r -d 'Format the output using the given Go template'

# docker inspect
# Usage: docker inspect [OPTIONS] NAME|ID [NAME|ID...]
complete -c docker -n '__fish_is_first_docker_argument' -fa inspect -d 'Return low-level information on Docker objects'
complete -c docker -n '__fish_docker_arguments_startswith inspect' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith inspect' -l size -s s -d 'Display total file sizes if the type is container'
complete -c docker -n '__fish_docker_arguments_startswith inspect' -l type -r -d 'Return JSON for specified type'

# docker kill
# Usage: docker kill [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa kill -d 'Kill one or more running containers'
complete -c docker -n '__fish_docker_arguments_startswith kill' -l signal -s s -r -d 'Signal to send to the container (default "KILL")'

# docker load
# Usage: docker load [OPTIONS]
complete -c docker -n '__fish_is_first_docker_argument' -fa load -d 'Load an image from a tar archive or STDIN'
complete -c docker -n '__fish_docker_arguments_startswith load' -l input -s i -r -d 'Read from tar archive file, instead of STDIN'
complete -c docker -n '__fish_docker_arguments_startswith load' -l quiet -s q -d 'Suppress the load output'

# docker login
# Usage: docker login [OPTIONS] [SERVER]
complete -c docker -n '__fish_is_first_docker_argument' -fa login -d 'Log in to a Docker registry'
complete -c docker -n '__fish_docker_arguments_startswith login' -l password -s p -r -d 'Password'
complete -c docker -n '__fish_docker_arguments_startswith login' -l password-stdin -d 'Take the password from stdin'
complete -c docker -n '__fish_docker_arguments_startswith login' -l username -s u -r -d 'Username'

# docker logout
# Usage: docker logout [SERVER]
complete -c docker -n '__fish_is_first_docker_argument' -fa logout -d 'Log out from a Docker registry'

# docker logs
# Usage: docker logs [OPTIONS] CONTAINER
complete -c docker -n '__fish_is_first_docker_argument' -fa logs -d 'Fetch the logs of a container'
complete -c docker -n '__fish_docker_arguments_startswith logs' -l details -d 'Show extra details provided to logs'
complete -c docker -n '__fish_docker_arguments_startswith logs' -l follow -s f -d 'Follow log output'
complete -c docker -n '__fish_docker_arguments_startswith logs' -l since -r -d 'Show logs since timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)'
complete -c docker -n '__fish_docker_arguments_startswith logs' -l tail -s n -r -d 'Number of lines to show from the end of the logs (default "all")'
complete -c docker -n '__fish_docker_arguments_startswith logs' -l timestamps -s t -d 'Show timestamps'
complete -c docker -n '__fish_docker_arguments_startswith logs' -l until -r -d 'Show logs before a timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)'

# docker manifest
# Usage: docker manifest COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa manifest -d 'Manage Docker image manifests and manifest lists'

# docker manifest annotate
# Usage: docker manifest annotate [OPTIONS] MANIFEST_LIST MANIFEST
complete -c docker -n '__fish_docker_arguments_equals manifest' -fa annotate -d 'Add additional information to a local image manifest'
complete -c docker -n '__fish_docker_arguments_startswith manifest annotate' -l arch -r -d 'Set architecture'
complete -c docker -n '__fish_docker_arguments_startswith manifest annotate' -l os -r -d 'Set operating system'
complete -c docker -n '__fish_docker_arguments_startswith manifest annotate' -l os-features -r -d 'Set operating system feature'
complete -c docker -n '__fish_docker_arguments_startswith manifest annotate' -l os-version -r -d 'Set operating system version'
complete -c docker -n '__fish_docker_arguments_startswith manifest annotate' -l variant -r -d 'Set architecture variant'

# docker manifest create
# Usage: docker manifest create MANIFEST_LIST MANIFEST [MANIFEST...]
complete -c docker -n '__fish_docker_arguments_equals manifest' -fa create -d 'Create a local manifest list for annotating and pushing to a registry'
complete -c docker -n '__fish_docker_arguments_startswith manifest create' -l amend -s a -d 'Amend an existing manifest list'
complete -c docker -n '__fish_docker_arguments_startswith manifest create' -l insecure -d 'Allow communication with an insecure registry'

# docker manifest inspect
# Usage: docker manifest inspect [OPTIONS] [MANIFEST_LIST] MANIFEST
complete -c docker -n '__fish_docker_arguments_equals manifest' -fa inspect -d 'Display an image manifest, or manifest list'
complete -c docker -n '__fish_docker_arguments_startswith manifest inspect' -l insecure -d 'Allow communication with an insecure registry'
complete -c docker -n '__fish_docker_arguments_startswith manifest inspect' -l verbose -s v -d 'Output additional info including layers and platform'

# docker manifest push
# Usage: docker manifest push [OPTIONS] MANIFEST_LIST
complete -c docker -n '__fish_docker_arguments_equals manifest' -fa push -d 'Push a manifest list to a repository'
complete -c docker -n '__fish_docker_arguments_startswith manifest push' -l insecure -d 'Allow push to an insecure registry'
complete -c docker -n '__fish_docker_arguments_startswith manifest push' -l purge -s p -d 'Remove the local manifest list after push'

# docker manifest rm
# Usage: docker manifest rm MANIFEST_LIST [MANIFEST_LIST...]
complete -c docker -n '__fish_docker_arguments_equals manifest' -fa rm -d 'Delete one or more manifest lists from local storage'

# docker network
# Usage: docker network COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa network -d 'Manage networks'

# docker network connect
# Usage: docker network connect [OPTIONS] NETWORK CONTAINER
complete -c docker -n '__fish_docker_arguments_equals network' -fa connect -d 'Connect a container to a network'
complete -c docker -n '__fish_docker_arguments_startswith network connect' -l alias -r -d 'Add network-scoped alias for the container'
complete -c docker -n '__fish_docker_arguments_startswith network connect' -l driver-opt -r -d 'driver options for the network'
complete -c docker -n '__fish_docker_arguments_startswith network connect' -l ip -r -d 'IPv4 address (e.g., 172.30.100.104)'
complete -c docker -n '__fish_docker_arguments_startswith network connect' -l ip6 -r -d 'IPv6 address (e.g., 2001:db8::33)'
complete -c docker -n '__fish_docker_arguments_startswith network connect' -l link -r -d 'Add link to another container'
complete -c docker -n '__fish_docker_arguments_startswith network connect' -l link-local-ip -r -d 'Add a link-local address for the container'

# docker network create
# Usage: docker network create [OPTIONS] NETWORK
complete -c docker -n '__fish_docker_arguments_equals network' -fa create -d 'Create a network'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l attachable -d 'Enable manual container attachment'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l aux-address -r -d 'Auxiliary IPv4 or IPv6 addresses used by Network driver (default map[])'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l config-from -r -d 'The network from which to copy the configuration'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l config-only -d 'Create a configuration only network'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l driver -s d -r -d 'Driver to manage the Network (default "bridge")'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l gateway -r -d 'IPv4 or IPv6 Gateway for the master subnet'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l ingress -d 'Create swarm routing-mesh network'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l internal -d 'Restrict external access to the network'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l ip-range -r -d 'Allocate container ip from a sub-range'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l ipam-driver -r -d 'IP Address Management Driver (default "default")'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l ipam-opt -r -d 'Set IPAM driver specific options (default map[])'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l ipv6 -d 'Enable IPv6 networking'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l label -r -d 'Set metadata on a network'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l opt -s o -r -d 'Set driver specific options (default map[])'
complete -c docker -n '__fish_docker_arguments_startswith network create' -l scope -r -d "Control the network's scope"
complete -c docker -n '__fish_docker_arguments_startswith network create' -l subnet -r -d 'Subnet in CIDR format that represents a network segment'

# docker network disconnect
# Usage: docker network disconnect [OPTIONS] NETWORK CONTAINER
complete -c docker -n '__fish_docker_arguments_equals network' -fa disconnect -d 'Disconnect a container from a network'
complete -c docker -n '__fish_docker_arguments_startswith network disconnect' -l force -s f -d 'Force the container to disconnect from a network'

# docker network inspect
# Usage: docker network inspect [OPTIONS] NETWORK [NETWORK...]
complete -c docker -n '__fish_docker_arguments_equals network' -fa inspect -d 'Display detailed information on one or more networks'
complete -c docker -n '__fish_docker_arguments_startswith network inspect' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith network inspect' -l verbose -s v -d 'Verbose output for diagnostics'

# docker network ls
# Usage: docker network ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals network' -fa ls -d 'List networks'
complete -c docker -n '__fish_docker_arguments_startswith network ls' -l filter -s f -r -d "Provide filter values (e.g. 'driver=bridge')"
complete -c docker -n '__fish_docker_arguments_startswith network ls' -l format -r -d 'Pretty-print networks using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith network ls' -l no-trunc -d 'Do not truncate the output'
complete -c docker -n '__fish_docker_arguments_startswith network ls' -l quiet -s q -d 'Only display network IDs'

# docker network prune
# Usage: docker network prune [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals network' -fa prune -d 'Remove all unused networks'
complete -c docker -n '__fish_docker_arguments_startswith network prune' -l filter -r -d "Provide filter values (e.g. 'until=<timestamp>')"
complete -c docker -n '__fish_docker_arguments_startswith network prune' -l force -s f -d 'Do not prompt for confirmation'

# docker network rm
# Usage: docker network rm NETWORK [NETWORK...]
complete -c docker -n '__fish_docker_arguments_equals network' -fa rm -d 'Remove one or more networks'

# docker node
# Usage: docker node COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa node -d 'Manage Swarm nodes'

# docker node demote
# Usage: docker node demote NODE [NODE...]
complete -c docker -n '__fish_docker_arguments_equals node' -fa demote -d 'Demote one or more nodes from manager in the swarm'

# docker node inspect
# Usage: docker node inspect [OPTIONS] self|NODE [NODE...]
complete -c docker -n '__fish_docker_arguments_equals node' -fa inspect -d 'Display detailed information on one or more nodes'
complete -c docker -n '__fish_docker_arguments_startswith node inspect' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith node inspect' -l pretty -d 'Print the information in a human friendly format'

# docker node ls
# Usage: docker node ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals node' -fa ls -d 'List nodes in the swarm'
complete -c docker -n '__fish_docker_arguments_startswith node ls' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith node ls' -l format -r -d 'Pretty-print nodes using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith node ls' -l quiet -s q -d 'Only display IDs'

# docker node promote
# Usage: docker node promote NODE [NODE...]
complete -c docker -n '__fish_docker_arguments_equals node' -fa promote -d 'Promote one or more nodes to manager in the swarm'

# docker node ps
# Usage: docker node ps [OPTIONS] [NODE...]
complete -c docker -n '__fish_docker_arguments_equals node' -fa ps -d 'List tasks running on one or more nodes, defaults to current node'
complete -c docker -n '__fish_docker_arguments_startswith node ps' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith node ps' -l format -r -d 'Pretty-print tasks using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith node ps' -l no-resolve -d 'Do not map IDs to Names'
complete -c docker -n '__fish_docker_arguments_startswith node ps' -l no-trunc -d 'Do not truncate output'
complete -c docker -n '__fish_docker_arguments_startswith node ps' -l quiet -s q -d 'Only display task IDs'

# docker node rm
# Usage: docker node rm [OPTIONS] NODE [NODE...]
complete -c docker -n '__fish_docker_arguments_equals node' -fa rm -d 'Remove one or more nodes from the swarm'
complete -c docker -n '__fish_docker_arguments_startswith node rm' -l force -s f -d 'Force remove a node from the swarm'

# docker node update
# Usage: docker node update [OPTIONS] NODE
complete -c docker -n '__fish_docker_arguments_equals node' -fa update -d 'Update a node'
complete -c docker -n '__fish_docker_arguments_startswith node update' -l availability -r -d 'Availability of the node ("active"|"pause"|"drain")'
complete -c docker -n '__fish_docker_arguments_startswith node update' -l label-add -r -d 'Add or update a node label (key=value)'
complete -c docker -n '__fish_docker_arguments_startswith node update' -l label-rm -r -d 'Remove a node label if exists'
complete -c docker -n '__fish_docker_arguments_startswith node update' -l role -r -d 'Role of the node ("worker"|"manager")'

# docker pause
# Usage: docker pause CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa pause -d 'Pause all processes within one or more containers'

# docker plugin
# Usage: docker plugin COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa plugin -d 'Manage plugins'

# docker plugin create
# Usage: docker plugin create [OPTIONS] PLUGIN PLUGIN-DATA-DIR
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa create -d 'Create a plugin from a rootfs and configuration. Plugin data directory must contain config.json and rootfs directory.'
complete -c docker -n '__fish_docker_arguments_startswith plugin create' -l compress -d 'Compress the context using gzip'

# docker plugin disable
# Usage: docker plugin disable [OPTIONS] PLUGIN
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa disable -d 'Disable a plugin'
complete -c docker -n '__fish_docker_arguments_startswith plugin disable' -l force -s f -d 'Force the disable of an active plugin'

# docker plugin enable
# Usage: docker plugin enable [OPTIONS] PLUGIN
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa enable -d 'Enable a plugin'
complete -c docker -n '__fish_docker_arguments_startswith plugin enable' -l timeout -r -d 'HTTP client timeout (in seconds) (default 30)'

# docker plugin inspect
# Usage: docker plugin inspect [OPTIONS] PLUGIN [PLUGIN...]
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa inspect -d 'Display detailed information on one or more plugins'
complete -c docker -n '__fish_docker_arguments_startswith plugin inspect' -l format -s f -r -d 'Format the output using the given Go template'

# docker plugin install
# Usage: docker plugin install [OPTIONS] PLUGIN [KEY=VALUE...]
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa install -d 'Install a plugin'
complete -c docker -n '__fish_docker_arguments_startswith plugin install' -l alias -r -d 'Local name for plugin'
complete -c docker -n '__fish_docker_arguments_startswith plugin install' -l disable -d 'Do not enable the plugin on install'
complete -c docker -n '__fish_docker_arguments_startswith plugin install' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith plugin install' -l grant-all-permissions -d 'Grant all permissions necessary to run the plugin'

# docker plugin ls
# Usage: docker plugin ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa ls -d 'List plugins'
complete -c docker -n '__fish_docker_arguments_startswith plugin ls' -l filter -s f -r -d "Provide filter values (e.g. 'enabled=true')"
complete -c docker -n '__fish_docker_arguments_startswith plugin ls' -l format -r -d 'Pretty-print plugins using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith plugin ls' -l no-trunc -d "Don't truncate output"
complete -c docker -n '__fish_docker_arguments_startswith plugin ls' -l quiet -s q -d 'Only display plugin IDs'

# docker plugin push
# Usage: docker plugin push [OPTIONS] PLUGIN[:TAG]
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa push -d 'Push a plugin to a registry'
complete -c docker -n '__fish_docker_arguments_startswith plugin push' -l disable-content-trust -d 'Skip image signing (default true)'

# docker plugin rm
# Usage: docker plugin rm [OPTIONS] PLUGIN [PLUGIN...]
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa rm -d 'Remove one or more plugins'
complete -c docker -n '__fish_docker_arguments_startswith plugin rm' -l force -s f -d 'Force the removal of an active plugin'

# docker plugin set
# Usage: docker plugin set PLUGIN KEY=VALUE [KEY=VALUE...]
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa set -d 'Change settings for a plugin'

# docker plugin upgrade
# Usage: docker plugin upgrade [OPTIONS] PLUGIN [REMOTE]
complete -c docker -n '__fish_docker_arguments_equals plugin' -fa upgrade -d 'Upgrade an existing plugin'
complete -c docker -n '__fish_docker_arguments_startswith plugin upgrade' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith plugin upgrade' -l grant-all-permissions -d 'Grant all permissions necessary to run the plugin'
complete -c docker -n '__fish_docker_arguments_startswith plugin upgrade' -l skip-remote-check -d 'Do not check if specified remote plugin matches existing plugin image'

# docker port
# Usage: docker port CONTAINER [PRIVATE_PORT[/PROTO]]
complete -c docker -n '__fish_is_first_docker_argument' -fa port -d 'List port mappings or a specific mapping for the container'

# docker ps
# Usage: docker ps [OPTIONS]
complete -c docker -n '__fish_is_first_docker_argument' -fa ps -d 'List containers'
complete -c docker -n '__fish_docker_arguments_startswith ps' -l all -s a -d 'Show all containers (default shows just running)'
complete -c docker -n '__fish_docker_arguments_startswith ps' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith ps' -l format -r -d 'Pretty-print containers using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith ps' -l last -s n -r -d 'Show n last created containers (includes all states) (default -1)'
complete -c docker -n '__fish_docker_arguments_startswith ps' -l latest -s l -d 'Show the latest created container (includes all states)'
complete -c docker -n '__fish_docker_arguments_startswith ps' -l no-trunc -d "Don't truncate output"
complete -c docker -n '__fish_docker_arguments_startswith ps' -l quiet -s q -d 'Only display container IDs'
complete -c docker -n '__fish_docker_arguments_startswith ps' -l size -s s -d 'Display total file sizes'

# docker pull
# Usage: docker pull [OPTIONS] NAME[:TAG|@DIGEST]
complete -c docker -n '__fish_is_first_docker_argument' -fa pull -d 'Pull an image or a repository from a registry'
complete -c docker -n '__fish_docker_arguments_startswith pull' -l all-tags -s a -d 'Download all tagged images in the repository'
complete -c docker -n '__fish_docker_arguments_startswith pull' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith pull' -l platform -r -d 'Set platform if server is multi-platform capable'
complete -c docker -n '__fish_docker_arguments_startswith pull' -l quiet -s q -d 'Suppress verbose output'

# docker push
# Usage: docker push [OPTIONS] NAME[:TAG]
complete -c docker -n '__fish_is_first_docker_argument' -fa push -d 'Push an image or a repository to a registry'
complete -c docker -n '__fish_docker_arguments_startswith push' -l all-tags -s a -d 'Push all tagged images in the repository'
complete -c docker -n '__fish_docker_arguments_startswith push' -l disable-content-trust -d 'Skip image signing (default true)'
complete -c docker -n '__fish_docker_arguments_startswith push' -l quiet -s q -d 'Suppress verbose output'

# docker rename
# Usage: docker rename CONTAINER NEW_NAME
complete -c docker -n '__fish_is_first_docker_argument' -fa rename -d 'Rename a container'

# docker restart
# Usage: docker restart [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa restart -d 'Restart one or more containers'
complete -c docker -n '__fish_docker_arguments_startswith restart' -l time -s t -r -d 'Seconds to wait for stop before killing the container (default 10)'

# docker rm
# Usage: docker rm [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa rm -d 'Remove one or more containers'
complete -c docker -n '__fish_docker_arguments_startswith rm' -l force -s f -d 'Force the removal of a running container (uses SIGKILL)'
complete -c docker -n '__fish_docker_arguments_startswith rm' -l link -s l -d 'Remove the specified link'
complete -c docker -n '__fish_docker_arguments_startswith rm' -l volumes -s v -d 'Remove anonymous volumes associated with the container'

# docker rmi
# Usage: docker rmi [OPTIONS] IMAGE [IMAGE...]
complete -c docker -n '__fish_is_first_docker_argument' -fa rmi -d 'Remove one or more images'
complete -c docker -n '__fish_docker_arguments_startswith rmi' -l force -s f -d 'Force removal of the image'
complete -c docker -n '__fish_docker_arguments_startswith rmi' -l no-prune -d 'Do not delete untagged parents'

# docker run
# Usage: docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
complete -c docker -n '__fish_is_first_docker_argument' -fa run -d 'Run a command in a new container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l add-host -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l attach -s a -r -d 'Attach to STDIN, STDOUT or STDERR'
complete -c docker -n '__fish_docker_arguments_startswith run' -l blkio-weight -r -d 'Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l blkio-weight-device -r -d 'Block IO weight (relative device weight) (default [])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cap-add -r -d 'Add Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cap-drop -r -d 'Drop Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cgroup-parent -r -d 'Optional parent cgroup for the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cgroupns -r -d "Cgroup namespace to use (host|private) 'host':    Run the container in the Docker host's cgroup namespace 'private': Run the container in its own private cgroup namespace '':        Use the cgroup namespace as configured by the default-cgroupns-mode option on the daemon (default)"
complete -c docker -n '__fish_docker_arguments_startswith run' -l cidfile -r -d 'Write the container ID to the file'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpu-period -r -d 'Limit CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpu-quota -r -d 'Limit CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpu-rt-period -r -d 'Limit CPU real-time period in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpu-rt-runtime -r -d 'Limit CPU real-time runtime in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpus -r -d 'Number of CPUs'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l detach -s d -d 'Run container in background and print container ID'
complete -c docker -n '__fish_docker_arguments_startswith run' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l device -r -d 'Add a host device to the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l device-cgroup-rule -r -d 'Add a rule to the cgroup allowed devices list'
complete -c docker -n '__fish_docker_arguments_startswith run' -l device-read-bps -r -d 'Limit read rate (bytes per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l device-read-iops -r -d 'Limit read rate (IO per second) from a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l device-write-bps -r -d 'Limit write rate (bytes per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l device-write-iops -r -d 'Limit write rate (IO per second) to a device (default [])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l disable-content-trust -d 'Skip image verification (default true)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l dns -r -d 'Set custom DNS servers'
complete -c docker -n '__fish_docker_arguments_startswith run' -l dns-option -r -d 'Set DNS options'
complete -c docker -n '__fish_docker_arguments_startswith run' -l dns-search -r -d 'Set custom DNS search domains'
complete -c docker -n '__fish_docker_arguments_startswith run' -l domainname -r -d 'Container NIS domain name'
complete -c docker -n '__fish_docker_arguments_startswith run' -l entrypoint -r -d 'Overwrite the default ENTRYPOINT of the image'
complete -c docker -n '__fish_docker_arguments_startswith run' -l env -s e -r -d 'Set environment variables'
complete -c docker -n '__fish_docker_arguments_startswith run' -l env-file -r -d 'Read in a file of environment variables'
complete -c docker -n '__fish_docker_arguments_startswith run' -l expose -r -d 'Expose a port or a range of ports'
complete -c docker -n '__fish_docker_arguments_startswith run' -l gpus -r -d "GPU devices to add to the container ('all' to pass all GPUs)"
complete -c docker -n '__fish_docker_arguments_startswith run' -l group-add -r -d 'Add additional groups to join'
complete -c docker -n '__fish_docker_arguments_startswith run' -l health-cmd -r -d 'Command to run to check health'
complete -c docker -n '__fish_docker_arguments_startswith run' -l health-interval -r -d 'Time between running the check (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l health-retries -r -d 'Consecutive failures needed to report unhealthy'
complete -c docker -n '__fish_docker_arguments_startswith run' -l health-start-period -r -d 'Start period for the container to initialize before starting health-retries countdown (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l health-timeout -r -d 'Maximum time to allow one check to run (ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l help -d 'Print usage'
complete -c docker -n '__fish_docker_arguments_startswith run' -l hostname -s h -r -d 'Container host name'
complete -c docker -n '__fish_docker_arguments_startswith run' -l init -d 'Run an init inside the container that forwards signals and reaps processes'
complete -c docker -n '__fish_docker_arguments_startswith run' -l interactive -s i -d 'Keep STDIN open even if not attached'
complete -c docker -n '__fish_docker_arguments_startswith run' -l ip -r -d 'IPv4 address (e.g., 172.30.100.104)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l ip6 -r -d 'IPv6 address (e.g., 2001:db8::33)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l ipc -r -d 'IPC mode to use'
complete -c docker -n '__fish_docker_arguments_startswith run' -l isolation -r -d 'Container isolation technology'
complete -c docker -n '__fish_docker_arguments_startswith run' -l kernel-memory -r -d 'Kernel memory limit'
complete -c docker -n '__fish_docker_arguments_startswith run' -l label -s l -r -d 'Set meta data on a container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l label-file -r -d 'Read in a line delimited file of labels'
complete -c docker -n '__fish_docker_arguments_startswith run' -l link -r -d 'Add link to another container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l link-local-ip -r -d 'Container IPv4/IPv6 link-local addresses'
complete -c docker -n '__fish_docker_arguments_startswith run' -l log-driver -r -d 'Logging driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l log-opt -r -d 'Log driver options'
complete -c docker -n '__fish_docker_arguments_startswith run' -l mac-address -r -d 'Container MAC address (e.g., 92:d0:c6:0a:29:33)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith run' -l memory-reservation -r -d 'Memory soft limit'
complete -c docker -n '__fish_docker_arguments_startswith run' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith run' -l memory-swappiness -r -d 'Tune container memory swappiness (0 to 100) (default -1)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l mount -r -d 'Attach a filesystem mount to the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l name -r -d 'Assign a name to the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l network -r -d 'Connect a container to a network'
complete -c docker -n '__fish_docker_arguments_startswith run' -l network-alias -r -d 'Add network-scoped alias for the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l no-healthcheck -d 'Disable any container-specified HEALTHCHECK'
complete -c docker -n '__fish_docker_arguments_startswith run' -l oom-kill-disable -d 'Disable OOM Killer'
complete -c docker -n '__fish_docker_arguments_startswith run' -l oom-score-adj -r -d "Tune host's OOM preferences (-1000 to 1000)"
complete -c docker -n '__fish_docker_arguments_startswith run' -l pid -r -d 'PID namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith run' -l pids-limit -r -d 'Tune container pids limit (set -1 for unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l platform -r -d 'Set platform if server is multi-platform capable'
complete -c docker -n '__fish_docker_arguments_startswith run' -l privileged -d 'Give extended privileges to this container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l publish -s p -r -d "Publish a container's port(s) to the host"
complete -c docker -n '__fish_docker_arguments_startswith run' -l publish-all -s P -d 'Publish all exposed ports to random ports'
complete -c docker -n '__fish_docker_arguments_startswith run' -l pull -r -d 'Pull image before running ("always"|"missing"|"never") (default "missing")'
complete -c docker -n '__fish_docker_arguments_startswith run' -l read-only -d "Mount the container's root filesystem as read only"
complete -c docker -n '__fish_docker_arguments_startswith run' -l restart -r -d 'Restart policy to apply when a container exits (default "no")'
complete -c docker -n '__fish_docker_arguments_startswith run' -l rm -d 'Automatically remove the container when it exits'
complete -c docker -n '__fish_docker_arguments_startswith run' -l runtime -r -d 'Runtime to use for this container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l security-opt -r -d 'Security Options'
complete -c docker -n '__fish_docker_arguments_startswith run' -l shm-size -r -d 'Size of /dev/shm'
complete -c docker -n '__fish_docker_arguments_startswith run' -l sig-proxy -d 'Proxy received signals to the process (default true)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l stop-signal -r -d 'Signal to stop a container (default "SIGTERM")'
complete -c docker -n '__fish_docker_arguments_startswith run' -l stop-timeout -r -d 'Timeout (in seconds) to stop a container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l storage-opt -r -d 'Storage driver options for the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l sysctl -r -d 'Sysctl options (default map[])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l tmpfs -r -d 'Mount a tmpfs directory'
complete -c docker -n '__fish_docker_arguments_startswith run' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith run' -l ulimit -r -d 'Ulimit options (default [])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith run' -l userns -r -d 'User namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith run' -l uts -r -d 'UTS namespace to use'
complete -c docker -n '__fish_docker_arguments_startswith run' -l volume -s v -r -d 'Bind mount a volume'
complete -c docker -n '__fish_docker_arguments_startswith run' -l volume-driver -r -d 'Optional volume driver for the container'
complete -c docker -n '__fish_docker_arguments_startswith run' -l volumes-from -r -d 'Mount volumes from the specified container(s)'
complete -c docker -n '__fish_docker_arguments_startswith run' -l workdir -s w -r -d 'Working directory inside the container'

# docker save
# Usage: docker save [OPTIONS] IMAGE [IMAGE...]
complete -c docker -n '__fish_is_first_docker_argument' -fa save -d 'Save one or more images to a tar archive (streamed to STDOUT by default)'
complete -c docker -n '__fish_docker_arguments_startswith save' -l output -s o -r -d 'Write to a file, instead of STDOUT'

# docker search
# Usage: docker search [OPTIONS] TERM
complete -c docker -n '__fish_is_first_docker_argument' -fa search -d 'Search the Docker Hub for images'
complete -c docker -n '__fish_docker_arguments_startswith search' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith search' -l format -r -d 'Pretty-print search using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith search' -l limit -r -d 'Max number of search results (default 25)'
complete -c docker -n '__fish_docker_arguments_startswith search' -l no-trunc -d "Don't truncate output"

# docker secret
# Usage: docker secret COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa secret -d 'Manage Docker secrets'

# docker secret create
# Usage: docker secret create [OPTIONS] SECRET [file|-]
complete -c docker -n '__fish_docker_arguments_equals secret' -fa create -d 'Create a secret from a file or STDIN as content'
complete -c docker -n '__fish_docker_arguments_startswith secret create' -l driver -s d -r -d 'Secret driver'
complete -c docker -n '__fish_docker_arguments_startswith secret create' -l label -s l -r -d 'Secret labels'
complete -c docker -n '__fish_docker_arguments_startswith secret create' -l template-driver -r -d 'Template driver'

# docker secret inspect
# Usage: docker secret inspect [OPTIONS] SECRET [SECRET...]
complete -c docker -n '__fish_docker_arguments_equals secret' -fa inspect -d 'Display detailed information on one or more secrets'
complete -c docker -n '__fish_docker_arguments_startswith secret inspect' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith secret inspect' -l pretty -d 'Print the information in a human friendly format'

# docker secret ls
# Usage: docker secret ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals secret' -fa ls -d 'List secrets'
complete -c docker -n '__fish_docker_arguments_startswith secret ls' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith secret ls' -l format -r -d 'Pretty-print secrets using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith secret ls' -l quiet -s q -d 'Only display IDs'

# docker secret rm
# Usage: docker secret rm SECRET [SECRET...]
complete -c docker -n '__fish_docker_arguments_equals secret' -fa rm -d 'Remove one or more secrets'

# docker service
# Usage: docker service COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa service -d 'Manage services'

# docker service create
# Usage: docker service create [OPTIONS] IMAGE [COMMAND] [ARG...]
complete -c docker -n '__fish_docker_arguments_equals service' -fa create -d 'Create a new service'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l cap-add -r -d 'Add Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l cap-drop -r -d 'Drop Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l config -r -d 'Specify configurations to expose to the service'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l constraint -r -d 'Placement constraints'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l container-label -r -d 'Container labels'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l credential-spec -r -d 'Credential spec for managed service account (Windows only)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l detach -s d -d 'Exit immediately instead of waiting for the service to converge'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l dns -r -d 'Set custom DNS servers'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l dns-option -r -d 'Set DNS options'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l dns-search -r -d 'Set custom DNS search domains'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l endpoint-mode -r -d 'Endpoint mode (vip or dnsrr) (default "vip")'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l entrypoint -r -d 'Overwrite the default ENTRYPOINT of the image'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l env -s e -r -d 'Set environment variables'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l env-file -r -d 'Read in a file of environment variables'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l generic-resource -r -d 'User defined resources'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l group -r -d 'Set one or more supplementary user groups for the container'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l health-cmd -r -d 'Command to run to check health'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l health-interval -r -d 'Time between running the check (ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l health-retries -r -d 'Consecutive failures needed to report unhealthy'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l health-start-period -r -d 'Start period for the container to initialize before counting retries towards unstable (ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l health-timeout -r -d 'Maximum time to allow one check to run (ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l host -r -d 'Set one or more custom host-to-IP mappings (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l hostname -r -d 'Container hostname'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l init -d 'Use an init inside each service container to forward signals and reap processes'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l isolation -r -d 'Service container isolation mode'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l label -s l -r -d 'Service labels'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l limit-cpu -r -d 'Limit CPUs'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l limit-memory -r -d 'Limit Memory'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l limit-pids -r -d 'Limit maximum number of processes (default 0 = unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l log-driver -r -d 'Logging driver for service'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l log-opt -r -d 'Logging driver options'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l max-concurrent -r -d 'Number of job tasks to run concurrently (default equal to --replicas)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l mode -r -d 'Service mode (replicated, global, replicated-job, or global-job) (default "replicated")'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l mount -r -d 'Attach a filesystem mount to the service'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l name -r -d 'Service name'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l network -r -d 'Network attachments'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l no-healthcheck -d 'Disable any container-specified HEALTHCHECK'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l no-resolve-image -d 'Do not query the registry to resolve image digest and supported platforms'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l placement-pref -r -d 'Add a placement preference'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l publish -s p -r -d 'Publish a port as a node port'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l quiet -s q -d 'Suppress progress output'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l read-only -d "Mount the container's root filesystem as read only"
complete -c docker -n '__fish_docker_arguments_startswith service create' -l replicas -r -d 'Number of tasks'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l replicas-max-per-node -r -d 'Maximum number of tasks per node (default 0 = unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l reserve-cpu -r -d 'Reserve CPUs'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l reserve-memory -r -d 'Reserve Memory'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l restart-condition -r -d 'Restart when condition is met ("none"|"on-failure"|"any") (default "any")'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l restart-delay -r -d 'Delay between restart attempts (ns|us|ms|s|m|h) (default 5s)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l restart-max-attempts -r -d 'Maximum number of restarts before giving up'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l restart-window -r -d 'Window used to evaluate the restart policy (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l rollback-delay -r -d 'Delay between task rollbacks (ns|us|ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l rollback-failure-action -r -d 'Action on rollback failure ("pause"|"continue") (default "pause")'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l rollback-max-failure-ratio -r -d 'Failure rate to tolerate during a rollback (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l rollback-monitor -r -d 'Duration after each task rollback to monitor for failure (ns|us|ms|s|m|h) (default 5s)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l rollback-order -r -d 'Rollback order ("start-first"|"stop-first") (default "stop-first")'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l rollback-parallelism -r -d 'Maximum number of tasks rolled back simultaneously (0 to roll back all at once) (default 1)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l secret -r -d 'Specify secrets to expose to the service'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l stop-grace-period -r -d 'Time to wait before force killing a container (ns|us|ms|s|m|h) (default 10s)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l stop-signal -r -d 'Signal to stop the container'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l sysctl -r -d 'Sysctl options'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l ulimit -r -d 'Ulimit options (default [])'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l update-delay -r -d 'Delay between updates (ns|us|ms|s|m|h) (default 0s)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l update-failure-action -r -d 'Action on update failure ("pause"|"continue"|"rollback") (default "pause")'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l update-max-failure-ratio -r -d 'Failure rate to tolerate during an update (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l update-monitor -r -d 'Duration after each task update to monitor for failure (ns|us|ms|s|m|h) (default 5s)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l update-order -r -d 'Update order ("start-first"|"stop-first") (default "stop-first")'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l update-parallelism -r -d 'Maximum number of tasks updated simultaneously (0 to update all at once) (default 1)'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l with-registry-auth -d 'Send registry authentication details to swarm agents'
complete -c docker -n '__fish_docker_arguments_startswith service create' -l workdir -s w -r -d 'Working directory inside the container'

# docker service inspect
# Usage: docker service inspect [OPTIONS] SERVICE [SERVICE...]
complete -c docker -n '__fish_docker_arguments_equals service' -fa inspect -d 'Display detailed information on one or more services'
complete -c docker -n '__fish_docker_arguments_startswith service inspect' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith service inspect' -l pretty -d 'Print the information in a human friendly format'

# docker service logs
# Usage: docker service logs [OPTIONS] SERVICE|TASK
complete -c docker -n '__fish_docker_arguments_equals service' -fa logs -d 'Fetch the logs of a service or task'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l details -d 'Show extra details provided to logs'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l follow -s f -d 'Follow log output'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l no-resolve -d 'Do not map IDs to Names in output'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l no-task-ids -d 'Do not include task IDs in output'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l no-trunc -d 'Do not truncate output'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l raw -d 'Do not neatly format logs'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l since -r -d 'Show logs since timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l tail -s n -r -d 'Number of lines to show from the end of the logs (default "all")'
complete -c docker -n '__fish_docker_arguments_startswith service logs' -l timestamps -s t -d 'Show timestamps'

# docker service ls
# Usage: docker service ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals service' -fa ls -d 'List services'
complete -c docker -n '__fish_docker_arguments_startswith service ls' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith service ls' -l format -r -d 'Pretty-print services using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith service ls' -l quiet -s q -d 'Only display IDs'

# docker service ps
# Usage: docker service ps [OPTIONS] SERVICE [SERVICE...]
complete -c docker -n '__fish_docker_arguments_equals service' -fa ps -d 'List the tasks of one or more services'
complete -c docker -n '__fish_docker_arguments_startswith service ps' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith service ps' -l format -r -d 'Pretty-print tasks using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith service ps' -l no-resolve -d 'Do not map IDs to Names'
complete -c docker -n '__fish_docker_arguments_startswith service ps' -l no-trunc -d 'Do not truncate output'
complete -c docker -n '__fish_docker_arguments_startswith service ps' -l quiet -s q -d 'Only display task IDs'

# docker service rm
# Usage: docker service rm SERVICE [SERVICE...]
complete -c docker -n '__fish_docker_arguments_equals service' -fa rm -d 'Remove one or more services'

# docker service rollback
# Usage: docker service rollback [OPTIONS] SERVICE
complete -c docker -n '__fish_docker_arguments_equals service' -fa rollback -d "Revert changes to a service's configuration"
complete -c docker -n '__fish_docker_arguments_startswith service rollback' -l detach -s d -d 'Exit immediately instead of waiting for the service to converge'
complete -c docker -n '__fish_docker_arguments_startswith service rollback' -l quiet -s q -d 'Suppress progress output'

# docker service scale
# Usage: docker service scale SERVICE=REPLICAS [SERVICE=REPLICAS...]
complete -c docker -n '__fish_docker_arguments_equals service' -fa scale -d 'Scale one or multiple replicated services'
complete -c docker -n '__fish_docker_arguments_startswith service scale' -l detach -s d -d 'Exit immediately instead of waiting for the service to converge'

# docker service update
# Usage: docker service update [OPTIONS] SERVICE
complete -c docker -n '__fish_docker_arguments_equals service' -fa update -d 'Update a service'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l args -r -d 'Service command args'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l cap-add -r -d 'Add Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l cap-drop -r -d 'Drop Linux capabilities'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l config-add -r -d 'Add or update a config file on a service'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l config-rm -r -d 'Remove a configuration file'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l constraint-add -r -d 'Add or update a placement constraint'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l constraint-rm -r -d 'Remove a constraint'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l container-label-add -r -d 'Add or update a container label'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l container-label-rm -r -d 'Remove a container label by its key'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l credential-spec -r -d 'Credential spec for managed service account (Windows only)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l detach -s d -d 'Exit immediately instead of waiting for the service to converge'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l dns-add -r -d 'Add or update a custom DNS server'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l dns-option-add -r -d 'Add or update a DNS option'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l dns-option-rm -r -d 'Remove a DNS option'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l dns-rm -r -d 'Remove a custom DNS server'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l dns-search-add -r -d 'Add or update a custom DNS search domain'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l dns-search-rm -r -d 'Remove a DNS search domain'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l endpoint-mode -r -d 'Endpoint mode (vip or dnsrr)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l entrypoint -r -d 'Overwrite the default ENTRYPOINT of the image'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l env-add -r -d 'Add or update an environment variable'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l env-rm -r -d 'Remove an environment variable'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l force -d 'Force update even if no changes require it'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l generic-resource-add -r -d 'Add a Generic resource'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l generic-resource-rm -r -d 'Remove a Generic resource'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l group-add -r -d 'Add an additional supplementary user group to the container'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l group-rm -r -d 'Remove a previously added supplementary user group from the container'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l health-cmd -r -d 'Command to run to check health'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l health-interval -r -d 'Time between running the check (ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l health-retries -r -d 'Consecutive failures needed to report unhealthy'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l health-start-period -r -d 'Start period for the container to initialize before counting retries towards unstable (ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l health-timeout -r -d 'Maximum time to allow one check to run (ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l host-add -r -d 'Add a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l host-rm -r -d 'Remove a custom host-to-IP mapping (host:ip)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l hostname -r -d 'Container hostname'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l image -r -d 'Service image tag'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l init -d 'Use an init inside each service container to forward signals and reap processes'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l isolation -r -d 'Service container isolation mode'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l label-add -r -d 'Add or update a service label'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l label-rm -r -d 'Remove a label by its key'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l limit-cpu -r -d 'Limit CPUs'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l limit-memory -r -d 'Limit Memory'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l limit-pids -r -d 'Limit maximum number of processes (default 0 = unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l log-driver -r -d 'Logging driver for service'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l log-opt -r -d 'Logging driver options'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l max-concurrent -r -d 'Number of job tasks to run concurrently (default equal to --replicas)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l mount-add -r -d 'Add or update a mount on a service'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l mount-rm -r -d 'Remove a mount by its target path'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l network-add -r -d 'Add a network'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l network-rm -r -d 'Remove a network'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l no-healthcheck -d 'Disable any container-specified HEALTHCHECK'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l no-resolve-image -d 'Do not query the registry to resolve image digest and supported platforms'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l placement-pref-add -r -d 'Add a placement preference'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l placement-pref-rm -r -d 'Remove a placement preference'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l publish-add -r -d 'Add or update a published port'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l publish-rm -r -d 'Remove a published port by its target port'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l quiet -s q -d 'Suppress progress output'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l read-only -d "Mount the container's root filesystem as read only"
complete -c docker -n '__fish_docker_arguments_startswith service update' -l replicas -r -d 'Number of tasks'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l replicas-max-per-node -r -d 'Maximum number of tasks per node (default 0 = unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l reserve-cpu -r -d 'Reserve CPUs'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l reserve-memory -r -d 'Reserve Memory'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l restart-condition -r -d 'Restart when condition is met ("none"|"on-failure"|"any")'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l restart-delay -r -d 'Delay between restart attempts (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l restart-max-attempts -r -d 'Maximum number of restarts before giving up'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l restart-window -r -d 'Window used to evaluate the restart policy (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l rollback -d 'Rollback to previous specification'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l rollback-delay -r -d 'Delay between task rollbacks (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l rollback-failure-action -r -d 'Action on rollback failure ("pause"|"continue")'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l rollback-max-failure-ratio -r -d 'Failure rate to tolerate during a rollback'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l rollback-monitor -r -d 'Duration after each task rollback to monitor for failure (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l rollback-order -r -d 'Rollback order ("start-first"|"stop-first")'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l rollback-parallelism -r -d 'Maximum number of tasks rolled back simultaneously (0 to roll back all at once)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l secret-add -r -d 'Add or update a secret on a service'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l secret-rm -r -d 'Remove a secret'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l stop-grace-period -r -d 'Time to wait before force killing a container (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l stop-signal -r -d 'Signal to stop the container'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l sysctl-add -r -d 'Add or update a Sysctl option'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l sysctl-rm -r -d 'Remove a Sysctl option'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l tty -s t -d 'Allocate a pseudo-TTY'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l ulimit-add -r -d 'Add or update a ulimit option (default [])'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l ulimit-rm -r -d 'Remove a ulimit option'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l update-delay -r -d 'Delay between updates (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l update-failure-action -r -d 'Action on update failure ("pause"|"continue"|"rollback")'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l update-max-failure-ratio -r -d 'Failure rate to tolerate during an update'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l update-monitor -r -d 'Duration after each task update to monitor for failure (ns|us|ms|s|m|h)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l update-order -r -d 'Update order ("start-first"|"stop-first")'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l update-parallelism -r -d 'Maximum number of tasks updated simultaneously (0 to update all at once)'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l user -s u -r -d 'Username or UID (format: <name|uid>[:<group|gid>])'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l with-registry-auth -d 'Send registry authentication details to swarm agents'
complete -c docker -n '__fish_docker_arguments_startswith service update' -l workdir -s w -r -d 'Working directory inside the container'

# docker stack
# Usage: docker stack [OPTIONS] COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa stack -d 'Manage Docker stacks'
complete -c docker -n '__fish_docker_arguments_startswith stack' -l orchestrator -r -d 'Orchestrator to use (swarm|kubernetes|all)'

# docker stack deploy
# Usage: docker stack deploy [OPTIONS] STACK
complete -c docker -n '__fish_docker_arguments_startswith stack' -fa deploy -d 'Deploy a new stack or update an existing stack'
complete -c docker -n '__fish_docker_arguments_startswith stack deploy' -l compose-file -s c -r -d 'Path to a Compose file, or "-" to read from stdin'
complete -c docker -n '__fish_docker_arguments_startswith stack deploy' -l orchestrator -r -d 'Orchestrator to use (swarm|kubernetes|all)'
complete -c docker -n '__fish_docker_arguments_startswith stack deploy' -l prune -d 'Prune services that are no longer referenced'
complete -c docker -n '__fish_docker_arguments_startswith stack deploy' -l resolve-image -r -d 'Query the registry to resolve image digest and supported platforms ("always"|"changed"|"never") (default "always")'
complete -c docker -n '__fish_docker_arguments_startswith stack deploy' -l with-registry-auth -d 'Send registry authentication details to Swarm agents'

# docker stack ls
# Usage: docker stack ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_startswith stack' -fa ls -d 'List stacks'
complete -c docker -n '__fish_docker_arguments_startswith stack ls' -l format -r -d 'Pretty-print stacks using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith stack ls' -l orchestrator -r -d 'Orchestrator to use (swarm|kubernetes|all)'

# docker stack ps
# Usage: docker stack ps [OPTIONS] STACK
complete -c docker -n '__fish_docker_arguments_startswith stack' -fa ps -d 'List the tasks in the stack'
complete -c docker -n '__fish_docker_arguments_startswith stack ps' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith stack ps' -l format -r -d 'Pretty-print tasks using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith stack ps' -l no-resolve -d 'Do not map IDs to Names'
complete -c docker -n '__fish_docker_arguments_startswith stack ps' -l no-trunc -d 'Do not truncate output'
complete -c docker -n '__fish_docker_arguments_startswith stack ps' -l orchestrator -r -d 'Orchestrator to use (swarm|kubernetes|all)'
complete -c docker -n '__fish_docker_arguments_startswith stack ps' -l quiet -s q -d 'Only display task IDs'

# docker stack rm
# Usage: docker stack rm [OPTIONS] STACK [STACK...]
complete -c docker -n '__fish_docker_arguments_startswith stack' -fa rm -d 'Remove one or more stacks'
complete -c docker -n '__fish_docker_arguments_startswith stack rm' -l orchestrator -r -d 'Orchestrator to use (swarm|kubernetes|all)'

# docker stack services
# Usage: docker stack services [OPTIONS] STACK
complete -c docker -n '__fish_docker_arguments_startswith stack' -fa services -d 'List the services in the stack'
complete -c docker -n '__fish_docker_arguments_startswith stack services' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith stack services' -l format -r -d 'Pretty-print services using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith stack services' -l orchestrator -r -d 'Orchestrator to use (swarm|kubernetes|all)'
complete -c docker -n '__fish_docker_arguments_startswith stack services' -l quiet -s q -d 'Only display IDs'

# docker start
# Usage: docker start [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa start -d 'Start one or more stopped containers'
complete -c docker -n '__fish_docker_arguments_startswith start' -l attach -s a -d 'Attach STDOUT/STDERR and forward signals'
complete -c docker -n '__fish_docker_arguments_startswith start' -l detach-keys -r -d 'Override the key sequence for detaching a container'
complete -c docker -n '__fish_docker_arguments_startswith start' -l interactive -s i -d "Attach container's STDIN"

# docker stats
# Usage: docker stats [OPTIONS] [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa stats -d 'Display a live stream of container(s) resource usage statistics'
complete -c docker -n '__fish_docker_arguments_startswith stats' -l all -s a -d 'Show all containers (default shows just running)'
complete -c docker -n '__fish_docker_arguments_startswith stats' -l format -r -d 'Pretty-print images using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith stats' -l no-stream -d 'Disable streaming stats and only pull the first result'
complete -c docker -n '__fish_docker_arguments_startswith stats' -l no-trunc -d 'Do not truncate output'

# docker stop
# Usage: docker stop [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa stop -d 'Stop one or more running containers'
complete -c docker -n '__fish_docker_arguments_startswith stop' -l time -s t -r -d 'Seconds to wait for stop before killing it (default 10)'

# docker swarm
# Usage: docker swarm COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa swarm -d 'Manage Swarm'

# docker swarm ca
# Usage: docker swarm ca [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa ca -d 'Display and rotate the root CA'
complete -c docker -n '__fish_docker_arguments_startswith swarm ca' -l ca-cert -r -d 'Path to the PEM-formatted root CA certificate to use for the new cluster'
complete -c docker -n '__fish_docker_arguments_startswith swarm ca' -l ca-key -r -d 'Path to the PEM-formatted root CA key to use for the new cluster'
complete -c docker -n '__fish_docker_arguments_startswith swarm ca' -l cert-expiry -r -d 'Validity period for node certificates (ns|us|ms|s|m|h) (default 2160h0m0s)'
complete -c docker -n '__fish_docker_arguments_startswith swarm ca' -l detach -s d -d 'Exit immediately instead of waiting for the root rotation to converge'
complete -c docker -n '__fish_docker_arguments_startswith swarm ca' -l external-ca -r -d 'Specifications of one or more certificate signing endpoints'
complete -c docker -n '__fish_docker_arguments_startswith swarm ca' -l quiet -s q -d 'Suppress progress output'
complete -c docker -n '__fish_docker_arguments_startswith swarm ca' -l rotate -d 'Rotate the swarm CA - if no certificate or key are provided, new ones will be generated'

# docker swarm init
# Usage: docker swarm init [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa init -d 'Initialize a swarm'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l advertise-addr -r -d 'Advertised address (format: <ip|interface>[:port])'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l autolock -d 'Enable manager autolocking (requiring an unlock key to start a stopped manager)'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l availability -r -d 'Availability of the node ("active"|"pause"|"drain") (default "active")'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l cert-expiry -r -d 'Validity period for node certificates (ns|us|ms|s|m|h) (default 2160h0m0s)'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l data-path-addr -r -d 'Address or interface to use for data path traffic (format: <ip|interface>)'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l data-path-port -r -d 'Port number to use for data path traffic (1024 - 49151). If no value is set or is set to 0, the default port (4789) is used.'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l default-addr-pool -r -d 'default address pool in CIDR format (default [])'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l default-addr-pool-mask-length -r -d 'default address pool subnet mask length (default 24)'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l dispatcher-heartbeat -r -d 'Dispatcher heartbeat period (ns|us|ms|s|m|h) (default 5s)'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l external-ca -r -d 'Specifications of one or more certificate signing endpoints'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l force-new-cluster -d 'Force create a new cluster from current state'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l listen-addr -r -d 'Listen address (format: <ip|interface>[:port]) (default 0.0.0.0:2377)'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l max-snapshots -r -d 'Number of additional Raft snapshots to retain'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l snapshot-interval -r -d 'Number of log entries between Raft snapshots (default 10000)'
complete -c docker -n '__fish_docker_arguments_startswith swarm init' -l task-history-limit -r -d 'Task history retention limit (default 5)'

# docker swarm join
# Usage: docker swarm join [OPTIONS] HOST:PORT
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa join -d 'Join a swarm as a node and/or manager'
complete -c docker -n '__fish_docker_arguments_startswith swarm join' -l advertise-addr -r -d 'Advertised address (format: <ip|interface>[:port])'
complete -c docker -n '__fish_docker_arguments_startswith swarm join' -l availability -r -d 'Availability of the node ("active"|"pause"|"drain") (default "active")'
complete -c docker -n '__fish_docker_arguments_startswith swarm join' -l data-path-addr -r -d 'Address or interface to use for data path traffic (format: <ip|interface>)'
complete -c docker -n '__fish_docker_arguments_startswith swarm join' -l listen-addr -r -d 'Listen address (format: <ip|interface>[:port]) (default 0.0.0.0:2377)'
complete -c docker -n '__fish_docker_arguments_startswith swarm join' -l token -r -d 'Token for entry into the swarm'

# docker swarm join-token
# Usage: docker swarm join-token [OPTIONS] (worker|manager)
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa join-token -d 'Manage join tokens'
complete -c docker -n '__fish_docker_arguments_startswith swarm join-token' -l quiet -s q -d 'Only display token'
complete -c docker -n '__fish_docker_arguments_startswith swarm join-token' -l rotate -d 'Rotate join token'

# docker swarm leave
# Usage: docker swarm leave [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa leave -d 'Leave the swarm'
complete -c docker -n '__fish_docker_arguments_startswith swarm leave' -l force -s f -d 'Force this node to leave the swarm, ignoring warnings'

# docker swarm unlock
# Usage: docker swarm unlock
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa unlock -d 'Unlock swarm'

# docker swarm unlock-key
# Usage: docker swarm unlock-key [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa unlock-key -d 'Manage the unlock key'
complete -c docker -n '__fish_docker_arguments_startswith swarm unlock-key' -l quiet -s q -d 'Only display token'
complete -c docker -n '__fish_docker_arguments_startswith swarm unlock-key' -l rotate -d 'Rotate unlock key'

# docker swarm update
# Usage: docker swarm update [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals swarm' -fa update -d 'Update the swarm'
complete -c docker -n '__fish_docker_arguments_startswith swarm update' -l autolock -d 'Change manager autolocking setting (true|false)'
complete -c docker -n '__fish_docker_arguments_startswith swarm update' -l cert-expiry -r -d 'Validity period for node certificates (ns|us|ms|s|m|h) (default 2160h0m0s)'
complete -c docker -n '__fish_docker_arguments_startswith swarm update' -l dispatcher-heartbeat -r -d 'Dispatcher heartbeat period (ns|us|ms|s|m|h) (default 5s)'
complete -c docker -n '__fish_docker_arguments_startswith swarm update' -l external-ca -r -d 'Specifications of one or more certificate signing endpoints'
complete -c docker -n '__fish_docker_arguments_startswith swarm update' -l max-snapshots -r -d 'Number of additional Raft snapshots to retain'
complete -c docker -n '__fish_docker_arguments_startswith swarm update' -l snapshot-interval -r -d 'Number of log entries between Raft snapshots (default 10000)'
complete -c docker -n '__fish_docker_arguments_startswith swarm update' -l task-history-limit -r -d 'Task history retention limit (default 5)'

# docker system
# Usage: docker system COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa system -d 'Manage Docker'

# docker system df
# Usage: docker system df [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals system' -fa df -d 'Show docker disk usage'
complete -c docker -n '__fish_docker_arguments_startswith system df' -l format -r -d 'Pretty-print images using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith system df' -l verbose -s v -d 'Show detailed information on space usage'

# docker system events
# Usage: docker system events [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals system' -fa events -d 'Get real time events from the server'
complete -c docker -n '__fish_docker_arguments_startswith system events' -l filter -s f -r -d 'Filter output based on conditions provided'
complete -c docker -n '__fish_docker_arguments_startswith system events' -l format -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith system events' -l since -r -d 'Show all events created since timestamp'
complete -c docker -n '__fish_docker_arguments_startswith system events' -l until -r -d 'Stream events until this timestamp'

# docker system info
# Usage: docker system info [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals system' -fa info -d 'Display system-wide information'
complete -c docker -n '__fish_docker_arguments_startswith system info' -l format -s f -r -d 'Format the output using the given Go template'

# docker system prune
# Usage: docker system prune [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals system' -fa prune -d 'Remove unused data'
complete -c docker -n '__fish_docker_arguments_startswith system prune' -l all -s a -d 'Remove all unused images not just dangling ones'
complete -c docker -n '__fish_docker_arguments_startswith system prune' -l filter -r -d "Provide filter values (e.g. 'label=<key>=<value>')"
complete -c docker -n '__fish_docker_arguments_startswith system prune' -l force -s f -d 'Do not prompt for confirmation'
complete -c docker -n '__fish_docker_arguments_startswith system prune' -l volumes -d 'Prune volumes'

# docker tag
# Usage: docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
complete -c docker -n '__fish_is_first_docker_argument' -fa tag -d 'Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE'

# docker top
# Usage: docker top CONTAINER [ps OPTIONS]
complete -c docker -n '__fish_is_first_docker_argument' -fa top -d 'Display the running processes of a container'

# docker trust
# Usage: docker trust COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa trust -d 'Manage trust on Docker images'

# docker trust inspect
# Usage: docker trust inspect IMAGE[:TAG] [IMAGE[:TAG]...]
complete -c docker -n '__fish_docker_arguments_equals trust' -fa inspect -d 'Return low-level information about keys and signatures'
complete -c docker -n '__fish_docker_arguments_startswith trust inspect' -l pretty -d 'Print the information in a human friendly format'

# docker trust key
# Usage: docker trust key COMMAND
complete -c docker -n '__fish_docker_arguments_equals trust' -fa key -d 'Manage keys for signing Docker images'

# docker trust key generate
# Usage: docker trust key generate NAME
complete -c docker -n '__fish_docker_arguments_startswith trust key' -fa generate -d 'Generate and load a signing key-pair'
complete -c docker -n '__fish_docker_arguments_startswith trust key generate' -l dir -r -d 'Directory to generate key in, defaults to current directory'

# docker trust key load
# Usage: docker trust key load [OPTIONS] KEYFILE
complete -c docker -n '__fish_docker_arguments_startswith trust key' -fa load -d 'Load a private key file for signing'
complete -c docker -n '__fish_docker_arguments_startswith trust key load' -l name -r -d 'Name for the loaded key (default "signer")'

# docker trust revoke
# Usage: docker trust revoke [OPTIONS] IMAGE[:TAG]
complete -c docker -n '__fish_docker_arguments_equals trust' -fa revoke -d 'Remove trust for an image'
complete -c docker -n '__fish_docker_arguments_startswith trust revoke' -l yes -s y -d 'Do not prompt for confirmation'

# docker trust sign
# Usage: docker trust sign IMAGE:TAG
complete -c docker -n '__fish_docker_arguments_equals trust' -fa sign -d 'Sign an image'
complete -c docker -n '__fish_docker_arguments_startswith trust sign' -l local -d 'Sign a locally tagged image'

# docker trust signer
# Usage: docker trust signer COMMAND
complete -c docker -n '__fish_docker_arguments_equals trust' -fa signer -d 'Manage entities who can sign Docker images'

# docker trust signer add
# Usage: docker trust signer add OPTIONS NAME REPOSITORY [REPOSITORY...] 
complete -c docker -n '__fish_docker_arguments_startswith trust signer' -fa add -d 'Add a signer'
complete -c docker -n '__fish_docker_arguments_startswith trust signer add' -l key -r -d "Path to the signer's public key file"

# docker trust signer remove
# Usage: docker trust signer remove [OPTIONS] NAME REPOSITORY [REPOSITORY...]
complete -c docker -n '__fish_docker_arguments_startswith trust signer' -fa remove -d 'Remove a signer'
complete -c docker -n '__fish_docker_arguments_startswith trust signer remove' -l force -s f -d 'Do not prompt for confirmation before removing the most recent signer'

# docker unpause
# Usage: docker unpause CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa unpause -d 'Unpause all processes within one or more containers'

# docker update
# Usage: docker update [OPTIONS] CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa update -d 'Update configuration of one or more containers'
complete -c docker -n '__fish_docker_arguments_startswith update' -l blkio-weight -r -d 'Block IO (relative weight), between 10 and 1000, or 0 to disable (default 0)'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpu-period -r -d 'Limit CPU CFS (Completely Fair Scheduler) period'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpu-quota -r -d 'Limit CPU CFS (Completely Fair Scheduler) quota'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpu-rt-period -r -d 'Limit the CPU real-time period in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpu-rt-runtime -r -d 'Limit the CPU real-time runtime in microseconds'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpu-shares -s c -r -d 'CPU shares (relative weight)'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpus -r -d 'Number of CPUs'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpuset-cpus -r -d 'CPUs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith update' -l cpuset-mems -r -d 'MEMs in which to allow execution (0-3, 0,1)'
complete -c docker -n '__fish_docker_arguments_startswith update' -l kernel-memory -r -d 'Kernel memory limit'
complete -c docker -n '__fish_docker_arguments_startswith update' -l memory -s m -r -d 'Memory limit'
complete -c docker -n '__fish_docker_arguments_startswith update' -l memory-reservation -r -d 'Memory soft limit'
complete -c docker -n '__fish_docker_arguments_startswith update' -l memory-swap -r -d "Swap limit equal to memory plus swap: '-1' to enable unlimited swap"
complete -c docker -n '__fish_docker_arguments_startswith update' -l pids-limit -r -d 'Tune container pids limit (set -1 for unlimited)'
complete -c docker -n '__fish_docker_arguments_startswith update' -l restart -r -d 'Restart policy to apply when a container exits'

# docker version
# Usage: docker version [OPTIONS]
complete -c docker -n '__fish_is_first_docker_argument' -fa version -d 'Show the Docker version information'
complete -c docker -n '__fish_docker_arguments_startswith version' -l format -s f -r -d 'Format the output using the given Go template'
complete -c docker -n '__fish_docker_arguments_startswith version' -l kubeconfig -r -d 'Kubernetes config file'

# docker volume
# Usage: docker volume COMMAND
complete -c docker -n '__fish_is_first_docker_argument' -fa volume -d 'Manage volumes'

# docker volume create
# Usage: docker volume create [OPTIONS] [VOLUME]
complete -c docker -n '__fish_docker_arguments_equals volume' -fa create -d 'Create a volume'
complete -c docker -n '__fish_docker_arguments_startswith volume create' -l driver -s d -r -d 'Specify volume driver name (default "local")'
complete -c docker -n '__fish_docker_arguments_startswith volume create' -l label -r -d 'Set metadata for a volume'
complete -c docker -n '__fish_docker_arguments_startswith volume create' -l opt -s o -r -d 'Set driver specific options (default map[])'

# docker volume inspect
# Usage: docker volume inspect [OPTIONS] VOLUME [VOLUME...]
complete -c docker -n '__fish_docker_arguments_equals volume' -fa inspect -d 'Display detailed information on one or more volumes'
complete -c docker -n '__fish_docker_arguments_startswith volume inspect' -l format -s f -r -d 'Format the output using the given Go template'

# docker volume ls
# Usage: docker volume ls [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals volume' -fa ls -d 'List volumes'
complete -c docker -n '__fish_docker_arguments_startswith volume ls' -l filter -s f -r -d "Provide filter values (e.g. 'dangling=true')"
complete -c docker -n '__fish_docker_arguments_startswith volume ls' -l format -r -d 'Pretty-print volumes using a Go template'
complete -c docker -n '__fish_docker_arguments_startswith volume ls' -l quiet -s q -d 'Only display volume names'

# docker volume prune
# Usage: docker volume prune [OPTIONS]
complete -c docker -n '__fish_docker_arguments_equals volume' -fa prune -d 'Remove all unused local volumes'
complete -c docker -n '__fish_docker_arguments_startswith volume prune' -l filter -r -d "Provide filter values (e.g. 'label=<label>')"
complete -c docker -n '__fish_docker_arguments_startswith volume prune' -l force -s f -d 'Do not prompt for confirmation'

# docker volume rm
# Usage: docker volume rm [OPTIONS] VOLUME [VOLUME...]
complete -c docker -n '__fish_docker_arguments_equals volume' -fa rm -d 'Remove one or more volumes'
complete -c docker -n '__fish_docker_arguments_startswith volume rm' -l force -s f -d 'Force the removal of one or more volumes'

# docker wait
# Usage: docker wait CONTAINER [CONTAINER...]
complete -c docker -n '__fish_is_first_docker_argument' -fa wait -d 'Block until one or more containers stop, then print their exit codes'
