CreditsState = GameState:new()

function CreditsState:getName()
    return 'credits'
end

function CreditsState:update(dt)
    Credits:update(dt)
end

function CreditsState:draw()
    Credits:draw()
end

function CreditsState:onMousePressed(mousePosition)

end

function CreditsState:onMouseReleased(mousePosition)
    Credits:backToMenu()
end

function CreditsState:onKeyPressed(key)

end

function CreditsState:onKeyReleased(key)

end

function CreditsState:onFocus(focus)
    
end