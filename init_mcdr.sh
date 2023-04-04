#!/bin/sh

read -p 'Do you want to init mcdreforged by `python3 -m mcdreforged init` (Y/n)' -s -n1 ans
echo

if [ "$ans" = Y ] || [ "$ans" = y ]; then
	echo 'Initializing mcdreforged...'
	python3 -m mcdreforged init || exit $?
else
	echo 'Canceled to initialize mcdreforged'
fi

echo
echo 'Please copy/download your minecraft server'
echo '  and then restart this container'
echo
echo 'Hint: you can use Ctrl+P+Q to detach this container'
echo '    | Use `docker copy` in the host environment to copy files between the host and contaniers,'
echo '    |   and for more helps, please run `docker copy --help` in the host environment.'
echo
echo 'Hint: We have pre-installed a minecraft server installer'
echo '    | Use `minecraft_installer -help` for more info'
echo

exec /bin/sh
