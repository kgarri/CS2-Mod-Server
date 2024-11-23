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
    if [[ "$TYPE" == "zip" ]]; then
        TEMP_ZIP="/tmp/addon.zip"
        log_info "Downloading ZIP from $URL..."
        if ! curl -L "$URL" -o "$TEMP_ZIP"; then
            log_error "Failed to download ZIP file from $URL"
            continue
        fi

        log_info "Extracting ZIP to cs2-dedicated/game/csgo/$DESTINATION..."
        if ! unzip -o "$TEMP_ZIP" -d "cs2-dedicated/game/csgo/$DESTINATION"; then
            log_error "Failed to extract ZIP: $TEMP_ZIP"
            rm -f "$TEMP_ZIP"
            continue
        fi
        rm -f "$TEMP_ZIP"
    elif [[ "$TYPE" == "gz" ]]; then
        TEMP_GZ="/tmp/addon.tar.gz"
        log_info "Downloading TAR.GZ from $URL..."
        if ! curl -L "$URL" -o "$TEMP_GZ"; then
            log_error "Failed to download TAR.GZ file from $URL"
            continue
        fi

        log_info "Extracting TAR.GZ to cs2-dedicated/game/csgo/$DESTINATION..."
        if ! tar -xzf "$TEMP_GZ" --strip-components=1 -C "cs2-dedicated/game/csgo/$DESTINATION"; then
            log_error "Failed to extract TAR.GZ: $TEMP_GZ"
            rm -f "$TEMP_GZ"
            continue
        fi
        rm -f "$TEMP_GZ"
    else
        log_error "Unknown type: $TYPE"
        exit 1
    fi

    # Verify if the files were created in the destination
    if [[ ! -d "cs2-dedicated/game/csgo/$DESTINATION" ]] || [[ -z "$(ls -A "cs2-dedicated/game/csgo/$DESTINATION")" ]]; then
        log_error "No files were created in destination: cs2-dedicated/game/csgo/$DESTINATION"
        continue
    fi

    log_info "Plugin installed successfully at cs2-dedicated/game/csgo/$DESTINATION"
done

# Moves metamod folder from CounterStrikeSharp
#INNER_METAMOD="cs2-dedicated/game/csgo/addons/counterstrikesharp/metamod/"
#OUTER_METAMOD="cs2-dedicated/game/csgo/addons/metamod/"
#if [[ -d "$INNER_METAMOD" ]]; then
#    find "$INNER_METAMOD" -mindepth 1 -exec mv -t "$OUTER_METAMOD" {} +
#    rmdir "$INNER_METAMOD"

echo "All plugins installed successfully!"