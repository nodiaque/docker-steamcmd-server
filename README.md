# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install ARK:SurvivalAscended and run it (Normal server startup of ARK can take a long time!).

**WARNING:** You have to set the value vm.max_map_count to at least 256000 on the host as root with the command:  
`echo 265000 > /proc/sys/vm/max_map_count`  
To make that value persistent on Unraid please use a User Script that runs on startup or with the command from above or put it in your `go` file.

ATTENTION: First Startup can take very long since it downloads the gameserver files!

Update Notice: Simply restart the container if a newer version of the game is available.

You can also run multiple servers with only one SteamCMD directory!

## Example Env params for CS:Source
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '2430930 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 2430930 |
| MAP | Enter your preferred map name | TheIsland_WP |
| SERVER_NAME | Your server name goes here | ASA Docker |
| SRV_PWD | Your server password goes here | Docker |
| SRV_ADMIN_PWD | Your server admin password goes here | adminDocker |
| GAME_PARAMS | Enter your game parameters seperated with ? and start with a ? | ?Port=7777?MaxPlayers=20 |
| GAME_PARAMS_EXTRA | Enter your Extra Game Parameters seperated with a space and - | -server -log -NoBattlEye |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | blank |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example for CS:Source
```
docker run --name ARKSurvivalAscended -d \
	-p 7777:7777/udp \
	--env 'GAME_ID=2430930' \
	--env 'MAP=TheIsland_WP' \
	--env 'SERVER_NAME=ASA Docker' \
	--env 'SRV_PWD=Docker' \
	--env 'SRV_ADMIN_PWD=adminDocker' \
	--env 'GAME_PARAMS=?Port=7777?MaxPlayers=20' \
	--env 'GAME_PARAMS_EXTRA=-server -log -NoBattlEye' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/arksa:/serverdata/serverfiles \
	ich777/steamcmd:asa
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

This Docker is forked from mattieserver, thank you for this wonderfull Docker.

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/