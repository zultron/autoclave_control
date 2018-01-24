#!/bin/bash -e

NAME=qqvcp
IMAGE=zultron/${NAME}
TOPDIR="$(readlink -f "$(dirname $0)"/..)"

usage() {
    ERRMSG="$1"
    {
	test -z "$ERRMSG" || echo "ERROR:  $ERRMSG"
	echo "Usage:"
	echo "    $0 -b                Build the Docker container image"
	echo "    $0                   Run interactive shell in container"
	echo "    $0 CMD [ ARGS ... ]  Run CMD in container"
	echo "    $0 -h                Use host networking" \
	     "(service visible externally)"
    } >&2
    if test -z "$ERRMSG"; then
	exit
    else
	exit 1
    fi
}

while getopts bh? ARG; do
    case $ARG in
	b) BUILD=true ;;
	h) NETWORK_ARGS="--hostname=$(hostname) --net=host" ;;
	i) IMAGE=$OPTARG ;;
	?) usage ;;
	*) usage "Unknown arg: '-$ARG'" ;;
    esac
done
shift $(($OPTIND-1))
BUILD=${BUILD:-false}
NETWORK_ARGS=${NETWORK_ARGS:-"--hostname=qqvcp"}

run() {
    UID_GID=`id -u`:`id -g`
    set -x
    exec docker run --rm \
	 -it --privileged \
	 -u $UID_GID \
	 -v /tmp/.X11-unix:/tmp/.X11-unix \
	 -v /dev/dri:/dev/dri \
	 -v $HOME:$HOME -e HOME \
	 -v $PWD:$PWD \
	 -p 3000:3000 \
	 -w $PWD \
	 -e DISPLAY \
	 -e DEBUG \
	 -e MSGD_OPTS \
	 ${NETWORK_ARGS} \
	 --name ${NAME} \
	 ${IMAGE} "$@"
}

if test "$1" = build; then
    shift
    cd "$TOPDIR/docker"
    set -x
    exec docker build -t $IMAGE "$@" .
fi

# Check for existing containers
EXISTING="$(docker ps -aq --filter=name=${NAME})"
if test -n "${EXISTING}"; then
    # Container exists; is it running?
    RUNNING=$(docker inspect ${EXISTING} | awk '/"Running":/ { print $2 }')
    if test "${RUNNING}" = "false,"; then
	# Remove stopped container
	echo docker rm ${EXISTING}
    elif test "${RUNNING}" = "true,"; then
	# Container already running; error
	echo "Error:  container '${NAME}' already running" >&2
	exit 1
    else
	# Something went wrong
	echo "Error:  unable to determine status of " \
	    "existing container '${EXISTING}'" >&2
	exit 1
    fi
fi

run "$@"
