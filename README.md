# docker-teamspeak

A nice and easy way to get a TeamSpeak server up and running using docker. For
help on getting started with docker see the [official getting started guide][0].
For more information on TeamSpeak and check out it's [website][1].

This work was forked from https://github.com/overshard/docker-teamspeak to
get support for latest Docker changes.

## Building docker-teamspeak

Running this will build you a docker image with the latest version of both
docker-teamspeak and TeamSpeak itself.

    git clone https://github.com/longsleep/docker-teamspeak
    cd docker-teamspeak
    docker build -t longsleep/teamspeak .


## Running docker-teamspeak

Running the first time will set your port to a static port of your choice so
that you can easily map a proxy to. If this is the only thing running on your
system you can map the ports to 9987, 10011, 30033 and no proxy is needed. i.e.
`-p=9987:9987/udp  -p=10011:10011 -p=30033:30033` Also be sure your mounted
directory on your host machine is already created before running
`mkdir -p /mnt/teamspeak`.

    sudo docker run --rm=true -p=9987:9987/udp -p=10011:10011 -p=30033:30033 -v=/mnt/teamspeak:/data longsleep/teamspeak

This runs docker-teamspeak in a temporary container in foreground. To stop it,
just press CTRL+C.

## Run with upstart

I recommend to run the docker container with upstart or systemd. Use the
following init file with upstart and put it into `/etc/init/teamspeak-container`.

```
description "Teamspeak container"

start on filesystem and started docker
stop on stopping docker

respawn

pre-start script
docker rm teamspeak >/dev/null 2>&1 || true
end script

script
exec docker run \
	--rm=true \
	-p 9987:9987/udp \
	-p 10011:10011 \
	-p 30033:30033 \
	-v /mnt/teamspeak:/data \
	--name teamspeak \
	longsleep/teamspeak
end script
```

The teamspeak container supports full signal integration, meaning start, stop
and reload commands work just fine. Start docker-teamspeak with upstart by
`start teamspeak-container`.


## Server Admin Token

You can find the server admin token in /mnt/teamspeak/logs/, search the log
files for ServerAdmin privilege key created and use that token on first connect.


### Notes on the run command

 + `-v` is the volume you are mounting `-v=host_dir:docker_dir`
 + `longsleep/teamspeak` is the name of the docker image chosen above
 + `-p` is the port it connects to, `-p=host_port:docker_port`


[0]: http://www.docker.io/gettingstarted/
[1]: http://teamspeak.com/

