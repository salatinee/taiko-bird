GameState = {}

function GameState:new()
    local newGameState = {}
    self.__index = self
    setmetatable(newGameState, self)
    return newGameState
end

function GameState:getName()
    error("must be implemented by instances")
end

function GameState:update(dt)
    error("must be implemented by instances")
end

function GameState:draw()
    error("must be implemented by instances")
end

function GameState:onMousePressed(mousePosition)
    error("must be implemented by instances")
end

function GameState:onMouseReleased(mousePosition)
    error("must be implemented by instances")
end

function GameState:onKeyPressed(key)
    error("must be implemented by instances")
end

function GameState:onKeyReleased(key)
    error("must be implemented by instances")
end

function GameState:onFocus(focus)
    error("must be implemented by instances")
end