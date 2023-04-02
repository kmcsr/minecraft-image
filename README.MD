
# Minecraft Server Docker Image

## Introduction

This is docker java environment images of minecraft servers.

We packed [MCDReforged](https://mcdreforged.readthedocs.io/) too.

The docker repository is at <https://hub.docker.com/r/craftmine/minecraft>

## How to use it

1. Make sure there is a [docker](https://www.docker.com) on the server.

2. Use tag to pull the environment that you want: `docker pull craftmine/minecraft:java<java_version>` _(for MCDR, it's `craftmine/minecraft:java<java_version>-mcdr<mcdr_version>`)_

3. Use `docker run` start the server with a volume: `docker run -it --rm -v "my-minecraft-server-volume":"/minecraft" craftmine/minecraft:java17`

  > Hint: You must run the server with a volume if you will remove the container. It will be more safe than without a volume.

4. Set up your minecraft server **inside** the container

  > Since [minecraft EULA](https://www.minecraft.net/en-us/eula), we can't pack minecraft server. So you should download the server file from it offical website (e.g. <https://www.minecraft.net/en-us/download/server>).
  - For example, you can download the 1.19.2 server use below command:
    ```shell
    wget -O /minecraft/minecraft.jar https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar
    ```

5. Sometimes you need to restart the docker containers, but you could just exit the init shell use `exit 0`

6. Have fun :)
