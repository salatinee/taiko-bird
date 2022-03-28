
Pipe = {}

function Pipe.createPipe(modifier, alignment, yAdjustment)
    local newPipe = {}
    newPipe.img = love.graphics.newImage("assets/stick.png")
    newPipe.faceImg = love.graphics.newImage("assets/stick-face.png")

    newPipe.scale = 0.15 * utils.vh -- idk
    newPipe.speed = 34.5 * utils.vh -- 250

    if utils.isMobile then
        newPipe.speed = newPipe.speed * 0.8
    end

    newPipe.width = newPipe.img:getWidth() * newPipe.scale

    newPipe.faceWidth = newPipe.faceImg:getWidth() * newPipe.scale
    newPipe.faceHeight = newPipe.faceImg:getHeight() * newPipe.scale

    newPipe.x = love.graphics.getWidth() + newPipe.width + (55.55 * utils.vh) 
    - (14 * utils.vh * modifier) -- 400 - (100 * modifier)
    
    newPipe.alignment = alignment
    
    assert(alignment == "top" or alignment == "bottom", "alignment must be top or bottom!")

    if alignment == "top" then
        newPipe.height = love.graphics.getHeight() * 0.33 - yAdjustment
        -- No pipe com alinhamento pra cima, o campo y indica a posição vertical da parte
        -- de baixo do pipe - ou seja, ele vai de 0 até newPipe.height
        newPipe.y = newPipe.height

    
        newPipe.shape = shapes.newPolygonShape(
            newPipe.x, 0,
            newPipe.x + newPipe.width, 0,
            newPipe.x + newPipe.width, newPipe.y - 4 * utils.vh,
            newPipe.x + newPipe.width * 0.8, newPipe.y - 1.375 * utils.vh, 
            newPipe.x + newPipe.width * 0.6, newPipe.y - 0.275 * utils.vh,   
            newPipe.x + newPipe.width * 0.55, newPipe.y - 0.2 * utils.vh,  
            newPipe.x + newPipe.width / 2, newPipe.y,
            newPipe.x + newPipe.width * 0.45, newPipe.y - 0.2 * utils.vh,  
            newPipe.x + newPipe.width * 0.4, newPipe.y - 0.275 * utils.vh,   
            newPipe.x + newPipe.width * 0.2, newPipe.y - 1.375 * utils.vh,
            newPipe.x, newPipe.y - 4 * utils.vh
        )

    else
        newPipe.height = love.graphics.getHeight() * 0.33 + yAdjustment
        -- Eu tirei o - yAdjustment daqui e do newPipe.y de baixo tbm
        newPipe.y = love.graphics.getHeight() - newPipe.height

        newPipe.shape = shapes.newPolygonShape(
            newPipe.x, newPipe.y + 4 * utils.vh,
            newPipe.x + newPipe.width * 0.2, newPipe.y + 1.375 * utils.vh,
            newPipe.x + newPipe.width * 0.4, newPipe.y + 0.275 * utils.vh,   
            newPipe.x + newPipe.width * 0.45, newPipe.y + 0.2 * utils.vh,  
            newPipe.x + newPipe.width / 2, newPipe.y,
            newPipe.x + newPipe.width * 0.55, newPipe.y + 0.2 * utils.vh,  
            newPipe.x + newPipe.width * 0.6, newPipe.y + 0.275 * utils.vh,   
            newPipe.x + newPipe.width * 0.8, newPipe.y + 1.375 * utils.vh, 
            newPipe.x + newPipe.width, newPipe.y + 4 * utils.vh, 
            newPipe.x + newPipe.width, newPipe.y + newPipe.height, 
            newPipe.x, newPipe.y + newPipe.height
        )

    end 

    newPipe.yAdjustment = yAdjustment

    return newPipe
end

function Pipe.movePipe(pipe, dt)
    pipe.x = pipe.x - pipe.speed * dt
    pipe.shape:move(-pipe.speed * dt, 0)
end


function Pipe.drawPipe(pipe)
    local angle = 0
    if pipe.alignment == "top" then
        angle = math.pi
        local endX = pipe.x + pipe.width
        love.graphics.draw(pipe.img, endX, pipe.y, angle, pipe.scale, pipe.scale)
    else
        love.graphics.draw(pipe.img, pipe.x, pipe.y, angle, pipe.scale, pipe.scale)
    end

    -- Representa a posição vertical da carinha quando ela está na parte de cima da tela
    local stickFaceCloseToScreenTopY = 5 * utils.vh
        
    -- E essa a posição de quando ele está junto a parte de baixo da tela
    local stickFaceCloseToScreenBottomY = love.graphics.getHeight() - pipe.faceHeight - 5 * utils.vh

    local faceY = 0
    if pipe.alignment == "top" then
        faceY = stickFaceCloseToScreenTopY
    else
        faceY = stickFaceCloseToScreenBottomY
    end

    local shouldDrawFace = pipe.yAdjustment == 0 or (
        pipe.alignment == "top" and pipe.yAdjustment < 0
        or pipe.alignment == "bottom" and pipe.yAdjustment > 0
    )

    if shouldDrawFace then
        love.graphics.draw(pipe.faceImg, pipe.x, faceY, 0, pipe.scale, pipe.scale)
    end

    -- pipe.shape:draw()
end

function Pipe.getBoundingBox(pipe)
    -- eba local
    local values = {}

    values.x = pipe.x
    values.width = pipe.width
    values.height = pipe.height
    
    if pipe.alignment == "bottom" then
        values.y = pipe.y
    else
        values.y = 0
    end
    
    return values
end


function Pipe.checkPipeCollision(a, b)
    return a.shape:collidesWith(b.shape)
    --[[ b = Pipe.getBoundingBox(b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    else
        return false
    end ]]
end
