# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Enshrouded and run it.  
  
**Server Name:** Enshrouded Docker  
**Password:** Docker  
  
**Configuration:** The configuration is located at: ./enshrouded_server.json.  
Env parameter will overwrite setting in config file. You either change directly the config file or use the env param.

**Update Notice:** Simply restart the container if a newer version of the game is available.  
  
Config file must be placed in /serverdata/serverfiles root folder (check path mapping below)  
The game will download enshrouded_server.json default config file if you don't provide yours (check in config folder for template).  

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '2278520 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 2278520 |
| GAME_PARAMS | Parameter to pass to server executable | blank |
| SERVERNAME | Name of the server. Overwrite config file | Enshrouded Docker |
| SERVERPASS | Password for the server. Overwrite config file | Docker |
| UDPGAMEPORT | UDP Game port used by the server. Overwrite config file. Be sure to change port mapping in the run command | 15636 |
| UDPQUERYPORT | UDP Query port used by the server. Overwrite config file. Be sure to change port mapping in the run command | 15637 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name Enshrouded -d \
	-p 15636-15637:15636-15637/udp \
	--env 'GAME_ID=2278520' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/enshroudedfile:/serverdata/serverfiles \
	nodiaque/steamcmd:enshrouded
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from ich777, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/151809-support-nodiaque-gameserver-docker
