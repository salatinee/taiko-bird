Credits = {}

function Credits:load()
    self.img = love.graphics.newImage("assets/credits.png")

    
    if love.graphics.getWidth() < love.graphics.getHeight() then
        local ratio = self.img:getHeight() / self.img:getWidth()
        self.width = love.graphics.getWidth() * 0.9
        self.height = self.width * ratio
    else
        local ratio = self.img:getWidth() / self.img:getHeight()
        self.height = love.graphics.getHeight() * 0.9
        self.width = self.height * ratio
    end

    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.opacity = 0
    self.opacitySpeed = 1
end

function Credits:update(dt)
    self.opacity = math.min(1, self.opacity + self.opacitySpeed * dt)
end

function Credits:draw()
    love.graphics.setColor(1, 1, 1, self.opacity)
    love.graphics.draw(self.img, self.x, self.y, 0, self.width / self.img:getWidth(), self.height / self.img:getHeight())
    love.graphics.setColor(1, 1, 1, 1)
end

function Credits:showCredits()
    admob.hideBanner()

    gameState = 'credits'
end

function Credits:backToMenu()
    admob.showBanner()

    gameState = 'menu'
    self.opacity = 0
end