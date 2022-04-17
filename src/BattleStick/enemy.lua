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
        self:updateEnemy(i, enemy, dt)
    end
end

function Enemy:createEnemy()
    local newEnemy = {
        img = self.img,
        width = self.img:getWidth() * self.scale,
        height = self.img:getHeight() * self.scale,
        x = love.graphics.getWidth() / 2, -- cool
        y = 0, -- cool
        ySpeed = -20 * utils.vh,
        xSpeed = 40 * utils.vw,
        rotation = math.pi / 2,
        hp = 4,
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

function Enemy:updateEnemy(i, enemy, dt)
    self:followPlayer(enemy, dt) 
    self:calculateAngleToPlayer(enemy)
    self:getsHit(i, enemy)
    self:updateShape(enemy)
end

function Enemy:updateShape(enemy)
    enemy.shape:moveTo(enemy.x - enemy.width / 2 , enemy.y - enemy.height / 2)
    enemy.shape:setRotation(enemy.rotation)
end

function Enemy:followPlayer(enemy, dt)
    enemy.y = enemy.y - enemy.ySpeed * dt
    
    if enemy.x - enemy.width / 2 < BattleStickPlayer.x + BattleStickPlayer.width / 2 then
		enemy.x = enemy.x + (enemy.xSpeed * dt)
	end
	if enemy.x - enemy.width / 2 > BattleStickPlayer.x + BattleStickPlayer.width / 2 then
		enemy.x = enemy.x - (enemy.xSpeed * dt)
	end
end

function Enemy:calculateAngleToPlayer(enemy)
    local a = BattleStickPlayer.x - enemy.x
    local b = math.sqrt((BattleStickPlayer.x - enemy.x)^2 + (BattleStickPlayer.y - enemy.y)^2)
    local angle = math.acos(a/b)
    if angle > (math.pi / 2) then
        -- se ele for maior do que pi/2, deve ser ao menos menor que 5pi/6
        angle = math.min(angle, 5 * math.pi / 6)
    else
        -- se ele for menor do que pi/2, deve ser ao menos maior que pi/6
        angle = math.max(angle, math.pi / 6)
    end

    enemy.rotation = angle
end

function Enemy:getsHit(i, enemy)
    for n, shot in ipairs(Shot.shots) do
        if shot.shape:collidesWith(enemy.shape) then
            Shot:deleteShot(n)
            enemy.hp = enemy.hp - 1
            if enemy.hp <= 0 then
                table.remove(self.enemies, i)
            end
        end
    end
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

    local canvasAssetCenter = {
        x = enemy.canvas:getWidth() / 2,
        y = enemy.canvas:getHeight() / 2,
    }
    enemy.shape:draw('line')
    love.graphics.draw(enemy.canvas, canvasPosition.x, canvasPosition.y, enemy.rotation, 1, 1, canvasAssetCenter.x, canvasAssetCenter.y)
end
