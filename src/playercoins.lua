PlayerCoins = {}

function PlayerCoins:load()
    self.quantity = Save:read()["coins"]
    self.x = 3 * utils.vh
    self.y = 12 * utils.vh -- avoiding ad thing
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

function PlayerCoins:draw()
    love.graphics.draw(self.coin.img, self.coin.x, self.coin.y, 0, self.scale, self.scale)
    drawTextWithShadow({
        content = self.quantity,
        x = self.text.x,
        y = self.text.y,
        font = self.text.font,
    }, 3 * utils.vh / 4, 3 * utils.vh / 4)

end