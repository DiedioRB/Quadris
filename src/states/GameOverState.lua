GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.board = params['board']
    self.score = params['score']
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')

        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    self.board:render()

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Game Over", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Final Score:", 0, (VIRTUAL_HEIGHT / 3)+100,
    VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf(self.score, 0, (VIRTUAL_HEIGHT / 3)+150,
    VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press enter to try again", 0, (VIRTUAL_HEIGHT / 3)+300,
    VIRTUAL_WIDTH, 'center')
end
