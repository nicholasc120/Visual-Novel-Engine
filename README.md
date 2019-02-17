# Visual-Novel-Engine
A processing based program for users to create their own visual novel games with
## Editing Scripts
The game follows a narrative that is saved into a text file. This text file contains
information about location, who's speaking, what backdrop the scene should have, what music 
is playing, and what emotion each character should display.

The script is located under `VisualNovelEngine\data\script.txt`
The commands and their descriptions are as follows

**SCENE: bg**

*-Changes background to `bg.png` located in the Backgrounds folder*

**MUSIC: song**

*-plays `song.mp3` located in the Music folder*

**MUSIC: STOP**

*-stops current music. Must be used before playing a new song to prevent overlap.*

**Character[EMOTION]: Text**

*-Character speaks with `Character - EMOTION.png` inside the Characters folder being displayed. For no image to be displayed, use NONE for EMOTION*

*-The main character's name does not display or change the displayed character*

*-Leave out [] and EMOTION to display `Character.png`*

**LEAVE: Character**

*-removes most recently used Character from being displayed*


## Backgrounds 
All backgrounds for all scenes should be located under `VisualNovelEngine\data\Backgrounds`


## Characters
Each character's character art and emotion should be located under `VisualNovelEngine\data\Characters`


## Music
All background music for all scenes should be located under `VisualNovelEngine\data\Music`

## Game settings
Game settings such as the main character's name, and key bindings for saving, loading, and
automatically advancing text are located under `VisualNovelEngine\data\settings.txt`
