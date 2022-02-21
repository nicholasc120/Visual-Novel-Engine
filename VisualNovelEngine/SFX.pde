class SFX extends Music {

  SFX(Minim minim) {
    super(minim);
  }

  //override parent to play sfx instead of looping
  void setMusic(String command) {
    switch(command) {
    case "STOP":
      music.mute();
      break;
    default:
      String sfxPath = "SFX\\" + command +".mp3";
      music = minim.loadFile(dataPath(sfxPath), 5000);
      music.play(0);
    }
  }
}
