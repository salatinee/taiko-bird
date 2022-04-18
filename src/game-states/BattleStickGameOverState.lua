BattleStickGameOverState = GameState:new()

function BattleStickGameOverState:getName()
    return 'battleStickGameOver'
end

function BattleStickGameOverState:update(dt)
    -- BattleStickPlayer:update(dt)
    BattleStickGameOver:update(dt)
end

function BattleStickGameOverState:draw()
    Background:drawVertical()
    BattleObstacles:draw()
    BattleStickPlayer:draw()
    BattleCoins:draw()
    BattleStickGameOver:draw()
end

function BattleStickGameOverState:onMousePressed(mousePosition)
    BattleStickGameOver:onMousePressed(mousePosition)
end

function BattleStickGameOverState:onMouseReleased(mousePosition)
    BattleStickGameOver:onMouseReleased(mousePosition)
end

function BattleStickGameOverState:onKeyPressed(key)
    if key == "space" then
        BattleStickGameOver:setPlayButtonAsPressed()
        BattleStickGameOver:delayedPlayAgain()
    end
end

function BattleStickGameOverState:onKeyReleased(key)

end

function BattleStickGameOverState:onFocus(focus)
    
end