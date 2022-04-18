ClassicCoins = BaseCoins:new()

function ClassicCoins:load()
    self:baseLoad()
end

function ClassicCoins:update(dt)
    self:createCoinIfNeeded()
    self.timer = self.timer + dt
    self.timer = math.min(self.timer, 0.1)
    for i, coin in ipairs(self.coins) do
        self:moveCoin(coin, coin.obstacle.bottom.x + coin.obstacle.bottom.width / 2 - self.imgs[1]:getWidth() * self.scale / 2)
        self:deleteCoinIfNeeded(i, coin)
    end
    if self.timer >= 0.1 then
        self.timer = 0
        for i, coin in ipairs(self.coins) do
            self:animateCoin(coin)
        end
    end
end

function ClassicCoins:createCoinIfNeeded()
    for i, obstacle in ipairs(ClassicObstacles.obstacles) do
        if not obstacle.hasCoin then
            obstacle.hasCoin = true
            local obstacleMiddleX = obstacle.bottom.x + obstacle.bottom.width / 2 - self.imgs[1]:getWidth() * self.scale / 2
            local obstacleMiddleY = (obstacle.top.y + obstacle.bottom.y) / 2 - self.imgs[1]:getHeight() * self.scale / 2
            self:createCoin({x = obstacleMiddleX, y = obstacleMiddleY, obstacle = obstacle})
        end
    end
end

function ClassicCoins:deleteCoinIfNeeded(i, coin)
    if coin.x <= coin.obstacle.bottom.width / 2 - self.imgs[1]:getWidth() * self.scale then
        self:deleteCoin(i, coin)
    end
end