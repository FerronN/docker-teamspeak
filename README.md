# TeamSpeak 3 Server in a for use with persistant storage (Alpine)
# I use this setup within my kubernetes cluster > questions = issue. 

[Docker Image](https://hub.docker.com/r/polinux/teamspeak/) with TeamSpeak 3 Server using Alpine Linux to make image super small. Size is < `25Mb` 

### Build

```bash
docker build -t polinux/teamspeak .
```

### Deploy Data Container
All settings will be saved in `/data/ts3/` directory and can easily be backed up.

```bash
docker run \
  -d \
  --name ts3-data \
  -v /data/ts3:/opt/teamspeak \
  busybox
```

### Deploy TeamSpeak Server
```bash
docker run \
  -d \
  --name ts3 \
  -p 9987:9987/udp \
  -p 10011:10011 \
  -p 30033:30033 \
  --volumes-from ts3-data \
  polinux/teamspeak
```

### Server administrator access and ServerAdmin privilege key
Admin login details can be found on first run in logs of running container. Make sure you save them. After restarting the container those details are not available anymore. See logs by typing `docker logs -f ts3`  

Example output:  

```bash
[LOG 09:43:32] Teamspeak version: 3.0.12.4 installed.
[LOG 09:43:32] Starting Teamspeak 3 Server
2016-05-05 09:43:32.736465|INFO    |ServerLibPriv |   |TeamSpeak 3 Server 3.0.12.4 (2016-04-25 15:16:45)
2016-05-05 09:43:32.736537|INFO    |ServerLibPriv |   |SystemInformation: Linux 3.10.0-327.10.1.el7.x86_64 #1 SMP Tue Feb 16 17:03:50 UTC 2016 x86_64 Binary: 64bit
2016-05-05 09:43:32.736555|WARNING |ServerLibPriv |   |The system locale is set to "C" this can cause unexpected behavior. We advice you to repair your locale!
2016-05-05 09:43:32.736567|INFO    |ServerLibPriv |   |Using hardware aes
2016-05-05 09:43:32.737012|INFO    |DatabaseQuery |   |dbPlugin name:    SQLite3 plugin, Version 2, (c)TeamSpeak Systems GmbH
2016-05-05 09:43:32.737034|INFO    |DatabaseQuery |   |dbPlugin version: 3.8.6
2016-05-05 09:43:32.737183|INFO    |DatabaseQuery |   |checking database integrity (may take a while)
2016-05-05 09:43:32.746986|INFO    |SQL           |   |db_CreateTables() tables created
2016-05-05 09:43:32.845159|WARNING |Accounting    |   |Unable to find valid license key, falling back to limited functionality

------------------------------------------------------------------
                      I M P O R T A N T
------------------------------------------------------------------
               Server Query Admin Account created
         loginname= "serveradmin", password= "MH67cEkp"
------------------------------------------------------------------

2016-05-05 09:43:34.015956|INFO    |              |   |Puzzle precompute time: 1154
2016-05-05 09:43:34.016317|INFO    |FileManager   |   |listening on 0.0.0.0:30033
2016-05-05 09:43:34.017202|INFO    |VirtualSvrMgr |   |executing monthly interval
2016-05-05 09:43:34.017328|INFO    |VirtualSvrMgr |   |reset virtualserver traffic statistics

------------------------------------------------------------------
                      I M P O R T A N T
------------------------------------------------------------------
      ServerAdmin privilege key created, please use it to gain
      serveradmin rights for your virtualserver. please
      also check the doc/privilegekey_guide.txt for details.

       token=zvy6PsP6px+qa39yM44CQ0cZalxv7JA7+mZtfp5h
------------------------------------------------------------------

2016-05-05 09:43:34.064654|INFO    |VirtualServer |1  |listening on 0.0.0.0:9987
2016-05-05 09:43:34.064932|INFO    |VirtualServer |1  |client 'server'(id:0) added privilege key for servergroup 'Server Admin'(id:6)
2016-05-05 09:43:34.064950|WARNING |VirtualServer |1  |--------------------------------------------------------
2016-05-05 09:43:34.064960|WARNING |VirtualServer |1  |ServerAdmin privilege key created, please use the line below
2016-05-05 09:43:34.064969|WARNING |VirtualServer |1  |token=zvy6PsP6px+qa39yM44CQ0cZalxv7JA7+mZtfp5h
2016-05-05 09:43:34.064977|WARNING |VirtualServer |1  |--------------------------------------------------------
2016-05-05 09:43:34.066438|INFO    |CIDRManager   |   |updated query_ip_whitelist ips: 127.0.0.1,
2016-05-05 09:43:34.066637|INFO    |Query         |   |listening on 0.0.0.0:10011
```

Docker troubleshooting
======================

Use docker command to see if all required containers are up and running:
```bash
$ docker ps
```

Check logs of gitbucket server container:
```bash
$ docker logs ts3
```

Sometimes you might just want to review how things are deployed inside a running
 container, you can do this by executing a _bash shell_ through _docker's
 exec_ command:
```bash
docker exec -ti ts3 /bin/bash
```

History of an image and size of layers:
```bash
docker history --no-trunc=true polinux/teamspeak | tr -s ' ' | tail -n+2 | awk -F " ago " '{print $2}'
```

## Author

Author: Przemyslaw Ozgo (<linux@ozgo.info>)

---
