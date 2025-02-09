#!/bin/bash

echo "Post-hook: Copying addons if available..."

# Ensure the addons directory exists in the server
mkdir -p "${STEAMAPPDIR}/game/csgo/addons"

# Check if the mounted volume exists and copy the contents
if [[ -d "/mnt/addons" && "$(ls -A /mnt/addons)" ]]; then
    echo "Copying addons to CS2 server..."
    cp -r /mnt/addons/* "${STEAMAPPDIR}/game/csgo/addons/"
    echo "Addons copied successfully."
else
    echo "No addons found to copy."
fi

echo "Post-hook: Done!"