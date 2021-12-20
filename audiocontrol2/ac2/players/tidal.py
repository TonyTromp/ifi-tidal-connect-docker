import json
import subprocess
import logging
import io

from ac2.helpers import map_attributes
from ac2.players import PlayerControl
from ac2.constants import CMD_NEXT, CMD_PREV, CMD_PLAYPAUSE, \
    STATE_PAUSED, STATE_PLAYING, STATE_STOPPED, STATE_UNDEF
from ac2.metadata import Metadata

TIDAL_PLAYERNAME    = "tidal"
TIDAL_STATE_PLAYING = "PLAYING"
TIDAL_STATE_PAUSED  = "PAUSED"
TIDAL_STATE_STOPPED = "IDLE"
TIDAL_STATE_UNDEF   = "" # scraper.py crashes, when container is not running
TIDAL_CMD_NEXT      = '/data/tidal-connect-docker/cmd/next-song',
TIDAL_CMD_PREV      = '/data/tidal-connect-docker/cmd/previous-song',
TIDAL_CMD_PLAYPAUSE = '/data/tidal-connect-docker/cmd/volume-play-pause'

STATE_MAP = {
  TIDAL_STATE_PLAYING: STATE_PLAYING,
  TIDAL_STATE_PAUSED : STATE_PAUSED,
  TIDAL_STATE_STOPPED: STATE_STOPPED,
}

class TidalControl(PlayerControl):
  def __init__(self, args={}):
    self.client = None
    self.playername = TIDAL_PLAYERNAME
    self.metadata = Metadata()
    self.state = STATE_STOPPED
    self.update()

  def start(self):
    pass

  def get_supported_commands(self):
    return [CMD_NEXT, CMD_PREV, CMD_PLAYPAUSE]

  def update(self):
    cmd = "/data/tidal-connect-docker/cmd/scraper.py"

    out = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    out = out.communicate()[0]
    out = out.replace(b"'", b'"')

    try:
      data = json.load(io.BytesIO(out))
    except:
      logging.warning("Can't load %s", out)
      data = ""

    #logging.info(data)

    try:
      self.state = STATE_MAP[data["playback_state"]]
    except:
      self.state = STATE_UNDEF

    #logging.info("State = %s", data["playback_state"])

    md  = Metadata()
    if self.state in [STATE_PLAYING,STATE_PAUSED]:
      md.playerName  = data["app_name"]
      md.playerState = data["playback_state"]
      md.artist      = data["artists"]
      md.title       = data["title"]
      md.albumTitle  = data["album_name"]
      #md.artUrl      = "XXX"
      self.metadata = md

    #logging.info("Metadata = %s", md)

  def get_state(self):
    self.update()
    return self.state

  def get_meta(self):
    self.update()
    return self.metadata

  def send_command(self,command, parameters={}):
    if command not in self.get_supported_commands():
      return False

    if self.state not in [STATE_UNDEF]:
      if command == CMD_NEXT:
        subprocess.check_output(CMD_NEXT.split())
      elif command == CMD_PREV:
        subprocess.check_output(CMD_PREV.split())
      elif command == CMD_PLAYPAUSE:
        subprocess.check_output(CMD_PLAYPAUSE.split())
      else:
        logging.warning("Command %s not implemented", command)
