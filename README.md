# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Windrose and run it on Wine64. 

**Server Name:** Windrose Docker  
**Password:** Docker  

**Configuration:** 
You must wait for the game to be fully initialize once, then shutdown the server to modify the config file.
NEVER MODIFY WHILE THE CONTAINER IS RUNNING.

There is 2 configuration file.

ServerDescription.json
```json
{
  "Version": 1,
  "ServerDescription_Persistent": {
    "InviteCode": "xxxxxxxx",
    "IsPasswordProtected": true,
    "Password": "Docker",
    "ServerName": "Windrose Server",
    "MaxPlayerCount": 4
  }
}
```

To edit World configuration and settings, you edit the file WorldDescription.json. This file will be under a random named folder like R5/Saved/SaveProfiles/Default/RocksDB/<game version>/Worlds/<world document id>/WorldDescription.json
Reference: https://steamcommunity.com/sharedfiles/filedetails/?id=3706337486

**Update Notice:** Simply restart the container if a newer version of the game is available.    
 
## Joining a game
This game doesn't need port forwarding. It rely on invite code and upnp connectivity to a relay server. Once the server has started, you can catch the invite code in the log.
You can also find it in the ServerDescription.json

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '4129620 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 2278520 |
| GAME_PARAMS | Parameter to pass to server executable | blank |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name Windrose -d \
	--env 'GAME_ID=2278520' \
	--env 'BACKUP=true' \
	--env 'BACKUP_INTERVAL=120' \
	--env 'BACKUPS_TO_KEEP=12' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/windrosefile:/serverdata/serverfiles \
	nodiaque/steamcmd:windrose
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from ich777, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/151809-support-nodiaque-gameserver-docker
