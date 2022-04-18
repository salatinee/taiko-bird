BattleStickState = GameState:new()

function BattleStickState:getName()
    return 'battleStick'
end

function BattleStickState:update(dt)
    Background:update(dt, -6 * utils.vh)
    BattleStickPlayer:update(dt)
    Enemy:update(dt)
    Score:update(dt)
    BattleObstacles:update(dt)
    BattleCoins:update(dt)
    Shot:update(dt)
end

function BattleStickState:draw()
    Background:drawVertical()
    BattleStickPlayer:draw()
    Enemy:draw()
    Shot:draw()
    BattleObstacles:draw()
    BattleCoins:draw()
    Score:draw()
end

function BattleStickState:onMousePressed(mousePosition)
end

function BattleStickState:onMouseReleased(mousePosition)
end

function BattleStickState:onKeyPressed(key)

end


function BattleStickState:onKeyReleased(key)

end

function BattleStickState:onFocus(focus)

end