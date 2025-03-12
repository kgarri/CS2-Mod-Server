#Get Base image from the existing base cs2 image
FROM base-cs2-image
SHELL ["/bin/bash", "-c"]
COPY ["setup.sh", "/home/steam/"]
USER root
RUN apt update && \
apt install -y unzip unar && \
chown steam /home/steam/setup.sh && \
chmod +x /home/steam/setup.sh  

USER steam
RUN mkdir /home/steam/download && \
cd /home/steam/download && \
curl -L https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1334-linux.tar.gz --output mmsource.tar.gz && \
tar -xzvf mmsource.tar.gz && \
rm mmsource.tar.gz && \
curl -L https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v305/counterstrikesharp-with-runtime-build-305-linux-e99d27c.zip --output counter-sharp.zip && \
unzip counter-sharp.zip && \
curl -L https://github.com/aquevadis/bg-koka-cs2-xray-esp/releases/download/1.0.9/AdminESP.rar --output ESP.rar && \
unar -o addons/counterstrikesharp/plugins/ ESP.rar && \
rm ESP.rar && \
rm counter-sharp.zip

ENTRYPOINT ["bash", "/home/steam/setup.sh"]

