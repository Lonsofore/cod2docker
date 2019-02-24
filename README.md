# cod2docker
Docker image for your Call of Duty 2 server. Libcod included! 


## Supported tags

Tags compared from CoD2 version + libcod features.

Supported versions: 1.0, 1.2, 1.3

Default version tag include MySQL and SQLite support both. If you want to use VoroN's MySQL variant (experimental) - use -voron with version.

### List of all supported tags
* 1.0
* 1.0-voron
* 1.2
* 1.2-voron
* 1.3
* 1.3-voron
* latest

latest is 1.3 version!


## How to use

Upload your main folder, fs_game of server (server folder) and [cod_lnxded for your version](https://killtube.org/showthread.php?1719-CoD2-Latest-cod2-linux-binaries-(1-0-1-2-1-3)) to your server.

Create (or copy from repo) a docker-compose.yml file contains:
```
version: '3.7'
services:
  myserver:
    image: lonsofore/cod2:1.0
    container_name: myserver
    restart: always
    stdin_open: true
    tty: true
    network_mode: host
    volumes:
     - ~/cod2/main:/cod2/main
     - ~/cod2/myserver:/cod2/myserver
     - ~/cod2/cod2_lnxded_1_0:/cod2/cod2_lnxded
     - ~/cod2/Library:/cod2/.callofduty2/server/Library
    environment:
     PARAMS: "+set fs_homepath /cod2/.callofduty2/ +set fs_game myserver +set dedicated 2 +set net_port 28960 +exec myserver.cfg"
     CHECK_PORT: 28960
```
And replace here volumes path to yours (local:container) and environment variables with yours (put in PARAMS your own fs_game, server port and server config name and also server port to CHECK_PORT).


# Support

You always can get support on [Killtube forum](https://killtube.org) and [Killtube Discord chat](https://discordapp.com/invite/mqBchQZ). Feel free to ask!