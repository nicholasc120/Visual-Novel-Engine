import java.util.*;
import ddf.minim.*;


String[] script, settings;
int count = 0;
Music BGM;

void setup() {
  size(1280, 720);
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
  frameRate(60);
  textSize(40);
}


String bgString, BGMString;
PImage bg;//, wipe;
int clickBuffer = 0;


void draw() {
  //auto();
  clickBuffer++;
  count = BGM.setMusic(script, count);
  setBackground();
  setAesthetics();
//  println(clickBuffer);
//   println(frameRate);
}
/*
void auto(){
 if(auto && !makingAChoice){
  count++; 
 }
}
*/
void setBackground() {
  //*****Background******//
  background(200);
  if (bgString != null) {
    bg = loadImage(bgString);
    image(bg, 0, 0);
  }
  
  if (script[count].startsWith("SCENE: ")) {
    bgString = "Backgrounds\\" + script[count].replace("SCENE: ", "") +".png";
    speakerImagePath = null;
    count++;
  }
}

String speakerImagePath;
color textBoxColor;

void setAesthetics() {
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
  fill(textBoxColor);
  rect(0, 3 * height/4, width, height/4, 10);  
  //*****Speaker Box******//
  rect(0, (3 * height/4) - height/12, width/5, height/12, 10);
  //********Text**********//]);
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

boolean makingAChoice = false, auto = false;
int choiceMade = -1;

void keyPressed() {
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
  
  if(key == settings[3].charAt(0)){
    auto= !auto;
  }
  
  
}

void mouseReleased() {
  if (clickBuffer > 2) {
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
    clickBuffer = 0;
  }
}


void initializeSettings(String[] settings) {
  settings[0] = settings[0].replace("MC: ", ""); 
  settings[1] = settings[1].replace("Save: ", ""); 
  settings[2] = settings[2].replace("Leave: ", "");
  settings[3] = settings[3].replace("Auto: ", "");
  settings[4] = settings[4].replace("TextBoxColor: ", "");
  switch(settings[4]){
    case "Blue":
      textBoxColor = color(80, 188, 255, 200);
      break;
    case "Pink":
      textBoxColor = color(255, 192, 203, 200);
      break;
  }
}


String setChoiceText(String choiceString) {
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


boolean checkIllegalName() {
  return !Actor.getCharacterName(script[count]).equals(settings[0]) && !Actor.getCharacterName(script[count]).equals("MUSIC") 
    && !Actor.getCharacterName(script[count]).equals("SCENE") && !Actor.getCharacterName(script[count]).equals("LEAVE") 
    && !Actor.getCharacterName(script[count]).equals("CHOICE") && (!Character.isDigit(script[count].charAt(0)) && script[count].charAt(1) != ':');
}
