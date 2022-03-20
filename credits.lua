Credits = {}

function Credits:load()
    self.img = love.graphics.newImage("assets/credits.png")
    self.scale = 0.06 * utils.vh

    self.width = self.img:getWidth() * self.scale
    self.height = self.img:getHeight() * self.scale
    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = 4 * utils.vh

    self.opacity = 0
    self.opacitySpeed = 1
end

function Credits:update(dt)
    self.opacity = math.min(1, self.opacity + self.opacitySpeed * dt)
end

function Credits:draw()
    love.graphics.setColor(1, 1, 1, self.opacity)
    love.graphics.draw(self.img, self.x, self.y, 0, self.scale, self.scale)
    love.graphics.setColor(1, 1, 1, 1)
end

function Credits:showCredits()
    gameState = 'credits'
end

function Credits:backToMenu()
    gameState = 'menu'
    self.opacity = 0
end