#!/bin/sh

echo
echo 'Please copy/download your minecraft server to `/minecraft/minecraft.jar`'
echo '  and then restart this container'
echo
echo 'Hint: you can use Ctrl+P+Q to detach this container'
echo '    | Use `docker copy` in the host environment to copy files between the host and contaniers'
echo '    | Use `wget -O /minecraft/minecraft.jar <server jar link>` to download the server'
echo

exec /bin/sh
