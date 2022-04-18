BaseCoins = {}

function BaseCoins:new()
    local newCoins = {}
    
    self.__index = self
    setmetatable(newCoins, self)
    return newCoins
end

function BaseCoins:baseLoad()
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

function BaseCoins:createCoin(options)
    local coin = {}
    coin.x = options.x
    coin.y = options.y
    coin.xSpeed = options.xSpeed or 0
    coin.ySpeed = options.ySpeed or 0
    coin.obstacle = options.obstacle or nil
    coin.i = 1
    coin.imgs = self.imgs
    coin.width = self.imgs[1]:getWidth() * self.scale
    coin.height = self.imgs[1]:getHeight() * self.scale
    table.insert(self.coins, coin)
end

function BaseCoins:update(dt)
    error("must be implemented by instances")
    -- self:createCoinIfNeeded()
    -- self.timer = self.timer + dt
    -- self.timer = math.min(self.timer, 0.1)
    -- for i, coin in ipairs(self.coins) do
    --     self:moveCoin(coin)
    --     self:deleteCoinIfNeeded(i, coin)
    -- end
    -- if self.timer >= 0.1 then
    --     self.timer = 0
    --     for i, coin in ipairs(self.coins) do
    --         self:animateCoin(coin)
    --     end
    -- end
end

function BaseCoins:createCoinIfNeeded()
    error("must be implemented by instances")
end

function BaseCoins:deleteCoinIfNeeded(i, coin)
    error("must be implemented by instances")
end

function BaseCoins:deleteCoin(i, coin)
    table.remove(self.coins, i)
end

function BaseCoins:moveCoin(coin, x, y)
    coin.x = x or coin.x
    coin.y = y or coin.y
end

function BaseCoins:travelCoin(coin, dt)
    coin.x = coin.x + coin.xSpeed * dt
    coin.y = coin.y + coin.ySpeed * dt
end

function BaseCoins:animateCoin(coin)
    coin.i = coin.i + 1
    if coin.i > #coin.imgs then
        coin.i = 1
    end
end

function BaseCoins:checkCoinCollision(player, i, coin)
    if checkCollision(player, coin) then
        self:collectCoin(i, coin)
        return true
    end
    return false
end

function BaseCoins:collectCoin(i, coin)
    PlayerCoins.quantity = PlayerCoins.quantity + 1
    self.bing:play() -- eba bing!
    self:deleteCoin(i, coin)
end

function BaseCoins:drawCoin(coin)
    love.graphics.draw(coin.imgs[coin.i], coin.x, coin.y, 0, self.scale, self.scale)
end

function BaseCoins:draw()
    for i, coin in ipairs(self.coins) do
        self:drawCoin(coin)
    end
end

function BaseCoins:reset()
    self.coins = {}
end