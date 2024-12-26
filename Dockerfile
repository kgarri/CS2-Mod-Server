###########################################################
# Dockerfile that builds a CS2 Gameserver
###########################################################
# Moddieifed version of joedwards32/cs2
###########################################################

# BUILD STAGE
FROM cm2network/steamcmd:root-bookworm AS build

LABEL maintainer="tompkinsjohn04@gmail.com"

ENV STEAMAPPID=730
ENV STEAMAPP=cs2
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMAPPVALIDATE=0

COPY etc/entry.sh "${HOMEDIR}/entry.sh"
COPY etc/server.cfg "/etc/server.cfg"
COPY etc/pre.sh "/etc/pre.sh"
COPY etc/post.sh "/etc/post.sh"

COPY etc/plugins.json "/etc/plugins.json"
COPY etc/install.sh "/etc/install.sh"
COPY docker-compose.yaml "docker-compose.yaml"

RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget \
		ca-certificates \
		lib32z1 \
                simpleproxy \
                libicu-dev \
                unzip \
		jq \
	&& mkdir -p "${STEAMAPPDIR}" \
	# Add start script
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	# Clean up
        && apt-get clean \
        && find /var/lib/apt/lists/ -type f -delete

# BASE

FROM build AS base

# !!!CONFIGURE SERVER SETTINGS HERE!!!
ENV CS2_SERVERNAME="Research" \
    CS2_CHEATS=1 \
    CS2_IP=0.0.0.0 \
    CS2_SERVER_HIBERNATE=0 \
    CS2_PORT=27015 \
    CS2_RCON_PORT='' \
    CS2_RCONPW="RVP" \
    CS2_MAXPLAYERS=10 \
    CS2_MAP="de_dust2" \
    CS2_GAMEALIAS="" \
    CS2_GAMETYPE=0 \
    CS2_GAMEMODE=0 \
    CS2_LAN=0 \
    TV_AUTORECORD=0 \
    TV_ENABLE=0 \
    TV_PORT=27020 \
    TV_PW="TVPW" \
    TV_RELAY_PW="TVRPW" \
    TV_MAXRATE=0 \
    TV_DELAY=0 \
    BOT_DIFFICULTY=3 \
    BOT_QUOTA=10 \
    BOT_QUOTA_MODE="normal" \
    SRCDS_TOKEN="DB8B4AFD4D55E2D7F7B1A83A2AA7E9EF" \
    CS2_LOG="off" \
    CS2_LOG_MONEY=0 \
    CS2_LOG_DETAIL=0 \
    CS2_LOG_ITEMS=0 \
    CS2_LOG_LOADOUTS=0 \
    CS2_ADDITIONAL_ARGS=""


# Permissions may need to be reset if persistent volume mounted
RUN set -x \
        && chown -R "${USER}:${USER}" "${STEAMAPPDIR}" \
        && chmod 0777 "${STEAMAPPDIR}" 

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

# Setup for server starting
CMD ["/bin/bash", "entry.sh"]

# Expose ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp 
