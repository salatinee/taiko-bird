BattleStickGameOver = {}

function BattleStickGameOver:loadGameOverScreen()
    -- TODO implementar acho
    local currentScore = 7
    local bestScore = 27

    self.gameOverScreen = GameOverScreen:new({
        currentScore = currentScore,
        bestScore = bestScore,
        onGoToMenuClicked = function()
            self:goToMenu()
        end,
        onPlayAgainClicked = function()
            self:playAgain()
        end,
    })
end

function BattleStickGameOver:update(dt)
    self.gameOverScreen:update(dt)
end

function BattleStickGameOver:gameOver()
    self:loadGameOverScreen()
    Save:updateCoinsQuantity()
    admob.showBanner()
    gameState = BattleStickGameOverState
end

function BattleStickGameOver:onMousePressed(mousePosition)
    self.gameOverScreen:onMousePressed(mousePosition)
end

function BattleStickGameOver:onMouseReleased(mousePosition)
    self.gameOverScreen:onMouseReleased(mousePosition)
end

function BattleStickGameOver:goToMenu()
    music:stop()
    music:play()
    self:resetAll()
    gameState = MenuState
end

function BattleStickGameOver:playAgain()
    error('yeah cool')
end

function BattleStickGameOver:delayedPlayAgain()
    if not self.gameOverScreen:isAnimating() then
        Timer.after(0.125, function()
            self:playAgain()
        end)
    end
end

function BattleStickGameOver:draw()
    self.gameOverScreen:draw()
end
