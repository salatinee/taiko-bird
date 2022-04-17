ClassicState = GameState:new()

function ClassicState:getName()
    return 'classic'
end

function ClassicState:update(dt)
    Background.xSpeed = -5 * utils.vh
    Background:update(dt)
    obstacles:update(dt)
    Player:update(dt)
    Score:update(dt)
    Coin:update(dt)
end

function ClassicState:draw()
    Player:draw()
    Score:draw()
    Coin:draw()
end

function ClassicState:onMousePressed(mousePosition)
    Player:jump()
end

function ClassicState:onMouseReleased(mousePosition)
end

function ClassicState:onKeyPressed(key)
    if key == "space" then
        Player:jump()
    end
end

function ClassicState:onKeyReleased(key)

end

function ClassicState:onFocus(focus)
    if not focus then
        Pause:pauseGame()
    end
end