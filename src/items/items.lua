Items = {}

function Items:load()
    self.hats = require('src/items/hats/hats')
end

function Items:getItemById(id)
    for i, item in ipairs(self.hats) do
        if item.id == id then
            return item
        end
    end

    return nil
end

function Items:getAllItems()
    return self.hats
end
