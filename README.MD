
# Minecraft Server Docker Image

## Introduction

This is docker java environment images of minecraft servers.

We packed [MCDReforged](https://mcdreforged.readthedocs.io/) too.

The docker repository is at <https://hub.docker.com/r/craftmine/minecraft>

## How to use it

1. Make sure [Docker Cli](https://www.docker.com) is installed on the server.

2. Use tag to pull the environment that you want:
	- Pure java: `docker pull craftmine/minecraft:java<java_version>`
	- MCDReforged: `craftmine/minecraft:java<java_version>-mcdr<mcdr_version>`

3. Use `docker run` or `docker create` to create the server.
	For example: `docker run -it --rm -v "my-minecraft-server-volume":"/minecraft" craftmine/minecraft:java17-mcdr`
	> Hints:
	> 	1. You must run the server with a volume if you will remove the container. It will be safer than without a volume.
	> 	2. If you don't need to attach the console, you can use `docker run` with `-d`(detach) option
	> 	3. If you used `docker create`, you must use `docker start` later to start the server

4. Set up your minecraft server **inside** the container

	> Since [minecraft EULA](https://www.minecraft.net/en-us/eula), we can't pack minecraft server. So you should download the server file from it offical website (e.g. <https://www.minecraft.net/en-us/download/server>).
	- For example, you can download the 1.19.2 server use below command:
		```shell
		wget -O /minecraft/minecraft.jar https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar
		```

5. Sometimes you need to restart the docker containers, but you may just exit the init shell use `exit 0` and the server will be auto start

6. Have fun :)
