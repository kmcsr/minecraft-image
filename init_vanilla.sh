#!/bin/sh

echo
echo 'Please copy/download your minecraft server to `/minecraft/minecraft.jar`'
echo '  and then restart this container'
echo
echo 'Hint: you can use ctrl+p+q to detach this container'
echo 'Hint: Use `docker copy` to copy files between the host and contaniers'
echo 'Hint: Use `wget -O /minecraft/minecraft.jar <server jar link>` to download the server'
echo

exec /bin/sh
