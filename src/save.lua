Save = {filename = "best.eki"}

function Save:read()
    if love.filesystem.getInfo(self.filename) == nil then
        return {["bestScore"] = 0, ["currentColor"] = 1}
    else
        local contents, bytesRead = binser.deserializeN(love.filesystem.read(self.filename), 1)
        if not pcall(function() assert(type(contents) == "table") end) then
            local newSave = {["bestScore"] = 0, ["currentColor"] = 1}
            love.filesystem.write(self.filename, binser.serialize(newSave))
            return newSave
        end
        print(contents.bestScore, contents.currentColor)
        return contents
    end
end

function Save:save(saveData)
    love.filesystem.write(self.filename, binser.serialize(saveData))
end
-- Atualiza a melhor pontuação, caso seja.

function Save:readBestScore()
    local saveData = self:read()
    return saveData["bestScore"]
end

function Save:updateIfBestScore(score)
    local contents = self:read()
    local best = contents["bestScore"]
    if score >= best then
        contents["bestScore"] = score
        self:save(contents)
    end
end

function Save:readCurrentColor()
    local contents = self:read()
    return contents["currentColor"]
end

function Save:updateCurrentColor()
    local contents = self:read()
    if contents["currentColor"] ~= Colors:getCurrentColor() then
        contents["currentColor"] = Colors:getCurrentColor()
        self:save(contents)
    end
end

function Save:updateAndReadBestScore(score)
    self:updateIfBestScore(score)
    return self:readBestScore()
end