ClassicState = GameState:new()

function ClassicState:getName()
    return 'classic'
end

function ClassicState:update(dt)
    Background.xSpeed = -5 * utils.vh
    Background:update(dt)
    ClassicObstacles:update(dt)
    ClassicPlayer:update(dt)
    Score:update(dt)
    ClassicCoins:update(dt)
end

function ClassicState:draw()
    Background:draw()
    ClassicObstacles:draw()
    ClassicPlayer:draw()
    Score:draw()
    ClassicCoins:draw()
end

function ClassicState:onMousePressed(mousePosition)
    ClassicPlayer:jump()
end

function ClassicState:onMouseReleased(mousePosition)
end

function ClassicState:onKeyPressed(key)

end

function ClassicState:onKeyReleased(key)

end

function ClassicState:onFocus(focus)
    if not focus then
        Pause:pauseGame()
    end
end