Brick = Class{}

colors = {
    ['cyan'] = {0, 1, 1},
    ['yellow'] = {1, 1, 0},
    ['purple'] = {0.5, 0, 0.5},
    ['green'] = {0, 1, 0},
    ['red'] = {1, 0, 0},
    ['blue'] = {0, 0, 1},
    ['orange'] = {1, 0.5, 0},
    ['grey'] = {0.5, 0.5, 0.5},
}

function Brick:init(params)
    self.x = params.x or DEFAULT_SPAWN_X
    self.y = params.y or DEFAULT_SPAWN_Y

    self.width = 40
    self.height = 40

    self.color = params.color or 'grey'
    self.type = params.type or nil

    self.center = false
    self.isGhost = params.isGhost or false

    self.rotations = 0

    -- connected bricks of a tetromino are kept here
    self.up = nil
    self.down = nil
    self.left = nil
    self.right = nil

    -- in case it's a random generated brick
    self.disposition = params.disposition or nil
end

function Brick:resetPosition(params)
    local x = DEFAULT_SPAWN_X
    local y = DEFAULT_SPAWN_Y
    if not (params == nil) then
        x = params['x'] or DEFAULT_SPAWN_X
        y = params['y'] or DEFAULT_SPAWN_Y
    end

    self.x = x
    self.y = y

    -- reset connected blocks
    if not (self.up == nil) then
        self.up:resetPosition({
            x = x,
            y = y-1
        })
    end
    if not (self.down == nil) then
        self.down:resetPosition({
            x = x,
            y = y+1
        })
    end
    if not (self.left == nil) then
        self.left:resetPosition({
            x = x-1,
            y = y
        })
    end
    if not (self.right == nil) then
        self.right:resetPosition({
            x = x+1,
            y = y
        })
    end
end

function Brick:rotateClockwise()
    -- 'O' type bricks do not spin
    if not (self.type == BRICK_O) then
        self.rotations = (self.rotations+1)% 4

        local aux = self.up

        -- left to up
        self:connect(self.left, 'up')
        if (not (self.left == nil)) then
            self.left:rotateClockwise()
            self.left.down = nil
        end
        self.left = nil

        -- down to left
        self:connect(self.down, 'left')
        if (not (self.down == nil)) then
            self.down:rotateClockwise()
            self.down.right = nil
        end
        self.down = nil

        -- right to down
        self:connect(self.right, 'down')
        if (not (self.right == nil)) then
            self.right:rotateClockwise()
            self.right.up = nil
        end
        self.right = nil

        -- up to right
        self:connect(aux, 'right')
        if (not (aux == nil)) then
            self.right:rotateClockwise()
            self.right.left = nil
        end
        if self.up == self.right then
            self.up = nil
        end
    end
end

function Brick:rotateCounterClockwise()
    -- 'O' type bricks do not spin
    if not (self.type == BRICK_O) then
        self.rotations = (self.rotations-1)%4

        local aux = self.up

        -- right to up
        self:connect(self.right, 'up')
        if (not (self.right == nil)) then
            self.right:rotateCounterClockwise()
            self.right.down = nil
        end
        self.right = nil

        -- down to right
        self:connect(self.down, 'right')
        if (not (self.down == nil)) then
            self.down:rotateCounterClockwise()
            self.down.left = nil
        end
        self.down = nil

        -- left to down
        self:connect(self.left, 'down')
        if (not (self.left == nil)) then
            self.left:rotateCounterClockwise()
            self.left.up = nil
        end
        self.left = nil

        -- up to left
        self:connect(aux, 'left')
        if (not (aux == nil)) then
            self.left:rotateCounterClockwise()
            self.left.right = nil
        end
        if self.up == self.left then
            self.up = nil
        end
    end
end

function Brick:reposition()
    local wasRepositioned = false

    local maxDown = self:maxDown()
    local maxLeft = self:maxLeft()
    local maxRight = self:maxRight()
    if maxDown > BOARD_MAX_Y then
        wasRepositioned = true
        self:goUp()
    end
    if maxLeft < BOARD_MIN_X then
        wasRepositioned = true
        self:goRight()
    end
    if maxRight > BOARD_MAX_X then
        wasRepositioned = true
        self:goLeft()
    end

    if wasRepositioned then
        self:reposition()
    end
end

function Brick:connect(brick, position)
    if not (brick == nil) then
        -- sets the type to match the parent brick
        brick.type = self.type

        -- changes the X and Y according to the
        -- position relative to the center brick
        if position == 'up' then
            brick.x = self.x
            brick.y = self.y-1
            self.up = brick
        elseif position == 'down' then
            brick.x = self.x
            brick.y = self.y+1
            self.down = brick
        elseif position == 'left' then
            brick.x = self.x-1
            brick.y = self.y
            self.left = brick
        elseif position == 'right' then
            brick.x = self.x+1
            brick.y = self.y
            self.right = brick
        end
    end
end

function Brick:maxDown()
    local y = self.y
    if not (self.down == nil) then
        y = math.max(self.down:maxDown(), y)
    end
    if not (self.left == nil) then
        y = math.max(self.left:maxDown(), y)
    end
    if not (self.right == nil) then
        y = math.max(self.right:maxDown(), y)
    end
    return y
end
function Brick:maxLeft()
    local x = self.x
    if not (self.left == nil) then
        x = math.min(self.left:maxLeft(), x)
    end
    if not (self.up == nil) then
        x = math.min(self.up:maxLeft(), x)
    end
    if not (self.down == nil) then
        x = math.min(self.down:maxLeft(), x)
    end
    return x
end
function Brick:maxRight()
    local x = self.x
    if not (self.right == nil) then
        x = math.max(self.right:maxRight(), x)
    end
    if not (self.up == nil) then
        x = math.max(self.up:maxRight(), x)
    end
    if not (self.down == nil) then
        x = math.max(self.down:maxRight(), x)
    end
    return x
end

function Brick:goDown()
    self.y = self.y+1

    if not (self.up == nil) then
        self.up:goDown()
    end
    if not (self.down == nil) then
        self.down:goDown()
    end
    if not (self.left == nil) then
        self.left:goDown()
    end
    if not (self.right == nil) then
        self.right:goDown()
    end
end
function Brick:goUp()
    self.y = self.y-1

    if not (self.up == nil) then
        self.up:goUp()
    end
    if not (self.down == nil) then
        self.down:goUp()
    end
    if not (self.left == nil) then
        self.left:goUp()
    end
    if not (self.right == nil) then
        self.right:goUp()
    end
end

function Brick:goLeft()
    if self:maxLeft() > BOARD_MIN_X then
        self.x = self.x-1
    
        if not (self.up == nil) then
            self.up:goLeft()
        end
        if not (self.down == nil) then
            self.down:goLeft()
        end
        if not (self.left == nil) then
            self.left:goLeft()
        end
        if not (self.right == nil) then
            self.right:goLeft()
        end

        if not self.isGhost then
            gSounds['move']:stop()
            gSounds['move']:play()
        end
    end
end

function Brick:goRight()
    if self:maxRight() < BOARD_MAX_X then
        self.x = self.x+1

        if not (self.up == nil) then
            self.up:goRight()
        end
        if not (self.down == nil) then
            self.down:goRight()
        end
        if not (self.left == nil) then
            self.left:goRight()
        end
        if not (self.right == nil) then
            self.right:goRight()
        end

        if not self.isGhost then
            gSounds['move']:stop()
            gSounds['move']:play()
        end
    end
end

function Brick:render()
    -- draw self
    if BOARD_OFFSET_Y+((self.y-1)) >= BOARD_OFFSET_Y then
        if self.isGhost then
            local color = {
                colors[self.color][1],
                colors[self.color][2],
                colors[self.color][3]
            }
            table.insert(color, 0.7)
            love.graphics.setColor(color)
        else
            love.graphics.setColor(colors[self.color])
        end
        love.graphics.rectangle('fill', BOARD_OFFSET_X+(self.x*self.width), BOARD_OFFSET_Y+((self.y-1)*self.height), self.width, self.height)
    end
    
    -- draw connected blocks
    if not (self.up == nil) then
        self.up:render()
    end
    if not (self.down == nil) then
        self.down:render()
    end
    if not (self.left == nil) then
        self.left:render()
    end
    if not (self.right == nil) then
        self.right:render()
    end
end

function Brick:renderAsNext(params)
    -- width and height to show the next brick
    local width = 16
    local height = 16
    
    -- absolute x and y instead of board coordinates
    local x = 700
    local y = 100
    if not (params == nil) then
        x = params['x'] or 700
        y = params['y'] or 100
    end

    -- draw self
    love.graphics.setColor(colors[self.color])
    love.graphics.rectangle('fill', x, y, width, height)
    
    -- draw connected blocks
    if not (self.up == nil) then
        self.up:renderAsNext({
            x = x,
            y = y-height
        })
    end
    if not (self.down == nil) then
        self.down:renderAsNext({
            x = x,
            y = y+height
        })
    end
    if not (self.left == nil) then
        self.left:renderAsNext({
            x = x-width,
            y = y
        })
    end
    if not (self.right == nil) then
        self.right:renderAsNext({
            x = x+width,
            y = y
        })
    end
end

function Brick:renderAsHold()
    -- width and height to show the next brick
    local width = 16
    local height = 16
    
    -- absolute x and y instead of board coordinates
    local x = 84
    local y = 100
    if not (params == nil) then
        x = params['x'] or 100
        y = params['y'] or 100
    end

    -- draw self
    love.graphics.setColor(colors[self.color])
    love.graphics.rectangle('fill', x, y, width, height)
    
    -- draw connected blocks
    if not (self.up == nil) then
        self.up:renderAsNext({
            x = x,
            y = y-height
        })
    end
    if not (self.down == nil) then
        self.down:renderAsNext({
            x = x,
            y = y+height
        })
    end
    if not (self.left == nil) then
        self.left:renderAsNext({
            x = x-width,
            y = y
        })
    end
    if not (self.right == nil) then
        self.right:renderAsNext({
            x = x+width,
            y = y
        })
    end
end