Enemy = {}

function Enemy:load()
    self.timer = 0
    self.enemies = {}
    self.scale = 0.025 * utils.vh

    self.img = love.graphics.newImage('assets/akuBirb.png')
    self.capeAnimation = {
        frames = {},
        duration = 1,
    }

    for i = 0, 23 do
        local frame = love.graphics.newImage('assets/aku-cape-' .. i .. '.png')

        table.insert(self.capeAnimation.frames, frame)
    end

    table.insert(self.enemies, Enemy:createEnemy())
end

function Enemy:update(dt)
    self.timer = self.timer + dt

    for i, enemy in ipairs(self.enemies) do
        self:updateEnemy(enemy, dt)
    end
end

function Enemy:createEnemy()
    local newEnemy = {
        img = self.img,
        width = self.img:getWidth() * self.scale,
        height = self.img:getHeight() * self.scale,
        x = love.graphics.getWidth() / 2, -- cool
        y = love.graphics.getHeight() / 2, -- cool
    }

    newEnemy.shape = shapes.newPolygonShape(
        newEnemy.x, newEnemy.y,
        newEnemy.x + newEnemy.width, newEnemy.y,
        newEnemy.x + newEnemy.width, newEnemy.y + newEnemy.height,
        newEnemy.x, newEnemy.y + newEnemy.height
    )

    newEnemy.canvas = love.graphics.newCanvas(2 * newEnemy.width, newEnemy.height)

    return newEnemy
end

function Enemy:updateEnemy(enemy, dt)
    -- cool   
end

function Enemy:draw()
    for i, enemy in ipairs(self.enemies) do
        self:drawEnemy(enemy)
    end
end

function Enemy:drawEnemy(enemy)
    local enemyPositionInCanvas = {
        x = enemy.canvas:getWidth() / 2 - enemy.width / 2,
        y = 0,
    }

    local capeAnimationTime = math.fmod(self.timer, self.capeAnimation.duration)
    local capeAnimationFrameIndex = math.ceil(capeAnimationTime / self.capeAnimation.duration * #self.capeAnimation.frames)
    local capeAnimationFrame = self.capeAnimation.frames[capeAnimationFrameIndex]

    local capePositionInCanvas = {
        -- Desenhar de modo que a parte da direita da capa fique em 30% da width do corpo
        x = enemyPositionInCanvas.x + enemy.width * 0.3 - capeAnimationFrame:getWidth() * self.scale,
        y = 0,
    }

    enemy.canvas:renderTo(function()
        love.graphics.clear()
        love.graphics.draw(enemy.img, enemyPositionInCanvas.x, enemyPositionInCanvas.y, 0, self.scale, self.scale)

        love.graphics.draw(capeAnimationFrame, capePositionInCanvas.x, capePositionInCanvas.y, 0, self.scale, self.scale)
    end)

    local canvasPosition = {
        x = enemy.x + enemy.width / 2 - enemy.canvas:getWidth() / 2,
        y = enemy.y - enemy.canvas:getHeight() / 2,
    }

    love.graphics.draw(enemy.canvas, canvasPosition.x, canvasPosition.y)
end
