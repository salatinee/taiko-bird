BaseBattleObstacleType = {}

function BaseBattleObstacleType:new()
    newBattleObstacleType = {}
    self.__index = self
    setmetatable(newBattleObstacleType, self)
    return newBattleObstacleType
end

function BaseBattleObstacleType:move(dt)
    -- obstacles only move down!
    self.y = self.y + self.ySpeed * dt
end

function BaseBattleObstacleType:moveShape()
    self.shape:moveTo(self.x - self.width / 2, self.y + self.height / 2)
end

function BaseBattleObstacleType:isCollisionedWithOtherCoin(preobstacle)
    for i, coin in ipairs(BattleCoins.coins) do
        if checkCollision(preobstacle, coin) then
            return true
        end
    end
    return false
end

function BaseBattleObstacleType:isCollisionedWithPlayer(player)
    return self.shape:collidesWith(player.shape) 
end