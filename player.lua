
Player = {}

function Player:load()
    self.img = love.graphics.newImage("assets/ekiBirb.png")
    self.scale = 0.25
    self.width = self.img:getWidth() * self.scale
    self.height = self.img:getHeight() * self.scale

    self.x = 200
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.yAcceleration = 700
    self.ySpeed = -20

    self.rotation = 0
    self.rotationSpeed = 0
    self.rotationAcceleration = 4
end

function Player:update(dt)
    objectGravity(Player, dt)
    self:playerScreenCollision()
    
    if gameState == "inGame" then
        objectRotation(Player, dt)
        self:playerObstacleCollision()
    end
end

function objectGravity(object, dt)
    object.ySpeed = object.ySpeed + object.yAcceleration * dt 
    object.y = object.y + object.ySpeed * dt
end

function objectRotation(object, dt)
    object.rotationSpeed = object.rotationSpeed + object.rotationAcceleration * dt
    local rotation = object.rotation + object.rotationSpeed * dt
    object.rotation = clamp(-math.pi / 4, rotation, math.pi / 2)

    if Player.rotation == (-math.pi / 4) then
        Player.rotationSpeed = math.max(-1.5, Player.rotationSpeed)
    end
end

function Player:playerScreenCollision()
    if Player.y <= 0 then
        Player.y = 0
        Player.ySpeed = 0

    elseif Player.y + Player.height >= love.graphics.getHeight() then
        Player.y = love.graphics.getHeight() - Player.height
        GameOver:gameOver()

    end
end

function Player:draw()
    local assetCenterX = self.img:getWidth() / 2
    local assetCenterY = self.img:getHeight() / 2

    local centerX = self.x + (self.width / 2)
    local centerY = self.y + (self.height / 2)

    love.graphics.draw(self.img, centerX, centerY, self.rotation, self.scale, self.scale, assetCenterX, assetCenterY)
    -- love.graphics.rectangle("line", Player.x, Player.y, Player.width, Player.height)
end

function Player:jump()
    Player.ySpeed = -350
    Player.rotationSpeed = -2.5
end

function Player:playerObstacleCollision()
    for i, obstacle in ipairs(obstacles.obstacles) do
        if Obstacle.checkObstacleCollision(Player, obstacle) then
            GameOver:gameOver()
        end
    end
end
