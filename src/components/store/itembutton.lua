ItemButton = {}
setmetatable(ItemButton, {__index = Button})

function ItemButton:new(options)
    local img = love.graphics.newImage('assets/store/item-button.png')
    local pressedImg = love.graphics.newImage('assets/store/item-button-pressed.png')
    local buttonOptions = {
        x = options.x,
        y = options.y,
        type = options.type,
        scale = options.scale,
        img = img,
        pressedImg = pressedImg,
    }
    local newItemButton = Button:new(buttonOptions)
    self.__index = self
    setmetatable(newItemButton, self)

    newItemButton.price = options.price
    newItemButton.type = options.type
    newItemButton.font = love.graphics.newFont("assets/Pixeled.ttf", 1.75 * utils.vh)
    newItemButton.coin = love.graphics.newImage("assets/coin0.png")
    newItemButton.toDress = love.graphics.newImage('assets/store/big-to-dress.png')
    newItemButton.check = love.graphics.newImage('assets/store/big-check.png')

    return newItemButton
end

function ItemButton:drawItemPrice()
    local xAdjustment = 2 * utils.vw -- 21.5
    local coinScale = 0.025 * utils.vh -- 0.17
    local coinWidth = self.coin:getWidth() * coinScale
    local coinHeight = self.coin:getHeight() * coinScale
    love.graphics.print(self.price, self.font, self.x + self.width / 2 - self.font:getWidth(self.price) / 2 + xAdjustment, self.y + self.height / 2 - self.font:getHeight(price) * 0.6)
    love.graphics.draw(self.coin, self.x + self.width / 2 - coinWidth / 2 - xAdjustment, self.y + self.height / 2 - coinHeight / 2, 0, coinScale, coinScale)
end

function ItemButton:drawBoughtIcon()
    local toDressScale = 0.015 * utils.vh 
    local toDressWidth = self.toDress:getWidth() * toDressScale
    local toDressHeight = self.toDress:getHeight() * toDressScale
    love.graphics.draw(self.toDress, self.x + self.width / 2 - toDressWidth / 2, self.y + self.height / 2 - toDressHeight / 2, 0, toDressScale, toDressScale)
end

function ItemButton:drawEquippedIcon()
    local checkScale = 0.01 * utils.vh
    local checkWidth = self.check:getWidth() * checkScale
    local checkHeight = self.check:getHeight() * checkScale
    love.graphics.draw(self.check, self.x + self.width / 2 - checkWidth / 2, self.y + self.height / 2 - checkHeight / 2, 0, checkScale, checkScale)
end

function ItemButton:draw()
    Button.draw(self)

    if self.type == 'BUY' then
        self:drawItemPrice()
    elseif self.type == 'BOUGHT' then
        self:drawBoughtIcon()
    else
        self:drawEquippedIcon()
    end
end