Hat = {}
setmetatable(Hat, {__index = Item})

function Hat:new(id, price, assetLocation)
    local newHat = Item:new(id, 'HAT', price, assetLocation)

    self.__index = self
    setmetatable(newHat, self)

    return newHat
end
