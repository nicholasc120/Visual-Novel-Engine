class Scene {
  String background;
  String [] actors;
  Music backgroundMusic;
  String speaker;
  String text;
  String [] choices;
  color textBoxColor;

  Scene(Minim minim) {
    actors = new String[0];
    choices = new String[0];
    backgroundMusic = new Music(minim);
  }

  void drawBackground() {
    if (background != null) {
      image(loadImage(dataPath("Backgrounds\\" + background + ".png")), 0, 0);
    }
  }

  void drawActors() {
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

  String getActorPath(String actorName) {
    String returnString = actorName;
    if (returnString.contains("[") && returnString.contains("]")) {
      String emotion = returnString.substring(returnString.indexOf("[") + 1, returnString.indexOf("]"));
      returnString = returnString.replace("[" + emotion + "]", ""); //remove emotion and save only Actor name
      returnString = returnString + " - " + emotion; // actor - EMOTION
    }
    return dataPath("Characters\\" + returnString + ".png");
  }

  void drawTextBox() {
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

  void drawText() {
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

  void drawChoices() {
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

  int getChoiceValue() {
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
