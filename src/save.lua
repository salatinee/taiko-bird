Save = {filename = "best.eki"}

function Save:readBestScore()
    if love.filesystem.getInfo(self.filename) == nil then
        return 0
    else
        local contents, bytesRead = love.filesystem.read(self.filename)
        assert(type(contents) == "string")
        assert(type(tonumber(contents)) == "number")
        return tonumber(contents)
    end
end

-- Atualiza a melhor pontuação, caso seja.
function Save:updateIfBestScore(score)
    local best = self:readBestScore()
    if score >= best then
        love.filesystem.write(self.filename, score)
    end
end

function Save:updateAndReadBestScore(score)
    self:updateIfBestScore(score)
    return self:readBestScore()
end