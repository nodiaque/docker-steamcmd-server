#!/bin/bash
#if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
#  echo "SteamCMD not found!"
#  wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
#  tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
#  rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
#fi

#echo "---Update SteamCMD---"
#if [ "${USERNAME}" == "" ]; then
#  ${STEAMCMD_DIR}/steamcmd.sh \
#  +login anonymous \
#  +quit
#else
#  ${STEAMCMD_DIR}/steamcmd.sh \
#  +login ${USERNAME} ${PASSWRD} \
#  +quit
#fi

#echo "---Update Server---"
#if [ "${USERNAME}" == "" ]; then
#  if [ "${VALIDATE}" == "true" ]; then
#    echo "---Validating installation---"
#    ${STEAMCMD_DIR}/steamcmd.sh \
#    +@sSteamCmdForcePlatformType linux \
#    +force_install_dir ${SERVER_DIR} \
#    +login anonymous \
#    +app_update ${GAME_ID} validate \
#    +quit
#  else
#    ${STEAMCMD_DIR}/steamcmd.sh \
#    +@sSteamCmdForcePlatformType linux \
#    +force_install_dir ${SERVER_DIR} \
#    +login anonymous \
#    +app_update ${GAME_ID} \
#    +quit
#  fi
#else
#  if [ "${VALIDATE}" == "true" ]; then
#    echo "---Validating installation---"
#    ${STEAMCMD_DIR}/steamcmd.sh \
#    +@sSteamCmdForcePlatformType linux \
#    +force_install_dir ${SERVER_DIR} \
#    +login ${USERNAME} ${PASSWRD} \
#    +app_update ${GAME_ID} validate \
#    +quit
#  else
#    ${STEAMCMD_DIR}/steamcmd.sh \
#    +@sSteamCmdForcePlatformType linux \
#    +force_install_dir ${SERVER_DIR} \
#    +login ${USERNAME} ${PASSWRD} \
#    +app_update ${GAME_ID} \
#    +quit
#  fi
#fi

echo "---Prepare Server---"
chmod -R ${DATA_PERM} ${CONFIG_FILE}
chmod -R ${DATA_PERM} ${SAVE_DIR}

echo "---Server ready---"

echo "---Start Server---"
#SERVER_EXE="${SERVER_DIR}/R5/Binaries/Linux/WindroseServer-Linux-Shipping"
cd ${DATA_DIR}
./WindroseServer.sh

#if [ -z "$SERVER_EXE" ]; then
#  echo "ERROR: Windrose server executable not found"
#  exit 1
#fi

#echo "Starting Windrose dedicated server"
#echo "Executable: $SERVER_EXE"

#cd ${SERVER_DIR}
#${SERVER_EXE} -log ${GAME_PARAMS}
