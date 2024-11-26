#!/bin/bash

# List of plugins and modding tools
PLUGINS="/etc/plugins.json"

# Parse plugins in the json file
jq -c '.[]' $PLUGINS | while read PLUGIN; do
    URL=$(echo $PLUGIN- | jq -r '.URL')
    DESTINATION=$(echo $PLUGIN | jq -r '.DESTINATION')
    TYPE=$(echo $PLUGIN | jq -r '.TYPE')

    echo "Installing plugin from $URL to $DESTINATION..."

    # Create the destination directory if it doesn't exist
    mkdir -p "$DESTINATION" || true

    # Handle different types
    if [[ "$TYPE" == "zip" ]]; then # Hanldes ZIP files
        TEMP_ZIP="/tmp/addon.zip"
        echo "Downloading ZIP from $URL..."
        echo "Downloading ZIP TEMP $TEMP_ZIP"
        if ! curl -L "$URL" -o "$TEMP_ZIP"; then
            echo "Failed to download ZIP file from $URL"
            echo "Failed to download TAR.GZ temp from $TEMP_GZ"
            continue
        fi

        echo "Extracting ZIP to $DESTINATION..."
        if ! unzip -o "$TEMP_ZIP" -d "$DESTINATION"; then
            echo "Failed to extract ZIP: $TEMP_ZIP"
            rm -f "$TEMP_ZIP"
            continue
        fi
        echo "Extracted ZIP: $TEMP_ZIP"
        rm -f "$TEMP_ZIP"


    elif [[ "$TYPE" == "gz" ]]; then # Hanldes GZ files
        TEMP_GZ="/tmp/addon.tar.gz"
        echo "Downloading TAR.GZ from $URL..."
        echo "Downloading TAR.GZ TEMP $TEMP_GZ"
        if ! curl -L "$URL" -o "$TEMP_GZ"; then
            echo "Failed to download TAR.GZ file from $URL"
            echo "Failed to download TAR.GZ temp from $TEMP_GZ"
            continue
        fi

        echo "Extracting TAR.GZ to $DESTINATION..."
        if ! tar -xzf "$TEMP_GZ" --strip-components=1 -C "$DESTINATION"; then
            echo "Failed to extract TAR.GZ: $TEMP_GZ"
            rm -f "$TEMP_GZ"
            continue
        fi
        echo "extracted TAR.GZ: $TEMP_GZ"
        rm -f "$TEMP_GZ"
        
    else
        log_error "Unknown type: $TYPE"
        exit 1
    fi

    # Verify if the files were created in the destination
    if [[ ! -d "$DESTINATION" ]] || [[ -z "$(ls -A "$DESTINATION")" ]]; then
        echo "No files were created in destination: $DESTINATION"
        continue
    fi

    echo "Plugin installed successfully at cs2-dedicated/game/csgo/$DESTINATION"
done

echo "All plugins installed successfully!"