MenuState = GameState:new()

function MenuState:update(dt)
    Background:update(dt)
    Menu:update(dt)
    AI:update(dt)
end

function MenuState:draw()
    Background:draw()
    Menu:draw()
    Coins:draw()
    AI:draw()
end