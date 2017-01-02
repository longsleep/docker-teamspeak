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
FROM   frolvlad/alpine-glibc:alpine-3.4

COPY   scripts/start /start.sh

CMD    ["/start.sh"]
EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033
VOLUME ["/data"]

ENV    TS_VERSION 3.0.13.6
ENV    TS_CHECKSUM 19ccd8db5427758d972a864b70d4a1263ebb9628fcc42c3de75ba87de105d179

RUN chmod +x /start.sh \
  && apk --update add curl su-exec \
  && curl -L "http://dl.4players.de/ts/releases/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2" -o /tmp/teamspeak.tar.bz2 \
  && if [ $(sha256sum /tmp/teamspeak.tar.bz2 | awk {'print $1'}) != ${TS_CHECKSUM} ]; then echo "Invalid checksum"; exit 1; fi \
  && mkdir /opt \
  && tar xjf /tmp/teamspeak.tar.bz2 -C /opt \
  && mv /opt/teamspeak3-server_* /opt/teamspeak \
  && chown -R root:root /opt/teamspeak \
  && apk del curl \
  && rm -rf \
    /tmp/teamspeak.tar.bz2 \
    /var/cache/apk*
