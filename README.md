# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Dark and Light and run it.  
  
**Server Name:** DNLDocker  
**Password:** Docker  
  
**Configuration:** The configuration is located at: ./DNL/Saved/Config/WindowsServer/GameUserSettings.ini.  

**Update Notice:** Simply restart the container if a newer version of the game is available.  
  
Run the server once and when it's started properly, stop and edit the config file

To enable RCon, you must forward port 27020. 

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '2278520 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 2278520 |
| GAME_PARAMS | Parameter to pass to server executable | blank |
| MAPNAME | Select the map for the server. Either DNL_ALL or theshard | DNL_ALL |
| SERVERNAME | Name of the server | DNLDocker |
| GAMEPASS | Server password | Docker |
| ADMINPASS | Server admin pass | AdminDocker |
| GAMEPORT | Game the port listen to. If changed, port mapping need also to be changed. Port mapping is range to GAMEPORT+1 | 7777 |
| QUERYPORT | Query port for the game. Used to discover the server. If changed, port mapping need to be changed. The port mapping is range to QUERYPORT+1 tcp/upd | 27015 |
| MAXPLAYERS | Maximum number of players in the game. | 127 |
| PUBLIC_IP | Set public ip for the server to be discoverable. Will try to get it if not specified. | blank |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name DNL -d \
	-p 27015-27016:27015-27016 \
	-p 27015-27016:27015-27016/udp \
	-p 7777-7778:7777-7778 \
	-p 7777-7778:7777-7778/udp \
	-p 27020:27020 \
	--env 'GAME_ID=630230' \
	--env 'ADMINPASS=AdminDocker' \
	--env 'SERVERNAME=DNLDocker' \
	--env 'MAPNAME=DNL_ALL' \
	--env 'GAMEPASS=Docker' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/dnl:/serverdata/serverfiles \
	nodiaque/steamcmd:dnl
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from ich777, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/151809-support-nodiaque-gameserver-docker
