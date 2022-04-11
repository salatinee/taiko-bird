Items = {}

itemTypes = {"HAT", "SHOE"}

function Items:load()
    self.itemsByType = {
        ['HAT'] = require('src/items/hats/hats'),
        ['SHOE'] = require('src/items/shoes/shoes'),
    }

    self.items = {}
    for _, itemType in ipairs(itemTypes) do
        local itemsOfType = self.itemsByType[itemType]

        for i, item in ipairs(itemsOfType) do
            table.insert(self.items, item)
        end
    end
end

function Items:getItemById(id)
    for i, item in ipairs(self.items) do
        if item.id == id then
            return item
        end
    end

    return nil
end

function Items:getAllItems()
    return self.items
end
