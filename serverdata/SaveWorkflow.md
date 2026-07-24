## File Structure

In the game, saves are implemented via the RocksDB database. Database files are located at <db_root>:
- Windrose - AppData/Local/R5/Saved/SaveProfiles/<user_id>/
- Windrose Dedicated Server - <application_root>/R5/Saved/SaveProfiles/Default/

The folder structure inside <db_root> is as follows:
- RocksDB_v2 - runtime state of databases starting from versions after 0.10.0.5. Data in this folder is regularly overwritten and deleted during gameplay.
- RocksDB_v2_Backups - database backups created by the game at certain intervals and every time you exit a world/the game (autosaves).
- RocksDB - databases up to and including version 0.10.0.4. If all world/character saves have been migrated to the current game version, this folder can be deleted.

Databases are divided into 3 types:
- Account - this database stores game settings that must synchronize via cloud storage. For example, selected game language, display of performance stats, etc.
- World - databases of this type store world progress. One folder-ID corresponds to one world.
- Player - these databases store character progress. One folder-ID corresponds to one character.


## Backup/Autosave System Operation

- The game creates an autosave every X minutes for any databases that have been modified.
  - This backup is placed into the folder <db_root>/RocksDB_v2_Backups/<data_base_type>/<data_base_id>/
- The game also creates a backup upon exiting the game.
- The backup is packed into a .zip archive and stored at <db_root>/RocksDB_v2_Backups/<data_base_type>/<data_base_id>/
- Each backup filename contains the <data_base_id>, the game version on which the backup was created, and its creation time in UTC.
- The most recent backup is marked with a _Latest suffix.
- The absence of a _Latest file is considered a critical error in the save system.


## Loading Saves

- At startup, the game sequentially loads the saved states of databases from backups — first the account, then characters, and finally worlds.
- To do this, it checks the folder <db_root>/RocksDB_v2_Backups for the most recent save of each database marked with _Latest.
- If an archive is found, the game loads the database from that archive, overwriting the contents of <db_root>/RocksDB_v2/<data_base_type>/<data_base_id>/
- If the _Latest archive is missing or contains errors, a backup recovery process is started.
- The game searches for the newest backup for that database, verifies its integrity, and prompts the player in a special window to confirm restoration from that backup.
- A backup that contains an error is marked with the prefix Broken-
- If no functional backups are found, the world, character, or account is considered permanently lost


## Support for Older Game Versions

When launching a version higher than 0.10.0.4, the game checks for current version database backups in the folder <db_root>/RocksDB_v2_Backups/. Their absence triggers migration of older saves to the new format. The algorithm works as follows:
- Databases from the <db_root>/RocksDB/ folder are loaded one by one.
- For all databases whose integrity is validated, corresponding _Latest versions are created in the <db_root>/RocksDB_v2_Backups/ folder.
- If some databases turn out to be corrupted, the player will see a window offering to delete the broken databases or exit the game.

For reference: in version 0.10.0.4 and earlier, the backup algorithm worked as follows:
- At game start, a complete backup of the <db_root>/RocksDB/ folder is created.
- A copy of this folder is saved at R5/Saved/SaveProfiles/<user_id>_Backups/<UTC time>/

Note that the folder R5/Saved/SaveProfiles/<user_id>_Backups/ is stored locally, was used only up to version 0.10.0.4, and is no longer used by the game. It can be deleted, if all your saves are already migrated to version higher than 0.10.0.4