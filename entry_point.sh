#!/bin/sh

function false() { return 1; }
function true() { return 0; }

INITED=false
if [ -f .inited ]; then
	INITED=true
fi

INIT_COMMAND="$1"

echo
echo "Workspace: $(pwd)"
echo "ENV COMMAND=$COMMAND"
echo "ENV ARGS=$ARGS"
echo

# TODO: try make a init system, or use one that already exists in apk
# function _broadcast_signal(){
# 	sig=$1
# 	kill "-$sig" "-1" # Cannot use gid=1 here, sincu some process must be killed by their parent (such as mcdreforged)
# 	wait "$pid"
# }
# function _broadcast_signals(){
# 	for sig; do
# 		trap "_broadcast_signal $sig"
# 	done
# }
# function trap_and_wait(){
# 	"$@" &
# 	pid=$!
# 	_forward_signals SIGHUP SIGINT SIGQUIT SIGILL SIGABRT SIGTERM SIGSTOP
# 	wait $pid
# }

function exec_command(){
	exec "${COMMAND[@]}" "${ARGS[@]}"
}

function initer(){
	if "$INITED"; then
		echo "WARN: This containter already inited"
	fi
	echo
	echo "Running init command"
	"${INIT_COMMAND[@]}" || exit $?
	if ! "$INITED"; then
		echo "Creating .inited"
		touch .inited
	fi
}

_CMD=$2

if ! [ -n "$_CMD" ]; then
	if ! "$INITED"; then
		echo "Not inited, run initer"
		initer || exit $?
		echo "Just inited, executing command '$COMMAND $ARGS'"
	fi
	exec_command
fi

case "$_CMD" in
	run) 
		if ! "$INITED"; then
			echo "Not inited, please use command 'init' for init"
			exit 1
		fi
		exec_command
		;;
	init)
		initer
		;;
	sh | shell)
		echo 'Enterning `/bin/sh`'
		echo
		echo 'Hint: you can use ctrl+p+q to detach this container'
		echo
		exec /bin/sh
		;;
	*)
		echo "Unknown command '$_CMD'"
		echo
		echo 'Commands:'
		echo '  run: run the server with env `COMMAND` and `ARGS`'
		echo '  init: initialize the server with default initializer'
		echo '  sh, shell: enter the shell mode'
		echo
		exit 2
		;;
esac
