Background = {}

function Background:load()
    self.img = love.graphics.newImage("assets/background.png")
end

function Background:update(dt)
    -- yeah cool
end

function Background:draw()
    -- Calcula a escala minima que vai cobrir a tela toda
    local scaleX = love.graphics.getWidth() / self.img:getWidth()
    local scaleY = love.graphics.getHeight() / self.img:getHeight()

    local scale = math.max(scaleX, scaleY)

    love.graphics.draw(self.img, 0, 0, 0, scale, scale)
end

-- BOA LINDO!
-- obg amor