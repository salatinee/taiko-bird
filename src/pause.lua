Pause = {}

function Pause:load()
    self.pauseScale = 0.07 * utils.vh -- 0.5
    self.img = love.graphics.newImage("assets/paused.png")
    self.width = self.img:getWidth() * self.pauseScale
    self.height = self.img:getHeight() * self.pauseScale
    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2 - 6 * utils.vh
    
    
    local playButtonImage = love.graphics.newImage("assets/play.png")
    local playButtonPressed = love.graphics.newImage("assets/play-pressed.png")
    local playButtonX = love.graphics.getWidth() / 2 - playButtonImage:getWidth() * self.pauseScale / 2
    local playButtonY = love.graphics.getHeight() / 2 - playButtonImage:getHeight() * self.pauseScale / 2 + 6 * utils.vh
    self.playButton = Button:new({
        img = playButtonImage,
        pressedImg = playButtonPressed,
        x = playButtonX,
        y = playButtonY,
        scale = self.pauseScale,
    })
end

function Pause:update(dt)
end

function Pause:draw()
    love.graphics.draw(self.img, self.x, self.y, 0, self.pauseScale, self.pauseScale)

    self.playButton:draw()
end

function Pause:pauseGame()
    music:pause()

    admob.showBanner()
    gameState = PausedState
end

function Pause:continueGame()
    music:play()

    admob.hideBanner()
    gameState = ClassicState
end