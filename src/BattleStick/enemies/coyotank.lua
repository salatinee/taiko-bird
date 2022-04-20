Coyotank = BaseEnemyType:new()

function Coyotank:load()
    self.scale = 0.4 * utils.vh
    self.animation = {
        frames = {},
        duration = 0.5,
    }
    self.timer = 0
    self.wings = love.graphics.newImage('assets/tankasas.png')
    self.bimba = love.graphics.newImage('assets/tankbimba.png')
    self.bimbaAssetYCenter = self.bimba:getHeight() * 15.5 / 39
    for i = 0, 7 do
        local frame = love.graphics.newImage('assets/tankPELADO' .. i .. '.png')

        table.insert(self.animation.frames, frame)
    end
end

function Coyotank:createEnemy()
    local width = self.animation.frames[1]:getWidth() * self.scale
    local height = self.animation.frames[1]:getHeight() * self.scale
    local newEnemy = {
        width = width,
        height = height,
        x = math.random(width, love.graphics.getWidth() - width), -- cool
        y = -height / 2, -- cool
        ySpeed = 20 * utils.vh,
        xSpeed = 15 * utils.vw,
        rotation = 0,
        animation = self.animation,
        timer = 0,
        wingTimer = 0,
        timerChangeSide = 0,
        wing = self.wings,
        bimba = self.bimba,
    }

    newEnemy.shape = shapes.newPolygonShape(
        newEnemy.x + newEnemy.width * 0.2, newEnemy.y,
        newEnemy.x + newEnemy.width * 0.8, newEnemy.y,
        newEnemy.x + newEnemy.width * 0.8, newEnemy.y + newEnemy.height * 0.6,
        newEnemy.x + newEnemy.width * 0.2, newEnemy.y + newEnemy.height * 0.6
    )

    for key, value in pairs(BaseEnemyType:defaultFields()) do
        newEnemy[key] = value
    end

    self.__index = self
    setmetatable(newEnemy, self)
    
    return newEnemy
end

function Coyotank:isDead() 
    return self.hp == 0 
end


function Coyotank:moving(dt)
    if self.y < self.height / 3 then
        self:moveDownwards(dt)
        return
    end
    self:moveSideways(dt)
    self:changesSide(dt)
end

function Coyotank:changesSide(dt)
    if not self.randomDuration then
        self.randomDuration = math.random(0, 3)
    end
    self.timerChangeSide = self.timerChangeSide + dt
    self.timerChangeSide = math.min(self.timerChangeSide, self.randomDuration)
    if self.timerChangeSide >= self.randomDuration or self.x < self.width or self.x > love.graphics.getWidth() - self.width then
        self.timerChangeSide = 0
        self.xSpeed = -self.xSpeed 
        self.randomDuration = nil
    end
end

function Coyotank:moveSideways(dt)
    self.x = self.x + self.xSpeed * dt
end

function Coyotank:moveDownwards(dt)
    self.y = self.y + self.ySpeed * dt
end

function Coyotank:update(dt)
    print(self.x, self.y)
    self.timer = self.timer + dt
    self:moving(dt)
    self:calculateAngleToPlayer()
    self.shape:moveTo(self.x - self.width / 2, self.y + self.height / 2)
    self:gotHit()
    self:tryToPerformHitAnimation(dt)
end

function Coyotank:draw()
    self.shape:draw()
    local xCenter, yCenter = self.shape:center()
    local animationFrameIndex = math.floor(self.timer / self.animation.duration) % #self.animation.frames + 1
    local animationFrame = self.animation.frames[animationFrameIndex]
    local animationFrameAssetX = animationFrame:getWidth() / 2
    local animationFrameAssetY = animationFrame:getHeight() / 2
    love.graphics.draw(animationFrame, xCenter, yCenter, 0, self.scale, self.scale, animationFrameAssetX, animationFrameAssetY)
    love.graphics.draw(self.wing, xCenter, yCenter, 0, self.scale, self.scale, self.wing:getWidth() / 2, self.wing:getHeight() / 2)
    love.graphics.draw(self.bimba, xCenter, yCenter - 2 * utils.vh, self.rotation + 3 * math.pi / 2, self.scale, self.scale, self.bimba:getWidth() / 2, self.bimbaAssetYCenter)
end
