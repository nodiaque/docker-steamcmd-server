#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
  echo "SteamCMD not found!"
  wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
  tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
  rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
  ${STEAMCMD_DIR}/steamcmd.sh \
  +login anonymous \
  +quit
else
  ${STEAMCMD_DIR}/steamcmd.sh \
  +login ${USERNAME} ${PASSWRD} \
  +quit
fi

echo "---Update Server---"
if [ "${USERNAME}" == "" ]; then
  if [ "${VALIDATE}" == "true" ]; then
    echo "---Validating installation---"
    ${STEAMCMD_DIR}/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login anonymous \
    +app_update ${GAME_ID} validate \
    +quit
  else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login anonymous \
    +app_update ${GAME_ID} \
    +quit
  fi
else
  if [ "${VALIDATE}" == "true" ]; then
    echo "---Validating installation---"
    ${STEAMCMD_DIR}/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login ${USERNAME} ${PASSWRD} \
    +app_update ${GAME_ID} validate \
    +quit
  else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login ${USERNAME} ${PASSWRD} \
    +app_update ${GAME_ID} \
    +quit
  fi
fi

export WINEARCH=win64
export WINEPREFIX=/serverdata/serverfiles/WINE64
export WINEDEBUG=-all
echo "---Checking if WINE workdirectory is present---"
if [ ! -d ${SERVER_DIR}/WINE64 ]; then
  echo "---WINE workdirectory not found, creating please wait...---"
  mkdir ${SERVER_DIR}/WINE64
else
  echo "---WINE workdirectory found---"
fi
echo "---Checking if WINE is properly installed---"
if [ ! -d ${SERVER_DIR}/WINE64/drive_c/windows ]; then
  echo "---Setting up WINE---"
  cd ${SERVER_DIR}
  winecfg > /dev/null 2>&1
  sleep 15
else
  echo "---WINE properly set up---"
fi
echo "---Prepare Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}

if [ ! -f ${SERVER_DIR}/enshrouded_server.json ]; then
        echo "---'enshrouded_server.json' not found, downloading template---"
        cd ${SERVER_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/nodiaque/docker-steamcmd-server/enshrouded/config/enshrouded_server.json ; then
                echo "---Sucessfully downloaded 'enshrouded_server.json'---"
        else
                echo "---Something went wrong, can't download 'enshrouded_server.json', will use game default file ---"
                cp /opt/config/enshrouded_server.json ${SERVER_DIR}/enshrouded_server.json
        fi
else
        echo "---'enshrouded_server.json' found---"
fi

echo "---Server ready---"

echo "---Start Server---"

if [ "${BACKUP}" == "true" ]; then
  echo "---Starting Backup daemon---"
  echo "Interval: ${BACKUP_INTERVAL} minutes and keep ${BACKUP_TO_KEEP} backups"
  if [ ! -d ${SERVER_DIR}/Backups ]; then
    mkdir -p ${SERVER_DIR}/Backups
  fi
  /opt/scripts/start-backup.sh &
fi

if [ ! -f ${SERVER_DIR}/enshrouded_server.exe ]; then
  echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
  sleep infinity
else
  cd ${SERVER_DIR}
  wine64 ${SERVER_DIR}/enshrouded_server.exe ${GAME_PARAMS}
fi

