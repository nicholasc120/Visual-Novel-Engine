class Music {
  Minim minim;
  AudioPlayer music;
  String musicPath;

  Music(Minim minim) {
    this.minim = minim;
  }

  int setMusic(String[] script, int count) {
    //********MUSIC********//
    if (script[count].startsWith("MUSIC: ") ) {
      controlMusic(script[count].replace("MUSIC: ", ""));
      count++;
    }
    return count;
  }

  void controlMusic(String command) {

    if (command.equals("STOP")) {
      music.mute();
    } 

    /*else if (command.equals("FADE")) {
     music.setVolume(music.getVolume() - 0.01);
     }
     */
    else {
      musicPath = "Music\\" + script[count].replace("MUSIC: ", "") +".mp3";
      music = minim.loadFile(musicPath, 5000);
      music.loop();
    }
  }
}