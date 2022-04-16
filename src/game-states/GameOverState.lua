GameOverState = GameState:new()

function GameOverState:getName()
    return 'gameOver'
end

function GameOverState:update(dt)
    Player:update(dt)
    GameOver:update(dt)
end

function GameOverState:draw()
    Player:draw()
    GameOver:draw()
end

function GameOverState:onMousePressed(mousePosition)
    if GameOver.playButton:isHovered(mousePosition) then
        GameOver.playButton:setButtonAsPressed()
    elseif GameOver.menuButton:isHovered(mousePosition) then
        GameOver.menuButton:setButtonAsPressed()
    end
end

function GameOverState:onMouseReleased(mousePosition)
    GameOver.playButton:onHovered(mousePosition, function() GameOver:playAgain() end)
    GameOver.playButton:onMouseReleased()
    GameOver.menuButton:onHovered(mousePosition, function() GameOver:goToMenu() end)
    GameOver.menuButton:onMouseReleased()
end

function GameOverState:onKeyPressed(key)
    if key == "space" then
        GameOver:setPlayButtonAsPressed()
        GameOver:delayedPlayAgain()
    end
end

function GameOverState:onKeyReleased(key)

end

function GameOverState:onFocus(focus)
    
end