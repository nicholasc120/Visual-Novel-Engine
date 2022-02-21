import java.io.FileInputStream;

class Music {
  Minim minim;
  AudioPlayer music;
  String musicName = "";

  Music(Minim minim) {
    this.minim = minim;
  }

  // If it's the STOP command, stop the music
  // If it's anything else, it must be a song
  void setMusic(String command) {
    switch(command) {
    case "STOP":
      musicName = "";
      if (music == null) {
        break;
      }
      music.mute();
      break;
    default:
      musicName = command;
      String musicPath = "Music\\" + command +".mp3";
      music = minim.loadFile(musicPath, 5000);
      music.loop();
    }
  }
}
