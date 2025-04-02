#Get Base image from the existing base cs2 image
FROM base-cs2-image
SHELL ["/bin/bash", "-c"]
COPY ["setup.sh", "/home/steam/"]
COPY ["autoexec.cfg", "/home/steam"]
COPY ["server.cfg", "/home/steam"]
USER root
RUN apt update && \
apt install -y unzip unar && \
chown steam /home/steam/setup.sh && \
chmod +x /home/steam/setup.sh && \  
chown steam /home/steam/autoexec.cfg && \
chown steam /home/steam/server.cfg 

USER steam
RUN mkdir /home/steam/download && \
cd /home/steam/download && \
#MetaMod
curl -L https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1334-linux.tar.gz --output mmsource.tar.gz && \
tar -xzvf mmsource.tar.gz && \
rm mmsource.tar.gz && \
#CounterStrikeSharp
curl -L https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v305/counterstrikesharp-with-runtime-build-305-linux-e99d27c.zip --output counter-sharp.zip && \
unzip counter-sharp.zip && \
rm counter-sharp.zip && \
#DiscordReport
curl -L https://github.com/SUBERNER/cs2-simple-discord-report/releases/download/Working/ReportDcPlugin.zip --output  ReportDcPlugin.zip && \
unzip ReportDcPlugin.zip -d addons/counterstrikesharp/plugins/ && \
rm ReportDcPlugin.zip && \
#Admin ESP plugin  
curl -L https://github.com/kgarri/bg-koka-cs2-xray-esp/releases/download/v1.0.2//AdminESP.tar.gz --output ESP.tar.gz && \
tar -xzvf ESP.tar.gz -C addons/counterstrikesharp/plugins/ && \
rm ESP.tar.gz


ENTRYPOINT ["bash", "/home/steam/setup.sh"]

