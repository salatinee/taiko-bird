GameModeState = GameState:new

function GameModeState:new()
    local newGameModeState = {}
    self.__index = self
    setmetatable(newGameModeState, self)
    return newGameModeState
end

function GameModeState:getName()
    error("must be implemented by instances")
end

function GameModeState:update(dt)
    error("must be implemented by instances")
end

function GameModeState:draw()
    error("must be implemented by instances")
end

function GameModeState:onMousePressed(mousePosition)
    error("must be implemented by instances")
end

function GameModeState:onMouseReleased(mousePosition)
    error("must be implemented by instances")
end

function GameModeState:onKeyPressed(key)
    error("must be implemented by instances")
end

function GameModeState:onKeyReleased(key)
    error("must be implemented by instances")
end

function GameModeState:onFocus(focus)
    error("must be implemented by instances")
end