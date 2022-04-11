Shoe = {}
setmetatable(Shoe, {__index = Item})

function Shoe:new(id, price, assetLocation)
    local newShoe = Item:new(id, 'SHOE', price, assetLocation)

    self.__index = self
    setmetatable(newShoe, self)

    return newShoe
end
