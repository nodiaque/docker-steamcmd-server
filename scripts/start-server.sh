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

if [ -z "${PUBLIC_IP}" ]; then
  echo "--- No public set, trying to obtain it...---"
  PUBLIC_IP="$(wget -qO - ipv4.icanhazip.com)"
  if [ -z "${PUBLIC_IP}" ]; then
    echo "---Can't get PublicIP, please use PUBLIC_IP env var and set your public IP!---"
    echo "Shutting down!"
  else
    echo "---Sucessfully obtained PublicIP: ${PUBLIC_IP}"
    echo "---Prepare Server---"
    chmod -R ${DATA_PERM} ${DATA_DIR}
    echo "---Server ready---"

    echo "---Start Server---"
    if [ ! -f ${SERVER_DIR}/DNL/Binaries/Win64/DNLServer.exe ]; then
      echo "---Something went wrong, can't find the executable, stopping container!---"
    #  sleep infinity
    else
      cd ${SERVER_DIR}
      wine64 ${SERVER_DIR}/DNL/Binaries/Win64/DNLServer.exe ${MAPNAME}?Multihome=${PUBLIC_IP}?listen?SessionName=${SERVERNAME}?ServerPassword=${GAMEPASS}?ServerAdminPassword=${ADMINPASS}?Port=${GAMEPORT}?QueryPort=${QUERYPORT}?MaxPlayers=${MAXPLAYERS} -server -log ${GAME_PARAMS}
    fi
  fi
fi

