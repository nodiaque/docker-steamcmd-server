FROM ich777/winehq-baseimage

LABEL org.opencontainers.image.authors="nodiaque-github@abinemail.com"
LABEL org.opencontainers.image.source="https://github.com/nodiaque/docker-steamcmd-server"

RUN apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc-s1 lib32stdc++6 lib32z1 winbind && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="630230"
ENV GAME_PARAMS=""
ENV VALIDATE=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""
ENV USER="steam"
ENV DATA_PERM=770
ENV QUERYPORT=27016
ENV GAMEPORT=7777
ENV ADMINPASS="DockerAdmin"
ENV SERVERNAME="DNLDocker"
ENV MAPNAME=DNL_ALL
ENV GAMEPASS="Docker"
ENV MAXPLAYERS=127
ENV PUBLIC_IP=""

RUN mkdir $DATA_DIR && \
	mkdir $STEAMCMD_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
