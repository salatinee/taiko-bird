GameState = {}

function GameState:new()
    local newGameState = {}
    self.__index = self
    setmetatable(newGameState, self)
    return newGameState
end

function GameState:update(dt)
    fail("must be implemented by instances")
end

function GameState:draw()
    fail("must be implemented by instances")
end
