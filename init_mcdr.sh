#!/bin/sh

read -p 'Do you want to init mcdreforged by `python3 -m mcdreforged init` (Y/n)' -s -n1 ans
echo

if [ "$ans" = Y ]; then
	echo "Initing mcdreforged..."
	python3 -m mcdreforged init || exit $?
fi

echo
echo 'Please copy/download your minecraft server'
echo '  and then restart this container'
echo
echo 'Hint: you can use ctrl+p+q to detach this container'
echo 'Hint: Use `docker copy` to copy files between the host and contaniers'
echo

exec /bin/sh
