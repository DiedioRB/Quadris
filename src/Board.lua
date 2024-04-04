Board = Class{}

function Board:init()
    self.placedBlocks = {}
    
    self:reset()
end

-- returns if the block can be placed. If not, it's game over
function Board:insert(brick)
    local inserted = true
    if not (brick.up == nil) then
        inserted = self:insert(brick.up)
    end
    if inserted and not (brick.down == nil) then
        inserted = self:insert(brick.down)
    end
    if inserted and not (brick.left == nil) then
        inserted = self:insert(brick.left)
    end
    if inserted and not (brick.right == nil) then
        inserted = self:insert(brick.right)
    end
    brick.up = nil
    brick.down = nil
    brick.left = nil
    brick.right = nil
    if not inserted or brick.y < 1 or not (self.placedBlocks[brick.y][brick.x] == nil) then
        return false
    end

    self.placedBlocks[brick.y][brick.x] = brick
    return true
end

function Board:destroyRows()
    local rowsBroken = 0
    local blocksInRow = 0
    -- first, destroy the complete rows
    local y = BOARD_MAX_Y
    while y >= 2 do
        blocksInRow = 0
        for x=1, BOARD_MAX_X do
            if not (self.placedBlocks[y][x] == nil) then
                blocksInRow = blocksInRow+1
            end
        end
        if blocksInRow == BOARD_MAX_X then
            rowsBroken = rowsBroken+1
            self:dropRowsUntil(y)
            y = y+1
        end
        y = y-1
    end

    return rowsBroken
end

function Board:dropRowsUntil(row)
    -- for every row above the parameter
    for y=row, 2, -1 do
        for x=1, BOARD_MAX_X do
            -- if there's a block, drop it
            if not (self.placedBlocks[y-1][x] == nil) then
                self.placedBlocks[y-1][x]:goDown()
            end
            -- drop the row
            self.placedBlocks[y][x] = self.placedBlocks[y-1][x]
            -- eliminates the row above
            self.placedBlocks[y-1][x] = nil
        end
    end
end

function Board:reset()
    for i=1, BOARD_MAX_Y do
        self.placedBlocks[i] = {}
        for j=1, BOARD_MAX_X do
            self.placedBlocks[i][j] = nil
        end
    end
end

function Board:collides(brick, dx, dy)
    local willCollide = false

    if (brick == nil)
    or (brick.y+dy < 1)
    then
       willCollide = false
    elseif (self.placedBlocks[brick.y+dy] == nil)
    or (not (self.placedBlocks[brick.y+dy][brick.x+dx] == nil))
    or (brick.x+dx < 0 or brick.x+dx > BOARD_MAX_X)
    then
        willCollide = true
    else
        if not (brick.up == nil) then
            willCollide = self:collides(brick.up, dx, dy)
        end
        if not willCollide and not (brick.down == nil) then
            willCollide = self:collides(brick.down, dx, dy)
        end
        if not willCollide and not (brick.left == nil) then
            willCollide = self:collides(brick.left, dx, dy)
        end
        if not willCollide and not (brick.right == nil) then
            willCollide = self:collides(brick.right, dx, dy)
        end
    end
    return willCollide
end

function Board:reposition(brick)
    if self:collides(brick, 0, 0) then
        if not self:collides(brick, -1, 0) then
            -- move left
            brick:goLeft()
        elseif not self:collides(brick, 1, 0) then
            -- move right
            brick:goRight()
        elseif not self:collides(brick, 0, -1) then
            --move up one block
            brick:goUp()
        else
            brick:rotateCounterClockwise()
        end
    end
end

function Board:canRotate(brick)
    if self:collides(brick, 0, 0)
    and (
        self:collides(brick, -1, 0)
        and self:collides(brick, 1, 0)
        and self:collides(brick, 0, -1)
    )
    then
        return false
    end
    return true
end

function Board:render()
    for i=1, BOARD_MAX_Y do
        for j=1, BOARD_MAX_X do
            if not (self.placedBlocks[i][j] == nil) then
                self.placedBlocks[i][j]:render()
            end
        end
    end 
end