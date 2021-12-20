# Tidal Connect Docker image for HifiBerry (and RaspbianOS)

![hifiberry_sources](img/hifiberry_listsources.png?raw=true)


Image based on https://github.com/shawaj/ifi-tidal-release and https://github.com/seniorgod/ifi-tidal-release. 
Please visit https://www.raspberrypi.org/forums/viewtopic.php?t=297771 for full information on the backround of this project.

# Why this Docker Port

I have been happily using HifiberryOS but being an extremely slim OS (based on Buildroot) has its pitfalls, that there is no easy way of extending its current features. Thankfully the Hifiberry Team have blessed us by providing Docker and Docker-Compose within OS.
As I didn't want to add yet another system for Tidal integration (e.g. Bluesound, Volumio), i stumbled upon this https://support.hifiberry.com/hc/en-us/community/posts/360013667717-Tidal-Connect-, and i decided to do something about it. 

This port does much more than just providing the docker image with TIDAL Connect and volume control, as for HifiBerry users it will also install additional sources meny as displayed above.
Volume controls are reflected in the UI.

# Installation

1. SSH into your Raspberry and clone/copy this repository onto your system. 
```
# On HifiberryOS
cd /data && \
  git clone https://github.com/TonyTromp/tidal-connect-docker.git && \
  cd tidal-connect-docker
```

2. Install and run

```
# On HifiBerryOS
./install.sh
```


Other PiOS (e.g. Raspbian), you can find the docker-compose scripts in the Docker folder.

ENJOY ! ;)

This will download the Docker image from github and install and start TIDAL Connect as a service.
In addition it will also add a new UI Source to HifiBerry called TIDAL Connect which you can use to start/stop the service

## Usage
```
./install.sh installs TIDAL Connect on your Raspberry Pi.

Usage: 

  [FRIENDLY_NAME=<FRIENDLY_NAME>] \
  [MODEL_NAME=<MODEL_NAME> ] \
  [BEOCREATE_SYMLINK_FOLDER=<BEOCREATE_SYMLINK_FOLDER> ] \
  [AUDIOCONTROL2_SYMLINK_MODUL=<AUDIOCONTROL2_SYMLINK_MODUL> ] \
  [DOCKER_DNS=<DOCKER_DNS> ] \
  ./install.sh \
    [-f <FRIENDLY_NAME>] \
    [-m <MODEL_NAME>] \
    [-b <BEOCREATE_SYMLINK_FOLDER>] \
    [-a <AUDIOCONTROL2_SYMLINK_MODUL>] \
    [-d <DOCKER_DNS>] \
    [-i <Docker Image>] \
    [-p <build|pull>]

Defaults:
  FRIENDLY_NAME:            hifiberry
  MODEL_NAME:               hifiberry
  BEOCREATE_SYMLINK_FOLDER: /opt/beocreate/beo-extensions/tidal
  AUDIOCONTROL2_SYMLINK_MODUL: /opt/audiocontrol2/ac2/players/tidal.py
  DOCKER_DNS:               8.8.8.8
  DOCKER_IMAGE:             edgecrush3r/tidal-connect:latest
  BUILD_OR_PULL:            pull

Example: 
  BUILD_OR_PULL=build \
  DOCKER_IMAGE=tidal-connect:latest \
  ./install.sh

Running environment: 
  FRIENDLY_NAME:            hifiberry
  MODEL_NAME:               hifiberry
  BEOCREATE_SYMLINK_FOLDER: /opt/beocreate/beo-extensions/tidal
  AUDIOCONTROL2_SYMLINK_MODUL: /opt/audiocontrol2/ac2/players/tidal.py
  DOCKER_DNS:               8.8.8.8
  DOCKER_IMAGE:             tidal-connect:latest
  BUILD_OR_PULL:            build
  PWD:                      /root

Please note that command line arguments 
take precedence over environment variables,
which take precedence over defaults.
```

## Example Run 1
This is an example from a Raspberry Pi that was configured with the hostname `hifipi1`.

```
# ./install.sh 
Running environment: 
  FRIENDLY_NAME:            hifipi1
  MODEL_NAME:               hifipi1
  BEOCREATE_SYMLINK_FOLDER: /opt/beocreate/beo-extensions/tidal
  AUDIOCONTROL2_SYMLINK_MODUL: /opt/audiocontrol2/ac2/players/tidal.py
  DOCKER_DNS:               8.8.8.8
  DOCKER_IMAGE:             edgecrush3r/tidal-connect:latest
  BUILD_OR_PULL:            pull
  PWD:                      /data/tidal-connect-docker

Wed Oct 20 21:48:11 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Pre-flight checks.
Wed Oct 20 21:48:11 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Checking to see if Docker is running.
Wed Oct 20 21:48:11 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Confirmed that Docker daemon is running.
Wed Oct 20 21:48:11 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Checking to see if Docker image edgecrush3r/tidal-connect:latest exists.
Wed Oct 20 21:48:11 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Docker image edgecrush3r/tidal-connect:latest does not exist on local machine.
Wed Oct 20 21:48:11 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Pulling docker image edgecrush3r/tidal-connect:latest.
latest: Pulling from edgecrush3r/tidal-connect
31994f9482cd: Already exists 
b7df42230716: Pull complete 
ff3b3b30d785: Pull complete 
c59fa572c696: Pull complete 
c25866291a97: Pull complete 
06d8c178ae9c: Pull complete 
e3a1435f71e6: Pull complete 
0503bcd05c0a: Pull complete 
10cba31442a1: Pull complete 
451f209d8450: Pull complete 
a670b60306b7: Pull complete 
4f99276c4db5: Pull complete 
050764b3bf72: Pull complete 
ac5e5d854f89: Pull complete 
cfeac5365a22: Pull complete 
7644a931eb75: Pull complete 
9c0257db74bb: Pull complete 
4b687a78d94f: Pull complete 
Digest: sha256:715cc0f52fe1b4f305796a016eeddac84d5a9da02b6f512a955a8a23356112fc
Status: Downloaded newer image for edgecrush3r/tidal-connect:latest
docker.io/edgecrush3r/tidal-connect:latest
Wed Oct 20 21:50:04 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Finished pulling docker image edgecrush3r/tidal-connect:latest.
Wed Oct 20 21:50:04 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Creating .env file.
Wed Oct 20 21:50:04 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Finished creating .env file.
Wed Oct 20 21:50:04 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Generating docker-compose.yml.
Wed Oct 20 21:50:04 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Finished generating docker-compose.yml.
Wed Oct 20 21:50:04 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Enabling TIDAL Connect Service.
Wed Oct 20 21:50:05 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Finished enabling TIDAL Connect Service.
Wed Oct 20 21:50:05 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Adding TIDAL Connect Source to Beocreate.
Tidal extension found, removing previous install...
Adding Tidal Source to Beocreate UI.
Wed Oct 20 21:50:05 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Finished adding TIDAL Connect Source to Beocreate.
Wed Oct 20 21:50:05 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Installation Completed.
Wed Oct 20 21:50:06 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Starting TIDAL Connect Service.

Starting TIDAL Connect Service...
Wed Oct 20 21:50:12 EDT 2021 hifipi1 install.sh[20785]: [INFO]: Restarting Beocreate 2 Service.
Stopping Beocreate 2 Server
Starting Beocreate 2 Server
Done.
```

## Example Run 2

This is an example where we specified to `install.sh` that it should build the image and overrode the default image name.

```
#   BUILD_OR_PULL=build \
>   DOCKER_IMAGE=tidal-connect:latest \
>   ./install.sh
Running environment: 
  FRIENDLY_NAME:            hifipi1
  MODEL_NAME:               hifipi1
  BEOCREATE_SYMLINK_FOLDER: /opt/beocreate/beo-extensions/tidal
  AUDIOCONTROL2_SYMLINK_MODUL: /opt/audiocontrol2/ac2/players/tidal.py
  DOCKER_DNS:               8.8.8.8
  DOCKER_IMAGE:             tidal-connect:latest
  BUILD_OR_PULL:            build
  PWD:                      /data/tidal-connect-docker

Wed Oct 20 21:53:09 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Pre-flight checks.
Wed Oct 20 21:53:09 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Checking to see if Docker is running.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Confirmed that Docker daemon is running.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Checking to see if Docker image tidal-connect:latest exists.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Docker image tidal-connect:latest exist on the local machine.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Creating .env file.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Finished creating .env file.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Generating docker-compose.yml.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Finished generating docker-compose.yml.
Wed Oct 20 21:53:10 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Enabling TIDAL Connect Service.
Wed Oct 20 21:53:11 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Finished enabling TIDAL Connect Service.
Wed Oct 20 21:53:11 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Adding TIDAL Connect Source to Beocreate.
Tidal extension found, removing previous install...
Adding Tidal Source to Beocreate UI.
Wed Oct 20 21:53:11 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Finished adding TIDAL Connect Source to Beocreate.
Wed Oct 20 21:53:11 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Installation Completed.
Wed Oct 20 21:53:11 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Starting TIDAL Connect Service.

Starting TIDAL Connect Service...
Wed Oct 20 21:53:17 EDT 2021 hifipi1 install.sh[21309]: [INFO]: Restarting Beocreate 2 Service.
Stopping Beocreate 2 Server
Starting Beocreate 2 Server
Done.
```

3. Start/Stopping

You can either start or stop the TIDAL Service via the HifiBerryOS Sources menu or via command-line.
If you would rather use command line, you might find these scripts handy.

![hifiberry_startstop](img/hifiberry_tidalcontrol.png?raw=true)

```
./start-tidal-service.sh
./stop-tidal-service.sh
```

You may also use the systemd scripts:
```
systemctl stop tidal.service
systemctl start tidal.service
```

4. Troubleshooting

* NO VOLUME *
Please check your volume setting on your device and use your device to increase the volume. 
If setup/dac is recognized it you will see volume changes also updating in the HifiBerry Audio Controls.

* DAC NOT RECOGNIZED / NOT PLAYING *
There are known issues whereas playback is not working, as the DAC is not recognized.
You can check the logs from the Docker image by running:
```
docker logs docker_tidal-connect_1
```
This will list some debug information useful for trouble shooting.
You can explicitly set the DAC playback device in the Docker/entrypoint.sh file.

For 'HifiBerry Digi+ Pro', if it doesn't work out-of-the-box, you will need to edit the Docker/entrypoint.sh and use
 "snd_rpi_hifiberry_digi: HiFiBerry Digi+ Pro HiFi wm8804-spdif-0 (hw:0,0)" as default playback device (like below).
```
/app/ifi-tidal-release/bin/tidal_connect_application \
   --tc-certificate-path "/app/ifi-tidal-release/id_certificate/IfiAudio_ZenStream.dat" \
   -f "HiFiBerry" \
   --playback-device "snd_rpi_hifiberry_digi: HiFiBerry Digi+ Pro HiFi wm8804-spdif-0 (hw:0,0)" \
   --codec-mpegh true \
   --codec-mqa false \
   --model-name "HiFiBerry" \
   --disable-app-security false \
   --disable-web-security false \
   --enable-mqa-passthrough false \
   --log-level 3 \
   --enable-websocket-log "0" \
```

Note you can list/print your device/DAC name by running the following command
```
docker run -ti \
--device /dev/snd \
-v /var/run/dbus:/var/run/dbus \
-v /var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket \
--entrypoint /app/ifi-tidal-release/bin/ifi-pa-devs-get edgecrush3r/tidal-connect
```

Edit the entryfile.sh and set the playback-device accordingly should solve your issue.

# *** Other Stuff *** #

Build the docker image (OPTIONAL!):

NOTE: I have already uploaded a pre-built docker image to Docker Hub for you.
This means you can skip this time consuming step to build the image manually, and use the pre-built image unless you need to add something to the base image.
However for those who like to thinker, you can add other things to the docker image if you would like to.
```
# Go to the <tidal-connect-docker>/Docker path
cd tidal-connect-docker-master/Docker

# Build the image
./build_docker.sh
```

* Fiddle with Audio Controls and Song Info scraping *

Check out the 'cmd' folder for a bunch of cool bash scripts to control your music (hence you can use to control via Alexa/Google etc).
To scrape song info you can try
```
python scraper.py
```
This will give you all song info in JSON format.

# Tweaking and tuning configuration
If you need to alter any parameters, just change the entrypoint.sh to contain whatever settings you need
The entrypoint.sh file/command is executed upon start of the container and mounted via docker-compose.

