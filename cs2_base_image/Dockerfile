#Get Base Image from Steam CMD
FROM cm2network/steamcmd
USER root
RUN usermod -aG sudo steam
USER steam
CMD bash ./steamcmd.sh +login anonymous +app_update 730 +quit
