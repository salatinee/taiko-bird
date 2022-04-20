
ClassicObstacles = {}

function ClassicObstacles:load()
    self.obstacles = {
        ClassicObstacle.createObstacle(4)
    }

    -- -- Adicionar um obstacle no final
    -- table.insert(self.obstacles, ClassicObstacle.createObstacle(123))

    -- -- Remover o primeiro obstacle
    -- table.remove(self.obstacles, 1)
end

function ClassicObstacles:update(dt)
    self:moveObstacles(dt)
    self:createObstacleIfNeeded()
    self:deleteObstacles()
    self:checkIfPlayerScored()
end

function ClassicObstacles:draw()
    for i, obstacle in ipairs(self.obstacles) do
        ClassicObstacle.drawObstacle(obstacle)
    end
end

function ClassicObstacles:reset()
    self.obstacles = {
        ClassicObstacle.createObstacle(4)
    }
end

function ClassicObstacles:moveObstacles(dt)
    for i, obstacle in ipairs(self.obstacles) do
        ClassicObstacle.moveObstacle(obstacle, dt)
    end
end

function ClassicObstacles:deleteObstacles()
    for i, obstacle in ipairs(self.obstacles) do
        if obstacle.top.x <= -obstacle.top.width then
            table.remove(self.obstacles, i)
        end
    end
end

function ClassicObstacles:createObstacleIfNeeded()
    local lastPipeX = self.obstacles[#self.obstacles].top.x + (self.obstacles[#self.obstacles].top.width + 175)

    if lastPipeX <= love.graphics.getWidth() then
        table.insert(self.obstacles, ClassicObstacle.createObstacle(4))
    end
end

function ClassicObstacles:checkIfPlayerScored()
    for i, obstacle in ipairs(ClassicObstacles.obstacles) do
        if not obstacle.wasSeen and obstacle.top.x <= ClassicPlayer.x then
            obstacle.wasSeen = true

            ClassicScore:onPlayerScored()
        end
    end
end