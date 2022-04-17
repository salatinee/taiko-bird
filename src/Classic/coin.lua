Coin = {}

function Coin:load()
    self.coins = {}
    self.imgs = {
        love.graphics.newImage("assets/coin0.png"),
        love.graphics.newImage("assets/coin1.png"),
        love.graphics.newImage("assets/coin2.png"),
        love.graphics.newImage("assets/coin3.png"),
    }
    self.timer = 0
    self.scale = 0.05 * utils.vh -- 0.33
    self.bing = love.audio.newSource("assets/coinbing.wav", "static")
    self.bing:setVolume(0.25)
end

function Coin:update(dt)
    self:createCoinsIfNeeded()
    self.timer = self.timer + dt
    self.timer = math.min(self.timer, 0.1)
    for i, coin in ipairs(self.coins) do
        self:move(coin)
        self:deleteCoinsIfNeeded(i, coin)
    end
    if self.timer >= 0.1 then
        self.timer = 0
        for i, coin in ipairs(self.coins) do
            self:animate(coin)
        end
    end
end

function Coin:createCoin(x, y, obstacle)
    local coin = {}
    coin.x = x
    coin.y = y
    coin.obstacle = obstacle
    coin.i = 1
    coin.imgs = self.imgs
    coin.width = self.imgs[1]:getWidth() * self.scale
    coin.height = self.imgs[1]:getHeight() * self.scale
    table.insert(self.coins, coin)
end

function Coin:createCoinsIfNeeded()
    for i, obstacle in ipairs(ClassicObstacles.obstacles) do
        if not obstacle.hasCoin then
            obstacle.hasCoin = true
            local obstacleMiddleX = obstacle.bottom.x + obstacle.bottom.width / 2 - self.imgs[1]:getWidth() * self.scale / 2
            local obstacleMiddleY = (obstacle.top.y + obstacle.bottom.y) / 2 - self.imgs[1]:getHeight() * self.scale / 2
            self:createCoin(obstacleMiddleX, obstacleMiddleY, obstacle)
        end
    end
end

function Coin:deleteCoinsIfNeeded(i, coin)
    if coin.x <= coin.obstacle.bottom.width / 2 - self.imgs[1]:getWidth() * self.scale then
        self:delete(i, coin)
    end
end

function Coin:delete(i, coin)
    table.remove(self.coins, i)
end

function Coin:move(coin)
    coin.x = coin.obstacle.bottom.x + coin.obstacle.bottom.width / 2 - self.imgs[1]:getWidth() * self.scale / 2
end

function Coin:animate(coin)
    coin.i = coin.i + 1
    if coin.i > #coin.imgs then
        coin.i = 1
    end
end

function Coin:checkCoinCollision(player, i, coin)
    if checkCollision(player, coin) then
        Coin:collect(i, coin)
        return true
    end
    return false
end

function Coin:collect(i, coin)
    Coins.quantity = Coins.quantity + 1
    self.bing:play() -- eba bing!
    self:delete(i, coin)
end

function Coin:drawEach(coin)
    love.graphics.draw(coin.imgs[coin.i], coin.x, coin.y, 0, self.scale, self.scale)
end

function Coin:draw()
    for i, coin in ipairs(self.coins) do
        self:drawEach(coin)
    end
end

function Coin:reset()
    self.coins = {}
end