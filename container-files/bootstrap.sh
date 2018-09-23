#!/bin/ash
set -e

# Functions
sig_int () {
    echo "SIGINT received"
    kill -2 ${pid}
}

sig_term () {
    echo "SIGTERM received"
    kill -15 ${pid}
}


if [ "$(ls -A $TS3_SQLPATH)" ]; then
     echo "Set symlink $TS3_SQLPATH is not Empty"
     rm -f /opt/teamspeak/ts3server.sqlitedb
     ln -s $TS3_SQLPATH /opt/teamspeak/ts3server.sqlitedb
fi

if [ "$(ls -A $TS3_CHANNELPATH)" ]; then
     echo "Set symlink $TS3_CHANNELPATH is not Empty"
     rm -rf /opt/teamspeak/files/virtualserver_1
     mkdir -p /opt/teamspeak/files
     ln -s $TS3_CHANNELPATH /opt/teamspeak/files/virtualserver_1
fi

./ts3server_minimal_runscript.sh $@ &

pid=$!

trap sig_int  INT
trap sig_term TERM

wait $pid
