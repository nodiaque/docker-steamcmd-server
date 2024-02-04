#!/bin/bash

timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

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

echo "---Checking if Proton is installed---"
if ! [ -f "${ASTEAM_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton" ]; then
  echo "---Proton not found, installing---"
  mkdir -p "${ASTEAM_PATH}/compatibilitytools.d" 
  mkdir -p "${ASTEAM_PATH}/steamapps/compatdata/${GAME_ID}" 
  mkdir -p "${DATA_DIR}/.steam"
  ln -s "${STEAMCMD_DIR}/linux32" "${DATA_DIR}/.steam/sdk32" 
  ln -s "${STEAMCMD_DIR}/linux64" "${DATA_DIR}/.steam/sdk64" 
  ln -s "${DATA_DIR}/.steam/sdk32/steamclient.so" "${DATA_DIR}/.steam/sdk32/steamservice.so" 
  ln -s "${DATA_DIR}/.steam/sdk64/steamclient.so" "${DATA_DIR}/.steam/sdk64/steamservice.so" 
  if ! [ -f "${DATA_DIR}/GE-Proton${GE_PROTON_VERSION}.tgz" ]; then
     wget "$GE_PROTON_URL" -O "${DATA_DIR}/GE-Proton${GE_PROTON_VERSION}.tgz"
  fi
  tar -x -C "${ASTEAM_PATH}/compatibilitytools.d/" -f "${DATA_DIR}/GE-Proton${GE_PROTON_VERSION}.tgz" && \
  if ! [ -f "${ASTEAM_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton" ]; then
    echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
    sleep infinity
  fi
else
  echo "---Proton already installed---"
fi

echo "---Updating Enshrouded Dedicated Server---"
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

echo "---Prepare Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}

if [ ! -f ${SERVER_DIR}/enshrouded_server.json ]; then
  echo "---Config file not present, copying default file---"
  cp /opt/config/enshrouded_server.json ${SERVER_DIR}/enshrouded_server.json
else
        echo "---'enshrouded_server.json' found---"
fi

echo "---Updating Enshrouded Server configuration---"
tmpfile=$(mktemp)
echo "---Server name: ${SERVER_NAME}"
#sed -i "/name/c\  \"name\": \"${SERVER_NAME}\"," ${SERVER_DIR}/enshrouded_server.json
jq --arg n "${SERVER_NAME}" '.name = $n' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
echo "---Server password: ${SERVER_PASSWORD}"
#sed -i "/password/c\  \"password\": \"${SERVER_PASSWORD}\"," ${SERVER_DIR}/enshrouded_server.json
jq --arg p "$SERVER_PASSWORD" '.password = $p' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
echo "---Game port: ${GAME_PORT}"
#sed -i "/gamePort/c\  \"gamePort\": \"${GAME_PORT}\"," ${SERVER_DIR}/enshrouded_server.json
jq --arg g "$GAME_PORT" '.gamePort = ($g | tonumber)' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
echo "---Query port: ${QUERY_PORT}"
#sed -i "/queryPort/c\  \"queryPort\": \"${QUERY_PORT}\"," ${SERVER_DIR}/enshrouded_server.json
jq --arg q "$QUERY_PORT" '.queryPort = ($q | tonumber)' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG
echo "---Server slots: ${SERVER_SLOTS}"
#sed -i "/slotCount/c\  \"slotCount\": \"${SERVER_SLOTS}\"," ${SERVER_DIR}/enshrouded_server.json
jq --arg s "$SERVER_SLOTS" '.slotCount = ($s | tonumber)' ${ENSHROUDED_CONFIG} > "$tmpfile" && mv "$tmpfile" $ENSHROUDED_CONFIG


# Wine talks too much and it's annoying
#export WINEDEBUG=-all

echo "---Server ready---"

echo "---Start Server---"

if [ "${BACKUP}" == "true" ]; then
  echo "---Starting Backup daemon---"
  echo "Interval: ${BACKUP_INTERVAL} minutes and keep ${BACKUPS_TO_KEEP} backups"
  if [ ! -d ${SERVER_DIR}/Backups ]; then
    mkdir -p ${SERVER_DIR}/Backups
  fi
  /opt/scripts/start-backup.sh &
fi

if [ ! -f ${SERVER_DIR}/enshrouded_server.exe ]; then
  echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
  sleep infinity
else
  ${ASTEAM_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton run ${SERVER_DIR}/enshrouded_server.exe ${GAME_PARAMS} &
  
  # Find pid for enshrouded_server.exe
  timeout=0
  while [ $timeout -lt 11 ]; do
    if ps -e | grep "enshrouded_serv"; then
      enshrouded_pid=$(ps -e | grep "enshrouded_serv" | awk '{print $1}')

      if [ "${BACKUP}" == "true" ]; then
        echo "---Starting Backup daemon---"
        echo "Interval: ${BACKUP_INTERVAL} minutes and keep ${BACKUPS_TO_KEEP} backups"
        if [ ! -d ${SERVER_DIR}/Backups ]; then
          mkdir -p ${SERVER_DIR}/Backups
        fi
        /opt/scripts/start-backup.sh &
      fi
      tail -n 9999 -f ${SERVER_DIR}/logs/enshrouded_server.log
      break
    elif [ $timeout -eq 10 ]; then
        echo "$(timestamp) ERROR: Timed out waiting for enshrouded_server.exe to be running"
      sleep infinity
    fi
    sleep 6
    ((timeout++))
    echo "$(timestamp) INFO: Waiting for enshrouded_server.exe to be running"
  done

  # I don't love this but I can't use `wait` because it's not a child of our shell
  tail --pid=$enshrouded_pid -f /dev/null

  # If we lose our pid, exit container
  echo "$(timestamp) ERROR: He's dead, Jim"
  exit 1
fi
