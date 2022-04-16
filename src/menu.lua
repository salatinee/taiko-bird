Menu = {}

function Menu:load()
    self.menuScale = 0.07 * utils.vh -- 0.5

    if utils.isMobile then
        self.menuScale = 0.1 * utils.vw
    end
    
    local titleImage = love.graphics.newImage("assets/taikobird-title.png")
    local titleWidth = titleImage:getWidth() * self.menuScale
    local titleHeight = titleImage:getHeight() * self.menuScale
    self.title = {
        img = titleImage,
        width = titleWidth,
        height = titleHeight,
        x = love.graphics.getWidth() / 2 - titleWidth / 2,
        y = love.graphics.getHeight() / 4 - titleHeight / 2,
    }

    local playButtonImage = love.graphics.newImage("assets/play.png")
    local playButtonPressed = love.graphics.newImage("assets/play-pressed.png")
    local playButtonX = love.graphics.getWidth() / 2 - playButtonImage:getWidth() * self.menuScale - 3.5 * utils.vh -- - 25
    local playButtonY = (3 * love.graphics.getHeight() / 4) - playButtonImage:getHeight() * self.menuScale / 2

    self.playButton = Button:new({
        x = playButtonX,
        y = playButtonY,
        scale = self.menuScale,
        img = playButtonImage,
        pressedImg = playButtonPressed,
    })

    local rateButtonImage = love.graphics.newImage("assets/rate.png")
    local rateButtonPressed = love.graphics.newImage("assets/rate-pressed.png")
    local rateButtonX = love.graphics.getWidth() / 2 + 3.5 * utils.vh -- 25
    local rateButtonY = (3 * love.graphics.getHeight() / 4) - rateButtonImage:getHeight() * self.menuScale / 2 
    self.rateButton = Button:new({
        x = rateButtonX,
        y = rateButtonY,
        scale = self.menuScale,
        img = rateButtonImage,
        pressedImg = rateButtonPressed,
    })

    local colorsButtonImage = love.graphics.newImage("assets/colors-button.png")
    local colorsButtonPressed = love.graphics.newImage("assets/colors-button-pressed.png")
    local colorsButtonX = love.graphics.getWidth() / 2 - colorsButtonImage:getWidth() * self.menuScale - 3.5 * utils.vh
    local colorsButtonY = rateButtonY + rateButtonImage:getHeight() * self.menuScale + 3.5 * utils.vh
    self.colorsButton = Button:new({
        x = colorsButtonX,
        y = colorsButtonY,
        scale = self.menuScale,
        img = colorsButtonImage,
        pressedImg = colorsButtonPressed,
    })

    local shopButtonImage = love.graphics.newImage("assets/sophieshop-button.png")
    local shopButtonPressed = love.graphics.newImage("assets/sophieshop-button-pressed.png")
    local shopButtonX = love.graphics.getWidth() / 2 + 3.5 * utils.vh
    local shopButtonY = rateButtonY + rateButtonImage:getHeight() * self.menuScale + 3.5 * utils.vh
    self.shopButton = Button:new({
        x = shopButtonX,
        y = shopButtonY,
        scale = self.menuScale,
        img = shopButtonImage,
        pressedImg = shopButtonPressed,
    })

    self.buttonPressedSound = love.audio.newSource("assets/button-bing.mp3", "static")
    self.buttonPressedSound:setVolume(0.5)
end

function Menu:update(dt)

end

function Menu:draw()
    love.graphics.draw(self.title.img, self.title.x, self.title.y, 0, self.menuScale, self.menuScale)

    self.playButton:draw()
    self.rateButton:draw()
    self.colorsButton:draw()
    self.shopButton:draw()
end

function Menu:onMouseReleased(mousePosition)
    self.playButton:onMouseReleased(mousePosition)
    self.rateButton:onMouseReleased(mousePosition)
    self.colorsButton:onMouseReleased(mousePosition)
    self.shopButton:onMouseReleased(mousePosition)
end

function Menu:playGame()
    admob.hideBanner()
    gameState = ClassicState
end

function Menu:rateGame()
    love.system.openURL("https://www.youtube.com/watch?v=a7E4O-plb7w")
end

function Menu:openStore()
    admob.hideBanner()
    gameState = StoreState
end
