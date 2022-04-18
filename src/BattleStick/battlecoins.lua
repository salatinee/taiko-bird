BattleCoins = BaseCoins:new()

function BattleCoins:load()
    self:baseLoad()
    self.timerCreateCoin = 1
    self.durationCreateCoin = 1.5
end

function BattleCoins:update(dt)
    self:createCoinIfNeeded()
    self.timerCreateCoin = self.timerCreateCoin + dt
    self.timerCreateCoin = math.min(self.timerCreateCoin, self.durationCreateCoin)
    self.timer = self.timer + dt
    self.timer = math.min(self.timer, 0.1)
    for i, coin in ipairs(self.coins) do
        self:travelCoin(coin, dt)
        self:deleteCoinIfNeeded(i, coin)
    end
    if self.timer >= 0.1 then
        self.timer = 0
        for i, coin in ipairs(self.coins) do
            self:animateCoin(coin)
        end
    end
end

function BattleCoins:createCoinIfNeeded()
    if self.timerCreateCoin >= self.durationCreateCoin then
        local xRandom = math.random(0, love.graphics.getWidth() - self.imgs[1]:getWidth() * self.scale)
        self:createCoin(
            {x = xRandom, 
            y = -self.imgs[1]:getHeight() * self.scale, 
            ySpeed = 300}
        )
        self.timerCreateCoin = 0
    end
end

function BattleCoins:deleteCoinIfNeeded(i, coin)
    if coin.y >= love.graphics.getHeight() then
        self:deleteCoin(i, coin)
    end
end