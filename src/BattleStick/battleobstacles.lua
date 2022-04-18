BattleObstacles = {}

function BattleObstacles:load()
    self.obstacles = {}
    self.typesOfObstacles = {}
    for img = 0, 2 do
        table.insert(self.typesOfObstacles, {img = love.graphics.newImage("assets/obstacle" .. img .. ".png"), type = "saw"})
    end
    self.scale = 0.025 * utils.vh    
end

function BattleObstacles:createObstacle()
    local newObstacle = {}
    newObstacle.id = math.random(1, #self.typesOfObstacles)
    newObstacle.img = self.typesOfObstacles[newObstacle.id].img
    newObstacle.type = self.typesOfObstacles[newObstacle.id].type
    newObstacle.width = newObstacle.img:getWidth() * self.scale
    newObstacle.height = newObstacle.img:getHeight() * self.scale
    newObstacle.y = -newObstacle.height / 2
    local x = math.random(newObstacle.width, love.graphics.getWidth() - newObstacle.width)
    while self:isCollisionedWithOtherObstacleOrCoin({x = x, y = newObstacle.y, width = newObstacle.width, height = newObstacle.height}) do
        x = math.random(newObstacle.width, love.graphics.getWidth() - newObstacle.width)
    end
    newObstacle.x = x
    newObstacle.rotation = 0
    newObstacle.ySpeed = 20 * utils.vh
    newObstacle.shape = shapes.newPolygonShape(
        newObstacle.x, newObstacle.y,
        newObstacle.x + newObstacle.width, newObstacle.y,
        newObstacle.x + newObstacle.width, newObstacle.y + newObstacle.height,
        newObstacle.x, newObstacle.y + newObstacle.height
    )
    table.insert(self.obstacles, newObstacle)
end

function BattleObstacles:createObstacleIfNeeded()
    local lastObstacle = self.obstacles[#self.obstacles]

    -- TODO melhorar a condicao eu acho n sei se é assim o melhor jeito
    -- se não tiver nenhum obstacle ainda, ou ele estiver abaixo de 30% da tela, criar um novo
    if lastObstacle == nil or lastObstacle.y >= 0.3 * love.graphics.getHeight() then
        self:createObstacle()
    end
end

function BattleObstacles:isCollisionedWithOtherObstacleOrCoin(obstacle)
    if self:isCollisionedWithOtherObstacle(obstacle) or self:isCollisionedWithOtherCoin(obstacle) then
        return true
    end
    return false
end

function BattleObstacles:isCollisionedWithOtherObstacle(obstacle)
    if self.obstacles[1] then
        for i, otherObstacle in ipairs(self.obstacles) do
            if obstacle ~= otherObstacle and checkCollision(obstacle, otherObstacle) then
                return true
            end
        end
    end
    return false
end

function BattleObstacles:isCollisionedWithOtherCoin(obstacle)
    for i, coin in ipairs(BattleCoins.coins) do
        if checkCollision(obstacle, coin) then
            return true
        end
    end
    return false
end

function BattleObstacles:isCollisionedWithPlayer(obstacle, player)
    if obstacle.shape:collidesWith(player.shape) then
        return true
    end
    return false
end

function BattleObstacles:updateShape(obstacle)
    obstacle.shape:moveTo(obstacle.x + obstacle.width / 2, obstacle.y + obstacle.height / 2)
    obstacle.shape:setRotation(obstacle.rotation)
end

function BattleObstacles:update(dt)
    self:createObstacleIfNeeded()

    for i, obstacle in ipairs(self.obstacles) do
        self:updateObstacle(i, obstacle, dt)
    end
end

function BattleObstacles:updateObstacle(index, obstacle, dt)
    self:moveObstacle(obstacle, dt)
    self:deleteObstacleIfNeeded(index, obstacle)
end

function BattleObstacles:moveObstacle(obstacle, dt)
    obstacle.y = obstacle.y + obstacle.ySpeed * dt
end

function BattleObstacles:deleteObstacle(index)
    table.remove(self.obstacles, index)
end

function BattleObstacles:deleteObstacleIfNeeded(index, obstacle)
    if obstacle.y - obstacle.height / 2 >= love.graphics.getHeight() then
        self:deleteObstacle(index)
    end
end

function BattleObstacles:drawObstacle(obstacle)
    love.graphics.draw(obstacle.img, obstacle.x, obstacle.y, obstacle.rotation, self.scale, self.scale, obstacle.width / 2, obstacle.height / 2)
end

function BattleObstacles:draw()
    for i, obstacle in ipairs(self.obstacles) do
        self:drawObstacle(obstacle)
    end
end
