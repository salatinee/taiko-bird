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
    newObstacle.id = math.random(0, #self.imgs)
    newObstacle.img = self.typesOfObstacles[newObstacle.id].img
    newObstacle.type = self.typesOfObstacles[newObstacle.id].type
    newObstacle.width = newObstacle.img:getWidth() * self.scale
    newObstacle.height = newObstacle.img:getHeight() * self.scale
    newObstacle.y = -newObstacle.height / 2
    local x = math.random(newObstacle.width, love.graphics.getWidth() - newObstacle.width)
    while self:isCollisionedWithOtherObstacle({x = x, y = newObstacle.y, width = newObstacle.width, height = newObstacle.height}) do
        x = math.random(newObstacle.width, love.graphics.getWidth() - newObstacle.width)
    end
    newObstacle.x = x
    newObstacle.rotation = 0
    newObstacle.ySpeed = -20 * utils.vh
    newObstacle.shape = shapes.newPolygonShape(
        newObstacle.x, newObstacle.y,
        newObstacle.x + newObstacle.width, newObstacle.y,
        newObstacle.x + newObstacle.width, newObstacle.y + newObstacle.height,
        newObstacle.x, newObstacle.y + newObstacle.height
    )
    table.insert(self.obstacles, newObstacle)
end

function BattleObstacles:isCollisionedWithOtherObstacle(obstacle)
    if self.obstacles[1] then
        for i, otherObstacle in ipairs(self.obstacles) do
            if obstacle ~= otherObstacle and checkCollision(obstacle, otherObstacle)
                    return true
                end
            end
        end
    end
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
    for i, obstacle in ipairs(self.obstacles) do
        self:updateObstacle(obstacle, dt)
    end
end

function BattleObstacles:updateObstacle(obstacle, dt)
    self:moveObstacle(obstacle, dt)
    self:deleteObstacleIfNeeded(obstacle)
end

function BattleObstacles:moveObstacle(obstacle, dt)
    obstacle.y = obstacle.y + obstacle.ySpeed * dt
end

function BattleObstacles:deleteObstacle(obstacle)
    table.remove(self.obstacles, obstacle.id)
end

function BattleObstacles:deleteObstacleIfNeeded(obstacle)
    if obstacle.y - obstacle.height / 2 >= love.graphics.getHeight() then
        self:deleteObstacle(obstacle)
    end
end