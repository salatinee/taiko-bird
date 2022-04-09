baseCharacter = {}

function baseCharacter:drawPlayerModel(Player, gameState)
    local canvasWidth = Player.width
    local canvasHeight = Player.height + 56 * utils.vh -- Player.height + 100
    local canvasAssetCenterX = canvasWidth / 2
    local canvasAssetCenterY = canvasHeight / 2
    local canvasCenterX = Player.x + canvasWidth / 2
    local canvasCenterY = Player.y + canvasHeight / 2 - 28 * utils.vh -- Player.y + canvasHeight / 2 - 50 

    local wingAssetCenterX = Player.wings.front.img:getWidth() / 2
    local wingAssetCenterY = Player.wings.front.img:getHeight() / 2
    local wingFrontCenterX = Player.wings.front.x + Player.wings.front.width / 2
    local wingBackCenterX = Player.wings.back.x + Player.wings.back.width / 2
    local wingCenterY = Player.wings.front.y + Player.wings.front.height / 2

    local playerWithWingsCanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
    playerWithWingsCanvas:renderTo(function()
        love.graphics.draw(Player.wings.back.img, wingBackCenterX, wingCenterY, Player.wings.back.rotation, Player.wings.scale, Player.wings.scale, wingAssetCenterX, wingAssetCenterY)
        love.graphics.setShader(Player.changeColorShader)
        self:drawPlayer(Player, gameState, canvasWidth, canvasHeight)
        love.graphics.setShader()
        love.graphics.draw(Player.wings.front.img, wingFrontCenterX, wingCenterY, Player.wings.front.rotation, Player.wings.scale, Player.wings.scale, wingAssetCenterX, wingAssetCenterY)
        self:drawWearables()
    end)
end

function baseCharacter:drawPlayer(Player, gameState, canvasWidth, canvasHeight)
    if gameState ~= "gameOver" then
        love.graphics.draw(Player.img, canvasWidth / 2 - Player.width / 2, canvasHeight / 2 - Player.height / 2, 0, Player.scale, Player.scale)
    elseif
        love.graphics.draw(self:cryingAnimation(), canvasWidth / 2 - self.width / 2, canvasHeight / 2 - self.height / 2, 0, self.scale, self.scale)
    end
end

function baseCharacter:cryingAnimation()
    local animationNumber = math.floor(self.crying.currentTime / 0.1)
    return love.graphics.newImage("assets/sad-ekiBirb" .. animationNumber .. ".png")
end

function baseCharacter:changesColor(Player, color)
    Player.changeColorShader = newColoredPlayerShader(color)
end

function baseCharacter:drawWearables()
    for _, itemType in ipairs(itemTypes) do
        local itemId = Inventory.equippedItemIdByType[itemType]
        if itemId ~= nil then
            local item = Items:getItemById(itemId)
            item:draw()
        end
    end
end
