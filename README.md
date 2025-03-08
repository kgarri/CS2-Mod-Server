##Setup
For the  setup you need to first make the base cs2-server image using the following command -
```
cd cs2_base_image
docker build . -t base-cs2-image```
Afterwards you will execute the following commands to build the modded server image.
```
cd cs2_main_image
docker build . -t cs2-mod-server
```
Then you can excute this command to start the server - 
```
docker run --name <server-name> --net=host -it --mount type=bind, source="<path to steamcmd>", target="/home/steam/steamcmd"
--mount type=bind, source="<path to Steam direcotry with CS2 in it>", target="/home/steam/Steam"
cs2-mod-server "<username> <steamid>" 
```

You can add as many users to the admin group as long as you repeat the end pattern "<username> <steamid>". 

