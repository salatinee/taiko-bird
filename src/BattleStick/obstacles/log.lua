Log = BaseBattleObstacleType:new()

function Log:load()
    self.img = love.graphics.newImage("assets/log.png")
    self.scale = 0.4 * utils.vh
end

function Log:new()
    local width = self.img:getWidth() * self.scale
    local height = self.img:getHeight() * self.scale
    local x = math.random(width / 2, love.graphics.getWidth() - width / 2)
    local y = -height / 2
    while self.isCollisionedWithOtherCoin({x = x, y = y, width = width, height = height}) do
        x = math.random(width / 2, love.graphics.getWidth() - width / 2)
    end
    newLog = {
            width = width,
            height = height,
            x = x,
            y = y,
            rotation = 0,
            randomScale = {1, -1}[math.random(1, 2)],
            scale = self.scale * randomScale,
            ySpeed = 60 * utils.vh,
            shape = shapes.newPolygonShape(
                x, y, 
                x + width, y,
                x + width, y + height,
                x, y + height
            )
        }

    self.__index = self
    setmetatable(newLog, self)
    return newLog
end

function Log:update(dt)
    self:move(dt)
    self.shape:moveTo(self.x - self.width / 2, self.y + self.height / 2)
end

function Log:draw()
    local xCenter, yCenter = self.shape:center()
    local AssetXCenter = self.img:getWidth()
    local AssetYCenter = self.img:getHeight()
    love.graphics.draw(self.img, xCenter, yCenter, self.rotation, self.scale, self.scale, AssetXCenter, AssetYCenter)
end