#!/bin/bash

log() {
  script=$(basename "$0")
  echo "$(/bin/date) ${HOSTNAME} ${script}[$$]: [$1]: $2"
}

running_environment()
{
  echo "Running environment: "
  echo "  FRIENDLY_NAME:            ${FRIENDLY_NAME}"
  echo "  MODEL_NAME:               ${MODEL_NAME}"
  echo "  BEOCREATE_SYMLINK_FOLDER: ${BEOCREATE_SYMLINK_FOLDER}"
  echo "  AUDIOCONTROL2_SYMLINK_MODUL: ${AUDIOCONTROL2_SYMLINK_MODUL}"
  echo "  DOCKER_DNS:               ${DOCKER_DNS}"
  echo "  DOCKER_IMAGE:             ${DOCKER_IMAGE}"
  echo "  BUILD_OR_PULL:            ${BUILD_OR_PULL}"
  echo "  MQA_PASSTHROUGH:          ${MQA_PASSTHROUGH}"
  echo "  MQA_CODEC:                ${MQA_CODEC}"
  echo "  PWD:                      ${PWD}"
  echo ""
}

usage()
{
  echo "$0 installs TIDAL Connect on your Raspberry Pi."
  echo ""
  echo "Usage: "
  echo ""
  echo "  [FRIENDLY_NAME=<FRIENDLY_NAME>] \\"
  echo "  [MODEL_NAME=<MODEL_NAME>] \\"
  echo "  [BEOCREATE_SYMLINK_FOLDER=<BEOCREATE_SYMLINK_FOLDER>] \\"
  echo "  [AUDIOCONTROL2_SYMLINK_MODUL=<AUDIOCONTROL2_SYMLINK_MODUL>] \\"
  echo "  [DOCKER_DNS=<DOCKER_DNS>] \\"
  echo "  [DOCKER_IMAGE=<DOCKER_IMAGE>] \\"
  echo "  [BUILD_OR_PULL=<build|pull>] \\"
  echo "  [MQA_PASSTHROUGH=<true|false>] \\"
  echo "  [MQA_CODEC=<true|false>] \\"
  echo "  $0 \\"
  echo "    [-f <FRIENDLY_NAME>] \\"
  echo "    [-m <MODEL_NAME>] \\"
  echo "    [-b <BEOCREATE_SYMLINK_FOLDER>] \\"
  echo "    [-a <AUDIOCONTROL2_SYMLINK_MODUL>] \\"
  echo "    [-d <DOCKER_DNS>] \\"
  echo "    [-i <Docker Image>] \\"
  echo "    [-p <build|pull>] \\"
  echo "    [-t <true|false>] \\"
  echo "    [-c <true|false>"
  echo ""
  echo "Defaults:"
  echo "  FRIENDLY_NAME:            ${FRIENDLY_NAME_DEFAULT}"
  echo "  MODEL_NAME:               ${MODEL_NAME_DEFAULT}"
  echo "  BEOCREATE_SYMLINK_FOLDER: ${BEOCREATE_SYMLINK_FOLDER_DEFAULT}"
  echo "  AUDIOCONTROL2_SYMLINK_MODUL: ${AUDIOCONTROL2_SYMLINK_MODUL_DEFAULT}"
  echo "  DOCKER_DNS:               ${DOCKER_DNS_DEFAULT}"
  echo "  DOCKER_IMAGE:             ${DOCKER_IMAGE_DEFAULT}"
  echo "  BUILD_OR_PULL:            ${BUILD_OR_PULL_DEFAULT}"
  echo "  MQA_PASSTHROUGH:          ${MQA_PASSTHROUGH_DEFAULT}"
  echo "  MQA_CODEC:                ${MQA_CODEC_DEFAULT}"
  echo ""

  echo "Example: "
  echo "  BUILD_OR_PULL=build \\"
  echo "  DOCKER_IMAGE=tidal-connect:latest \\"
  echo "  MQA_PASSTHROUGH=true \\"
  echo "  $0"
  echo ""

  running_environment

  echo "Please note that command line arguments "
  echo "take precedence over environment variables,"
  echo "which take precedence over defaults."
  echo ""
}

# define defaults
FRIENDLY_NAME_DEFAULT=${HOSTNAME}
MODEL_NAME_DEFAULT=${HOSTNAME}
BEOCREATE_SYMLINK_FOLDER_DEFAULT="/opt/beocreate/beo-extensions/tidal"
AUDIOCONTROL2_SYMLINK_MODUL_DEFAULT="/opt/audiocontrol2/ac2/players/tidal.py"
DOCKER_DNS_DEFAULT="8.8.8.8"
DOCKER_IMAGE_DEFAULT="edgecrush3r/tidal-connect:latest"
BUILD_OR_PULL_DEFAULT="pull"
MQA_PASSTHROUGH_DEFAULT="false"
MQA_CODEC_DEFAULT="false"

# override defaults with environment variables, if they have been set
FRIENDLY_NAME=${FRIENDLY_NAME:-${FRIENDLY_NAME_DEFAULT}}
MODEL_NAME=${MODEL_NAME:-${MODEL_NAME_DEFAULT}}
BEOCREATE_SYMLINK_FOLDER=${BEOCREATE_SYMLINK_FOLDER:-${BEOCREATE_SYMLINK_FOLDER_DEFAULT}}
AUDIOCONTROL2_SYMLINK_MODUL=${AUDIOCONTROL2_SYMLINK_MODUL:-${AUDIOCONTROL2_SYMLINK_MODUL_DEFAULT}}
DOCKER_DNS=${DOCKER_DNS:-${DOCKER_DNS_DEFAULT}}
DOCKER_IMAGE=${DOCKER_IMAGE:-${DOCKER_IMAGE_DEFAULT}}
BUILD_OR_PULL=${BUILD_OR_PULL:-${BUILD_OR_PULL_DEFAULT}}
MQA_PASSTHROUGH=${MQA_PASSTHROUGH:-${MQA_PASSTHROUGH_DEFAULT}}
MQA_CODEC=${MQA_CODEC:-${MQA_CODEC_DEFAULT}}

HELP=${HELP:-0}
VERBOSE=${VERBOSE:-0}

# override with command line parameters, if defined
while getopts "hvf:m:b:d:i:p:t:c:" option
do
  case ${option} in
    f)
      FRIENDLY_NAME=${OPTARG}
      ;;
    m)
      MODEL_NAME=${OPTARG}
      ;;
    b)
      BEOCREATE_SYMLINK_FOLDER=${OPTARG}
      ;;
    a)
      AUDIOCONTROL2_SYMLINK_MODUL=${OPTARG}
      ;;
    d)
      DOCKER_DNS=${OPTARG}
      ;;
    i)
      DOCKER_IMAGE=${OPTARG}
      ;;
    p)
      BUILD_OR_PULL=${OPTARG}
      ;;
    t)
      MQA_PASSTHROUGH=${OPTARG}
      ;;
    c)
      MQA_CODEC=${OPTARG}
      ;;
    v)
      VERBOSE=1
      ;;
    h)
      HELP=1
      usage
      exit 0
      ;;
  esac
done

running_environment

log INFO "Pre-flight checks."

log INFO "Checking to see if Docker is running."
docker info &> /dev/null
if [ $? -ne 0 ]
then
  log ERROR "Docker daemon isn't running."
  exit 1
else
  log INFO "Confirmed that Docker daemon is running."
fi

log INFO "Checking to see if Docker image ${DOCKER_IMAGE} exists."
docker inspect --type=image ${DOCKER_IMAGE} &> /dev/null
if [ $? -eq 0 ]
then
  log INFO "Docker image ${DOCKER_IMAGE} exist on the local machine."
  DOCKER_IMAGE_EXISTS=1
else
  log INFO "Docker image ${DOCKER_IMAGE} does not exist on local machine."
  DOCKER_IMAGE_EXISTS=0
fi

# Pull latest image or build Docker image if it doesn't already exist.
if [ ${DOCKER_IMAGE_EXISTS} -eq 0 ]
then
  if [ "${BUILD_OR_PULL}" == "pull" ]
  then
    # Pulling latest image
    log INFO "Pulling docker image ${DOCKER_IMAGE}."
    docker pull ${DOCKER_IMAGE}
    log INFO "Finished pulling docker image ${DOCKER_IMAGE}."
  elif [ "${BUILD_OR_PULL}" == "build" ]
  then
    log INFO "Building docker image."
    cd Docker && \
    DOCKER_IMAGE=${DOCKER_IMAGE} ./build_docker.sh && \
    cd ..
    log INFO "Finished building docker image."
  else
    log ERROR "BUILD_OR_PULL must be set to \"build\" or \"pull\""
    usage
    exit 1
  fi

  docker inspect --type=image ${DOCKER_IMAGE} &> /dev/null
  if [ $? -ne 0 ]
  then
    log ERROR "Docker image ${DOCKER_IMAGE} does not exist on the local machine even after we tried ${BUILD_OR_PULL}ing it."
    log ERROR "Exiting."
    exit 1
  fi
fi

log INFO "Creating .env file."
ENV_FILE="Docker/.env"
> ${ENV_FILE}
echo "FRIENDLY_NAME=${FRIENDLY_NAME}" >> ${ENV_FILE}
echo "MODEL_NAME=${MODEL_NAME}" >> ${ENV_FILE}
echo "MQA_PASSTHROUGH=${MQA_PASSTHROUGH}" >> ${ENV_FILE}
echo "MQA_CODEC=${MQA_CODEC}" >> ${ENV_FILE}
log INFO "Finished creating .env file."

# Generate docker-compose.yml
log INFO "Generating docker-compose.yml."
eval "echo \"$(cat templates/docker-compose.yml.tpl)\"" > Docker/docker-compose.yml
log INFO "Finished generating docker-compose.yml."

# Enable service
log INFO  "Enabling TIDAL Connect Service."
#cp systemd/tidal.service /etc/systemd/system/
eval "echo \"$(cat templates/tidal.service.tpl)\"" >/etc/systemd/system/tidal.service

systemctl enable tidal.service

log INFO "Finished enabling TIDAL Connect Service."

# Add TIDAL Connect Source to Beocreate
log INFO "Adding TIDAL Connect Source to Beocreate."
if [ -L "${BEOCREATE_SYMLINK_FOLDER}" ]; then
  # Already installed... remove symlink and re-install
  log INFO "TIDAL Connect extension found, removing previous install."
  rm ${BEOCREATE_SYMLINK_FOLDER}
fi

echo  "Adding TIDAL Connect Source to Beocreate UI."
ln -s ${PWD}/beocreate/beo-extensions/tidal ${BEOCREATE_SYMLINK_FOLDER}
log INFO "Finished adding TIDAL Connect Source to Beocreate."

# Add TIDAL to Audiocontrol
echo "Adding TIDAL to Audiocontrol2."
if [ -L "${AUDIOCONTROL2_SYMLINK_MODUL}" ]; then
  # Already installed... remove symlink and re-install
  log INFO "TIDAL Connect extension (audiocontrol2) found, removing previous install."
  rm ${AUDIOCONTROL2_SYMLINK_MODUL}
fi
sed -i 's@from ac2.players.mpdcontrol import MPDControl@from ac2.players.tidal import TidalControl\nfrom ac2.players.mpdcontrol import MPDControl@' /opt/audiocontrol2/audiocontrol2.py
sed -i 's@# Native MPD backend and metadata processor@if "tidal" in config.sections():\n        tidal = TidalControl()\n        mpris.register_nonmpris_player("tidal",tidal)\n        logging.info("registered non-MPRIS tidal backend")\n    # Native MPD backend and metadata processor@' \
  /opt/audiocontrol2/audiocontrol2.py
echo '[tidal]' >> /etc/audiocontrol2.conf
ln -s ${PWD}/audiocontrol2/ac2/players/tidal.py ${AUDIOCONTROL2_SYMLINK_MODUL}
log INFO "Finished adding TIDAL Connect to Audiocontrol2."

log INFO "Installation Completed."

if [ "$(docker ps -q -f name=docker_tidal-connect)" ]; then
  log INFO "Stopping TIDAL Connect Service."
  ./stop-tidal-service.sh
fi

log INFO "Starting TIDAL Connect Service."
./start-tidal-service.sh

log INFO "Restarting Beocreate 2 Service."
./restart_beocreate2.sh

log INFO "Restarting audiocontrol2 Service."
systemctl restart audiocontrol2.service

log INFO "Finished, exiting."
