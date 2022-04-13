Inventory = {}

function Inventory:load()
    -- TODO Load from save file
    local saveInventoryData = Save:readInventoryData() or {}

    self.equippedItemIdByType = saveInventoryData.equippedItemIdByType
    self.itemsIds = saveInventoryData.itemsIds
end

function Inventory:addItem(item)
    table.insert(self.itemsIds, item:getId())

    Save:updateInventoryData(self)
end

function Inventory:hasItem(item)
    for _, itemId in ipairs(self.itemsIds) do
        if itemId == item:getId() then
            return true
        end
    end

    return false
end

function Inventory:equipItem(item)
    local itemType = item:getType()
    self.equippedItemIdByType[itemType] = item:getId()

    Save:updateInventoryData(self)
end

function Inventory:deequipItem(item)
    local itemType = item:getType()
    self.equippedItemIdByType[itemType] = nil

    Save:updateInventoryData(self)
end

function Inventory:hasItemEquipped(item)
    return self.equippedItemIdByType[item:getType()] == item:getId()
end
