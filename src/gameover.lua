GameOver = {}

function GameOver:loadImages()
    self.scale = 1
    if utils.isMobile then
        self.scale = 0.8
    end

    self.fontScore = love.graphics.newFont("assets/dpcomic.ttf", 11 * self.scale * utils.vh) -- 80

    self.gameOverScale = 0.07 * self.scale * utils.vh -- 0.5

    self.gameOverSpeed = 173.6 * self.scale *  utils.vh -- 1250
    
    local gameOverScoreAndBestImage = love.graphics.newImage("assets/scoreandbest.png")
    local gameOverScoreAndBestWidth = gameOverScoreAndBestImage:getWidth() * self.gameOverScale
    local gameOverScoreAndBestHeight = gameOverScoreAndBestImage:getHeight() * self.gameOverScale
    self.gameOverScoreAndBest = {
        img = gameOverScoreAndBestImage,
        width = gameOverScoreAndBestWidth,
        height = gameOverScoreAndBestHeight,
        x = love.graphics.getWidth() / 2 - gameOverScoreAndBestWidth / 2,
    }

    self:reset()

    local gameOverTitleImage = love.graphics.newImage("assets/gameover-title.png")
    local gameOverTitleWidth = gameOverTitleImage:getWidth() * self.gameOverScale
    local gameOverTitleHeight = gameOverTitleImage:getHeight() * self.gameOverScale
    self.gameOverTitle = {
        img = gameOverTitleImage,
        width = gameOverTitleWidth,
        height = gameOverTitleHeight,
        x = love.graphics.getWidth() / 2 - gameOverTitleWidth / 2,
        y = self.gameOverScoreAndBest.y - 15.3 * self.scale * utils.vh, -- - 110
    }
    local img = love.graphics.newImage("assets/play.png")
    self.playButton = Button:new({
        img = img,
        pressedImg = love.graphics.newImage("assets/play-pressed.png"),
        scale = self.gameOverScale,
        x = love.graphics.getWidth() / 2 - img:getWidth() * self.gameOverScale - 3.5 * utils.vh,
        y = self.gameOverScoreAndBest.y + 27.7 * self.scale * utils.vh, -- + 200
    })

    local img = love.graphics.newImage("assets/menu-button.png")
    local pressedImg = love.graphics.newImage("assets/menu-button-pressed.png")
    self.menuButton = Button:new({
        img = img,
        pressedImg = pressedImg,
        scale = self.gameOverScale,
        x = love.graphics.getWidth() / 2 + 3.5 * utils.vh,
        y = self.gameOverScoreAndBest.y + 27.7 * self.scale * utils.vh, -- + 200
    })
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
        self.gameOverTitle.y = self.gameOverScoreAndBest.y - 15.3 * self.scale * utils.vh -- - 110
        self.scoresY = self.gameOverScoreAndBest.y + self.gameOverScoreAndBest.height / 2 - self.currentScoreAdjustment.y / 2

        local playButtonX, playButtonY = self.playButton:getPosition()
        local buttonsUpdatedY = self.gameOverScoreAndBest.y + 27.7 * self.scale * utils.vh -- + 200
        local menuButtonX, menuButtonY = self.menuButton:getPosition()
        self.playButton:moveTo(playButtonX, buttonsUpdatedY)
        self.menuButton:moveTo(menuButtonX, buttonsUpdatedY)
    end
end

function GameOver:gameOver()
    -- Isso pode ser chamado varias vezes do player, ent ver se não estamos em gameover pra realizar as operações
    -- Seria legal mudar isso pra só ser chamado 1x...
    if gameState ~= 'gameOver' then
        self:loadCurrentAndBestScore()
        music:stop()

        admob.showBanner()
        gameState = "gameOver"
    end
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
        self.playButton:setButtonAsPressed()
    end
end

function GameOver:playAgain()
    if not self.gameOverScoreAndBest.isAnimating then
        self:resetAll()
        music:play()

        admob.hideBanner()
        gameState = "inGame"
    end
end

function GameOver:reset()
    self.gameOverScoreAndBest.isAnimating = true
    self.gameOverScoreAndBest.y = (-self.gameOverScoreAndBest.height / 2) - 27.7 * self.scale * utils.vh -- - 200
end 

function GameOver:resetAll()
    self:reset()
    Score:reset()
    Player:reset()
    obstacles:reset()
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

    local textOffset = 13.33 * self.scale * utils.vh -- 96
    local blackTextOffset = 0.25 * self.scale * utils.vh -- 2
    love.graphics.print({black, self.currentScore}, self.fontScore, (self.gameOverScoreAndBest.x - self.currentScoreAdjustment.x + textOffset + blackTextOffset), self.scoresY + blackTextOffset)
    love.graphics.print({scoreFontColor, self.currentScore}, self.fontScore, (self.gameOverScoreAndBest.x - self.currentScoreAdjustment.x + textOffset), self.scoresY)
    love.graphics.print({black, self.bestScore}, self.fontScore, (self.gameOverScoreAndBest.x + self.gameOverScoreAndBest.width - self.bestScoreAdjustment.x - textOffset + blackTextOffset), self.scoresY + blackTextOffset)
    love.graphics.print({scoreFontColor, self.bestScore}, self.fontScore, (self.gameOverScoreAndBest.x + self.gameOverScoreAndBest.width - self.bestScoreAdjustment.x - textOffset), self.scoresY)

    self.playButton:draw()
    self.menuButton:draw()
end

function GameOver:goToMenu()
    if not self.gameOverScoreAndBest.isAnimating then
        music:stop()
        music:play()
        self:resetAll()
        gameState = "menu"
    end
end