Store = {}

function Store:load()
    self.background = love.graphics.newImage("assets/store/store-background.png")
    self.scale = 0.9 * love.graphics.getWidth() / self.background:getWidth() -- isso parece errado

    self.itemBackground = love.graphics.newImage("assets/store/store-item-background.png")

    local buttonScale = 0.5
    local leftArrowButtonImage = love.graphics.newImage('assets/button-left-arrow.png')
    local leftArrowButtonPressed = love.graphics.newImage('assets/button-left-arrow-pressed.png')
    local leftArrowButtonHeight = leftArrowButtonImage:getHeight() * self.scale
    local backButtonX = utils.vh * 5
    local backButtonY = love.graphics.getHeight() - leftArrowButtonHeight - (utils.vh * 5 * buttonScale)
    self.backButton = Button:new({
        img = leftArrowButtonImage,
        scale = buttonScale,
        pressedImg = leftArrowButtonPressed,
        x = backButtonX,
        y = backButtonY,
    })

    self.visibleListings = {}

    self:updateVisibleListings()
end

function Store:updateVisibleListings()
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

        local buttonType = nil
        if Inventory:hasItemEquipped(item) then
            buttonType = 'EQUIPPED'
        elseif Inventory:hasItem(item) then
            buttonType = 'BOUGHT'
        else
            buttonType = 'BUY'
        end

        print(buttonType)

        -- Colocar o botao em qqr lugar, pra gente descobrir a width e height dele e mover depois
        local button = ItemButton:new({
            x = 0,
            y = 0,
            scale = self.scale,
            price = item:getPrice(),
            type = buttonType,
        })

        local centeredButtonX = backgroundPosition.x + backgroundPosition.width / 2 - button:getWidth() / 2
        local buttonY = backgroundPosition.y + backgroundPosition.height - button:getHeight() / 2
        button:moveTo(centeredButtonX, buttonY)

        local image = love.graphics.newImage(item:getStoreListingAssetLocation())
        local imageScale = math.min(
            0.4 * backgroundPosition.width / image:getWidth(),
            0.4 * backgroundPosition.height / image:getHeight()
        )

        local imagePosition = {
            x = backgroundPosition.x + backgroundPosition.width / 2 - image:getWidth() * imageScale / 2,
            y = backgroundPosition.y + backgroundPosition.height / 2 - image:getHeight() * imageScale / 2,
        }

        -- isso ta mt cagado
        self.visibleListings[i + 1] = {
            item = item,
            image = love.graphics.newImage(item:getStoreListingAssetLocation()),
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
    for _, listing in ipairs(self.visibleListings) do
        love.graphics.draw(self.itemBackground, listing.backgroundPosition.x, listing.backgroundPosition.y, 0, self.scale, self.scale)
        love.graphics.draw(listing.image, listing.imagePosition.x, listing.imagePosition.y, 0, listing.imageScale, listing.imageScale)
        listing.button:draw()
    end
    self.backButton:draw()
end

function Store:onMousePressed(position)
    for _, listing in ipairs(self.visibleListings) do
        if listing.button:isHovered(position) then
            listing.button:setButtonAsPressed(position)
        end
    end
    self.backButton:setButtonAsPressed(position)
end

function Store:onMouseReleased(position)
    for _, listing in ipairs(self.visibleListings) do
        listing.button:onMouseReleased(position)

        if listing.button:isHovered(position) then
            self:onListingButtonClicked(listing)
        elseif self.backButton:isHovered(position) then
            self.backButton:onMouseReleased(position)
            gameState = "menu"
        end
    end
end

function Store:tryBuyingItem(item)
    -- FIXME n sei se essa logica devia estar aqui tbh
    if item:getPrice() <= Coins.quantity then
        Coins.quantity = Coins.quantity - item:getPrice()
        Save:updateCoinsQuantity()

        Inventory:addItem(item)
    end
end

function Store:onListingButtonClicked(listing)
    local item = listing.item

    if not Inventory:hasItem(item) then
        -- Se o cara não tem o item, tentar comprar
        self:tryBuyingItem(item)
    elseif not Inventory:hasItemEquipped(item) then
        -- Se o cara tem o item mas não tem equipado, equipar
        Inventory:equipItem(item)
    end

    self:updateVisibleListings()
end
