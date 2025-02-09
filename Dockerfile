###########################################################
# Dockerfile that builds a CS2 Gameserver
###########################################################
# Moddieifed version of joedwards32/cs2
###########################################################

# BUILD STAGE
FROM cm2network/steamcmd:root as build

LABEL maintainer="tompkinsjohn04@gmail.com"

ENV STEAMAPPID=730
ENV STEAMAPP=cs2
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"
ENV STEAMAPPVALIDATE=0

COPY etc/entry.sh "${HOMEDIR}/entry.sh"
COPY etc/server.cfg "/etc/server.cfg"
COPY etc/pre.sh "/etc/pre.sh"
COPY etc/post.sh "/etc/post.sh"
COPY docker-compose.yml "docker-compose.yml"

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
	# Add entry script
	&& chmod +x "${HOMEDIR}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	# Clean up
        && apt-get clean \
        && find /var/lib/apt/lists/ -type f -delete

# BASE

FROM build AS base

# variables used in entry.sh to create the server
# other variables are in the server.cfg
ENV IP=0.0.0.0 \
    PORT=27015 \
    RCON_PORT=27050 \
    MAXPLAYERS=10 \
    MAP="de_dust2" \
    GAMEALIAS="" \
    GAMETYPE=0 \
    GAMEMODE=1 \
    LAN=0 \
    SRCDS_TOKEN="DB8B4AFD4D55E2D7F7B1A83A2AA7E9EF" \
    CFG_URL="" \
    ADDITIONAL_ARGS=""

# Set permissions on STEAMAPPDIR
#   Permissions may need to be reset if persistent volume mounted
RUN set -x \
        && chown -R "${USER}:${USER}" "${STEAMAPPDIR}" \
        && chmod 0777 "${STEAMAPPDIR}"

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose ports
EXPOSE 27015/tcp \
       27015/udp \
       27020/udp \ 
       27050/tcp

