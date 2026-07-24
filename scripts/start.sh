#!/bin/bash
kill -n 9 $(pidof WindroseServer-Linux-Shipping)
kill -n 9 $(pidof sh)
kill -n 9 1
echo "---Ensuring UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Ensuring GID: ${GID} matches user---"
groupmod -g ${GID} ${USER} > /dev/null 2>&1 ||:
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Taking ownership of data...---"
chown -R root:${GID} /home/ue_user/scripts
chmod -R 750 /home/ue_user/scripts
chown -R ${UID}:${GID} ${DATA_DIR}

echo "---Starting...---"
term_handler() {
	kill -n 9 $(pidof WindroseServer-Linux-Shipping)
	tail --pid=$(pidof WindroseServer-Linux-Shipping) -f 2>/dev/null
	exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM
su ${USER} -c "/home/ue_user/scripts/start-server.sh" &
killpid="$!"
while true
do
  wait $killpid
  exit 0;
done
