Button = {}

function Button:new(options)
    local newButton = {
        x = options.x,
        y = options.y,
        scale = options.scale,
        img = options.img,
        width = options.img:getWidth() * options.scale,
        height = options.img:getHeight() * options.scale,
        pressed = false,
        pressedImg = options.pressedImg,
        pressedWidth = options.pressedImg:getWidth() * options.scale,
        pressedHeight = options.pressedImg:getHeight() * options.scale,
        pressedSound = love.audio.newSource("assets/button-bing.mp3", "static"),
        pressedSoundVolume = 0.5,
    }

    newButton.pressedSound:setVolume(newButton.pressedSoundVolume)

    self.__index = self

    setmetatable(newButton, self)

    return newButton
end

function Button:draw()
    if self.pressed then
        local xPressed, yPressed = self:getPressedPosition()

        love.graphics.draw(self.pressedImg, xPressed, yPressed, 0, self.scale, self.scale)
    else
        love.graphics.draw(self.img, self.x, self.y, 0, self.scale, self.scale)
    end
end

function Button:moveAnimation(dt, end_x, end_y, xSpeed, ySpeed)
    end_x = end_x or self.x
    end_y = end_y or self.y
    xSpeed = xSpeed or 0
    ySpeed = ySpeed or 0
    self.x = clamp(-math.huge, self.x, end_x)
    self.y = clamp(-math.huge, self.y, end_y)
    
    if self.x ~= end_x then
        self.x = self.x + xSpeed * dt
    end

    if self.y ~= end_y then
        self.y = self.y + ySpeed * dt
    end
end

function Button:moveTo(x, y)
    self.x = x
    self.y = y
end

function Button:getPosition()
    return self.x, self.y
end

function Button:getPressedPosition()
    xPressed = self.x + (self.width - self.pressedWidth)
    yPressed = self.y + (self.height - self.pressedHeight)
    return xPressed, yPressed
end

function Button:getWidth()
    return self.width
end

function Button:getHeight()
    return self.height
end

function Button:isHovered(mousePosition)
    if mousePosition.x >= self.x and mousePosition.x <= self.x + self.width and
        mousePosition.y >= self.y and mousePosition.y <= self.y + self.height then
        return true
    end
    return false
end

function Button:setButtonAsPressed()
    self.pressedSound:play()
    self.pressed = true
end

function Button:onMouseReleased(mousePosition)
    self.pressed = false
end