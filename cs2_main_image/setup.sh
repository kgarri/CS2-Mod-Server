#!/bin/bash
CSGO_STRING="Counter-Strike Global Offensive"
CSGO_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game/csgo"
SERVER_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game/bin/linuxsteamrt64"
ADMINS_JSON="$CSGO_DIR/addons/counterstrikesharp/configs/admins.json"
rm -r "$CSGO_DIR/addons" || true
cp -r "/home/steam/download/addons" "$CSGO_DIR"


echo "{" >> "$ADMINS_JSON"  
declare -i iter=1
for arg in "$@"; do 
    input=($arg)
    if [ $iter -eq "$#" ]; then 
        echo -e "\t\"${input[0]}\": {\n\t\t\"identity\": \"${input[1]}\",\n\t\t\"flags\":[\"@css/ban\"]\n\t}" >>"$ADMINS_JSON"
    else
        echo -e "\t\"${input[0]}\": {\n\t\t\"identity\": \"${input[1]}\",\n\t\t\"flags\":[\"@css/ban\"]\n\t}," >>"$ADMINS_JSON"
    fi
    ((iter += 1))
done 
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

"$SERVER_DIR/cs2" -dedicated -insecure -autoupdate -port 27015 +map de_dust2


