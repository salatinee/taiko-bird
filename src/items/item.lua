Item = {}

function Item:new(id, type, price, assetName)
    local storeListingAssetLocation = 'assets/store/' .. assetName
    local wearableAssetLocation = 'assets/items/' .. assetName
    local newItem = {
        id = id,
        type = type,
        price = price,
        storeListingAssetLocation = storeListingAssetLocation,
        wearableAssetLocation = wearableAssetLocation,
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

function Item:getStoreListingAssetLocation()
    return self.storeListingAssetLocation
end

function Item:getWearableAssetLocation()
    return self.wearableAssetLocation
end

function Item:draw()
    fail("Item:draw() is not implemented, this should be subclassed")
end
