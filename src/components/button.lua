Button = {}

function Button:new(options)
    local scaleX = options.scaleX or options.scale or 1
    local scaleY = options.scaleY or options.scale or 1

    local newButton = {
        x = options.x,
        y = options.y,
        scaleX = scaleX,
        scaleY = scaleY,
        opacity = options.opacity or 1,
        img = options.img,
        pressed = false,
        pressedImg = options.pressedImg,
        pressedSound = love.audio.newSource("assets/button-bing.mp3", "static"),
        pressedSoundVolume = 0.5,
    }

    newButton.pressedSound:setVolume(newButton.pressedSoundVolume)

    self.__index = self

    setmetatable(newButton, self)

    return newButton
end

function Button:draw()
    love.graphics.setColor(1, 1, 1, self.opacity)

    if self.pressed then
        local xPressed, yPressed = self:getPressedPosition()

        love.graphics.draw(self.pressedImg, xPressed, yPressed, 0, self.scaleX, self.scaleY)
    else
        love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, self.scaleY)
    end

    love.graphics.setColor(1, 1, 1, 1)
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

function Button:getWidth()
    return self.img:getWidth() * self.scaleX
end

function Button:getHeight()
    return self.img:getHeight() * self.scaleY
end

function Button:getPressedWidth()
    return self.pressedImg:getWidth() * self.scaleX
end

function Button:getPressedHeight()
    return self.pressedImg:getHeight() * self.scaleY
end

function Button:getScaleX()
    return self.scaleX
end

function Button:getScaleY()
    return self.scaleY
end

function Button:getPosition()
    return self.x, self.y
end

function Button:getPressedPosition()
    xPressed = self.x + (self:getWidth() - self:getPressedWidth())
    yPressed = self.y + (self:getHeight() - self:getPressedHeight())
    return xPressed, yPressed
end

function Button:isHovered(mousePosition)
    if mousePosition.x >= self.x and mousePosition.x <= self.x + self:getWidth() and
        mousePosition.y >= self.y and mousePosition.y <= self.y + self:getHeight() then
        return true
    end
    return false
end

function Button:setButtonAsPressed()
    self.pressedSound:play()
    self.pressed = true
end

function Button:setScale(scale)
    self:setScaleX(scale)
    self:setScaleY(scale)
end

function Button:setScaleX(scaleX)
    self.scaleX = scaleX
end

function Button:setScaleY(scaleY)
    self.scaleY = scaleY
end

function Button:onMouseReleased(mousePosition)
    self.pressed = false
end