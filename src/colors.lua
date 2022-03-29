Colors = {}

function Colors:load()
    self.buttonScale = 0.1 * utils.vh -- 0.5

    local ButtonImage = love.graphics.newImage("assets/color.png")
    local ButtonWidth = ButtonImage:getWidth() * self.buttonScale
    local ButtonHeight = ButtonImage:getHeight() * self.buttonScale
    local ButtonPressed = love.graphics.newImage("assets/color-pressed.png")
    local ButtonX = love.graphics.getWidth() / 2 - ButtonWidth / 2
    local ButtonY = love.graphics.getHeight() / 2 - ButtonHeight / 2 + utils.vh * 0.1
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
    local leftArrowButtonX = love.graphics.getWidth() / 2 - leftArrowButtonWidth / 2 - ButtonWidth / 2 - leftArrowButtonWidth / 2 - utils.vh * 0.1
    local leftArrowButtonY = love.graphics.getHeight() / 2 - leftArrowButtonHeight / 2 + utils.vh * 0.1
    self.leftArrowButton = Button:new({
        img = leftArrowButtonImage,
        scale = self.buttonScale,
        pressedImg = leftArrowButtonPressed,
        x = leftArrowButtonX,
        y = leftArrowButtonY,
        image_map = love.image.newImageData('assets/button-left-arrow.png'),
        image_map_pressed = love.image.newImageData('assets/button-left-arrow-pressed.png'),
    })

    -- obg amor
    
    local rightArrowButtonImage = love.graphics.newImage('assets/button-right-arrow.png')
    local rightArrowButtonWidth = rightArrowButtonImage:getWidth() * self.buttonScale
    local rightArrowButtonHeight = rightArrowButtonImage:getWidth() * self.buttonScale
    local rightArrowButtonPressed = love.graphics.newImage("assets/button-right-arrow-pressed.png")
    local rightArrowButtonX = love.graphics.getWidth() / 2 + ButtonWidth / 2 + rightArrowButtonWidth / 2 + utils.vh * 0.1
    local rightArrowButtonY = love.graphics.getHeight() / 2 - rightArrowButtonHeight / 2 + utils.vh * 0.1
    self.rightArrowButton = Button:new({
        img = rightArrowButtonImage,
        scale = self.buttonScale,
        pressedImg = rightArrowButtonPressed,
        x = rightArrowButtonX,
        y = rightArrowButtonY,
        image_map = love.image.newImageData('assets/button-right-arrow.png'),
        image_map_pressed = love.image.newImageData('assets/button-right-arrow-pressed.png'),
    })
    
    -- colors we are currently using, may be added more according to users' sugestions
    self.availableColors = {
        {r = 255, g = 255, b = 255},
        {r = 255, g = 0, b = 0},
        {r = 0, g = 255, b = 0},
        {r = 0, g = 0, b = 255},
        {r = 255, g = 255, b = 0},
        {r = 255, g = 0, b = 255},
        {r = 0, g = 255, b = 255},
    }

    -- current color is by default the first one in the available colors
    -- FIXME current color should be the one that was previously used, if any
    self.currentColor = 1

end

function Colors:update(dt)
end

function Colors:nextColor()
    if self.currentColor == #self.availableColors then
        self.currentColor = 1
    else
        self.currentColor = self.currentColor + 1
    end
end

function Colors:previousColor()
    if self.currentColor == 1 then
        self.currentColor = #self.availableColors
    else
        self.currentColor = self.currentColor - 1
    end
end

function Colors:getCurrentColor()
    return self.availableColors[self.currentColor]
end

function Colors:draw()
    self.leftArrowButton:draw()
    self.colorButton:draw()
    self.rightArrowButton:draw()
end
