StoreState = GameState:new()

function StoreState:getName()
    return 'store'
end

function StoreState:update(dt)
    Store:update(dt)
end

function StoreState:draw()
    Store:draw()
end

function StoreState:onMousePressed(mousePosition)
    Store:onMousePressed(mousePosition)
end

function StoreState:onMouseReleased(mousePosition)
    Store:onMouseReleased(mousePosition)
end

function StoreState:onKeyPressed(key)

end

function StoreState:onKeyReleased(key)

end

function StoreState:onFocus(focus)
    
end