Store = {}

function Store:load()
    self.background = love.graphics.newImage("assets/store/store-background.png")
    self.scale = 0.9 * 0.056 * utils.vh
    if utils.isMobile then
        self.background = love.graphics.newImage("assets/store/store-background2.png")
        -- self.scale = 0.9 * love.graphics.getWidth() / self.background:getHeight() -- isso parece errado
    end

    self.itemBackground = love.graphics.newImage("assets/store/store-item-background.png")
    self.itemBackgroundScale = 1
    self.itemButtonScale = 1.1

    local backButtonScale = 0.1 * utils.vh
    if utils.isMobile then
        backButtonScale = 0.75 * backButtonScale
    end
    local backButtonImage = love.graphics.newImage('assets/button-left-arrow.png')
    local backButtonPressed = love.graphics.newImage('assets/button-left-arrow-pressed.png')
    local backButtonHeight = backButtonImage:getHeight() * backButtonScale
    local backButtonX = utils.vh * 1.5
    local backButtonY = love.graphics.getHeight() - backButtonHeight - (utils.vh * 1.5)
    self.backButton = Button:new({
        img = backButtonImage,
        scale = backButtonScale,
        pressedImg = backButtonPressed,
        x = backButtonX,
        y = backButtonY,
    })

    local pagingButtonScale = 0.04 * utils.vh
    local previousButtonImage = love.graphics.newImage('assets/store/previous-page-button.png')
    local previousButtonPressed = love.graphics.newImage('assets/store/previous-page-button-pressed.png')
    local previousButtonHeight = previousButtonImage:getHeight() * pagingButtonScale
    local previousButtonX = love.graphics.getWidth() / 2 - previousButtonImage:getWidth() * pagingButtonScale / 2 - 5 * utils.vh
    local previousButtonY = love.graphics.getHeight() - previousButtonHeight - (utils.vh * 9)
    self.previousPageButton = Button:new({
        img = previousButtonImage,
        scale = pagingButtonScale,
        pressedImg = previousButtonPressed,
        x = previousButtonX,
        y = previousButtonY,
    })

    local nextButtonImage = love.graphics.newImage('assets/store/next-page-button.png')
    local nextButtonPressed = love.graphics.newImage('assets/store/next-page-button-pressed.png')
    local nextButtonHeight = nextButtonImage:getHeight() * pagingButtonScale
    local nextButtonX = love.graphics.getWidth() / 2 - nextButtonImage:getWidth() * pagingButtonScale / 2 + 5 * utils.vh
    local nextButtonY = love.graphics.getHeight() - nextButtonHeight - (utils.vh * 9)
    self.nextPageButton = Button:new({
        img = nextButtonImage,
        scale = pagingButtonScale,
        pressedImg = nextButtonPressed,
        x = nextButtonX,
        y = nextButtonY,
    })

    if utils.isMobile then
        self.itemsPerRow = 2
        self.rows = 3
        self.itemBackgroundScale = 1.8
    else
        self.itemsPerRow = 3
        self.rows = 2
        self.itemBackgroundScale = 2
    end

    self.currentPage = 1

    self.visibleListings = {}

    self:updateVisibleListings()
end

function Store:getNumberOfPages()
    local allItems = Items:getAllItems()
    local visibleListingsPerPage = self.itemsPerRow * self.rows

    return math.ceil(#allItems / visibleListingsPerPage)
end

function Store:updateVisibleListings()
    self.visibleListings = {}

    local allItems = Items:getAllItems()
    local visibleListingsPerPage = self.itemsPerRow * self.rows

    -- TODO implementar paginacao
    local firstItemIndex = (self.currentPage - 1) * visibleListingsPerPage
    local lastItemIndex = math.min(#allItems - 1, firstItemIndex + visibleListingsPerPage - 1)

    local rowWidth = 0.9 * love.graphics.getWidth()
    local columnWidth = rowWidth / self.itemsPerRow
    local rowStartX = 0.05 * love.graphics.getWidth()
    
    local rowStartY = 0.05 * love.graphics.getHeight()
    local rowHeight = 0.75 * love.graphics.getHeight() / self.rows

    -- i inicia em 0 acho...
    for i = firstItemIndex, lastItemIndex do
        -- positionOnPage tbm comeca em 0
        local positionOnPage = i - firstItemIndex
        local item = allItems[i + 1]
        local row = math.floor(positionOnPage / self.itemsPerRow)
        local column = positionOnPage % self.itemsPerRow

        local backgroundWidth = self.itemBackground:getWidth() * self.scale * self.itemBackgroundScale
        local backgroundHeight = self.itemBackground:getHeight() * self.scale * self.itemBackgroundScale

        local backgroundXCenter = rowStartX + (column + 0.5) * columnWidth
        local backgroundX = backgroundXCenter - backgroundWidth / 2

        local backgroundYCenter = rowStartY + (row + 0.5) * rowHeight
        local backgroundY = backgroundYCenter - backgroundHeight / 2

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

        -- Colocar o botao em qqr lugar, pra gente descobrir a width e height dele e mover depois
        local button = ItemButton:new({
            x = 0,
            y = 0,
            scale = self.scale * self.itemBackgroundScale * self.itemButtonScale,
            price = item:getPrice(),
            type = buttonType,
        })

        local buttonY = backgroundPosition.y + backgroundPosition.height + utils.vh * 1
        local buttonScaleX = button:getScaleX() * backgroundPosition.width / button:getWidth()
        button:moveTo(backgroundPosition.x, buttonY)
        button:setScaleX(buttonScaleX)

        local image = love.graphics.newImage(item:getStoreListingAssetLocation())
        local imageScale = math.min(
            0.4 * backgroundPosition.width / image:getWidth(),
            0.4 * backgroundPosition.height / image:getHeight()
        )

        local imagePosition = {
            x = backgroundPosition.x + backgroundPosition.width / 2 - image:getWidth() * imageScale / 2,
            y = backgroundPosition.y + backgroundPosition.height / 2 - image:getHeight() * imageScale / 2,
        }

        self.visibleListings[positionOnPage + 1] = {
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
        love.graphics.draw(self.itemBackground, listing.backgroundPosition.x, listing.backgroundPosition.y, 0, self.scale * self.itemBackgroundScale, self.scale * self.itemBackgroundScale)
        love.graphics.draw(listing.image, listing.imagePosition.x, listing.imagePosition.y, 0, listing.imageScale, listing.imageScale)
        listing.button:draw()
    end

    self.backButton:draw()
    self.previousPageButton:draw()
    self.nextPageButton:draw()
end

function Store:onMousePressed(position)
    for _, listing in ipairs(self.visibleListings) do
        if listing.button:isHovered(position) then
            listing.button:setButtonAsPressed(position)
        end
    end

    if self.backButton:isHovered(position) then
        self.backButton:setButtonAsPressed(position)
    end

    if self.previousPageButton:isHovered(position) then
        self.previousPageButton:setButtonAsPressed(position)
    end

    if self.nextPageButton:isHovered(position) then
        self.nextPageButton:setButtonAsPressed(position)
    end
end

function Store:onMouseReleased(position)
    self.backButton:onMouseReleased(position)
    self.previousPageButton:onMouseReleased(position)
    self.nextPageButton:onMouseReleased(position)

    for _, listing in ipairs(self.visibleListings) do
        listing.button:onMouseReleased(position)

        if listing.button:isHovered(position) then
            self:onListingButtonClicked(listing)
        end
    end

    if self.backButton:isHovered(position) then
        gameState = "menu"
    end

    if self.previousPageButton:isHovered(position) then
        self:onPreviousPageClicked()
    end

    if self.nextPageButton:isHovered(position) then
        self:onNextPageClicked()
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
    else
        -- Se o cara tem o item equipado, desequipar
        Inventory:deequipItem(item)
    end

    self:updateVisibleListings()
end

function Store:onPreviousPageClicked()
    self.currentPage = math.max(1, self.currentPage - 1)

    self:updateVisibleListings()
end

function Store:onNextPageClicked()
    self.currentPage = math.min(self.currentPage + 1, self:getNumberOfPages())

    self:updateVisibleListings()
end
