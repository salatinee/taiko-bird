Colors = {}

function Colors:load()
    self.buttonScale = 0.1 * utils.vh -- 0.5

    local ButtonImage = love.graphics.newImage("assets/color.png")
    local ButtonWidth = ButtonImage:getWidth() * self.buttonScale
    local ButtonHeight = ButtonImage:getHeight() * self.buttonScale
    local ButtonPressed = love.graphics.newImage("assets/color-pressed.png")
    local ButtonX = love.graphics.getWidth() / 2 - ButtonWidth / 2
    local ButtonY = love.graphics.getHeight() / 2 - ButtonHeight / 2 + utils.vh * 30
    self.colorButton = ColorButton:new({
        img = ButtonImage,
        scale = self.buttonScale,
        pressedImg = ButtonPressed,
        x = ButtonX,
        y = ButtonY,
        image_map = love.image.newImageData("assets/color.png"),
        image_map_pressed = love.image.newImageData("assets/color-pressed.png"),
    })

    local leftArrowButtonImage = love.graphics.newImage('assets/button-left-arrow.png')
    local leftArrowButtonWidth = leftArrowButtonImage:getWidth() * self.buttonScale
    local leftArrowButtonHeight = leftArrowButtonImage:getHeight() * self.buttonScale
    local leftArrowButtonPressed = love.graphics.newImage("assets/button-left-arrow-pressed.png")
    local leftArrowButtonX = love.graphics.getWidth() / 2 - ButtonWidth / 2 - leftArrowButtonWidth - utils.vh * 0.1
    local leftArrowButtonY = love.graphics.getHeight() / 2 - leftArrowButtonHeight / 2 + utils.vh * 30
    self.leftArrowButton = Button:new({
        img = leftArrowButtonImage,
        scale = self.buttonScale,
        pressedImg = leftArrowButtonPressed,
        x = leftArrowButtonX,
        y = leftArrowButtonY,
    })

    -- obg amor
    
    local rightArrowButtonImage = love.graphics.newImage('assets/button-right-arrow.png')
    local rightArrowButtonWidth = rightArrowButtonImage:getWidth() * self.buttonScale
    local rightArrowButtonHeight = rightArrowButtonImage:getHeight() * self.buttonScale
    local rightArrowButtonPressed = love.graphics.newImage("assets/button-right-arrow-pressed.png")
    local rightArrowButtonX = love.graphics.getWidth() / 2 + ButtonWidth / 2 + utils.vh * 0.1
    local rightArrowButtonY = love.graphics.getHeight() / 2 - rightArrowButtonHeight / 2 + utils.vh * 30
    self.rightArrowButton = Button:new({
        img = rightArrowButtonImage,
        scale = self.buttonScale,
        pressedImg = rightArrowButtonPressed,
        x = rightArrowButtonX,
        y = rightArrowButtonY,
    })

    local backButtonX = utils.vh * 5
    local backButtonY = love.graphics.getHeight() - leftArrowButtonHeight - utils.vh * 5

    self.backButton = Button:new({
        img = leftArrowButtonImage,
        scale = self.buttonScale,
        pressedImg = leftArrowButtonPressed,
        x = backButtonX,
        y = backButtonY,
    })
    
    -- colors we are currently using, may be added more according to users' sugestions
    self.availableColors = {
        {r = 255, g = 255, b = 255, a = 255},
        {r = 204, g = 51, b = 0, a = 255},
        {r = 51, g = 153, b = 51, a = 255},
        {r = 0, g = 0, b = 230, a = 255},
        {r = 255, g = 255, b = 0, a = 255},
        {r = 255, g = 51, b = 204, a = 255},
        {r = 51, g = 204, b = 255, a = 255},
        {r = 190, g = 92, b = 255, a = 255},
        {r = 255, g = 102, b = 0, a = 255},
        {r = 207, g = 201, b = 229, a = 255},
        {r = 252, g = 179, b = 200, a = 255},
    }

    -- current color is by default the first one in the available colors
    -- FIXME current color should be the one that was previously used, if any
    self.currentColor = Save:readCurrentColor()
    self:changeColor(self:getCurrentColor())
end

function Colors:update(dt)
end

function Colors:nextColor()
    if self.currentColor == #self.availableColors then
        self.currentColor = 1
    else
        self.currentColor = self.currentColor + 1
    end
    self:changeColor(self:getCurrentColor())
end

function Colors:previousColor()
    if self.currentColor == 1 then
        self.currentColor = #self.availableColors
    else
        self.currentColor = self.currentColor - 1
    end
    self:changeColor(self:getCurrentColor())
end

function Colors:changeColor(color)
    Player:changesColor(color)
    AI:changesColor(color)
    AIColors:changesColor(color)

    self.colorButton:setColor(self:getCurrentColor())
end

function Colors:getCurrentColor()
    return self.availableColors[self.currentColor]
end

function Colors:getCurrentColorIndex()
    return self.currentColor
end

function Colors:draw()
    self.leftArrowButton:draw()
    self.colorButton:draw()
    self.rightArrowButton:draw()
    self.backButton:draw()
end