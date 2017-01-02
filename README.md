# docker-teamspeak

A nice and easy way to get a TeamSpeak server up and running using docker. For
help on getting started with docker see the [official getting started guide][0].
For more information on TeamSpeak and check out it's [website][1].

This work was forked from https://github.com/overshard/docker-teamspeak to
get support for latest Docker changes and latest Teamspeak server version.

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
`-p=9987:9987/udp -p=10011:10011 -p=30033:30033` Also be sure your mounted
directory on your host machine is already created before and has the correct
permissions. The docker container uses user ID 9001 by default to access/write
the logs and the database.

    sudo docker run --rm=true -p=9987:9987/udp -p=10011:10011 -p=30033:30033 -e LOCAL_USER_ID=9001 -v=/srv/teamspeak/data:/data longsleep/teamspeak

This runs docker-teamspeak in a temporary container in foreground. To stop it,
just press CTRL+C.

## Run with systemd

I recommend to run the docker container with systemd. Use the following service
file as `/etc/systemd/system/docker.teamspeak.service`.

```
[Unit]
Description=Teamspeak Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker kill teamspeak
ExecStartPre=-/usr/bin/docker rm teamspeak
ExecStart=/usr/bin/docker run \
        --rm=true \
        -e LOCAL_USER_ID=9001 \
        -p 9987:9987/udp \
        -p 10011:10011 \
        -p 30033:30033 \
        -v /srv/teamspeak/data:/data \
        --name teamspeak \
        longsleep/teamspeak

[Install]
WantedBy=multi-user.target
```

The teamspeak container supports full signal integration, meaning start, stop
and reload commands work just fine. Start docker-teamspeak with systemd by
`systemctl start docker.teamspeak`.


## Server Admin Token

You can find the server admin token in /mnt/teamspeak/logs/, search the log
files for ServerAdmin privilege key created and use that token on first connect.


### Notes on the run command

 + `-v` is the volume you are mounting `-v=host_dir:docker_dir`
 + `longsleep/teamspeak` is the name of the docker image chosen above
 + `-p` is the port it connects to, `-p=host_port:docker_port`


[0]: http://www.docker.io/gettingstarted/
[1]: http://teamspeak.com/
