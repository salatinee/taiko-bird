selectGameMode = {}

function selectGameMode:load()
    self.scale = 0.1 * utils.vh

    local classicButtonImage = love.graphics.newImage("assets/color.png")
    local classicButtonPressedImage = love.graphics.newImage("assets/color-pressed.png")

    self.classicButton = Button:new({
        x = love.graphics.getWidth() / 2 - classicButtonImage:getWidth() * self.scale - 3.5 * utils.vh,
        y = love.graphics.getHeight() / 2 - classicButtonImage:getHeight() * self.scale / 2,
        scale = self.scale,
        img = classicButtonImage,
        pressedImg = classicButtonPressedImage,
    })

    local battleStickButtonImage = love.graphics.newImage("assets/color.png")
    local battleStickButtonPressedImage = love.graphics.newImage("assets/color-pressed.png")

    self.battleStickButton = Button:new({
        x = love.graphics.getWidth() / 2 + 3.5 * utils.vh,
        y = love.graphics.getHeight() / 2 - battleStickButtonImage:getHeight() * self.scale / 2,
        scale = self.scale,
        img = battleStickButtonImage,
        pressedImg = battleStickButtonPressedImage,
    })

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
end

function selectGameMode:update(dt)
    -- 👍
end

function selectGameMode:draw()
    self.classicButton:draw()
    self.battleStickButton:draw()
    self.backButton:draw()
end

function selectGameMode:onMouseReleased(mousePosition)
    self.classicButton:onMouseReleased(mousePosition)
    self.battleStickButton:onMouseReleased(mousePosition)
    self.backButton:onMouseReleased(mousePosition)
end