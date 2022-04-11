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
        img = love.graphics.newImage(wearableAssetLocation),
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

function Item:draw(scale, canvasWidth, canvasHeight)
    local itemWidth = self.img:getWidth() * scale
    local itemHeight = self.img:getHeight() * scale

    local x = canvasWidth / 2 - itemWidth / 2
    local y = canvasHeight / 2 - itemHeight / 2

    love.graphics.draw(self.img, x, y, 0, scale, scale)
end
