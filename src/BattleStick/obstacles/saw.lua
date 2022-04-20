Saw = BaseBattleObstacleType:new()

function Saw:load()
    self.img = love.graphics.newImage("assets/saw.png")
    self.scale = 0.4 * utils.vh
    self.animationDuration = 0.5
end

function Saw:new()
    local width = self.img:getWidth() * self.scale
    local height = self.img:getHeight() * self.scale
    local x = math.random(width / 2, love.graphics.getWidth() - width / 2)
    local y = -height / 2
    while self.isCollisionedWithOtherCoin({x = x, y = y, width = width, height = height}) do
        x = math.random(width / 2, love.graphics.getWidth() - width / 2)
    end
    newSaw = {
        width = width,
        height = height,
        x = x,
        y = y,
        rotation = 0,
        ySpeed = 60 * utils.vh,
        shape = shapes.newPolygonShape(
            x, y, 
            x + width, y,
            x + width, y + height,
            x, y + height
        )
    }
    
    self.__index = self
    setmetatable(newSaw, self)
    return newSaw
end

function Saw:update(dt)
    self:move(dt)
    self:rotate(dt)
    self:updateShape()
end

function Saw:updateShape()
    self.shape:moveTo(self.x - self.width / 2, self.y + self.height / 2)
    self.shape:rotation(self.rotation)
end

function Saw:rotate(dt)
    self.rotation = self.rotation + dt * math.pi / 36
end

function Saw:draw()
    local xCenter, yCenter = self.shape:center()
    local AssetXCenter = self.img:getWidth()
    local AssetYCenter = self.img:getHeight()

    love.graphics.draw(self.img, xCenter, yCenter, self.rotation, self.scale, self.scale, AssetXCenter, AssetYCenter)
end