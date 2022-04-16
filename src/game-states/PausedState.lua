PausedState = GameState:new()

function PausedState:getName()
    return 'paused'
end

function PausedState:update(dt)
    Pause:update(dt)
end

function PausedState:draw()
    Player:draw()
    Pause:draw()
end

function PausedState:onMousePressed(mousePosition)
    Pause.playButton:setButtonAsPressed()
end

function PausedState:onMouseReleased(mousePosition)
    Pause.playButton:onHovered(mousePosition, function() Pause:continueGame() end)
    Pause.playButton:onMouseReleased()
end

function PausedState:onKeyPressed(key)

end

function PausedState:onKeyReleased(key)

end

function PausedState:onFocus(focus)
    
end
