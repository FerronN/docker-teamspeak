### Alpine requires glibc to be present in the system below link to fficial repository
### https://github.com/sgerrand/alpine-pkg-glibc
FROM alpine:latest

ENV     TS3_VERSION=3.3.0 \
        GLIBC_VERSION='2.28-r0' \
        TS3_SQLPATH=/opt/teamspeak-sql/ts3server.sqlitedb \
        TS3_CHANNELPATH=/opt/teamspeak-channel/virtualserver_1
RUN \
    addgroup -S -g 1000 teamspeak && adduser -S -u 1000 teamspeak -G teamspeak; \
    apk --no-cache add ca-certificates wget; \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk; \
    apk add glibc-${GLIBC_VERSION}.apk; \
    apk add --update bzip2; \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* /glibc-${GLIBC_VERSION}.apk; \
    wget http://dl.4players.de/ts/releases/${TS3_VERSION}/teamspeak3-server_linux_amd64-${TS3_VERSION}.tar.bz2 -O /tmp/teamspeak.tar.bz2; \
    mkdir -p /opt/teamspeak; \
    mkdir -p /opt/teamspeak-sql; \
    mkdir -p /opt/teamspeak-channel; \
    touch /opt/teamspeak/.ts3server_license_accepted; \
    tar jxf /tmp/teamspeak.tar.bz2 -C /opt/teamspeak --strip-components=1 && rm -f /tmp/teamspeak.tar.bz2; \
    chown -R teamspeak:teamspeak /opt;

COPY container-files /
USER teamspeak
WORKDIR /opt/teamspeak
ENTRYPOINT ["/bootstrap.sh"]

EXPOSE 9987/udp 10011 30033
