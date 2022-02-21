# Visual Novel Engine Documentation
## Setting Backgrounds
Background images must be of size 1280x720 and inside the `Backgrounds` folder
### Title Screen
- The title screen background must be named TitleScreen.png
### In-Game Backgrounds
- use `SETTING: ` to define the background for a scene
  - e.g. `SETTING: park` will load `park.png` from the `Backgrounds` folder
## Background Music
### Title Screen
- If there is music for the Title Screen, the `settings.init` must have the `TitleScreenMusic` value set to True
- The background music must be named `TitleScreen.mp3` and placed in the `Music` folder
### Controlling In-Game Background Music
- use `MUSIC: STOP` to stop music. This must be done before playing another song to prevent overlap
- append the song name to `MUSIC: ` to play the song from the `Music` folder
  - e.g. the command `MUSIC: song` will play the song `song.mp3` from the `Music` folder
## Displaying messages
### Messages with no speaker box
- use `TEXT: ` to display messages with no speaker box
  - e.g. `TEXT: The cat runs away.`
### Messages with a speaker box
- use `Speaker: line` to display messages with the `Speaker` in the speaker box
  - e.g. `Character: line` will display `Character` in the speaker box
## Actors
- Please use images of size 960x960
- One, Two, or Zero actors can be onscreen at a time
  - use the `ONE: `, `TWO: `, and `NONE: ` arguments respectively to accomplish this
  - Actor names should follow the argument, separated by a comma and space
    - e.g. `ONE: character` will display the `character.png` file in the `Characters` folder
    - e.g. `TWO: character1, character2` will display characters `character1.png` and `character2.png` file from the `Characters` folder
- Character variants can be denoted using `[]` in the character name
  - e.g. `ONE: character[variant]` will display `character - variant.png` in the `Characters` folder
  - `ONE: ` and `TWO: ` can be used repeatedly to swap between variants of characters
## Special Effects (SFX)
- SFX can be added and is played on the line immediately following it by using the `SFX: ` command
  - e.g. use `SFX: smack` to play the `smack.mp3` file in the `SFX` folder
## Choices
- choices can be made with one to four available options.
- use the `CHOICE: ` argument with each choice separated by a comma and a space
- The following lines should be numbered, with their corresponding choice numbers
  - e.g. `CHOICE: labela, labelb, labelc` will display three choices reading labela, labelb, and labelc
    - the following lines should be written as so:
      - `1: TEXT: exampletext`
      - `1: TEXT: more text`
      - `2: TEXT: this appears if you clikced labelb`
      - `3: TEXT: this is for labelc`