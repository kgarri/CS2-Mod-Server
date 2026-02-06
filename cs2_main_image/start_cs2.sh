#!/bin/bash

CSGO_STRING="Counter-Strike Global Offensive"
LAUNCH_DIR="/home/steam/Steam/steamapps/common/$CSGO_STRING/game"

"$LAUNCH_DIR/cs2.sh" +exec autoexec.cfg +exec server.cfg -dedicated -insecure -autoupdate -port 27015 +map de_dust2 +game_alias competitive +exec autoexec.cfg +exec server.cfg

