Save = {
    filename = "best.eki",
    defaultSave = {
        ["bestScore"] = 0, 
        ["currentColor"] = 1, 
        ["coins"] = 0,
        ["inventory"] = {
            ["equippedItemIdByType"] = {},
            ["itemsIds"] = {},
        }
    }
}

function Save:read()
    if love.filesystem.getInfo(self.filename) == nil then
        return {["bestScore"] = 0, ["currentColor"] = 1, ["coins"] = 0}
    else
        local saveContents, _ = binser.deserializeN(love.filesystem.read(self.filename), 1)
        if not pcall(function() assert(type(saveContents) == "table") end) then
            love.filesystem.write(self.filename, binser.serialize(self.defaultSave))
            return self.defaultSave
        end

        for i, defaultContent in pairs(self.defaultSave) do
            if saveContents[i] == nil then
                saveContents[i] = self.defaultSave[i]
                love.filesystem.write(self.filename, binser.serialize(saveContents))
            end
        end
        return saveContents
    end
end

function Save:save(saveData)
    love.filesystem.write(self.filename, binser.serialize(saveData))
end
-- Atualiza a melhor pontuação, caso seja.

function Save:readBestScore()
    return self:read()["bestScore"]
end

function Save:updateIfBestScore(score)
    local contents = self:read()
    local best = self:readBestScore()
    if score >= best then
        contents["bestScore"] = score
        self:save(contents)
    end
end

function Save:readCurrentColor()
    return self:read()["currentColor"]
end

function Save:updateCoinsQuantity()
    local contents = self:read()
    local quantity = Coins.quantity
    contents["coins"] = quantity
    self:save(contents)
end

function Save:updateCurrentColor()
    local contents = self:read()
    if contents["currentColor"] ~= Colors:getCurrentColorIndex() then
        contents["currentColor"] = Colors:getCurrentColorIndex()
        self:save(contents)
        return true -- updated
    end
    return false -- not updated
end

function Save:updateAndReadBestScore(score)
    self:updateIfBestScore(score)
    return self:readBestScore()
end

function Save:readInventoryData()
    return self:read()["inventory"]
end

function Save:updateInventoryData(inventoryData)
    local saveContents = self:read()
    saveContents['inventory'] = inventoryData
    self:save(saveContents)
end
