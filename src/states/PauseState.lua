PauseState = Class{__includes = BaseState}

function PauseState:enter(params)
    Timer.clear()
    self.board = params['board']
    self.score = params['score']
    self.fallingBrick = params['fallingBrick']
    self.next = params['next']
    self.onHold = params['onHold']
    self.combo = params['combo']
    self.didHold = params['didHold']
    self.preview = params['preview']
    self.fallTimer = params['fallTimer']
    self.rowsBroken = params['rowsBroken']
end

function PauseState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            board = self.board,
            score = self.score,
            fallingBrick = self.fallingBrick,
            next = self.next,
            onHold = self.onHold,
            combo = self.combo,
            didHold = self.didHold,
            preview = self.preview,
            fallTimer = self.fallTimer,
            rowsBroken = self.rowsBroken
        })
    end

    if love.keyboard.wasPressed('q') then
        gStateMachine:change('start')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PauseState:render()
    self.fallingBrick:render()
    self.preview:render()
    self.board:render()
    
    self.next:renderAsNext()
    if not (self.onHold == nil) then
        self.onHold:renderAsHold()
    end

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Paused", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press P to \nresume game', 0, (VIRTUAL_HEIGHT / 3)+150,
    VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Q to \nreturn to the menu', 0, (VIRTUAL_HEIGHT / 3)+250,
    VIRTUAL_WIDTH, 'center')

    renderScore(self.score)
end
