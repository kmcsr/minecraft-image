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

function runner(){
	exec $COMMAND $EXE
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
		echo "Not inited, running initer"
		initer || exit $?
		echo "Just inited, running runner"
	fi
	runner
fi

case "$_CMD" in
	run) 
		if ! "$INITED"; then
			echo "Not inited, please use command 'init' for init"
			exit 1
		fi
		runner
		;;
	init) initer ;;
	*)
		echo "Unknown command '$_CMD'"
		exit 2
		;;
esac
