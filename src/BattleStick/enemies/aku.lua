Aku = BaseEnemyType:new()

function Aku:load()
    self.scale = 0.025 * utils.vh
    self.img = love.graphics.newImage('assets/akuBirb.png')
    self.capeAnimation = {
        frames = {},
        duration = 1,
    }
    self.timer = 0

    for i = 0, 23 do
        local frame = love.graphics.newImage('assets/aku-cape-' .. i .. '.png')

        table.insert(self.capeAnimation.frames, frame)
    end
end

function Aku:createEnemy()
    local width = self.img:getWidth() * self.scale
    local height = self.img:getHeight() * self.scale
    local newEnemy = {
        width = width,
        height = height,
        x = math.random(width, love.graphics.getWidth() - width), -- cool
        y = -height / 2, -- cool
        ySpeed = -20 * utils.vh,
        xSpeed = 40 * utils.vw,
        rotation = math.pi / 2,
    }

    newEnemy.shape = shapes.newPolygonShape(
        newEnemy.x, newEnemy.y,
        newEnemy.x + newEnemy.width, newEnemy.y,
        newEnemy.x + newEnemy.width, newEnemy.y + newEnemy.height,
        newEnemy.x, newEnemy.y + newEnemy.height
    )

    newEnemy.canvas = love.graphics.newCanvas(2 * newEnemy.width, newEnemy.height)

    for key, value in pairs(BaseEnemyType:defaultFields()) do
        newEnemy[key] = value
    end

    self.__index = self
    setmetatable(newEnemy, self)

    return newEnemy
end

function Aku:isDead()
    return self.hp == 0 or self.y > love.graphics.getHeight() + self.height
end

function Aku:update(dt)
    self.timer = self.timer + dt
    self:followPlayer(dt) 
    self:calculateAngleToPlayer()
    self:updateShape()
    self:gotHit()
    self:tryToPerformHitAnimation(dt)
end

function Aku:draw()
    local enemyPositionInCanvas = {
        x = self.canvas:getWidth() / 2 - self.width / 2,
        y = 0,
    }

    local capeAnimationTime = math.fmod(self.timer, self.capeAnimation.duration)
    local capeAnimationFrameIndex = math.ceil(capeAnimationTime / self.capeAnimation.duration * #self.capeAnimation.frames)
    local capeAnimationFrame = self.capeAnimation.frames[capeAnimationFrameIndex]

    local capePositionInCanvas = {
        -- Desenhar de modo que a parte da direita da capa fique em 30% da width do corpo
        x = enemyPositionInCanvas.x + self.width * 0.3 - capeAnimationFrame:getWidth() * self.scale,
        y = 0,
    }
    self.canvas:renderTo(function()
        love.graphics.clear()
        love.graphics.setColor(1, 1 * self.hitAnimation.greenMultiplier, 1 * self.hitAnimation.blueMultiplier)
        love.graphics.draw(self.img, enemyPositionInCanvas.x, enemyPositionInCanvas.y, 0, self.scale, self.scale)

        love.graphics.draw(capeAnimationFrame, capePositionInCanvas.x, capePositionInCanvas.y, 0, self.scale, self.scale)
        love.graphics.setColor(1,1,1)
    end)

    local canvasPosition = {
        x = self.x + self.width / 2 - self.canvas:getWidth() / 2,
        y = self.y - self.canvas:getHeight() / 2,
    }

    local canvasAssetCenter = {
        x = self.canvas:getWidth() / 2,
        y = self.canvas:getHeight() / 2,
    }
    love.graphics.draw(self.canvas, canvasPosition.x, canvasPosition.y, self.rotation, 1, 1, canvasAssetCenter.x, canvasAssetCenter.y)
end