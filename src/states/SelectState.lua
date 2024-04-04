SelectState = Class{__includes = BaseState}

function SelectState:enter()
    self.items = {
        {
            code =  'classic',
            title = 'Classic',
            description = 'Regular Quadris game based on Tetris',
            bricks = {
                BRICK_I,
                BRICK_J,
                BRICK_L,
                BRICK_O,
                BRICK_S,
                BRICK_T,
                BRICK_Z,
            }
        },
        {
            code =  'plus',
            title = 'Quadris +',
            description = 'Sometimes larger bricks may appear to make your job harder',
            bricks = {
                BRICK_I,
                BRICK_J,
                BRICK_L,
                BRICK_O,
                BRICK_S,
                BRICK_T,
                BRICK_Z,
                BRICK_RANDOM
            }
        },
        {
            code =  'random',
            title = 'All random!',
            description = 'Every brick is big and random. Just try to get the higher score possible!',
            bricks = {
                BRICK_RANDOM,
            }
        },
    }
    self.selected = 1
end

function SelectState:changeOption(position)
    if position < 1 then
        self.selected = #self.items
    elseif position > #self.items then
        self.selected = 1
    else
        self.selected = position
    end
end

function SelectState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            mode = self.items[self.selected]
        })
        
        gSounds['select']:stop()
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('a') or love.keyboard.wasPressed('left') then
        self:changeOption(self.selected -1)

        gSounds['select']:stop()
        gSounds['select']:play()
    end

    if love.keyboard.wasPressed('d') or love.keyboard.wasPressed('right') then
        self:changeOption(self.selected + 1)

        gSounds['select']:stop()
        gSounds['select']:play()
    end
    
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('start')

        gSounds['select']:stop()
        gSounds['select']:play()
    end
end

function SelectState:render()
    local descriptionWidth = 380

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Select mode", 0, VIRTUAL_HEIGHT / 3,
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('< '.. self.items[self.selected].title ..' >', VIRTUAL_WIDTH/2-(descriptionWidth/2), (VIRTUAL_HEIGHT / 3)+150,
    descriptionWidth, 'center')
    love.graphics.printf(self.items[self.selected].description, VIRTUAL_WIDTH/2-(descriptionWidth/2), (VIRTUAL_HEIGHT / 3)+200,
    descriptionWidth, 'center')
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press enter to return', 0, (VIRTUAL_HEIGHT / 3)+400,
    VIRTUAL_WIDTH, 'center')
end
