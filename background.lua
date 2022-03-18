Background = {}

function Background:load()
    self.img = love.graphics.newImage("assets/coolbackground.png")
    self.x = 0
    self.xSpeed = -3 * utils.vh
end

function Background:update(dt)
    self.x = self.x + self.xSpeed * dt
end

function Background:draw()
    -- Calcula a escala minima que vai cobrir a tela toda
    local scaleX = love.graphics.getWidth() / self.img:getWidth()
    local scaleY = love.graphics.getHeight() / self.img:getHeight()

    local scale = math.max(scaleX, scaleY)
    local scaledWidth = self.img:getWidth() * scale

    -- Como o self.x pode diminuir infinitamente, temos que limitar até um máximo de -scaledWidth
    local leftBackgroundXPosition = math.fmod(self.x, scaledWidth)

    love.graphics.draw(self.img, leftBackgroundXPosition, 0, 0, scale, scale)
    love.graphics.draw(self.img, leftBackgroundXPosition + scaledWidth, 0, 0, scale, scale)
end

-- BOA LINDA! ヾ(≧▽≦*)o
-- obg amor
-- aff vou deixar isso mt fof