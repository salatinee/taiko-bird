Inventory = {}

function Inventory:load()
    -- TODO Load from save file
    local saveInventoryData = Save:readInventoryData()

    self.equippedItemIdByType = saveInventoryData.equippedItemIdByType
    self.itemsIds = saveInventoryData.itemsIds
end

function Inventory:addItem(item)
    table.insert(self.itemsIds, item:getId())

    Save:updateInventory(self)
end

function Inventory:hasItem(item)
    -- sla usei o copilot nem sei se isso existe de vdd tbh
    return table.contains(self.itemsIds, item:getId())
end

function Inventory:equipItem(item)
    local itemType = item:getType()
    self.equippedItemsIds[itemType] = item:getId()

    Save:updateInventory(self)
end

function Inventory:hasItemEquipped(item)
    return self.equippedItemIdByType[item:getType()] == item:getId()
end
