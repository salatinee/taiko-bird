Store = {}

function Store:load()
    self.background = love.graphics.newImage("assets/store/store-background.png") -- vou renomaer
    self.scale = 0.9 * love.graphics.getWidth() / self.background:getWidth() -- isso parece errado

    self.itemBackground = love.graphics.newImage("assets/store/store-item-background.png")

    self.visibleItems = {}

    self:updateVisibleItems()
end

function Store:updateVisibleItems()
    local allItems = Items:getAllItems()
    -- TODO implementar paginacao
    local firstItemIndex = 0
    local lastItemIndex = math.min(#allItems - 1, 6)

    local itemsPerRow = 3

    local rowWidth = 0.9 * love.graphics.getWidth()
    local columnWidth = rowWidth / itemsPerRow
    local rowStartX = 0.05 * love.graphics.getWidth()
    
    local rowStartY = 0.05 * love.graphics.getHeight()
    local rowHeight = 0.9 * love.graphics.getHeight() / 2

    -- i inicia em 0 acho...
    for i = firstItemIndex, lastItemIndex do
        local item = allItems[i + 1]
        local row = math.floor(i / itemsPerRow)
        local column = i % itemsPerRow

        local backgroundWidth = self.itemBackground:getWidth() * self.scale
        local backgroundHeight = self.itemBackground:getHeight() * self.scale

        local backgroundXCenter = rowStartX + (column + 0.5) * columnWidth
        local backgroundX = backgroundXCenter - backgroundWidth / 2

        local backgroundYCenter = rowStartY + (row + 0.5) * rowHeight
        local backgroundY = backgroundYCenter - backgroundHeight / 2

        print(rowStartY, row, rowHeight, backgroundHeight, backgroundYCenter, backgroundY)
        local backgroundPosition = {
            x = backgroundX,
            y = backgroundY,
            width = backgroundWidth,
            height = backgroundHeight,
        }

        -- Colocar o botao em qqr lugar, pra gente descobrir a width e height dele e mover depois
        local button = ItemButton:new({
            x = 0,
            y = 0,
            scale = self.scale,
            price = item.price,
        })

        local centeredButtonX = backgroundPosition.x + backgroundPosition.width / 2 - button:getWidth() / 2
        local buttonY = backgroundPosition.y + backgroundPosition.height - button:getHeight() / 2
        button:moveTo(centeredButtonX, buttonY)

        local image = love.graphics.newImage(item:getAssetLocation())
        local imageScale = math.min(
            0.4 * backgroundPosition.width / image:getWidth(),
            0.4 * backgroundPosition.height / image:getHeight()
        )

        local imagePosition = {
            x = backgroundPosition.x + backgroundPosition.width / 2 - image:getWidth() * imageScale / 2,
            y = backgroundPosition.y + backgroundPosition.height / 2 - image:getHeight() * imageScale / 2,
        }

        -- isso ta mt cagado
        self.visibleItems[i + 1] = {
            item = item,
            image = love.graphics.newImage(item:getAssetLocation()),
            imagePosition = imagePosition,
            imageScale = imageScale,
            backgroundPosition = backgroundPosition,
            button = button,
        }
    end
end

function Store:update()
end

function Store:draw()
    -- Desenhar o background ocupando 90% da tela
    local backgroundScaleX = 0.9 * love.graphics.getWidth() / self.background:getWidth()
    local backgroundScaleY = 0.9 * love.graphics.getHeight() / self.background:getHeight()
    local backgroundX = 0.05 * love.graphics.getWidth()
    local backgroundY = 0.05 * love.graphics.getHeight()

    love.graphics.draw(self.background, backgroundX, backgroundY, 0, backgroundScaleX, backgroundScaleY)

    -- Desenhar os itens
    for _, item in ipairs(self.visibleItems) do
        love.graphics.draw(self.itemBackground, item.backgroundPosition.x, item.backgroundPosition.y, 0, self.scale, self.scale)
        love.graphics.draw(item.image, item.imagePosition.x, item.imagePosition.y, 0, item.imageScale, item.imageScale)
        item.button:draw()
    end
end

function Store:onMousePressed(position)
end

function Store:onMouseReleased(position)
end