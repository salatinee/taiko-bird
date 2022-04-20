Boomba = BaseEnemyType:new()

-- static method
function Boomba:load()
    self.animationDuration = 1
    self.animationFrames = {}
    self.scale = 0.05 * utils.vh
    for i = 1, 10 do
        table.insert(self.animationFrames, love.graphics.newImage('assets/foguinho/boomba' .. i .. '.png'))
    end

    self.boom = love.graphics.newImage('assets/boom.png')
    self.boomScale = self.scale * 8
    self.boomWidth = self.boom:getWidth() * self.boomScale
    self.boomHeight = self.boom:getHeight() * self.boomScale
    self.boomAnimation = {}
    self.boomAnimationDuration = 1
    for i = 0, 11 do
        local quad = love.graphics.newQuad(96 * i, 0, 96, 96, self.boom:getDimensions())
        table.insert(self.boomAnimation, quad)
    end
end

function Boomba:createEnemy()
    local width = self.animationFrames[1]:getWidth() * self.scale
    local height = self.animationFrames[1]:getHeight() * self.scale
    local x = math.random(width, love.graphics.getWidth() - width) -- cool
    local y = -height
    local newBoomba = { -- cu
        timer = 0,
        exploding = false,
        explosionTimer = 0,
        rotation = math.pi / 2,
        width = width,
        height = height,
        x = x,
        y = y,
        xSpeed = 300, -- yeah
        ySpeed = -300, -- yeah
        shape = shapes.newPolygonShape(
            x, y,
            x + width, y,
            x + width, y + height,
            x, y + height
        ),
    }

    for key, value in pairs(BaseEnemyType:defaultFields()) do
        newBoomba[key] = value
    end

    self.__index = self
    setmetatable(newBoomba, self)

    return newBoomba
end

function Boomba:isDead()
    return self.explosionTimer >= self.boomAnimationDuration or self.hp == 0
end

function Boomba:update(dt)
    self.timer = self.timer + dt
    if self.exploding then
        self.explosionTimer = self.explosionTimer + dt
        self.explosionTimer = math.min(self.explosionTimer, self.boomAnimationDuration)
        return
    end
    self:followPlayer(dt)
    self:calculateAngleToPlayer()
    self:updateShape()
    self:gotHit()
    self:tryToPerformHitAnimation(dt)
    self:tryToExplode()
end

function Boomba:tryToExplode()
    if self:collidesWithPlayer() then
        self.exploding = true
    end
end

function Boomba:draw()
    self.shape:draw()

    local xCenter, yCenter = self.shape:center()

    -- Desenhar o Boomba indo reto pra baixo
    if self.exploding then
        local animationQuadIndex = math.floor(#self.boomAnimation * self.explosionTimer / self.boomAnimationDuration) % #self.boomAnimation + 1

        local animationQuad = self.boomAnimation[animationQuadIndex]
        local _, _, quadWidth, quadHeight = animationQuad:getViewport()
        local quadXCenter = quadWidth / 2
        local quadYCenter = quadHeight / 2
        love.graphics.draw(self.boom, animationQuad, xCenter, yCenter, 0, self.boomScale, self.boomScale, quadXCenter, quadYCenter)
        -- mas n era pr isso q n tava no centro
        -- n sei mt uhhh mas so qria teestar se funcinona

        return
    end
    local animationFrameIndex = math.floor(#self.animationFrames * self.timer / self.animationDuration) % #self.animationFrames + 1
    local animationFrame = self.animationFrames[animationFrameIndex]

    local frameAssetXCenter = animationFrame:getWidth() / 2
    local frameAssetYCenter = animationFrame:getHeight() / 2
    
    love.graphics.draw(animationFrame, xCenter, yCenter, self.rotation, self.scale, self.scale, frameAssetXCenter, frameAssetYCenter)
end
