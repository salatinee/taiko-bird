ClassicGameOver = {}

function ClassicGameOver:loadClassicGameOverScreen()
    local currentScore = Score.score
    local bestScore = Save:updateAndReadBestScore("classic", Score.score)

    self.classicGameOverScreen = GameOverScreen:new({
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

function ClassicGameOver:update(dt)
    self.classicGameOverScreen:update(dt)
end

function ClassicGameOver:gameOver()
    -- Isso pode ser chamado varias vezes do player, ent ver se não estamos em Classicgameover pra realizar as operações
    -- Seria legal mudar isso pra só ser chamado 1x...
    if gameState:getName() ~= 'gameOver' then
        self:loadClassicGameOverScreen()
        Save:updateCoinsQuantity()
        admob.showBanner()
        gameState = GameOverState
    end
end

function ClassicGameOver:onMousePressed(mousePosition)
    self.classicGameOverScreen:onMousePressed(mousePosition)
end

function ClassicGameOver:onMouseReleased(mousePosition)
    self.classicGameOverScreen:onMouseReleased(mousePosition)
end

function ClassicGameOver:playAgain()
    self:resetAll()
    music:play()

    admob.hideBanner()
    gameState = ClassicState
end

function ClassicGameOver:resetAll()
    Score:reset()
    ClassicPlayer:reset()
    ClassicObstacles:reset()
    Coin:reset()
end

function ClassicGameOver:delayedPlayAgain()
    if not self.classicGameOverScoreAndBest.isAnimating then
        Timer.after(0.125, function()
            ClassicGameOver:playAgain()
        end)
    end
end

function ClassicGameOver:draw()
    self.classicGameOverScreen:draw()
end

function ClassicGameOver:goToMenu()
    music:stop()
    music:play()
    self:resetAll()
    gameState = MenuState
end