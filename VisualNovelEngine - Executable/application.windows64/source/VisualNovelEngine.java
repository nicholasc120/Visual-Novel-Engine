import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class VisualNovelEngine extends PApplet {





String[] script, settings;
int count = 0;
Music BGM;

public void setup() {
  
  Minim minim = new Minim(this);
  BGM = new Music(minim);

  try {
    Scanner sc = new Scanner(new File(dataPath("script.txt")));
    String scriptString = "";
    while (sc.hasNext()) {
      scriptString+= sc.nextLine() + "\n";
    }
    sc.close();
    script = scriptString.split("\n");

    Scanner scc = new Scanner(new File(dataPath("settings.txt")));
    String settingsString = "";
    while (scc.hasNext()) {
      settingsString+= scc.nextLine() + "\n";
    }
    scc.close();
    settings = settingsString.split("\n");
  } 
  catch(IOException e) {
    println(e);
  }

  initializeSettings(settings);
  //  wipe = loadImage("Effects\\wipe.png");
}


String bgString, BGMString;
PImage bg;//, wipe;
public void draw() {

  count = BGM.setMusic(script, count);
  setBackground();
  setAesthetics();
}

public void setBackground() {
  //*****Background******//
  background(200);
  if (bgString != null) {
    bg = loadImage(bgString);
    image(bg, 0, 0);
  }
  textSize(40);
  if (script[count].startsWith("SCENE: ")) {
    bgString = "Backgrounds\\" + script[count].replace("SCENE: ", "") +".png";
    speakerImagePath = null;
    count++;
  }
}

String speakerImagePath;

public void setAesthetics() {
  //*******Speaker********//
  if (checkIllegalName()) {
    speakerImagePath = Actor.getCharacterImagePath(script[count]);
  }
  //println(path);
  if (speakerImagePath != null) {
    image(loadImage(dataPath(speakerImagePath)), 100, -50);
  }
  if (script[count].startsWith("LEAVE: ")) {
    speakerImagePath = null;
    count++;
  }
  //*******Text Box*******//
  strokeWeight(8); 
  fill(255, 192, 203, 200);
  rect(0, 3 * height/4, width, height/4, 10);  
  //*****Speaker Box******//
  rect(0, (3 * height/4) - height/12, width/5, height/12, 10);
  //********Text**********//
  String speaker = Actor.getCharacterName(script[count]);
  String text = script[count].substring(script[count].indexOf(":") + 2, script[count].length());

  fill(0);
  if (script[count].startsWith("CHOICE: ")) {
    speaker = settings[0];
    text = setChoiceText(script[count]);
    makingAChoice = true;
  }
  if (script[count].startsWith(choiceMade + ": ")) {
    speaker = Actor.getCharacterName(script[count].replace(choiceMade + ": ", ""));
    String temp = script[count].replace(choiceMade + ": ", "");
    text = temp.substring(temp.indexOf(":") +2, temp.length());
  }

  //*********Text in the Text Box************//
  if (text.length() > 40) {
    int i  = 40;
    while (text.charAt(i) != ' ') {
      if (i+1 < text.length()) {
        i++;
      } else {
        i = 30;
      }
    }
    String part1 = text.substring(0, i);
    String part2 = text.substring(i + 1, text.length());
    text = part1 + "\n" + part2;
  }
  if (!speaker.equals("MUSIC") && !speaker.equals("SCENE") && !speaker.contains("LEAVE")) {
    text(speaker, 5, (3 * height/4)- height/48);
    text(text, 10, 3 * height/4 +height/72 * 5);
  }
}

boolean makingAChoice = false;
int choiceMade = -1;

public void keyPressed() {
  if ('0' <= key && key <= '9') {
    choiceMade = key - '0';
    for (int i= count; i< script.length; i++) {
      if (script[i].startsWith(choiceMade + ": ")) {
        count = i;
        makingAChoice = false;
        break;
      }
    }
  }
}

public void mouseClicked() {
  if (count != script.length - 1 && !makingAChoice && choiceMade == -1) {
    count++;
  }
  if (count != script.length - 1 && !makingAChoice && choiceMade != -1) {
    if (script[count+1].startsWith(choiceMade + ": ")) {
      count++;
    } else {

      for (int i= count; i< script.length; i++) {
        if (!Character.isDigit(script[i].charAt(0))) {
          count = i;
          choiceMade = -1;
          break;
        }
      }
    }
  }
}


public void initializeSettings(String[] settings) {
  settings[0] = settings[0].replace("MC: ", ""); 
  settings[1] = settings[1].replace("Save: ", ""); 
  settings[2] = settings[2].replace("Leave: ", "");
  settings[3] = settings[3].replace("Auto: ", "");
  settings[4] = settings[4].replace("Skip: ", "");
}


public String setChoiceText(String choiceString) {
  String returnString = "What should I do? ";

  String[] choices = choiceString.replace("CHOICE: ", "").split(", ");
  for (int i = 0; i < choices.length; i++) {
    if (i == 0) {
      returnString +="1: " + choices[0];
    } else if (i == choices.length - 1) {
      returnString += " or " + (i + 1) + ": " + choices[i] + "?";
    } else {
      returnString += ", " +(i+1) + ": "+choices[i];
    }
  }
  return returnString;
}


public boolean checkIllegalName() {
  return !Actor.getCharacterName(script[count]).equals(settings[0]) && !Actor.getCharacterName(script[count]).equals("MUSIC") && !Actor.getCharacterName(script[count]).equals("SCENE") && !Actor.getCharacterName(script[count]).equals("LEAVE") 
    && !Actor.getCharacterName(script[count]).equals("CHOICE") && (!Character.isDigit(script[count].charAt(0)) && script[count].charAt(1) != ':');
}

static class Actor {

  public static String getCharacterImagePath(String line) {
    String emotion = checkEmotion(line);
    String name = getCharacterName(line);
    //println(emotion);
    if (emotion.equals("NEUTRAL")) {
      emotion = "";
      return  "Characters\\" + name + ".png";
    }
    if (emotion.equals("NONE")) {
      return null;
    }
    return  "Characters\\" + name + " - " + emotion + ".png";
  }

  public static String getCharacterName(String line) {
    String returnString = line.substring(0, line.indexOf(":"));
    if (returnString.contains("[") && returnString.contains("]")) {
      returnString= returnString.substring(0, returnString.indexOf("["));
    }

    return returnString;
  }

  public static String checkEmotion(String line) {
    String returnString = line;
    if (returnString.contains("[") && returnString.contains("]")) {
      String emotion = returnString.substring(returnString.indexOf("[") + 1, returnString.indexOf("]"));
      return emotion;
    }
    return "NEUTRAL";
  }
}
class Music {
  Minim minim;
  AudioPlayer music;
  String musicPath;

  Music(Minim minim) {
    this.minim = minim;
  }

  public int setMusic(String[] script, int count) {
    //********MUSIC********//
    if (script[count].startsWith("MUSIC: ") ) {
      controlMusic(script[count].replace("MUSIC: ", ""));
      count++;
    }
    return count;
  }

  public void controlMusic(String command) {

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
  public void settings() {  size(1280, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "VisualNovelEngine" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
