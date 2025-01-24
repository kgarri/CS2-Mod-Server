#!/bin/bash

# Create App Dir
mkdir -p "${STEAMAPPDIR}" || true

# Download Updates

if [[ "$STEAMAPPVALIDATE" -eq 1 ]]; then
    VALIDATE="validate"
else
    VALIDATE=""
fi

eval bash "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" "${VALIDATE}"\
				+quit

# steamclient.so fix
mkdir -p ~/.steam/sdk64
ln -sfT ${STEAMCMDDIR}/linux64/steamclient.so ~/.steam/sdk64/steamclient.so

# Install server.cfg
cp /etc/server.cfg "${STEAMAPPDIR}"/game/csgo/cfg/server.cfg

# Install hooks if they don't already exist
if [[ ! -f "${STEAMAPPDIR}/pre.sh" ]] ; then
    cp /etc/pre.sh "${STEAMAPPDIR}/pre.sh"
fi
if [[ ! -f "${STEAMAPPDIR}/post.sh" ]] ; then
    cp /etc/post.sh "${STEAMAPPDIR}/post.sh"
fi

# Download and extract custom config bundle
if [[ ! -z $CFG_URL ]]; then
    echo "Downloading config pack from ${CFG_URL}"
    wget -qO- "${CFG_URL}" | tar xvzf - -C "${STEAMAPPDIR}"
fi

# Rewrite Gameinfo File and Config File
sed -i "/Game[[:space:]]core/a  \\\t\t\tGame\tcsgo/addons/metamod" "${STEAMAPPDIR}/game/csgo/gameinfo.gi"
sed -i "${STEAMAPPDIR}"/game/csgo/cfg/server.cfg

# Install Plugins and Tools
echo "START INSTALL"
source /etc/install.sh
echo "END INSTALL"

# Switch to server directory
cd "${STEAMAPPDIR}/game/bin/linuxsteamrt64"

# Pre Hook
source "${STEAMAPPDIR}/pre.sh"

# Construct server arguments

if [[ -z $GAMEALIAS ]]; then
    # If GAMEALIAS is undefined then default to GAMETYPE and GAMEMODE
    GAME_MODE_ARGS="+game_type ${GAMETYPE} +game_mode ${GAMEMODE}"
else
    # Else, use alias to determine game mode
    GAME_MODE_ARGS="+game_alias ${GAMEALIAS}"
fi

if [[ -z $IP ]]; then
    IP_ARGS=""
else
    IP_ARGS="-ip ${IP}"
fi

if [[ ! -z $SRCDS_TOKEN ]]; then
    SV_SETSTEAMACCOUNT_ARGS="+sv_setsteamaccount ${SRCDS_TOKEN}"
fi

# Start Server

if [[ ! -z $RCON_PORT ]]; then
    echo "Establishing Simpleproxy for ${RCON_PORT} to 127.0.0.1:${PORT}"
    simpleproxy -L "${RCON_PORT}" -R 127.0.0.1:"${PORT}" &
fi

echo "Starting CS2 Dedicated Server"
eval "./cs2" -dedicated \
        "${IP_ARGS}" -port "${PORT}" \
        -console \
        -insecure \
        -usercon \
        -maxplayers "${MAXPLAYERS}" \
        "${GAME_MODE_ARGS}" \
        +map "${MAP}" \
        "${SV_SETSTEAMACCOUNT_ARGS}" \
        +sv_lan "${LAN}" \
        "${ADDITIONAL_ARGS}"

# Post Hook
source "${STEAMAPPDIR}/post.sh"
