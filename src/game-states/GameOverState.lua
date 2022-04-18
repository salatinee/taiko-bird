GameOverState = GameState:new()

function GameOverState:getName()
    return 'gameOver'
end

function GameOverState:update(dt)
    ClassicPlayer:update(dt)
    ClassicCoins:update(dt)
    ClassicGameOver:update(dt)
end

function GameOverState:draw()
    Background:draw()
    ClassicObstacles:draw()
    ClassicPlayer:draw()
    ClassicCoins:draw()
    ClassicGameOver:draw()
end

function GameOverState:onMousePressed(mousePosition)
    ClassicGameOver:onMousePressed(mousePosition)
end

function GameOverState:onMouseReleased(mousePosition)
    ClassicGameOver:onMouseReleased(mousePosition)
end

function GameOverState:onKeyPressed(key)
    if key == "space" then
        ClassicGameOver:setPlayButtonAsPressed()
        ClassicGameOver:delayedPlayAgain()
    end
end

function GameOverState:onKeyReleased(key)

end

function GameOverState:onFocus(focus)
    
end