## Setup

Copy the `CS2-Mod-Server/cs2_main_image/admins.conf.template` file and set the Steam username and Steam ID for the admin users.

You can add as many users to the admin group as needed, as long as you repeat the pattern `<username> <steamid>` at the end.

To build and run the server, just run:

```bash
docker compose up -d --build

docker exec -it "cs2-server" bash -c "~/setup.sh"
```

This will start the server and open the server terminal required to control the matches.

