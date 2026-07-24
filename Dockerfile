#FROM ich777/winehq-baseimage
#FROM windroseserver/windroseserver:latest
FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="nodiaque-github@abinemail.com"
LABEL org.opencontainers.image.source="https://github.com/nodiaque/docker-steamcmd-server"

RUN apt-get update && \
	apt-get install -y ca-certificates && \
	update-ca-certificates && \
	apt-get install -y libcurl4 lib32gcc-s1 && \
	rm -rf /var/lib/apt/lists/*

ENV HOME_DIR="/home/ue_user"
ENV DATA_DIR="${HOME_DIR}/app"
#ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV CONFIG_FILE="${DATA_DIR}/R5/ServerDescription.json"
ENV SAVE_DIR="${DATA_DIR}/R5/Saved"
#ENV GAME_ID="4129620"
#ENV GAME_PARAMS=""
#ENV VALIDATE=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""
ENV USER="steam"
ENV DATA_PERM=770
#ENV WINEDEBUG=-all
RUN useradd --create-home -d $HOME_DIR -s /bin/bash $USER && \
	chown -R $USER $HOME_DIR && \
	mkdir $DATA_DIR && \
	ulimit -n 2048

ADD /serverdata/ $DATA_DIR

ADD /scripts/ /opt/scripts/
RUN chmod 777 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]
