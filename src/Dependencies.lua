-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'
-- https://github.com/Ulydev/push
push = require 'lib/push'


-- timers
Timer = require 'lib/knife.timer'

-- global constants
require 'src/constants'

-- the individual brick that creates the shapes for the game
require 'src/Brick'
-- class to create the different shapes of the bricks
require 'src/BrickBuilder'

-- placed blocks are registered in the board
require 'src/Board'

-- state machine
require 'src/StateMachine'

-- utilities to split the spritesheet
require 'src/Util'

-- States
require 'src/states/BaseState'
require 'src/states/SelectState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/PauseState'
require 'src/states/GameOverState'
require 'src/states/ControlsState'