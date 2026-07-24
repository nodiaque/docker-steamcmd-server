# Windrose Dedicated Server settings

## Contents
- [Hardware requirements](#hardware-requirements)
- [Easy Start](#easy-start)
- [Server Settings](#server-settings)
  - [ServerDescription.json](#serverdescriptionjson)
  - [WorldDescription.json](#worlddescriptionjson)
  - [Direct IP Connection Scenarios](#direct-ip-connection-scenarios)
  - [Docker image usage](#instructions-for-docker-image-usage)


## Hardware requirements
### 2 players
- CPU: Intel Xeon Scalable (Sapphire Rapids), 2 cores, 3.2 GHz
- RAM: 8 GB
- Storage: 35 GB SSD
### 4 players
- CPU: Intel Xeon Scalable (Sapphire Rapids), 2 cores, 3.2 GHz
- RAM: 12 GB
- Storage: 35 GB SSD
### 10 players
- CPU: Intel Xeon Scalable (Sapphire Rapids), 2 cores, 3.2 GHz
- RAM: 16 GB
- Storage: 35 GB SSD

## Easy Start
If you just want a simple way to start the server on your PC, follow these quick instructions:

1. Start the Windrose Dedicated Server on your platform of choice, or via `StartServerForeground.bat`.
2. A console window will appear on your screen.
3. Once it finishes loading, you should see an invite code that looks something like this: `f1014dc1`.
4. If you cannot find it (the console messages sometimes disappear too quickly), do not worry. Go to the folder where you installed the Windrose Dedicated Server, then open the `R5` folder. Inside it you will find the `ServerDescription.json` file. Open it with any text editor (plain Notepad will do) and look for the invite code. It will look something like this: `f1014dc1`.
5. Now you can launch the game itself. Go to **Play → Connect to Server** and paste the invite code there. You should now be able to see the server and connect to it.
6. Send the invite code to your friends, and they should be able to connect to the server as well (**Play → Connect to Server**, paste the invite code).
7. Yarr!

If you want to change your server settings or need more technical details, see the sections below.

## Server Settings
Server settings are split into two separate JSON files. The first one is `ServerDescription.json`, which holds common server settings. There can be only one such file regardless of the number of worlds, and it is located in the root folder of the application. The second one is `WorldDescription.json` — one file of this type exists per world.

On initial start, the server creates a default `ServerDescription.json` and a first world with its `WorldDescription.json`. It is therefore recommended to start and stop the server once so that the files are generated, and then edit them.

### ServerDescription.json
This is a single file in the root folder of the application.

List of fields:

1. PersistentServerId — unique ID of your server. Do not edit it. **_It will be changed in upcoming builds._**
2. InviteCode — invite code used to find your server. Allowed characters: `0-9`, `a-z`, and `A-Z`. Must contain at least 6 characters. Case sensitive.
3. IsPasswordProtected — specifies whether a password is required. Should be `true` if a password is set and `false` if the `Password` field is empty. Otherwise it may cause unexpected behavior.
4. Password — the server password.
5. ServerName — name of your server. Helpful when invite codes look similar.
6. WorldIslandId — ID of the currently selected world. Must match the corresponding field in one of the server's `WorldDescription.json` files. This world will be loaded when the server starts.
7. MaxPlayerCount — maximum number of simultaneous players on your server.
8. UserSelectedRegion — region for the Connection Service. Supported options: `SEA`, `CIS`, `EU` (EU covers both EU and NA). If left empty, the server will automatically detect and select the optimal region based on latency. If a region is specified (for example, `EU`), the server will use that region exclusively.
9. P2pProxyAddress — IP address for listening sockets.
10. UseDirectConnection — if `true`, the server will create sockets for direct connections with clients. If `false`, the server will use the ICE protocol to establish a P2P connection.
11. DirectConnectionServerAddress — address for direct connection. Reserved for future use. Not used currently.
12. DirectConnectionServerPort — port for direct connection. Must be available for TCP and UDP connections if `UseDirectConnection` is `true`.
13. DirectConnectionProxyAddress — can be used to select a specific network on the computer where the server with direct connection is running. `0.0.0.0` is the default.
14. AutoLoadLatestBackupIfHasBroken — if set to `true`, on launch the server will try to restore broken save files from backups, as described in `SaveWorkflow.md`.
15. CanLaunchMultipleServerInstances — `false` by default, to prevent launching multiple instances of the game server on the same PC. This is an additional safeguard against data corruption when multiple copies of the application work with the same database.

This file can be edited manually only when the server is shut down. Any field may be automatically changed by the server in the event of an issue.

Example:
```json
{
	"Version": 1,
	"DeploymentId": "0.10.0.0.251-master-9f800c33",
	"ServerDescription_Persistent":
	{
		"PersistentServerId": "1B80182E460F727CEA080C8EEBB1EA0A",
		"InviteCode": "d6221bb7",
		"IsPasswordProtected": false,
		"Password": "",
		"ServerName": "",
		"WorldIslandId": "DB57768A8A7746899683D0EEE91F97BF",
		"MaxPlayerCount": 4,
		"UserSelectedRegion": "EU",
		"P2pProxyAddress": "192.168.31.49",
		"UseDirectConnection": false,
		"DirectConnectionServerAddress": "",
		"DirectConnectionServerPort": 7777,
		"DirectConnectionProxyAddress": "0.0.0.0",
		"AutoLoadLatestBackupIfHasBroken": true,
		"CanLaunchMultipleServerInstances": false
	}
}
```


### WorldDescription.json
You can create as many worlds as you need on your server. All worlds are located under:

`<root folder>/R5/Saved/SaveProfiles/Default/RocksDB_v2/<game version>/Worlds/<world document id>/WorldDescription.json`

The first one is created automatically when the server starts.

Note that `WorldIslandId` in `ServerDescription.json` must match the `IslandId` field in the `WorldDescription.json` of the world you want loaded.

List of fields:

1. IslandId — unique ID of the world. Must match the name of the folder containing the file.
2. WorldName — name of the world.
3. CreationTime — creation time in internal format.
4. WorldPresetType — gameplay difficulty preset. Accepted values: `"Easy"`, `"Medium"`, `"Hard"`. If any custom values are present in `WorldSettings`, the preset will be forced to `"Custom"` on the next server launch.
5. WorldSettings — world parameters grouped by type: `bool`, `float`, and `tag`. Should be empty for all presets except `"Custom"`.

List of available world parameters for the custom preset. Note that it may be easier to set up a custom preset in the game and then copy the resulting values to the dedicated server file manually. **_The parameter list and its value ranges may change in upcoming builds._**
Each parameter name below shows the friendly label followed by the actual tag suffix used in JSON (the full tag is `WDS.Parameter.<suffix>`).
1. CoopQuests (`Coop.SharedQuests`): If any player on the server completes a quest marked as a co-op quest, it auto-completes for all players who currently have it active. Default: `true`.
2. EasyExplore (`EasyExplore`): When set to `true`, disables map markers that highlight points of interest, making them harder to find. Default: `false`. Note: "EasyExplore" is the legacy name; in-game it is called "Immersive exploration" and, in effect, makes exploration harder.
3. MobHealthMultiplier (`MobHealthMultiplier`): Defines how much Health enemies have. Default: `1.0`. Range: `[0.2; 5.0]`.
4. MobDamageMultiplier (`MobDamageMultiplier`): Defines how hard enemies hit. Default: `1.0`. Range: `[0.2; 5.0]`.
5. ShipHealthMultiplier (`ShipsHealthMultiplier`): Defines how much Ship Health enemy ships have. Default: `1.0`. Range: `[0.4; 5.0]`.
6. ShipDamageMultiplier (`ShipsDamageMultiplier`): Defines how much Damage enemy ships deal. Default: `1.0`. Range: `[0.2; 2.5]`.
7. BoardingDifficultyMultiplier (`BoardingDifficultyMultiplier`): Defines how many enemy sailors must be defeated to win a boarding action. Default: `1.0`. Range: `[0.2; 5.0]`.
8. CoopStatsCorrectionModifier (`Coop.StatsCorrectionModifier`): Adjusts enemy Health and how fast enemies lose Posture, based on the number of players on the server. Default: `1.0`. Range: `[0.0; 2.0]`.
9. CoopShipStatsCorrectionModifier (`Coop.ShipStatsCorrectionModifier`): Adjusts enemy Ship Health based on the number of players on the server. Default: `0.0`. Range: `[0.0; 2.0]`.
10. CombatDifficulty (`CombatDifficulty`): Defines how difficult boss encounters are and how aggressive enemies are in general. Default: `{"TagName": "WDS.Parameter.CombatDifficulty.Normal"}`. Allowed values: `{"TagName": "WDS.Parameter.CombatDifficulty.Easy"}`, `{"TagName": "WDS.Parameter.CombatDifficulty.Normal"}`, `{"TagName": "WDS.Parameter.CombatDifficulty.Hard"}`.

Example "WorldPresetType": "Medium":
```json
{
    "Version": 1,
    "WorldDescription":
    {
        "IslandId": "E24A22C9C8D3448951AFD002162576D5",
        "WorldName": "The Archipelago",
        "CreationTime": 6.3910902400911002e+17,
        "WorldPresetType": "Medium",
        "WorldSettings":
        {
            "BoolParameters":
            {
                "{\"TagName\": \"WDS.Parameter.Coop.SharedQuests\"}": true,
                "{\"TagName\": \"WDS.Parameter.EasyExplore\"}": false
            },
            "FloatParameters":
            {
                "{\"TagName\": \"WDS.Parameter.MobHealthMultiplier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.MobDamageMultiplier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.ShipsHealthMultiplier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.ShipsDamageMultiplier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.BoardingDifficultyMultiplier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.Coop.StatsCorrectionModifier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.Coop.ShipStatsCorrectionModifier\"}": 0
            },
            "TagParameters":
            {
                "{\"TagName\": \"WDS.Parameter.CombatDifficulty\"}":
                {
                    "TagName": "WDS.Parameter.CombatDifficulty.Normal"
                }
            }
        }
    }
}
```

Example "WorldPresetType": "Easy":
```json
{
    "Version": 1,
    "WorldDescription":
    {
        "IslandId": "26C14DC8A78D4AF69E9C77527C934CF3",
        "WorldName": "The Archipelago",
        "CreationTime": 6.3911887576664998e+17,
        "WorldPresetType": "Easy",
        "WorldSettings":
        {
            "BoolParameters":
            {
                "{\"TagName\": \"WDS.Parameter.Coop.SharedQuests\"}": true,
                "{\"TagName\": \"WDS.Parameter.EasyExplore\"}": false
            },
            "FloatParameters":
            {
                "{\"TagName\": \"WDS.Parameter.MobHealthMultiplier\"}": 0.7,
                "{\"TagName\": \"WDS.Parameter.MobDamageMultiplier\"}": 0.6,
                "{\"TagName\": \"WDS.Parameter.ShipsHealthMultiplier\"}": 0.7,
                "{\"TagName\": \"WDS.Parameter.ShipsDamageMultiplier\"}": 0.6,
                "{\"TagName\": \"WDS.Parameter.BoardingDifficultyMultiplier\"}": 0.7,
                "{\"TagName\": \"WDS.Parameter.Coop.StatsCorrectionModifier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.Coop.ShipStatsCorrectionModifier\"}": 0
            },
            "TagParameters":
            {
                "{\"TagName\": \"WDS.Parameter.CombatDifficulty\"}":
                {
                    "TagName": "WDS.Parameter.CombatDifficulty.Easy"
                }
            }
        }
    }
}
```

Example "WorldPresetType": "Hard":
```json
{
    "Version": 1,
    "WorldDescription":
    {
        "IslandId": "26C14DC8A78D4AF69E9C77527C934CF3",
        "WorldName": "The Archipelago",
        "CreationTime": 6.3911887576664998e+17,
        "WorldPresetType": "Hard",
        "WorldSettings":
        {
            "BoolParameters":
            {
                "{\"TagName\": \"WDS.Parameter.Coop.SharedQuests\"}": true,
                "{\"TagName\": \"WDS.Parameter.EasyExplore\"}": false
            },
            "FloatParameters":
            {
                "{\"TagName\": \"WDS.Parameter.MobHealthMultiplier\"}": 1.5,
                "{\"TagName\": \"WDS.Parameter.MobDamageMultiplier\"}": 1.25,
                "{\"TagName\": \"WDS.Parameter.ShipsHealthMultiplier\"}": 1.5,
                "{\"TagName\": \"WDS.Parameter.ShipsDamageMultiplier\"}": 1.25,
                "{\"TagName\": \"WDS.Parameter.BoardingDifficultyMultiplier\"}": 1.5,
                "{\"TagName\": \"WDS.Parameter.Coop.StatsCorrectionModifier\"}": 1,
                "{\"TagName\": \"WDS.Parameter.Coop.ShipStatsCorrectionModifier\"}": 0
            },
            "TagParameters":
            {
                "{\"TagName\": \"WDS.Parameter.CombatDifficulty\"}":
                {
                    "TagName": "WDS.Parameter.CombatDifficulty.Hard"
                }
            }
        }
    }
}
```

#### Updating World Settings in WorldDescription.json for Dedicated Server
To change `WorldDescription.json` settings on a Dedicated Server, follow these steps:
1. Stop the `WindroseServer` application.
2. Make the necessary changes to the `WorldDescription.json` file of the selected world inside the `Saved\SaveProfile\Default\RocksDB_v2` folder.
3. Locate the `R5WorldDescriptionUpdater.exe` file in the server root folder.
4. Open Command Prompt and navigate to that folder.
5. Run the updater with the path to the selected world’s `WorldDescription.json` file.
```
R5WorldDescriptionUpdater.exe <path_to_world>\WorldDescription.json
```

For example:
```
R5WorldDescriptionUpdater.exe R5\Saved\SaveProfiles\Default\RocksDB_v2\0.10.0\Worlds\796AE3C6113C451DE5BD791D70E4A52B\WorldDescription.json
```

### Direct IP Connection Scenarios
There are two common setups for Direct IP connections, depending on whether the players are on the same local network or connecting over the internet.

#### Players on Different Networks
(Different routers / different homes.)

Example: each player connects from their own home internet connection.

In this scenario, the person hosting the server must have a public external IP address assigned to their router. Some internet providers offer this as a paid service.

The host must configure port forwarding on their router using the following mapping:

    external_ip:external_port (TCP + UDP)
    internal_ip:gameserver_port (TCP + UDP)

Both TCP and UDP forwarding are required.

Definitions:
1. `external_ip` — public IP address assigned to the router by the ISP.
2. `external_port` — port configured in the router's port forwarding settings.
3. `internal_ip` — local IP address of the computer running the dedicated server.
4. `gameserver_port` — port selected in the server UI when launching the server.

How it works:
Connections made to the router's public IP and forwarded port are redirected to the local machine running the server.

Example:

    203.0.113.25:17777
    192.168.1.100:7777

The host then shares:
1. Their public IP address.
2. The forwarded port.

The second player connects using that IP and port in the game client.

#### Players on the Same Local Network (LAN)
Example: two players in the same house using the same router.

In this case:
1. No public IP is required.
2. No port forwarding is required.

The host simply launches the server and selects a port in the server UI, then shares:
1. The local IP address of the server machine.
2. The selected server port.

The second player connects using the local IP and port.

Example:

    192.168.1.100:7777

#### Troubleshooting Direct IP Connections
If connection problems occur, try the following:
1. Verify the server IP address using `ipconfig`. Run this on the machine hosting the server.
2. Try changing the port from `7777` to a higher alternative, such as:
    - `17777`
    - `27890`
    - any unused port below `65000`.
3. Temporarily disable Windows Firewall.
4. Ensure the game client has permission to access the network.
5. Temporarily disable antivirus software.
6. Confirm that both TCP and UDP traffic are allowed for the selected port.
7. Make sure the server is fully started before attempting to connect.

## Instructions for Docker Image Usage
1. Download the Docker image with the following command:
`docker pull windroseserver/windroseserver:latest`
2. Create a folder on your disk to store save files.
3. In the created folder, create a file named ServerDescription.json. Make sure to configure all other required keys as described/preferred earlier in the Server Settings section.
In particular, ensure that the following values are set exactly as shown:
```json
{
...
"UseDirectConnection": true,
"DirectConnectionServerPort": 7777
...
}
```
4. Run the following command in the command line:
`docker run --user ue_user --name WindroseServer -p 7777:7777/tcp -p 7777:7777/udp -d -v {path_with_save}\Saved:/home/ue_user/app/R5/Saved -v {path_with_save}\ServerDescription.json:/home/ue_user/app/R5/ServerDescription.json windroseserver/windroseserver:latest`

If {path_with_save} contains spaces in folder names, use quotes. Example:
` "C:\My Games\WindroseSaves\Saved" `
5. To connect to the local server running in Docker, use a Direct IP Connection with the IP address assigned to the Docker container.
Example:
• IP: 127.0.0.1
• Port: 7777