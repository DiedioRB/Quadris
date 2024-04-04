StartState = Class{__includes = BaseState}

function StartState:enter(params)
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('select')

        gSounds['select']:stop()
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('c') then
        gStateMachine:change('controls')
        
        gSounds['select']:stop()
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("QUADRIS", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press enter to start", 0, (VIRTUAL_HEIGHT / 3)+100,
    VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press C for controls", 0, (VIRTUAL_HEIGHT / 3)+200,
    VIRTUAL_WIDTH, 'center')
end
