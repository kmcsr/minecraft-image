#!/bin/sh

function false() { return 1; }
function true() { return 0; }

INITED=false
if [ -f .inited ]; then
	INITED=true
fi

INIT_COMMAND=$1

echo
echo "Workspace: $(pwd)"
echo "Exec command: $COMMAND $EXE"
echo

function exec_command(){
	exec "$COMMAND" $EXE
}

function initer(){
	if "$INITED"; then
		echo "WARN: This containter already inited"
	fi
	echo
	echo "Running init command"
	$INIT_COMMAND || exit $?
	if ! "$INITED"; then
		echo "Touching .inited"
		touch .inited
	fi
}

_CMD=$2

if ! [ -n "$_CMD" ]; then
	if ! "$INITED"; then
		echo "Not inited, run initer"
		initer || exit $?
		echo "Just inited, executing command "
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
	shell)
		echo 'Enterning `/bin/sh`'
		echo
		echo 'Hint: you can use ctrl+p+q to detach this container'
		echo
		exec /bin/sh
		;;
	*)
		echo "Unknown command '$_CMD'"
		exit 2
		;;
esac
