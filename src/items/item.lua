Item = {}

function Item:new(id, type, price, assetLocation)
    local newItem = {
        id = id,
        type = type,
        price = price,
        assetLocation = assetLocation,
    }
     
    self.__index = self
    setmetatable(newItem, self)

    return newItem
end

function Item:getId()
    return self.id
end

function Item:getType()
    return self.type
end

function Item:getPrice()
    return self.price
end

function Item:getAssetLocation()
    return self.assetLocation
end

function Item:draw()
    fail("Item:draw() is not implemented, this should be subclassed")
end
