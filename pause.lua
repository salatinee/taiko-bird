Pause = {}

function Pause:load()
    self.pauseScale = 0.07 * utils.vh -- 0.5
    self.img = love.graphics.newImage("assets/paused.png")
    self.width = self.img:getWidth() * self.pauseScale
    self.height = self.img:getHeight() * self.pauseScale
    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2 - 6 * utils.vh
    
    
    local playButtonImage = love.graphics.newImage("assets/play.png")
    local playButtonWidth = playButtonImage:getWidth() * self.pauseScale
    local playButtonHeight = playButtonImage:getHeight() * self.pauseScale
    local playButtonPressed = love.graphics.newImage("assets/play-pressed.png")
    local playButtonPressedWidth = playButtonPressed:getWidth() * self.pauseScale
    local playButtonPressedHeight = playButtonPressed:getHeight() * self.pauseScale
    local playButtonX = love.graphics.getWidth() / 2 - playButtonWidth / 2
    local playButtonY = love.graphics.getHeight() / 2 - playButtonHeight / 2 + 6 * utils.vh
    self.playButton = {
        img = playButtonImage,
        pressedImg = playButtonPressed,
        x = playButtonX,
        y = playButtonY,
        xPressed = playButtonX + (playButtonWidth - playButtonPressedWidth),
        yPressed = playButtonY + playButtonHeight - playButtonPressedHeight, 
        width = playButtonWidth,
        height = playButtonHeight,
        pressed = false,
    }

    self.buttonPressedSound = love.audio.newSource("assets/button-bing.mp3", "static")
    self.buttonPressedSound:setVolume(0.5)
end

function Pause:update(dt)
end

function Pause:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.pauseScale, self.pauseScale)

    if self.playButton.pressed then
        love.graphics.draw(self.playButton.pressedImg, self.playButton.xPressed, self.playButton.yPressed, 0, self.pauseScale, self.pauseScale)
    else
        love.graphics.draw(self.playButton.img, self.playButton.x, self.playButton.y, 0, self.pauseScale, self.pauseScale)
    end
end

function Pause:setPlayButtonAsPressed()
    self.buttonPressedSound:play()

    self.playButton.pressed = true
end

function Pause:onMouseReleased()
    self.playButton.pressed = false
end

function Pause:pauseGame()
    music:pause()
    gameState = "paused"
end

function Pause:continueGame()
    music:play()
    gameState = "inGame"
end