ControlsState = Class{__includes = BaseState}

function ControlsState:enter()
    
end

function ControlsState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')

        gSounds['select']:stop()
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ControlsState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Controls", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('a/d - Move brick', 0, (VIRTUAL_HEIGHT / 3)+150,
    VIRTUAL_WIDTH, 'center')
    love.graphics.printf('s - Drop brick', 0, (VIRTUAL_HEIGHT / 3)+200,
    VIRTUAL_WIDTH, 'center')
    love.graphics.printf('z - rotate brick', 0, (VIRTUAL_HEIGHT / 3)+250,
    VIRTUAL_WIDTH, 'center')
    love.graphics.printf('space - quick drop', 0, (VIRTUAL_HEIGHT / 3)+300,
    VIRTUAL_WIDTH, 'center')
    love.graphics.printf('w/x - Hold brick', 0, (VIRTUAL_HEIGHT / 3)+350,
    VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press enter to return', 0, (VIRTUAL_HEIGHT / 3)+400,
    VIRTUAL_WIDTH, 'center')
end
