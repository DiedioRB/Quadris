require 'src/Dependencies'

--//TODO: New game mode
--//TODO: Change random brick color
function love.load()
    love.graphics.setDefaultFilter("nearest", 'nearest')
    math.randomseed(os.time())

    love.window.setTitle('Quadris')

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 32),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 64),
    }
    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background_white.png'),
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = {
        ['move'] = love.audio.newSource('sounds/move.wav', 'static'),
        ['hold'] = love.audio.newSource('sounds/hold.wav', 'static'),
        ['place-brick'] = love.audio.newSource('sounds/place-brick.wav', 'static'),
        ['break-row-1'] = love.audio.newSource('sounds/break-row-1.wav', 'static'),
        ['break-row-2'] = love.audio.newSource('sounds/break-row-2.wav', 'static'),
        ['break-row-3'] = love.audio.newSource('sounds/break-row-3.wav', 'static'),
        ['break-row-4'] = love.audio.newSource('sounds/break-row-4.wav', 'static'),
        ['combo-lost'] = love.audio.newSource('sounds/combo-lost.wav', 'static'),
        ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),

        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    }

    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['select'] = function () return SelectState() end,
        ['play'] = function () return PlayState() end,
        ['pause'] = function () return PauseState() end,
        ['game-over'] = function () return GameOverState() end,
        ['controls'] = function () return ControlsState() end,
    }

    gStateMachine:change('start', {})

    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:apply('start')

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 0, 0, 0,
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1)
    )

    gStateMachine:render()

    push:apply('end')
end

function renderScore(score)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('SCORE', VIRTUAL_WIDTH - 200, (VIRTUAL_HEIGHT/5*2), 200, 'right')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(tostring(math.min(score, 999999999)), VIRTUAL_WIDTH - 180, (VIRTUAL_HEIGHT/5*2)+80, 180, 'right')
end

function renderRowsDestroyed(rows)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('ROWS', 0, (VIRTUAL_HEIGHT/5*2), 200, 'right')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf(tostring(math.min(rows, 999999999)), 0, (VIRTUAL_HEIGHT/5*2)+80, 190, 'right')
end

function renderCombo(combo)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('COMBO', 0, (VIRTUAL_HEIGHT/5*2) + 160, 200, 'right')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('x'..tostring(math.min(combo, 999999999)), 0, (VIRTUAL_HEIGHT/5*2) + 238, 190, 'right')
end