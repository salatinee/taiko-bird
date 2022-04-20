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

    local leaderboardButtonImage = love.graphics.newImage("assets/leaderboard-button.png")
    local leaderboardScale = self.menuScale * 4
    self.leaderboardButton = Button:new({
        x = love.graphics.getWidth() - 6 * utils.vh - leaderboardButtonImage:getWidth() * leaderboardScale / 2,
        y = 10 * utils.vh - leaderboardButtonImage:getHeight() * leaderboardScale / 4, -- avoiding ad thing
        scale = leaderboardScale,
        img = leaderboardButtonImage,
        pressedImg = love.graphics.newImage("assets/leaderboard-button-pressed.png"),
    })

    self.memeShader = Shaders.newPixelizeShader(10)
end

function Menu:update(dt)

end

function Menu:draw()
    love.graphics.draw(self.title.img, self.title.x, self.title.y, 0, self.menuScale, self.menuScale)

    love.graphics.setShader(self.memeShader)
    self.playButton:draw()
    self.rateButton:draw()
    self.colorsButton:draw()
    self.shopButton:draw()
    self.leaderboardButton:draw()
    love.graphics.setShader()
end

function Menu:onMouseReleased(mousePosition)
    self.playButton:onMouseReleased(mousePosition)
    self.rateButton:onMouseReleased(mousePosition)
    self.colorsButton:onMouseReleased(mousePosition)
    self.shopButton:onMouseReleased(mousePosition)
    self.leaderboardButton:onMouseReleased(mousePosition)
end

function Menu:playGame()
    gameState = SelectGameModeState
end

function Menu:rateGame()
    love.system.openURL("https://www.youtube.com/watch?v=a7E4O-plb7w")
end

function Menu:openStore()
    admob.hideBanner()
    gameState = StoreState
end

function Menu:openLeaderboard()
    leaderboards.showLeaderboard('CgkIqP7r2vYIEAIQAg')
end