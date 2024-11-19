#!/bin/bash

# List of plugins and modding tools
PLUGINS="/etc/plugins.json"

# Parse plugins in the json file
jq -c '.[]' $PLUGINS | while read PLUGIN; do
    URL=$(echo $PLUGIN- | jq -r '.URL')
    DESTINATION=$(echo $PLUGIN | jq -r '.DESTINATION')
    TYPE=$(echo $PLUGIN | jq -r '.TYPE')

    echo "Installing plugin from $URL to cs2-dedicated/game/csgo/$DESTINATION..."

    # Create the destination directory if it doesn't exist
    mkdir -p cs2-dedicated/game/csgo/"$DESTINATION" || true

    # Handle different types
    if [ "$TYPE" = "zip" ]; then
        TEMP_ZIP="/tmp/addon.zip"
        echo "Downloading and extracting ZIP..."
        curl -L "$URL" -o "$TEMP_ZIP"
        unzip "$TEMP_ZIP" -e cs2-dedicated/game/csgo/"$DESTINATION"
        rm "$TEMP_ZIP"
    elif [ "$TYPE" = "gz" ]; then
        TEMP_GZ="/tmp/addon.tar.gz"
        echo "Downloading and extracting TAR.GZ..."
        curl -L "$URL" -o "$TEMP_GZ"
        tar -xzf "$TEMP_GZ" --strip-components=1 -C cs2-dedicated/game/csgo/"$DESTINATION"
        rm "$TEMP_GZ"
    else
        echo "Unknown type: $TYPE"
        exit 1
    fi
done

echo "All plugins installed successfully!"