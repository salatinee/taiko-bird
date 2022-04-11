baseCharacter = {}

function baseCharacter:new()
    local newBaseCharacter = {}
    
    self.__index = self
    setmetatable(newBaseCharacter, self)
    return newBaseCharacter
end

function baseCharacter:load(options)
    self.img = love.graphics.newImage("assets/ekiBirb.png")
    self.scale = options.scale
    self.width = self.img:getWidth() * self.scale
    self.height = self.img:getHeight() * self.scale

    self.x = options.xCenter - self.width / 2
    self.y = options.yCenter - self.height / 2
    self.yAcceleration = 104 * utils.vh -- 750
    self.ySpeed = -3 * utils.vh -- -20

    self.rotation = 0
    self.rotationSpeed = 0
    self.rotationAcceleration = 4

    local wingsScale = self.scale * 1.5
    local wingsImage = love.graphics.newImage("assets/wing.png")
    local wingsWidth = wingsImage:getWidth() * wingsScale
    local wingsHeight = wingsImage:getHeight() * wingsScale
    local wingFrontX =  0.215 * self.width - wingsWidth / 2
    local wingBackX = 0.315 * self.width - wingsWidth / 2
    local wingsY = wingsHeight / 2 + 2 * utils.vh

    local frontWingOffsetXFromPlayerCenter = -self.width / 2
    local backWingOffsetXFromPlayerCenter = -self.width / 2 + 1 * utils.vw
    local wingOffsetYFromPlayerCenter = -self.height / 2 - 0.5 * utils.vh

    self.animationRotation = 0

    self.wings = {
        isAnimating = false,

        scale = wingsScale,

        front = {
            img = wingsImage,
            width = wingsWidth,
            height = wingsHeight,
            x = wingFrontX,
            y = wingsY,
            offsetXFromCenter = frontWingOffsetXFromPlayerCenter,
            offsetYFromCenter = wingOffsetYFromPlayerCenter,
            rotation = self.rotation + self.animationRotation,
        },

        back = {
            img = wingsImage,
            width = wingsWidth,
            height = wingsHeight,
            x = wingBackX,
            y = wingsY,
            offsetXFromCenter = backWingOffsetXFromPlayerCenter,
            offsetYFromCenter = wingOffsetYFromPlayerCenter,
            rotation = self.rotation + self.animationRotation,
        },
    }

    self.crying = {
        currentTime = 0,
        duration = 0.9,
    }

    self.changeColorShader = Shaders.newNoOpShader()
end

function baseCharacter:drawPlayerModel(crying)
    local canvasWidth = self.width
    local canvasHeight = self.height + 28 * utils.vh -- self.height + 100
    local canvasAssetCenterX = canvasWidth / 2
    local canvasAssetCenterY = canvasHeight / 2
    local canvasCenterX = self.x + canvasWidth / 2
    local canvasCenterY = self.y + canvasHeight / 2 - 14 * utils.vh -- self.y + canvasHeight / 2 - 50 

    local wingAssetCenterX = self.wings.front.img:getWidth() / 2
    local wingAssetCenterY = self.wings.front.img:getHeight() / 2
    local wingFrontCenterX = canvasWidth / 2 + self.wings.front.offsetXFromCenter + self.wings.front.width / 2
    local wingBackCenterX = canvasWidth / 2 + self.wings.back.offsetXFromCenter + self.wings.back.width / 2
    local wingCenterY = canvasHeight / 2 + self.wings.front.offsetYFromCenter + self.wings.front.height / 2

    local playerWithWingsCanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
    playerWithWingsCanvas:renderTo(function()
        love.graphics.draw(self.wings.back.img, wingBackCenterX, wingCenterY, self.wings.back.rotation, self.wings.scale, self.wings.scale, wingAssetCenterX, wingAssetCenterY)
        love.graphics.setShader(self.changeColorShader)
        self:drawPlayer(crying, canvasWidth, canvasHeight)
        love.graphics.setShader()
        love.graphics.draw(self.wings.front.img, wingFrontCenterX, wingCenterY, self.wings.front.rotation, self.wings.scale, self.wings.scale, wingAssetCenterX, wingAssetCenterY)
        self:drawWearables(canvasWidth, canvasHeight)
    end)

    love.graphics.draw(playerWithWingsCanvas, canvasCenterX, canvasCenterY, self.rotation, 1, 1, canvasAssetCenterX, canvasAssetCenterY)
end

function baseCharacter:drawPlayer(crying, canvasWidth, canvasHeight)
    if crying then
        love.graphics.draw(self:cryingAnimation(), canvasWidth / 2 - self.width / 2, canvasHeight / 2 - self.height / 2, 0, self.scale, self.scale)
        return
    end
    love.graphics.draw(self.img, canvasWidth / 2 - self.width / 2, canvasHeight / 2 - self.height / 2, 0, self.scale, self.scale)    
end

function baseCharacter:cryingAnimation()
    local animationNumber = math.floor(self.crying.currentTime / 0.1)
    return love.graphics.newImage("assets/sad-ekiBirb" .. animationNumber .. ".png")
end

function baseCharacter:changesColor(color)
    self.changeColorShader = newColoredPlayerShader(color)
end

function baseCharacter:drawWearables(canvasWidth, canvasHeight)
    for _, itemType in ipairs(itemTypes) do
        local itemId = Inventory.equippedItemIdByType[itemType]
        if itemId ~= nil then
            local item = Items:getItemById(itemId)
            item:draw(self.scale, canvasWidth, canvasHeight)
        end
    end
end
