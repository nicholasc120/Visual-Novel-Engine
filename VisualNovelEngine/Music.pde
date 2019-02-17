class Music {
  Minim minim;
  AudioPlayer music;
  String musicPath;
  boolean fading = false;
  
  Music(Minim minim) {
    this.minim = minim;
  }

  int setMusic(String[] script, int count) {
    //********MUSIC********//
    if (script[count].startsWith("MUSIC: ") ) {
      controlMusic(script[count].replace("MUSIC: ", ""));
      count++;
    }
    if (fading) {
      fade();
    }
    return count;
  }

  void controlMusic(String command) {

    if (command.equals("STOP")) {
      music.mute();
    } else if (command.equals("FADE")) {
      fading = true;
    } else {
      musicPath = "Music\\" + script[count].replace("MUSIC: ", "") +".mp3";
      if (music != null &&  music.isPlaying() ) {
        music.pause();
      }
      music = minim.loadFile(musicPath, 5000);
      fading = false;
      music.loop();
    }
  }

  void fade() {
    if (music.hasControl(Controller.VOLUME)) {
      music.setVolume(music.getVolume() - 0.01);
      if (music.getVolume() == 0) {
        fading = false;
      }
    } else {
      music.setGain(music.getGain() - 2.5); 
      //println(music.getGain());
      if (music.getGain() == -80) {
        fading = false;
      }
    }
  }
}