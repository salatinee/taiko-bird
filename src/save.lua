Save = {
    filename = "best.eki",
    defaultSave = {
        ["bestClassicScore"] = 0,
        ["bestBattlestickScore"] = 0, 
        ["currentColor"] = 1, 
        ["coins"] = 0,
        ["inventory"] = {
            ["equippedItemIdByType"] = {},
            ["itemsIds"] = {},
        },
        ["version"] = 2,
    }
}

leaderboardIDs = {
    Classic = "CgkIqP7r2vYIEAIQAg",
    Battlestick = "",
}

local function performInitialMigration(save)
    if save.version == nil then
        save.version = 1
    end

    return save
end

local migrationFunctions = {
    -- nossa obrigada copilot
    [1] = function(save)
        save.bestClassicScore = save.bestScore
        save.bestScore = nil
        save.version = 2

        return save
    end
}

-- dai tipo uhh no read ficaria assim

function Save:read()
    if love.filesystem.getInfo(self.filename) == nil then
        return self.defaultSave
    else
        local saveContents, _ = binser.deserializeN(love.filesystem.read(self.filename), 1)
        if not pcall(function() assert(type(saveContents) == "table") end) then
            love.filesystem.write(self.filename, binser.serialize(self.defaultSave))
            return self.defaultSave
        end

        -- Perform migrations
        saveContents = performInitialMigration(saveContents)
        for i = saveContents.version, #migrationFunctions do
            saveContents = migrationFunctions[i](saveContents)
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

function Save:readBestScore(gameMode)
    return self:read()["best" .. gameMode .. "Score"]
end

function Save:updateIfBestScore(gameMode, score)
    local contents = self:read()
    if score >= contents["best" .. gameMode .. "Score"] then
        contents["best" .. gameMode .. "Score"] = score
        leaderboards.submitScore(leaderboardIDs[gameMode], score)
        self:save(contents)
    end
end

function Save:updateAndReadBestScore(gameMode, score)
    local gameMode = firstToUpper(gameMode)
    self:updateIfBestScore(gameMode, score)

    return self:readBestScore(gameMode)
end

function Save:readCurrentColor()
    return self:read()["currentColor"]
end

function Save:updateCoinsQuantity()
    local contents = self:read()
    local quantity = PlayerCoins.quantity
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

function Save:readInventoryData()
    return self:read()["inventory"]
end

function Save:updateInventoryData(inventoryData)
    local saveContents = self:read()
    saveContents['inventory'] = inventoryData
    self:save(saveContents)
end