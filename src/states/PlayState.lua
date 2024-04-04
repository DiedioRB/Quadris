PlayState = Class{__includes = BaseState}

DEFAULT_FALL_TIMER = 1
BLOCK_FALL_QUICK_TIMER = 0.05
QUICK_SHIFT_DELAY = 0.2

function PlayState:enter(params)
    params = (not (params == nil)) and params or {}
    self.fallingBrick = params['fallingBrick'] or nil
    self.onHold = params['onHold'] or nil
    self.next = params['next'] or nil

    self.preview = params['preview'] or nil

    self.gameOver = false

    self.combo = params['combo'] or 0

    self.quickFall = false
    self.quickShiftTimer = 0
    self.didHold = params['didHold'] or false

    self.score = params['score'] or 0

    self.board = params['board'] or Board()

    self.fallTimer = params['fallTimer'] or DEFAULT_FALL_TIMER
    self.rowsBroken = params['rowsBroken'] or 0

    self.bricks = params.mode and params.mode.bricks or {
        BRICK_I,
        BRICK_J,
        BRICK_L,
        BRICK_O,
        BRICK_S,
        BRICK_T,
        BRICK_Z,
    }


    if self.fallingBrick == nil then
        self.fallingBrick = BrickBuilder:create({
            type = self.bricks[math.random(1,#self.bricks)],
        })
    end

    if self.preview == nil then
        self.preview = BrickBuilder:create({
            type = self.fallingBrick.type,
            isGhost = true,
            disposition = self.fallingBrick.disposition,
            color = self.fallingBrick.color
        })
        self:calculatePreview()
    end

    if self.next == nil then
        self.next = BrickBuilder:create({
            type = self.bricks[math.random(1,#self.bricks)]
        })
    end
    
    self:setTimer()
end

function PlayState:setTimer()
    if not self.gameOver then
        if self.quickFall then
            Timer.after(BLOCK_FALL_QUICK_TIMER, function()
                self:goDown()
                self:setTimer()
            end)
        else
            Timer.after(self.fallTimer, function()
                self:goDown()
                self:setTimer()
            end)
        end
    end
end

function PlayState:resetTimer()
    Timer.clear()
    self:setTimer()
end

function PlayState:newBrick()
    self.fallingBrick = self.next
    self.preview = BrickBuilder:create({
        type = self.fallingBrick.type,
        isGhost = true,
        disposition = self.fallingBrick.disposition,
        color = self.fallingBrick.color
    })
    self.next = BrickBuilder:create({
        type = self.bricks[math.random(1,#self.bricks)],
    })
    self:calculatePreview()
end

function PlayState:hold()
    if not self.didHold then
        if self.onHold == nil then
            self.onHold = self.fallingBrick
            self:newBrick()
        else
            local aux = self.fallingBrick
            self.fallingBrick = self.onHold
            self.onHold = aux
    
            self.fallingBrick:resetPosition()
        end
        self.preview = BrickBuilder:create({
            type = self.fallingBrick.type,
            isGhost = true,
            disposition = self.fallingBrick.disposition
        })
        while not (self.preview.rotations == self.fallingBrick.rotations) do
        self.preview:rotateClockwise()
        end
        self:calculatePreview()
        self.didHold = true

        gSounds['hold']:play()
    end
end

function PlayState:drop()
    self.fallingBrick:goDown()
end

function PlayState:quickDrop()
    while not (self.fallingBrick:maxDown() > BOARD_MAX_Y or self.board:collides(self.fallingBrick, 0, 1)) do
        self:goDown()
    end
    self:goDown()
end

function PlayState:goDown()
    local madeNewBrick = false
    if self.fallingBrick:maxDown() > BOARD_MAX_Y or self.board:collides(self.fallingBrick, 0, 1) then
        local placed = self.board:insert(self.fallingBrick)
        gSounds['place-brick']:stop()
        gSounds['place-brick']:play()

        if not placed then
            self:GameOver()
        end
        local rowsBroken = self.board:destroyRows()

        if rowsBroken > 0 then
            self.combo = self.combo+1
            self.score = self.score + ((rowsBroken*self.combo) * 100)

            self.rowsBroken = self.rowsBroken + rowsBroken
            -- slightly increases speed up to a maximum
            self.fallTimer = math.max(DEFAULT_FALL_TIMER - (self.rowsBroken/50), 0.2)

            gSounds['break-row-'..math.min((1 + self.combo), 4)]:play()
        else
            if self.combo > 1 then
                gSounds['combo-lost']:play()
            end
            self.combo = 0
        end
        
        self.didHold = false
        self:newBrick()
        madeNewBrick = true
    end
    if not madeNewBrick then
        self.fallingBrick:goDown()
    end
end

function PlayState:GameOver()
    self.gameOver = true
    for i=1, BOARD_MAX_Y do
        for j=1, BOARD_MAX_X do
            if not (self.board.placedBlocks[i][j] == nil) then
                self.board.placedBlocks[i][j].color = 'grey'
            end
        end
    end

    gStateMachine:change('game-over', {
        board = self.board,
        score = self.score
    })

    gSounds['game-over']:play()
end

function PlayState:goLeft()
    self.fallingBrick:goLeft()
    self.preview:goLeft()
    self:calculatePreview()
end

function PlayState:goRight()
    self.fallingBrick:goRight()
    self.preview:goRight()
    self:calculatePreview()
end

function PlayState:rotateClockwise()
    self.fallingBrick:rotateClockwise()
    if self.board:canRotate(self.fallingBrick) then
        -- rotating was successful
        while not (self.preview.rotations == self.fallingBrick.rotations) do
            self.preview:rotateClockwise()
        end
        self.board:reposition(self.fallingBrick)
        self.fallingBrick:reposition()
        self:calculatePreview()
    else
        -- rotating causes the brick to collide with another
        self.fallingBrick:rotateCounterClockwise()
    end
    
end

function PlayState:calculatePreview()
    self.preview:resetPosition({
        x = self.fallingBrick.x,
        y = self.fallingBrick.y
    })
    while((not self.board:collides(self.preview, 0, 1))) do
        self.preview:goDown()
    end
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('pause', {
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

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')
        or love.keyboard.wasPressed('space') then
        self:quickDrop()
    end    
    if love.keyboard.wasPressed('z') then
            self:rotateClockwise()
    end

    if love.keyboard.wasPressed('left') or love.keyboard.wasPressed('a') then
        self.quickShiftTimer = QUICK_SHIFT_DELAY
        if not self.board:collides(self.fallingBrick, -1, 0) then
            self:goLeft()
        end
    end

    if love.keyboard.wasPressed('right') or love.keyboard.wasPressed('d') then
        self.quickShiftTimer = QUICK_SHIFT_DELAY
        if not self.board:collides(self.fallingBrick, 1, 0) then
            self:goRight()
        end
    end

    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('w') or love.keyboard.wasPressed('x') then
        self:hold()
    end

    if love.keyboard.wasPressed('down') or love.keyboard.wasPressed('s') then
        self.quickFall = true
        self:resetTimer()
    end

    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.quickFall = true
    else
        self.quickFall = false
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        -- when held for more than half a second, keeps shifting to the left
        if self.quickShiftTimer > 0 then
            self.quickShiftTimer = self.quickShiftTimer-dt
        end
        if(self.quickShiftTimer <= 0) then
            self.quickShiftTimer = BLOCK_FALL_QUICK_TIMER
            if not self.board:collides(self.fallingBrick, -1, 0) then
                self:goLeft()
            end
        end
    else
        if not (love.keyboard.isDown('right') or love.keyboard.isDown('d')) then
            self.quickShiftTimer = QUICK_SHIFT_DELAY
        end
    end

    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        -- when held for more than half a second, keeps shifting to the left
        if self.quickShiftTimer > 0 then
            self.quickShiftTimer = self.quickShiftTimer-dt
        end
        if(self.quickShiftTimer <= 0) then
            self.quickShiftTimer = BLOCK_FALL_QUICK_TIMER
            if not self.board:collides(self.fallingBrick, 1, 0) then
                self:goRight()
            end
        end
    else
        if not (love.keyboard.isDown('left') or love.keyboard.isDown('a')) then
            self.quickShiftTimer = QUICK_SHIFT_DELAY
        end
    end

    self.fallingBrick:reposition()
    self.preview:reposition()

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dt)
end

function PlayState:render()
    self.fallingBrick:render()
    self.preview:render()
    self.board:render()

    self.next:renderAsNext()
    if not (self.onHold == nil) then
        self.onHold:renderAsHold()
    end

    renderScore(self.score)
    renderRowsDestroyed(self.rowsBroken)
    renderCombo(self.combo)
end