#!/bin/bash
# Wait for cs2-base to finish its steamcmd run by checking for the marker
echo "cs2-mod-server: waiting for cs2-base completion marker..."
while [ ! -f /home/steam/steamcmd/.cs2_base_done ]; do
    sleep 2
done

echo "cs2-mod-server: detected cs2-base completion marker. Continuing startup."
echo "cs2-mod-server: removing cs2-base completion marker."
rm /home/steam/steamcmd/.cs2_base_done


CSGO_STRING="Counter-Strike Global Offensive"
LAUNCH_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game"
CSGO_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game/csgo"
SERVER_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game/bin/linuxsteamrt64"
REPLAYS_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game/csgo/replays"
CFG_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game/csgo/cfg"
ADMINS_JSON="$CSGO_DIR/addons/counterstrikesharp/configs/admins.json"


rm -r "$CSGO_DIR/addons" || true

cp -r "/home/steam/download/addons" "$CSGO_DIR"
cp "/home/steam/autoexec.cfg" "$CFG_DIR/" 
cp "/home/steam/server.cfg"   "$CFG_DIR/"

ADMINS_CONF="/home/steam/admins.conf"
line_count=$(wc -l < "$ADMINS_CONF")

echo "{" >> "$ADMINS_JSON"  
declare -i iter=1
while IFS=' ' read -r -a input; do
    if [ $iter -eq $line_count ]; then 
        echo -e "\t\"${input[0]}\": {\n\t\t\"identity\": \"${input[1]}\",\n\t\t\"flags\":[\"@css/ban\"]\n\t}" >>"$ADMINS_JSON"
    else
        echo -e "\t\"${input[0]}\": {\n\t\t\"identity\": \"${input[1]}\",\n\t\t\"flags\":[\"@css/ban\"]\n\t}," >>"$ADMINS_JSON"
    fi
    ((iter += 1))
done < "$ADMINS_CONF"
echo "}" >> "$ADMINS_JSON" 


metamod=$(cat "$CSGO_DIR/gameinfo.gi" | grep -oh metamod | wc -w)
echo "Checking metamod installation status: $metamod"

#metamod section taken and modified from reddit https://www.reddit.com/r/cs2/comments/16ydlkb/counterstrike_2_dedicated_linux_server_install/
if [[ $metamod -eq 1 ]]
then
	echo "Metamod already installed"
else
	echo "Installing metamod in gameinfo.gi"
	sed -ie '/Game_LowViolence/a\\n\t\t\tGame    csgo/addons/metamod' "$CSGO_DIR/gameinfo.gi"
fi

execstack -c "$CSGO_DIR/addons/counterstrikesharp/bin/linuxsteamrt64/counterstrikesharp.so"


"$LAUNCH_DIR/cs2.sh" +exec autoexec.cfg +exec server.cfg -dedicated -insecure -autoupdate -port 27015 +map de_dust2 +game_alias competitive +exec autoexec.cfg +exec server.cfg


