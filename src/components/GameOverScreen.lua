GameOverScreen = {}

-- Static method, load common things
function GameOverScreen:loadImages()
    self.scale = 0.14 * utils.vh
    if utils.isMobile then
        self.scale = 0.175 * utils.vw
    end

    self.fontScore = love.graphics.newFont("assets/dpcomic.ttf", 11 * self.scale * utils.vh) -- 80
    self.gameOverScale = 0.07 * self.scale * utils.vh -- 0.5
    self.gameOverSpeed = 173.6 * self.scale *  utils.vh 
end

function GameOverScreen:new(options)
    local newGameOverScreen = {}
    self.__index = self
    setmetatable(newGameOverScreen, self)

    newGameOverScreen.currentScore = options.currentScore
    newGameOverScreen.bestScore = options.bestScore
    newGameOverScreen.onGoToMenuClicked = options.onGoToMenuClicked
    newGameOverScreen.onPlayAgainClicked = options.onPlayAgainClicked

    local gameOverScoreAndBestImage = love.graphics.newImage("assets/scoreandbest.png")
    local gameOverScoreAndBestWidth = gameOverScoreAndBestImage:getWidth() * self.gameOverScale
    local gameOverScoreAndBestHeight = gameOverScoreAndBestImage:getHeight() * self.gameOverScale
    newGameOverScreen.gameOverScoreAndBest = {
        img = gameOverScoreAndBestImage,
        width = gameOverScoreAndBestWidth,
        height = gameOverScoreAndBestHeight,
    }

    local gameOverTitleImage = love.graphics.newImage("assets/gameover-title.png")
    local gameOverTitleWidth = gameOverTitleImage:getWidth() * self.gameOverScale
    local gameOverTitleHeight = gameOverTitleImage:getHeight() * self.gameOverScale
    newGameOverScreen.gameOverTitle = {
        img = gameOverTitleImage,
        width = gameOverTitleWidth,
        height = gameOverTitleHeight,
    }

    local img = love.graphics.newImage("assets/play.png")
    newGameOverScreen.playButton = Button:new({
        img = img,
        pressedImg = love.graphics.newImage("assets/play-pressed.png"),
        scale = self.gameOverScale,
        -- The button's position is updated dynamically in draw
        x = 0,
        y = 0,
    })

    local img = love.graphics.newImage("assets/menu-button.png")
    local pressedImg = love.graphics.newImage("assets/menu-button-pressed.png")
    newGameOverScreen.menuButton = Button:new({
        img = img,
        pressedImg = pressedImg,
        scale = self.gameOverScale,
        -- The button's position is updated dynamically in draw
        x = 0,
        y = 0,
    })

    -- Calcular posicao inicial, comecando em cima da tela
    -- FIXME mt magic number................. oq pq n entendi mt
    -- sla esses 27.7 * ngc meio magic n e mt facil de entender oq eles significam
    newGameOverScreen.y = (-newGameOverScreen.gameOverScoreAndBest.height / 2) - 27.7 * self.scale * utils.vh - 15.3 * self.scale * utils.vh

    return newGameOverScreen
end

function GameOverScreen:calculatePositions()
    local positions = {}
    positions.gameOverTitle = {
        x = love.graphics.getWidth() / 2 - self.gameOverTitle.width / 2,
        y = self.y,
    }

    positions.gameOverScoreAndBest = {
        x = love.graphics.getWidth() / 2 - self.gameOverScoreAndBest.width / 2,
        y = positions.gameOverTitle.y + 15.3 * self.scale * utils.vh,
    }

    positions.playButton = {
        x = love.graphics.getWidth() / 2 - self.playButton:getWidth() - 3.5 * utils.vh,
        y = positions.gameOverScoreAndBest.y + 27.7 * self.scale * utils.vh, 
    }

    positions.menuButton = {
        x = love.graphics.getWidth() / 2 + 3.5 * utils.vh,
        y = positions.gameOverScoreAndBest.y + 27.7 * self.scale * utils.vh, 
    }

    local currentScoreAdjustment = {
        x = self.fontScore:getWidth(self.currentScore) / 2,
        y = self.fontScore:getHeight(self.currentScore) / 2
    }

    local bestScoreAdjustment = {
        x = self.fontScore:getWidth(self.bestScore) / 2,
        y = self.fontScore:getHeight(self.bestScore) / 2
    }

    -- FIXME textOffset seems a bit hacky here... probably we could be get around it by positioning
    -- properly the x position of the texts inside the box, and remove this variable
    local textOffset = 13.33 * self.scale * utils.vh -- 96
    local shadowTextOffset = 0.25 * self.scale * utils.vh -- 2
    local scoresY = positions.gameOverScoreAndBest.y + self.gameOverScoreAndBest.height / 2 - currentScoreAdjustment.y / 2

    positions.currentScore = {
        x = positions.gameOverScoreAndBest.x - currentScoreAdjustment.x + textOffset,
        y = scoresY,
    }

    positions.currentScoreShadow = {
        x = positions.currentScore.x + shadowTextOffset,
        y = scoresY + shadowTextOffset,
    }

    positions.bestScore = {
        x = positions.gameOverScoreAndBest.x + self.gameOverScoreAndBest.width - bestScoreAdjustment.x - textOffset,
        y = scoresY,
    }

    positions.bestScoreShadow = {
        x = positions.bestScore.x + shadowTextOffset,
        y = scoresY + shadowTextOffset,
    }

    return positions
end

function GameOverScreen:getEndY()
    -- FIXME too many magic numbers i guess
    return love.graphics.getHeight() / 2 - self.gameOverScoreAndBest.height / 2 - 15.3 * self.scale * utils.vh
end

function GameOverScreen:isAnimating()
    return self.y < self:getEndY()
end

function GameOverScreen:update(dt)
    local endY = self:getEndY()
    if self.y < endY then
        self.y = math.min(self.y + self.gameOverSpeed * dt, endY)
    end
end

function GameOverScreen:draw()
    local positions = self:calculatePositions()

    love.graphics.draw(self.gameOverTitle.img, positions.gameOverTitle.x, positions.gameOverTitle.y, 0, self.gameOverScale, self.gameOverScale)
    love.graphics.draw(self.gameOverScoreAndBest.img, positions.gameOverScoreAndBest.x, positions.gameOverScoreAndBest.y, 0, self.gameOverScale, self.gameOverScale)

    local scoreFontColor = {192 / 255, 120 / 255, 72 / 255, 255 / 255}
    local black = {0, 0, 0, 255 / 255}

    love.graphics.print({black, self.currentScore}, self.fontScore, positions.currentScoreShadow.x, positions.currentScoreShadow.y)
    love.graphics.print({scoreFontColor, self.currentScore}, self.fontScore, positions.currentScore.x, positions.currentScore.y)
    love.graphics.print({black, self.bestScore}, self.fontScore, positions.bestScoreShadow.x, positions.bestScoreShadow.y)
    love.graphics.print({scoreFontColor, self.bestScore}, self.fontScore, positions.bestScore.x, positions.bestScore.y)

    self.playButton:moveTo(positions.playButton.x, positions.playButton.y)
    self.playButton:draw()
    self.menuButton:moveTo(positions.menuButton.x, positions.menuButton.y)
    self.menuButton:draw()
end

function GameOverScreen:onMousePressed(mousePosition)
    if self:isAnimating() then
        return
    end

    if self.playButton:isHovered(mousePosition) then
        self.playButton:setButtonAsPressed()
    end

    if self.menuButton:isHovered(mousePosition) then
        self.menuButton:setButtonAsPressed()
    end
end

function GameOverScreen:onMouseReleased(mousePosition)
    if self:isAnimating() then
        return
    end

    self.playButton:onHovered(mousePosition, function()
        self.onPlayAgainClicked()
    end)

    self.menuButton:onHovered(mousePosition, function()
        self.onGoToMenuClicked()
    end)

    self.playButton:onMouseReleased()
    self.menuButton:onMouseReleased()
end
