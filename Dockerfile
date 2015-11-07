# -----------------------------------------------------------------------------
# docker-teamspeak
#
# Builds a basic docker image that can run TeamSpeak
# (http://teamspeak.com/).
#
# Authors: Isaac Bythewood, Simon Eisenmann
# Updated: Nov 7th, 2015
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------

# Base system is the LTS version of Ubuntu.
FROM   ubuntu:14.04

# Teamspeak version to download.
ENV    TS_VERSION 3.0.11.4

# Make sure we don't get notifications we can't answer during building.
ENV    DEBIAN_FRONTEND noninteractive

# Download and install everything from the repos.
RUN    apt-get --yes update; apt-get --yes upgrade
RUN    apt-get --yes install curl

# Download and install TeamSpeak 3
RUN    curl "http://dl.4players.de/ts/releases/${TS_VERSION}/teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz" -o /opt/teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz
RUN    cd /opt && tar -zxvf teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz && mv teamspeak3-server_linux-amd64 teamspeak && chown -R root.root /opt/teamspeak && rm teamspeak3-server_linux-amd64-${TS_VERSION}.tar.gz

# Load in all of our config files.
ADD    ./scripts/start /start

# Fix all permissions
RUN    chmod +x /start

# /start runs it.
EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033

VOLUME ["/data"]

ENTRYPOINT ["/start"]
