# Quadris: Tetris with some other things
###### By Diedio

---
## The game
Quadris is a simple and endless puzzle game based on the Alexey Pajitnov classic Tetris.
In this game, bricks in different shapes fall from the top of the screen. The objective is to form lines with these bricks, which are then destroyed upon completion and increase the player's score.
The game ends when enough bricks are placed so that there is no more space to place or move the falling bricks.

---
## Movement
In order to complete rows, the player can manipulate the falling bricks by moving it left or right and rotating the piece.
To help the player, the next brick to be dropped is shown, allowing to plan the next move.
The player can also "hold" a brick to replace the current falling brick during the gameplay. This can be used to strategically position bricks and store useful bricks for later use.

### Controls

- **a / d (← / →)** - Move the falling brick left and right
- **s (↓)** - Increase the falling speed
- **w / x (↑)** - Hold the falling brick and replaces it with the stored brick
- **z** - Rotate the brick clockwise
- **space / enter** - Instantly drops the brick into position
- **p** - Pause the game
- **esc** - End the game

---
## Game modes
Quadris comes with three game modes:
- **Classic** - The basic game, with the 7 common shapes of Tetris
- **Quadris +** - Includes the 7 letter shapes, with some randomly generated bricks spawning eventually
- **All random!** - Every piece is randomly generated. This game mode might be a little harder, but can be am interesting challenge for the ones used to the regular game.

---
## The bricks
The bricks may appear as seven different shapes which can be divided into four single bricks, each one being called by a letter: I, J, L, O, S, T and Z.
Depending on the game mode you play, there may also be randomly generated bricks in different sizes and shapes, including a single, small brick to be placed on a single space.

---
## Scoring points
Scoring points is achieved by breaking rows.
Breaking a single row grants 100 points to the total score, which can be increased up to 999,999,999 points. That's a lot of points, so there's some ways to score a little more points for every row broken:
- Breaking rows sequentially (with different bricks) grants a combo stack. The score you get is multiplied by your current combo, so having an 8x combo grants you 800 points for every row broken! Be mindful, though, that if you drop a brick in place and no row is broken, you will lose your current combo.
- Destroying multiple rows with a single brick dropped does not add a multiplier to the added score, but the combo is applied for every row broken. So, if you destroy 3 rows with a single brick and a 3x combo, you get a total of 900 points!

---
## The interface
The board is a 19x10 grid, and its positioning is marked with a white box. Blocks will fall inside this area and can't trespass its limits. Trying to move or rotate a brick outside of the area with pull the brick in the center direction.
In the left and right of the board, there are two squares that show the held brick and the next falling brick respectively. You can also find the amount of bricks broken, current combo and total score displayed below these squares.
To help the player with brick alignment, a translucent "ghost brick" with the same shape as the falling brick is displayed in the space where the brick will be placed in case it is dropped instantly.

## The project
For the making of this project, some basic files were recycled from the CS50 game projects, such as **StateMachine**, **Dependencies**, **Util** and **BaseState**.

The project has 6 different states:
- **StartState** - A menu screen for basic navigation
- **ControlsState** - A screen containing the controls of the game
- **SelectState** - The screen where the player can choose the game mode
- **PlayState** - The actual gameplay and the most of the complexity of the game is contained here
- **PauseState** - A state where the game is frozen until the player wishes to return to the game
- **GameOverState** - A "Game Over" message is displayed above the board. From here, the player can return to the StartState and play again

The project also has some objects to manipulate the elements:
- **Brick** class - Contains information about the brick and the connections that build the larger shapes (described deeply ahead)
- **Board** class - Has the placed bricks information and helps to check collision between the bricks and shift the current falling brick
- **BrickBuilder** class - A helper class to build the different shapes of bricks

## Challenges of the making

### Building bricks
The game bricks are actually small pieces that are linked together to make different shapes. A single unit of brick contains information about color, position and links in every side of it. The brick is made like this to allow infinite shaping and easy manipulation of its spin and decomposing when placed on the board.
Because it is built like this, a lot of recursive functions are used when going through all the connected pieces for movement, rotation and random generation. It makes the code a little more complex, but makes future changes to be easier to implement (like adding a new shape to the game or a new movement mechanic).

### A note about rotationing bricks
In some cases the rotation of a brick might cause it to collide with other bricks in place so that they would be positioned one over the other. In these cases, an adjustment system will try and shift the falling brick to avoid the collision.
This adjustment will try to move the brick left, right and up and check if these positions also collide with another brick. If any of them is free, the brick will be shifted to that position. In case there is no free space to shift the block without collision, the rotation will be blocked and the brick will fall into place unable to rotate.
Since every brick is based on smaller pieces, this operation is recursive and checks the position for every small brick.
The rotation was probably the most difficult part to do because of the complexity of the logic behind the rotation and shifting.

---
## Art and Sounds

### Background
The background was made using [Krita](https://krita.org/en/), an open source painting program.

### Music
The music was made by myself using [BeepBox](https://www.beepbox.co/), an online tool for sketching music.
It was heavily inspired by the original Tetris Theme to determine Rythm and loop.

### Sounds
The sounds were all created using [BFXR](https://www.bfxr.net/).

### Fonts
The font used is the same used in some of the CS50's game projects.

---
###### This project was made by Diedio as Final Project for CS50's Introduction to Game Development course.