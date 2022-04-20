BaseBattleObstacleType = {}

function BaseBattleObstacleType:new()
    newBattleObstacleType = {}
    self.__index = self
    setmetatable(newBattleObstacleType, self)
    return newBattleObstacleType
end

function BaseBattleObstacleType:moveObstacle(obstacle, dt)
    obstacle.y = obstacle.y + obstacle.ySpeed * dt
end