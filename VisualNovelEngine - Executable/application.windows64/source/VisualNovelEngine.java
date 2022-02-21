import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.io.*; 
import ddf.minim.*; 
import java.io.FileInputStream; 

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
int choiceValue = -1;
boolean gameStarted = false;
SFX sfx;
Scene scene;

public void setup() {
  
  try {
    // Read in entire script
    Scanner sc = new Scanner(new File(dataPath("script.txt")));
    String scriptString = "";
    while (sc.hasNext()) {
      scriptString+= sc.nextLine() + "\n";
    }
    sc.close();
    script = scriptString.split("\n");

    // Read in settings
    sc = new Scanner(new File(dataPath("settings.init")));
    String settingsString = "";
    while (sc.hasNext()) {
      settingsString+= sc.nextLine() + "\n";
    }
    sc.close();
    settings = settingsString.split("\n");
  } 
  catch(IOException e) {
    println(e);
  }

  scene = new Scene(new Minim(this));
  sfx = new SFX(new Minim(this));
  initializeSettings(settings);
}

public void draw() {
  if (!gameStarted) {
    drawTitleScreen();
  } else {
    parseLines(script);
    scene.drawBackground();
    scene.drawActors();
    scene.drawTextBox();
    drawSaveAndLoad();
  }
}

public void initializeSettings(String[] settings) {
  textSize(40);
  strokeWeight(8); 
  settings[0] = settings[0].replace("TextBoxColor: ", "");
  switch(settings[0]) {
  case "Blue":
    scene.textBoxColor = color(80, 188, 255, 200);
    break;
  case "Pink":
    scene.textBoxColor = color(255, 192, 203, 200);
    break;
  }

  // save settings for if there exists TitleScreenMusic
  settings[1] = settings[1].replace("TitleScreenMusic: ", "");
  // If there IS titlescreen music, play it
  if (settings[1].equals("True")) {
    scene.backgroundMusic.setMusic("TitleScreen");
  }
}

public void mouseClicked() {
  if (!gameStarted) {
    //If on title screen, check if clicked New or Continue
    if (clickedOnNew() || clickedOnContinue()) {
      gameStarted = true;
      scene.backgroundMusic.setMusic("STOP");
      if (clickedOnContinue()) {
        loadGame();
      }
      return;
    }
  }
  if (gameStarted) {
    if (clickedOnSave()) {
      saveGame();
    } else if (clickedOnLoad()) {
      loadGame();
    } else if (scene.choices.length != 0) {
      // If choice is active
      if (scene.getChoiceValue() != -1) {
        // If clicked on valid choice, save choice value and continue
        choiceValue = scene.getChoiceValue();
        count++;
      }
    } else {
      //otherwise, increase count.
      if (count+1 < script.length) {
        count++;
      }
    }
  }
}

public void drawTitleScreen() {
  // set background image
  image(loadImage(dataPath("Backgrounds\\TitleScreen.png")), 0, 0);
  // draw NEW and CONTINUE buttons at bottom
  drawNewAndContinue();
}

public void drawNewAndContinue() {
  fill(scene.textBoxColor);
  rect(3 * (width/5), (4 * height/5), width/5, height/12, 10);
  rect((width/5), (4 * height/5), width/5, height/12, 10);
  fill(0);
  text("New", (width/5) + 80, (4 * height/5) + 45);
  text("Continue", 3 * (width/5) + 40, (4 * height/5) + 45);
}

public void drawSaveAndLoad() {
  fill(scene.textBoxColor);
  rect(0, 0, width/12, height/15, 10);
  rect(width/12, 0, width/12, height/15, 10);
  fill(0);
  text("Save", 5, 40);
  text("Load", width/12 + 5, 40);
}

public boolean clickedOnNew() {
  int newMinX = (width/5);
  int newMaxX = newMinX + width/5;
  int minY = (4 * height/5);
  int maxY = (4 * height/5) + height/12;

  if (mouseY >= minY && mouseY <= maxY) {
    if (mouseX <= newMaxX && mouseX >= newMinX) {
      return true;
    }
  }
  return false;
}

public boolean clickedOnContinue() {
  int continueMinX = 3 * (width/5);
  int continueMaxX = continueMinX + width/5;
  int minY = (4 * height/5);
  int maxY = (4 * height/5) + height/12;

  if (mouseY >= minY && mouseY <= maxY) {
    if (mouseX <= continueMaxX && mouseX >= continueMinX) {
      return true;
    }
  }
  return false;
}

public boolean clickedOnSave() {
  int saveMinX = 0;
  int saveMaxX = saveMinX + width/12;
  int minY = 0;
  int maxY = height/12;
  if (mouseY >= minY && mouseY <= maxY) {
    if (mouseX <= saveMaxX && mouseX >= saveMinX) {
      return true;
    }
  }
  return false;
}

public boolean clickedOnLoad() {
  int loadMinX = width/12;
  int loadMaxX = loadMinX + width/12;
  int minY = 0;
  int maxY = height/12;
  if (mouseY >= minY && mouseY <= maxY) {
    if (mouseX <= loadMaxX && mouseX >= loadMinX) {
      return true;
    }
  }
  return false;
}

public void saveGame() {
  //save Scene object
  try {
    PrintWriter pw = new PrintWriter(new FileWriter(dataPath("save.s1")));
    pw.println("BACKGROUND: " + scene.background);
    pw.println("SONG: " + scene.backgroundMusic.musicName);
    pw.println("SPEAKER: " + scene.speaker);
    pw.println("TEXT: " + scene.text.replace("\n", " "));
    String actorsText = "";
    for (int i = 0; i < scene.actors.length; i++) {
      actorsText += scene.actors[i];
      if (i != scene.actors.length - 1) {
        actorsText += ", ";
      }
    }
    pw.println("ACTORS: " + actorsText);
    String choicesText = "";
    for (int i = 0; i < scene.choices.length; i++) {
      choicesText += scene.choices[i];
      if (i != scene.choices.length - 1) {
        choicesText += ", ";
      }
    }
    pw.println("CHOICEVALUE: " + choiceValue);
    pw.println("CHOICES: " + choicesText);
    pw.println("COUNT: " + count);
    pw.close();
  } 
  catch (IOException e) {
    print(e);
  }
}

public void loadGame() {
  //load Scene object
  scene.backgroundMusic.setMusic("STOP"); 
  scene.backgroundMusic.musicName = "";
  scene.actors = new String[0]; 
  scene.choices = new String[0]; 
  scene.text = "";
  scene.speaker = "";
  scene.background = null;

  try {
    Scanner sc = new Scanner(new File(dataPath("save.s1")));
    while (sc.hasNext()) {
      String line = sc.nextLine();
      String argument = line.substring(0, line.indexOf(": ")); 
      String value = line.replace(argument + ": ", ""); 

      if (!value.equals("null") && !value.equals("")) {
        switch(argument) {
        case "BACKGROUND": 
          scene.background = value;
          break;
        case "SONG":
          scene.backgroundMusic.setMusic(value);
          break;
        case "SPEAKER":
          scene.speaker = value;
          break;
        case "TEXT":
          scene.text = value;
          break;
        case "ACTORS":
          scene.actors = value.split(", ");
          break;
        case "CHOICEVALUE":
          choiceValue = Integer.parseInt(value);
          break;
        case "CHOICES":
          scene.choices = value.split(", ");
          break;
        case "COUNT":
          count = Integer.parseInt(value);
          break;
        }
      }
    }
    sc.close();
  } 
  catch (IOException e) {
    println(e);
  }
}

public void parseLines(String[] script) {
  String line = script[count]; 
  String argument = line.substring(0, line.indexOf(": ")); 
  // If encountered a normal line after making a decision
  if (!Character.isDigit(argument.charAt(0)) && choiceValue != -1) {
    choiceValue = -1; 
    scene.choices = new String[0];
  } else if (choiceValue == -1 || line.startsWith(Character.toString((char)(choiceValue + '0')))) {
    // If no choice has been made OR if this line is on the branch of choices
    if (line.startsWith(Character.toString((char)(choiceValue + '0')) + ": ")) {
      scene.choices = new String[0]; 
      // if this line is on a branch, get rid of the branch heading and re-parse argument
      line = line.replace(Character.toString((char)(choiceValue + '0')) + ": ", ""); 
      argument = line.substring(0, line.indexOf(": "));
    }
    String value = line.replace(argument + ": ", ""); 
    switch(argument) {
    case "SETTING" : 
      scene.background = value; 
      count++; 
      parseLines(script); 
      break; 
    case "MUSIC" : 
      scene.backgroundMusic.setMusic(value); 
      count++; 
      parseLines(script); 
      break; 
    case "SFX" : 
      sfx.setMusic(value); 
      count++; 
      parseLines(script); 
      break; 
    case "NONE" : 
      scene.actors = new String[0]; 
      count++; 
      parseLines(script); 
      break; 
    case "ONE" : 
    case "TWO" : 
    case "THREE" : 
      scene.actors = value.split(", "); 
      count++; 
      parseLines(script); 
      break; 
    case "TEXT" : 
      scene.speaker = null; 
      scene.text = value; 
      break; 
    case "CHOICE" : 
      scene.choices = value.split(", "); 
      break; 
    default : 
      //speaker
      scene.speaker = argument; 
      scene.text = value;
    }
  } else if (choiceValue != -1 && !line.startsWith(Character.toString((char)(choiceValue + '0')))) {
    // if a choice has been made and the current line is NOT on the choice's branch
    while (!line.startsWith(Character.toString((char)(choiceValue + '0'))) && Character.isDigit(line.charAt(0))) {
      // Skip lines until branches converge
      count++; 
      line = script[count];
    }
    scene.choices = new String[0];
  }
}


class Music {
  Minim minim;
  AudioPlayer music;
  String musicName = "";

  Music(Minim minim) {
    this.minim = minim;
  }

  // If it's the STOP command, stop the music
  // If it's anything else, it must be a song
  public void setMusic(String command) {
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
class SFX extends Music {

  SFX(Minim minim) {
    super(minim);
  }

  //override parent to play sfx instead of looping
  public void setMusic(String command) {
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
class Scene {
  String background;
  String [] actors;
  Music backgroundMusic;
  String speaker;
  String text;
  String [] choices;
  int textBoxColor;

  Scene(Minim minim) {
    actors = new String[0];
    choices = new String[0];
    backgroundMusic = new Music(minim);
  }

  public void drawBackground() {
    if (background != null) {
      image(loadImage(dataPath("Backgrounds\\" + background + ".png")), 0, 0);
    }
  }

  public void drawActors() {
    switch(actors.length) {
    case 1:
      image(loadImage(getActorPath(actors[0])), 100, -50);
      break;
    case 2:
      image(loadImage(getActorPath(actors[0])), -150, -50);
      image(loadImage(getActorPath(actors[1])), 450, -50);
      break;
    case 3:
    }
  }

  public String getActorPath(String actorName) {
    String returnString = actorName;
    if (returnString.contains("[") && returnString.contains("]")) {
      String emotion = returnString.substring(returnString.indexOf("[") + 1, returnString.indexOf("]"));
      returnString = returnString.replace("[" + emotion + "]", ""); //remove emotion and save only Actor name
      returnString = returnString + " - " + emotion; // actor - EMOTION
    }
    return dataPath("Characters\\" + returnString + ".png");
  }

  public void drawTextBox() {
    // if Speaker is null, don't draw speaker box
    //*******Text Box*******//
    fill(textBoxColor);
    rect(0, 3 * height/4, width, height/4, 10);
    if (speaker != null) {
      //*****Speaker Box******//
      rect(0, (3 * height/4) - height/12, width/5, height/12, 10);
      fill(0);
      text(speaker, 5, (3 * height/4)- height/48);
    }
    drawText(); 
    // if choices is NOT empty, draw choices boxes
    if (choices.length != 0) {
      drawChoices();
    }
  }

  public void drawText() {
    if (text.length() > 40 && !text.contains("\n")) {
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
    fill(0);
    text(text, 10, 3 * height/4 +height/72 * 5);
  }

  public void drawChoices() {
    switch(choices.length) {
    case 1:
      fill(textBoxColor);
      rect(width/3, height/3, width/3, height/12, 10);
      fill(0);
      text(choices[0], width/3 + 30, 1 * height/3 + 45);
      break;
    case 2:
      fill(textBoxColor);
      rect(width/3, 1 * height/6, width/3, height/12, 10);
      rect(width/3, 2 * height/6, width/3, height/12, 10);
      fill(0);
      text(choices[0], width/3 + 30, 1 * height/6 + 45);
      text(choices[1], width/3 + 30, 2 * height/6 + 45);
      break;
    case 3:
      fill(textBoxColor);
      rect(width/3, 1 * height/6, width/3, height/12, 10);
      rect(width/3, 2 * height/6, width/3, height/12, 10);
      rect(width/3, 3 * height/6, width/3, height/12, 10);
      fill(0);
      text(choices[0], width/3 + 30, 1 * height/6 + 45);
      text(choices[1], width/3 + 30, 2 * height/6 + 45);
      text(choices[2], width/3 + 30, 3 * height/6 + 45);
      break;
    case 4:
      fill(textBoxColor);
      // 1
      rect(width/10, 1 * height/6, 2 * width/5, height/12, 10);
      // 2
      rect(5 * width/10, 1 * height/6, 2 * width/5, height/12, 10);
      // 3
      rect(width/10, 3 * height/6, 2 * width/5, height/12, 10);
      // 4
      rect(5 * width/10, 3 * height/6, 2 * width/5, height/12, 10);
      fill(0);
      text(choices[0], width/10 + 30, 1 * height/6 + 45);
      text(choices[1], 5 * width/10 + 30, 1 * height/6 + 45);
      text(choices[2], width/10 + 30, 3 * height/6 + 45);
      text(choices[3], 5 * width/10 + 30, 3 * height/6 + 45);
      break;
    }
  }

  public int getChoiceValue() {
    switch(choices.length) {
    case 1:
      int minX = width/3, maxX = width/3 + width/3;
      int minY = height/3, maxY = height/3 + height/12;
      if (mouseX > minX && mouseX < maxX) {
        if (mouseY > minY && mouseY < maxY) {
          return 1;
        }
      }
      return -1;
    case 2:
      minX = width/3;
      maxX = width/3 + width/3;
      int minY1 = height/6, maxY1 = height/6 + height/12;
      int minY2 = 2 * height/6, maxY2 = 2 * height/6 + height/12;
      if (mouseX > minX && mouseX < maxX) {
        if (mouseY > minY1 && mouseY < maxY1) {
          return 1;
        }
        if (mouseY > minY2 && mouseY < maxY2) {
          return 2;
        }
      }
      return -1;
    case 3:
      minX = width/3;
      maxX = width/3 + width/3;
      minY1 = height/6;
      maxY1 = height/6 + height/12;
      minY2 = 2 * height/6;
      maxY2 = 2 * height/6 + height/12;
      int minY3 = 3 * height/6, maxY3 = 3 * height/6 + height/12;
      if (mouseX > minX && mouseX < maxX) {
        if (mouseY > minY1 && mouseY < maxY1) {
          return 1;
        }
        if (mouseY > minY2 && mouseY < maxY2) {
          return 2;
        }
        if (mouseY > minY3 && mouseY < maxY3) {
          return 3;
        }
      }
      return -1;
    case 4:
      int minXLeft = width/10, maxXLeft = minXLeft + 2 * width/5;
      int minXRight = 5 * width/10, maxXRight = minXRight + 2 * width/5;
      int minYBottom = 3 * height/6, maxYBottom = minYBottom + height/12;
      int minYTop = height/6, maxYTop = minYTop + height/12;

      // If on left side 
      if (minXLeft < mouseX && mouseX < maxXLeft) {
        if (mouseY < maxYBottom && mouseY > minYBottom) {
          //if on bottom
          return 3;
        }
        if (mouseY < maxYTop && mouseY > minYTop) {
          //if on top
          return 1;
        }
      } else if (minXRight < mouseX && mouseX < maxXRight) {
        // If on right side
        if (mouseY < maxYBottom && mouseY > minYBottom) {
          //if on bottom
          return 4;
        }
        if (mouseY < maxYTop && mouseY > minYTop) {
          //if on top
          return 2;
        }
      }
      return -1;
    default:
      return -1;
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
