static class Actor {

  static String getCharacterImagePath(String line) {
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

  static String getCharacterName(String line) {
    String returnString = line.substring(0, line.indexOf(":"));
    if (returnString.contains("[") && returnString.contains("]")) {
      returnString= returnString.substring(0, returnString.indexOf("["));
    }

    return returnString;
  }

  static String checkEmotion(String line) {
    String returnString = line;
    if (returnString.contains("[") && returnString.contains("]")) {
      String emotion = returnString.substring(returnString.indexOf("[") + 1, returnString.indexOf("]"));
      return emotion;
    }
    return "NEUTRAL";
  }
}