GameOver = {}

function GameOver:loadImages()
    self.fontScore = love.graphics.newFont("assets/dpcomic.ttf", 11 * utils.vh) -- 80

    self.gameOverScale = 0.07 * utils.vh -- 0.5
    self.gameOverSpeed = 173.6 * utils.vh -- 1250
    
    local gameOverScoreAndBestImage = love.graphics.newImage("assets/scoreandbest.png")
    local gameOverScoreAndBestWidth = gameOverScoreAndBestImage:getWidth() * self.gameOverScale
    local gameOverScoreAndBestHeight = gameOverScoreAndBestImage:getHeight() * self.gameOverScale
    self.gameOverScoreAndBest = {
        img = gameOverScoreAndBestImage,
        width = gameOverScoreAndBestWidth,
        height = gameOverScoreAndBestHeight,
        x = love.graphics.getWidth() / 2 - gameOverScoreAndBestWidth / 2,
        y = (-gameOverScoreAndBestHeight / 2) - 27.7 * utils.vh, -- - 200
        isAnimating = true,
    }

    local gameOverTitleImage = love.graphics.newImage("assets/gameover-title.png")
    local gameOverTitleWidth = gameOverTitleImage:getWidth() * self.gameOverScale
    local gameOverTitleHeight = gameOverTitleImage:getHeight() * self.gameOverScale
    self.gameOverTitle = {
        img = gameOverTitleImage,
        width = gameOverTitleWidth,
        height = gameOverTitleHeight,
        x = love.graphics.getWidth() / 2 - gameOverTitleWidth / 2,
        y = self.gameOverScoreAndBest.y - 15.3 * utils.vh, -- - 110
    }
    
    local playButtonImage = love.graphics.newImage("assets/play.png")
    local playButtonWidth = playButtonImage:getWidth() * self.gameOverScale
    local playButtonHeight = playButtonImage:getHeight() * self.gameOverScale
    local playButtonPressed = love.graphics.newImage("assets/play-pressed.png")
    local playButtonPressedWidth = playButtonPressed:getWidth() * self.gameOverScale
    local playButtonPressedHeight = playButtonPressed:getHeight() * self.gameOverScale
    local playButtonX = love.graphics.getWidth() / 2 - playButtonWidth / 2
    local playButtonY = self.gameOverScoreAndBest.y + 27.7 * utils.vh -- + 200
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

function GameOver:loadCurrentAndBestScore()
    self.currentScore = Score.score
    self.bestScore = Save:updateAndReadBestScore(Score.score)

    self.currentScoreAdjustment = {x = self.fontScore:getWidth(self.currentScore) / 2, y = self.fontScore:getHeight(self.currentScore) / 2}
    self.bestScoreAdjustment = {x = self.fontScore:getWidth(self.bestScore) / 2, y = self.fontScore:getHeight(self.bestScore) / 2}
    self.scoresY = self.gameOverScoreAndBest.y + self.gameOverScoreAndBest.height / 2 - self.currentScoreAdjustment.y / 2
    
end

function GameOver:update(dt)
    if self.gameOverScoreAndBest.isAnimating then
        self:gameOverScoreAndBestAnimation(dt)
        self.gameOverTitle.y = self.gameOverScoreAndBest.y - 15.3 * utils.vh -- - 110
        self.scoresY = self.gameOverScoreAndBest.y + self.gameOverScoreAndBest.height / 2 - self.currentScoreAdjustment.y / 2
        self.playButton.y = self.gameOverScoreAndBest.y + 27.7 * utils.vh -- + 200
        -- Como o botão não apertado é um pouco menor que o apertado, ajustar a posicao horizontal e vertical dele para que eles tenham a 
        -- mesma "base", compensando a diferença de altura/largura
        self.playButton.xPressed = self.playButton.x + (self.playButton.img:getWidth() - self.playButton.pressedImg:getWidth())
        self.playButton.yPressed = self.playButton.y + (self.playButton.img:getHeight() - self.playButton.pressedImg:getHeight())
    end
end

function GameOver:gameOver()
    self:loadCurrentAndBestScore()
    music:stop()
    gameState = "gameOver"
end

function GameOver:gameOverScoreAndBestAnimation(dt)
    local gameOverScoreAndBestEndY = love.graphics.getHeight() / 2 - self.gameOverScoreAndBest.height / 2
    if self.gameOverScoreAndBest.y ~= gameOverScoreAndBestEndY then
        self.gameOverScoreAndBest.y = self.gameOverScoreAndBest.y + self.gameOverSpeed * dt
        
        -- guarantees gameOverScoreAndBest to be positioned correctly
        if self.gameOverScoreAndBest.y > gameOverScoreAndBestEndY then
            self.gameOverScoreAndBest.y = gameOverScoreAndBestEndY
        end
    else
        self.gameOverScoreAndBest.isAnimating = false
    end
end

function GameOver:setPlayButtonAsPressed()
    if not self.gameOverScoreAndBest.isAnimating then
        self.buttonPressedSound:play()
        self.playButton.pressed = true
    end
end

function GameOver:onMouseReleased()
    self.playButton.pressed = false
end

function GameOver:playAgain()
    if not self.gameOverScoreAndBest.isAnimating then
        gameState = "inGame"
        love.load()
    end
end

function GameOver:delayedPlayAgain()
    if not self.gameOverScoreAndBest.isAnimating then
        Timer.after(0.125, function()
            GameOver:playAgain()
        end)
    end
end

function GameOver:draw()
    love.graphics.draw(self.gameOverTitle.img, self.gameOverTitle.x, self.gameOverTitle.y, 0, self.gameOverScale, self.gameOverScale)
    love.graphics.draw(self.gameOverScoreAndBest.img, self.gameOverScoreAndBest.x, self.gameOverScoreAndBest.y, 0, self.gameOverScale, self.gameOverScale)

    local scoreFontColor = {192 / 255, 120 / 255, 72 / 255, 255 / 255}
    local black = {0, 0, 0, 255 / 255}

    local textOffset = 13.33 * utils.vh -- 96
    local blackTextOffset = 0.25 * utils.vh -- 2
    love.graphics.print({black, self.currentScore}, self.fontScore, (self.gameOverScoreAndBest.x - self.currentScoreAdjustment.x + textOffset + blackTextOffset), self.scoresY + blackTextOffset)
    love.graphics.print({scoreFontColor, self.currentScore}, self.fontScore, (self.gameOverScoreAndBest.x - self.currentScoreAdjustment.x + textOffset), self.scoresY)
    love.graphics.print({black, self.bestScore}, self.fontScore, (self.gameOverScoreAndBest.x + self.gameOverScoreAndBest.width - self.bestScoreAdjustment.x - textOffset + blackTextOffset), self.scoresY + blackTextOffset)
    love.graphics.print({scoreFontColor, self.bestScore}, self.fontScore, (self.gameOverScoreAndBest.x + self.gameOverScoreAndBest.width - self.bestScoreAdjustment.x - textOffset), self.scoresY)

    if self.playButton.pressed then
        love.graphics.draw(self.playButton.pressedImg, self.playButton.xPressed, self.playButton.yPressed, 0, self.gameOverScale, self.gameOverScale)
    else
        love.graphics.draw(self.playButton.img, self.playButton.x, self.playButton.y, 0, self.gameOverScale, self.gameOverScale)
    end
end