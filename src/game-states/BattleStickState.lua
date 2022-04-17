BattleStickState = GameState:new()

function BattleStickState:getName()
    return 'battleStick'
end

function BattleStickState:update(dt)
    Background:update(dt)
    BattleStickPlayer:update(dt)
    Score:update(dt)
    Coin:update(dt)
end

function BattleStickState:draw()
    Background:drawVertical()
    BattleStickPlayer:draw()
    Score:draw()
    Coin:draw()
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