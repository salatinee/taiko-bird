
obstacles = {}

function obstacles:load()
    self.obstacles = {
        Obstacle.createObstacle(4)
    }

    -- -- Adicionar um obstacle no final
    -- table.insert(self.obstacles, Obstacle.createObstacle(123))

    -- -- Remover o primeiro obstacle
    -- table.remove(self.obstacles, 1)
end

function obstacles:update(dt)
    self:moveObstacles(dt)
    self:createObstacleIfNeeded()
    self:deleteObstacles()
end

function obstacles:draw()
    for i, obstacle in ipairs(self.obstacles) do
        Obstacle.drawObstacle(obstacle)
    end
end

function obstacles:reset()
    self.obstacles = {
        Obstacle.createObstacle(4)
    }
end

function obstacles:moveObstacles(dt)
    for i, obstacle in ipairs(self.obstacles) do
        Obstacle.moveObstacle(obstacle, dt)
    end
end

function obstacles:deleteObstacles()
    for i, obstacle in ipairs(self.obstacles) do
        if obstacle.top.x <= -obstacle.top.width then
            table.remove(self.obstacles, i)
        end
    end
end

function obstacles:createObstacleIfNeeded()
    local lastPipeX = self.obstacles[#self.obstacles].top.x + (self.obstacles[#self.obstacles].top.width + 175)

    if lastPipeX <= love.graphics.getWidth() then
        table.insert(self.obstacles, Obstacle.createObstacle(4))
    end
end