# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Enshrouded and run it.  
  
**Server Name:** Enshrouded Docker  
**Password:** Docker  
  
**Configuration:** The configuration is located at: ./enshrouded_server.json.  

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
| SERVER_NAME | Name of the server | Enshrouded Docker |
| SERVER_PASSWORD | Serevr password | Docker |
| GAME_PORT | Game port | 15636 |
| QUERY_PORT | Query Port | 15637 |
| SERVER_SLOTS | Number of player slots | 16 |
| BACKUP | Set this value to 'true' to enable the automated backup function from the container, you find the Backups in '.../palworld/Backups/'. Set to 'false' to disable the backup function. | true |
| BACKUP_INTERVAL | The backup interval in minutes (ATTENTION: The first backup will be triggered after the set interval in this variable after the start/restart of the container) | 120 |
| BACKUP_TO_KEEP | Number of backups to keep (by default set to 12 to keep the last backups of the last 24 hours) | 12 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name Enshrouded_Proton -d \
	-p 15636-15637:15636-15637/udp \
	--env GAME_ID=2278520 \
	--env SERVER_NAME="Enshrouded Docker" \
	--env SERVER_PASSWORD="Docker" \
	--env GAME_PORT=15636 \
	--env QUERY_PORT=15637 \
	--env SERVER_SLOTS=16 \
	--env BACKUP=true \
	--env BACKUP_INTERVAL=120 \
	--env BACKUP_TO_KEEP=12 \
	--env UID=99 \
	--env GID=100 \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/enshroudedfile:/serverdata/serverfiles \
	nodiaque/steamcmd:enshrouded_proton
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from ich777, thank you for this wonderfull Docker.

Also used sknnr work on Proton for Enshrouded.

### Support Thread: https://forums.unraid.net/topic/151809-support-nodiaque-gameserver-docker
