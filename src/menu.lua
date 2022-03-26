Menu = {}

function Menu:load()
    self.menuScale = 0.07 * utils.vh -- 0.5

    local titleImage = love.graphics.newImage("assets/taikobird-title.png")
    local titleWidth = titleImage:getWidth() * self.menuScale
    local titleHeight = titleImage:getHeight() * self.menuScale
    self.title = {
        img = titleImage,
        width = titleWidth,
        height = titleHeight,
        x = love.graphics.getWidth() / 2 - titleWidth / 2,
        y = love.graphics.getHeight() / 4 - titleHeight / 2,
    }

    local playButtonImage = love.graphics.newImage("assets/play.png")
    local playButtonWidth = playButtonImage:getWidth() * self.menuScale
    local playButtonHeight = playButtonImage:getHeight() * self.menuScale
    local playButtonPressed = love.graphics.newImage("assets/play-pressed.png")
    local playButtonPressedWidth = playButtonPressed:getWidth() * self.menuScale
    local playButtonPressedHeight = playButtonPressed:getHeight() * self.menuScale
    local playButtonX = love.graphics.getWidth() / 2 - playButtonWidth - 3.5 * utils.vh -- - 25
    local playButtonY = (3 * love.graphics.getHeight() / 4) - playButtonHeight / 2
    self.playButton = {
        img = playButtonImage,
        pressedImg = playButtonPressed,
        x = playButtonX,
        y = playButtonY,
        
        -- Como o botão não apertado é um pouco menor que o apertado, ajustar a posicao horizontal e vertical dele para que eles tenham a 
        -- mesma "base", compensando a diferença de altura/largura
        xPressed = playButtonX + (playButtonWidth - playButtonPressedWidth),
        yPressed = playButtonY + playButtonHeight - playButtonPressedHeight, 
        width = playButtonWidth,
        height = playButtonHeight,
        widthPressed = playButtonPressedWidth,
        heightPressed = playButtonPressedHeight,
        pressed = false,
    }

    local rateButtonImage = love.graphics.newImage("assets/rate.png")
    local rateButtonWidth = rateButtonImage:getWidth() * self.menuScale
    local rateButtonHeight = rateButtonImage:getHeight() * self.menuScale
    local rateButtonPressed = love.graphics.newImage("assets/rate-pressed.png")
    local rateButtonPressedWidth = rateButtonPressed:getWidth() * self.menuScale
    local rateButtonPressedHeight = rateButtonPressed:getHeight() * self.menuScale
    local rateButtonX = love.graphics.getWidth() / 2 + 3.5 * utils.vh -- 25
    local rateButtonY = (3 * love.graphics.getHeight() / 4) - rateButtonHeight / 2 
    self.rateButton = {
        img = rateButtonImage,
        pressedImg = rateButtonPressed,
        x = rateButtonX,
        y = rateButtonY,
        xPressed = rateButtonX + (rateButtonWidth - rateButtonPressedWidth),
        yPressed = rateButtonY + (rateButtonHeight - rateButtonPressedHeight), 
        width = rateButtonWidth,
        height = rateButtonHeight,
        widthPressed = rateButtonPressedWidth,
        heightPressed = rateButtonPressedHeight,
        pressed = false,
    }

    self.buttonPressedSound = love.audio.newSource("assets/button-bing.mp3", "static")
    self.buttonPressedSound:setVolume(0.5)
end

function Menu:update(dt)

end

function Menu:draw()
    love.graphics.draw(self.title.img, self.title.x, self.title.y, 0, self.menuScale, self.menuScale)

    if self.playButton.pressed then
        love.graphics.draw(self.playButton.pressedImg, self.playButton.xPressed, self.playButton.yPressed, 0, self.menuScale, self.menuScale)
    else
        love.graphics.draw(self.playButton.img, self.playButton.x, self.playButton.y, 0, self.menuScale, self.menuScale)
    end

    if self.rateButton.pressed then
        love.graphics.draw(self.rateButton.pressedImg, self.rateButton.xPressed, self.rateButton.yPressed, 0, self.menuScale, self.menuScale)
    else
        love.graphics.draw(self.rateButton.img, self.rateButton.x, self.rateButton.y, 0, self.menuScale, self.menuScale)
    end
end

function Menu:setPlayButtonAsPressed()
    self.buttonPressedSound:play()
    self.playButton.pressed = true
end

function Menu:setRateButtonAsPressed()
    self.buttonPressedSound:play()
    self.rateButton.pressed = true
end

function Menu:onMouseReleased()
    self.playButton.pressed = false
    self.rateButton.pressed = false
end

function Menu:playGame()
    gameState = "inGame"
end

function Menu:rateGame()
    love.system.openURL("https://www.youtube.com/watch?v=a7E4O-plb7w")
end
