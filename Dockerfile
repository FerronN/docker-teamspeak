### Alpine requires glibc to be present in the system below link to fficial repository
### https://github.com/sgerrand/alpine-pkg-glibc
FROM alpine:latest

ENV     TS3_VERSION=3.10.0 \
        GLIBC_VERSION='2.30-r0' \
        TS3_SQLPATH=/opt/teamspeak-sql/ts3server.sqlitedb \
        TS3_CHANNELPATH=/opt/teamspeak-channel/virtualserver_1
RUN \
    apk add --no-cache ca-certificates libstdc++ su-exec; \
    addgroup -S -g 1000 teamspeak && adduser -S -u 1000 teamspeak -G teamspeak; \
    apk add --no-cache --virtual .fetch-deps tar; \
    wget https://files.teamspeak-services.com/releases/server/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2 -O /tmp/teamspeak.tar.bz2; \
    mkdir -p /opt/teamspeak; \
    mkdir -p /opt/teamspeak-sql; \
    mkdir -p /opt/teamspeak-channel; \
    touch /opt/teamspeak/.ts3server_license_accepted; \
    tar jxf /tmp/teamspeak.tar.bz2 -C /opt/teamspeak --strip-components=1 && rm -f /tmp/teamspeak.tar.bz2; \
    chown -R teamspeak:teamspeak /opt; \
    ldconfig /usr/local/lib; \
    apk del .fetch-deps; \

COPY container-files /
USER teamspeak
WORKDIR /opt/teamspeak
ENTRYPOINT ["/bootstrap.sh"]

EXPOSE 9987/udp 10011 30033
