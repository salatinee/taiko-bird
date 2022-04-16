GameState = {}

function GameState:new()
    local newGameState = {}
    self.__index = self
    setmetatable(newGameState, self)
    return newGameState
end

function GameState:getName()
    fail("must be implemented by instances")
end

function GameState:update(dt)
    fail("must be implemented by instances")
end

function GameState:draw()
    fail("must be implemented by instances")
end

function GameState:onMousePressed(mousePosition)
    fail("must be implemented by instances")
end

function GameState:onMouseReleased(mousePosition)
    fail("must be implemented by instances")
end

function GameState:onKeyPressed(key)
    fail("must be implemented by instances")
end

function GameState:onKeyReleased(key)
    fail("must be implemented by instances")
end

function GameState:onFocus(focus)
    
end