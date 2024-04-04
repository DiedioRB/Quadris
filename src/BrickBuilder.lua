BrickBuilder = Class{}

function BrickBuilder:create(params)
    if not (params.type == nil) then
        if params.type == BRICK_I then
            return self:createI(params)
        elseif params.type == BRICK_J then
            return self:createJ(params)
        elseif params.type == BRICK_L then
            return self:createL(params)
        elseif params.type == BRICK_O then
            return self:createO(params)
        elseif params.type == BRICK_S then
            return self:createS(params)
        elseif params.type == BRICK_T then
            return self:createT(params)
        elseif params.type == BRICK_Z then
            return self:createZ(params)
        elseif params.type == BRICK_RANDOM then
            if params.disposition == nil then
                local brickColors = {
                    'cyan',
                    'yellow',
                    'purple',
                    'green',
                    'red',
                    'blue',
                    'orange',
                    'grey'
                }
                params.color = brickColors[math.random(1,#brickColors)]
                return self:createRandom(params)
            else
                return self:createFromDisposition(params.disposition, params)
            end
        end
    end
end

function BrickBuilder:createI(params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X,
        y = params.y or DEFAULT_SPAWN_Y,
        color = 'cyan',
        center = true,
        type = BRICK_I,
        isGhost = params.isGhost or false
    })
    brick:connect(Brick({
            color = 'cyan',
            isGhost = params.isGhost or false
        }), 'left'
    )
    brick:connect(Brick({
            color = 'cyan',
            isGhost = params.isGhost or false
        }), 'right'
    )
    brick.right:connect(Brick({
            color = 'cyan',
            isGhost = params.isGhost or false
        }), 'right'
    )
    return brick
end

function BrickBuilder:createJ(params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X-1,
        y = params.y or DEFAULT_SPAWN_Y,
        color = 'blue',
        center = true,
        type = BRICK_J,
        isGhost = params.isGhost or false
    })
    brick:connect(Brick({
            color = 'blue',
            isGhost = params.isGhost or false
        }), 'up'
    )
    brick:connect(Brick({
            color = 'blue',
            isGhost = params.isGhost or false
        }), 'right'
    )
    brick.right:connect(Brick({
            color = 'blue',
            isGhost = params.isGhost or false
        }), 'right'
    )
    return brick
end

function BrickBuilder:createL(params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X+1,
        y = params.y or DEFAULT_SPAWN_Y,
        color = 'orange',
        center = true,
        type = BRICK_L,
        isGhost = params.isGhost or false
    })
    brick:connect(Brick({
            color = 'orange',
            isGhost = params.isGhost or false
        }), 'up'
    )
    brick:connect(Brick({
            color = 'orange',
            isGhost = params.isGhost or false
        }), 'left'
    )
    brick.left:connect(Brick({
            color = 'orange',
            isGhost = params.isGhost or false
        }), 'left'
    )
    return brick
end

function BrickBuilder:createO(params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X,
        y = params.y or DEFAULT_SPAWN_Y,
        color = 'yellow',
        center = true,
        type = BRICK_O,
        isGhost = params.isGhost or false
    })
    brick:connect(Brick({
            color = 'yellow',
            isGhost = params.isGhost or false
        }), 'up'
    )
    brick:connect(Brick({
            color = 'yellow',
            isGhost = params.isGhost or false
        }), 'right'
    )
    brick.right:connect(Brick({
            color = 'yellow',
            isGhost = params.isGhost or false
        }), 'up'
    )
    return brick
end

function BrickBuilder:createS(params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X,
        y = params.y or DEFAULT_SPAWN_Y,
        color = 'green',
        center = true,
        type = BRICK_S,
        isGhost = params.isGhost or false
    })
    brick:connect(Brick({
            color = 'green',
            isGhost = params.isGhost or false
        }), 'left'
    )
    brick:connect(Brick({
            color = 'green',
            isGhost = params.isGhost or false
        }), 'up'
    )
    brick.up:connect(Brick({
            color = 'green',
            isGhost = params.isGhost or false
        }), 'right'
    )
    return brick
end

function BrickBuilder:createT(params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X,
        y = params.y or DEFAULT_SPAWN_Y,
        color = 'purple',
        center = true,
        type = BRICK_T,
        isGhost = params.isGhost or false
    })
    brick:connect(Brick({
            color = 'purple',
            isGhost = params.isGhost or false
        }), 'up'
    )
    brick:connect(Brick({
            color = 'purple',
            isGhost = params.isGhost or false
        }), 'right'
    )
    brick:connect(Brick({
            color = 'purple',
            isGhost = params.isGhost or false
        }), 'left'
    )
    return brick
end

function BrickBuilder:createZ(params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X,
        y = params.y or DEFAULT_SPAWN_Y,
        color = 'red',
        center = true,
        type = BRICK_Z,
        isGhost = params.isGhost or false
    })
    brick:connect(Brick({
            color = 'red',
            isGhost = params.isGhost or false
        }), 'right'
    )
    brick:connect(Brick({
            color = 'red',
            isGhost = params.isGhost or false
        }), 'up'
    )
    brick.up:connect(Brick({
            color = 'red',
            isGhost = params.isGhost or false
        }), 'left'
    )
    return brick
end

-- generates a random brick with 5 - 8 pieces or a one-piece brick
function BrickBuilder:createRandom(params)
    -- 1 in 10 chance to create a one piece brick
    local disposition = {}
    if(not (math.random(10) == 1)) then

        local allPositions = {
            RANDOM_BRICK_CREATE_NONE,
            RANDOM_BRICK_CREATE_TOP,
            RANDOM_BRICK_CREATE_LEFT,
            RANDOM_BRICK_CREATE_RIGHT
        }

        local allowedPositions = {}
        local blockLeft = false
        local blockRight = false
        
        -- first, we path the bricks we will insert
        for i=1, 4 do
            -- reset the allowed positions table
            allowedPositions = {}
            for j=1, #allPositions do
                if
                    (not ((allPositions[j] == RANDOM_BRICK_CREATE_RIGHT) and blockRight)) and
                    (not ((i == 4) and (allPositions[j] == RANDOM_BRICK_CREATE_LEFT) and blockLeft))
                then
                    table.insert(allowedPositions, allPositions[j])
                end
            end
            blockRight = false

            disposition[i] = {}
            disposition[i][1] = (math.random(2) == 1) and RANDOM_BRICK_CREATE_TOP or RANDOM_BRICK_CREATE_NONE

            disposition[i][2] = allowedPositions[math.random(#allowedPositions)]
            if (disposition[i][1] == RANDOM_BRICK_CREATE_NONE) and (not (disposition[i][2] == RANDOM_BRICK_CREATE_NONE)) then
                disposition[i][2] = RANDOM_BRICK_CREATE_TOP
            end

            -- checking to avoid two bricks in the same space
            if disposition[i][2] == RANDOM_BRICK_CREATE_LEFT then
                blockRight = true
            elseif (i == 1) and (disposition[i][2] == RANDOM_BRICK_CREATE_RIGHT) then
                -- this one is used in the last spin to create the shape
                blockLeft = true
            end
        end

    end

    -- then, we put the bricks based on the configuration created above
    -- spinning the brick every position of the array
    local brick = self:createFromDisposition(disposition, params)

    return brick
end

function BrickBuilder:createFromDisposition(disposition, params)
    local brick = Brick({
        x = params.x or DEFAULT_SPAWN_X,
        y = params.y or DEFAULT_SPAWN_Y,
        color = params.color or 'grey',
        center = true,
        type = BRICK_RANDOM,
        isGhost = params.isGhost or false,
        disposition = disposition
    })
    if not (disposition == nil) then
        for i=1, 4 do
            -- creates branch only if the disposition[1] is a piece to be placed
            if (not (disposition[i] == nil)) and disposition[i][1] == RANDOM_BRICK_CREATE_TOP then
                -- first layer
                brick:connect(Brick({
                    color = params.color or 'grey',
                    isGhost = params.isGhost or false
                }), 'up')

                local where = disposition[i][2]
                -- if there's a second layer
                if not (where == RANDOM_BRICK_CREATE_NONE) then
                    if where == RANDOM_BRICK_CREATE_LEFT then
                        where = 'left'
                    elseif where == RANDOM_BRICK_CREATE_RIGHT then
                        where = 'right'
                    else
                        where = 'top'
                    end
                    
                    brick.up:connect(Brick({
                        color = params.color or 'grey',
                        isGhost = params.isGhost or false
                    }), where)
                end
            end
            brick:rotateClockwise()
        end
    end

    return brick
end