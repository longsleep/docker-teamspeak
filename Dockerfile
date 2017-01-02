# -----------------------------------------------------------------------------
# docker-teamspeak
#
# Builds a basic docker image that can run TeamSpeak
# (http://teamspeak.com/).
#
# Authors: Isaac Bythewood, Simon Eisenmann
# Updated: Jan 2nd, 2017
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

# Base system.
FROM   phusion/baseimage:0.9.19

# Teamspeak version to download.
ENV    TS_VERSION 3.0.13.6

# Make sure we don't get notifications we can't answer during building.
ENV    DEBIAN_FRONTEND noninteractive

# Download and install everything from the repos.
RUN    apt-get --yes update; apt-get --yes upgrade
RUN    apt-get --yes install curl

# Download and install TeamSpeak 3
RUN    curl "http://dl.4players.de/ts/releases/${TS_VERSION}/teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz" -o /opt/teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz
RUN    cd /opt && tar -zxvf teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz && mv teamspeak3-server_linux-amd64 teamspeak && chown -R root.root /opt/teamspeak && rm teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz

# Load in all of our config files.
RUN    mkdir /etc/service/teamspeak
ADD    scripts/start /etc/service/teamspeak/run
RUN    chmod 755 /etc/service/teamspeak/run

# /start runs it.
EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033

VOLUME ["/data"]

CMD ["/sbin/my_init"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
