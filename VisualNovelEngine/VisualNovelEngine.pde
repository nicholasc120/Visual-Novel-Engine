import java.util.*;
import java.io.*;
import ddf.minim.*;

String[] script, settings;
int count = 0;
int choiceValue = -1;
boolean gameStarted = false;
SFX sfx;
Scene scene;

void setup() {
  size(1280, 720);
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

void draw() {
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

void initializeSettings(String[] settings) {
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

void mouseClicked() {
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

void drawTitleScreen() {
  // set background image
  image(loadImage(dataPath("Backgrounds\\TitleScreen.png")), 0, 0);
  // draw NEW and CONTINUE buttons at bottom
  drawNewAndContinue();
}

void drawNewAndContinue() {
  fill(scene.textBoxColor);
  rect(3 * (width/5), (4 * height/5), width/5, height/12, 10);
  rect((width/5), (4 * height/5), width/5, height/12, 10);
  fill(0);
  text("New", (width/5) + 80, (4 * height/5) + 45);
  text("Continue", 3 * (width/5) + 40, (4 * height/5) + 45);
}

void drawSaveAndLoad() {
  fill(scene.textBoxColor);
  rect(0, 0, width/12, height/15, 10);
  rect(width/12, 0, width/12, height/15, 10);
  fill(0);
  text("Save", 5, 40);
  text("Load", width/12 + 5, 40);
}

boolean clickedOnNew() {
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

boolean clickedOnContinue() {
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

boolean clickedOnSave() {
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

boolean clickedOnLoad() {
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

void saveGame() {
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

void loadGame() {
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

void parseLines(String[] script) {
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
