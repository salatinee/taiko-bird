Coins = {}

function Coins:load()
    self.quantity = Save:read()["coins"]
    self.x = 3 * utils.vh
    self.y = 10 * utils.vh -- avoiding ad thing
    self.scale = 0.03 * utils.vh -- 0.2

    local coinImg = love.graphics.newImage("assets/coin0.png")
    self.coin = {
        img = coinImg,
        x = self.x,
        y = self.y,
        width = coinImg:getWidth() * self.scale,
        height = coinImg:getHeight() * self.scale,
    }
    
    self.text = {
        font = love.graphics.newFont("assets/Pixeled.ttf", 3 * utils.vh),
        x = self.x + self.coin.width + 2 * utils.vw,
        y = self.y,
    }
end

function Coins:draw()
    local fontBackgroundOffset = utils.vh / 2
    local yAdjustment = self.text.font:getHeight(self.quantity) * 0.4
    love.graphics.draw(self.coin.img, self.coin.x, self.coin.y, 0, self.scale, self.scale)
    love.graphics.print({{0, 0, 0, 1}, self.quantity}, self.text.font, self.text.x + fontBackgroundOffset, self.text.y + fontBackgroundOffset - yAdjustment)
    love.graphics.print(self.quantity, self.text.font, self.text.x, self.text.y - yAdjustment)
end