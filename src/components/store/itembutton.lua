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
    local xCenter = self.x + self:getWidth() / 2
    local xAdjustment = 2 * utils.vw -- 21.5
    -- Fazer o icone preencher 90% da altura do botão
    local coinScale = 0.9 * self:getHeight() / self.coin:getHeight() 
    local coinWidth = self.coin:getWidth() * coinScale
    local coinHeight = self.coin:getHeight() * coinScale

    local fontWidth = self.font:getWidth(self.price)

    local totalWidth = coinWidth + 2 * utils.vw + fontWidth
    local coinX = xCenter - totalWidth / 2
    local priceX = coinX + coinWidth + 2 * utils.vw

    love.graphics.print(self.price, self.font, priceX, self.y + self.height / 2 - self.font:getHeight(price) * 0.6)
    love.graphics.draw(self.coin, coinX, self.y + self.height / 2 - coinHeight / 2, 0, coinScale, coinScale)
end

function ItemButton:drawBoughtIcon()
    -- Fazer o icone preencher 90% da altura do botão
    local toDressScale = 0.9 * self:getHeight() / self.toDress:getHeight() 
    local toDressWidth = self.toDress:getWidth() * toDressScale
    local toDressHeight = self.toDress:getHeight() * toDressScale

    love.graphics.draw(self.toDress, self.x + self.width / 2 - toDressWidth / 2, self.y + self.height / 2 - toDressHeight / 2, 0, toDressScale, toDressScale)
end

function ItemButton:drawEquippedIcon()
    -- Fazer o icone preencher 90% da altura do botão
    local checkScale = 0.9 * self:getHeight() / self.check:getHeight() 
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