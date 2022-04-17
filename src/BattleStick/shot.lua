Shot = {}

function Shot:load()
    self.shots = {}
    self.img = love.graphics.newImage("assets/coin0.png") -- FIXME yeah
    self.sound = love.audio.newSource("assets/coinbing.wav", "static") -- FIXME yeah
    self.scale = 0.025 * utils.vh -- 0.33
    self.ySpeed = 15 * utils.vh
    self.sound:setVolume(0.1)
end

function Shot:update(dt)
    for i, shot in ipairs(self.shots) do
        self:moveShot(shot, dt)
    end
end

function Shot:createShot()
    local newShot = {}
    newShot.img = self.img
    newShot.width = self.img:getWidth() * self.scale
    newShot.height = self.img:getHeight() * self.scale
    newShot.x = BattleStickPlayer.x + newShot.width
    newShot.y = BattleStickPlayer.y - BattleStickPlayer.height + utils.vh

    self.shape = shapes.newPolygonShape(
        newShot.x, newShot.y,
        newShot.x + newShot.width, newShot.y,
        newShot.x + newShot.width, newShot.y + newShot.height,
        newShot.x, newShot.y + newShot.height
    )
    table.insert(self.shots, newShot)
    self.sound:play()
    Timer.after(0.09, function() self.sound:stop() end)
    return newShot
end

function Shot:moveShot(shot, dt)
    shot.y = shot.y - utils.vh * self.ySpeed * dt
end

function Shot:deleteShot(i)
    table.remove(self.shots, i)
end

function Shot:deleteShotsIfNeeded()
    for i, shot in ipairs(self.shots) do
        if shot.y - shot.width < 0 then
            self:deleteShot(i)
        end
    end
end

function Shot:draw()
    for i, shot in ipairs(self.shots) do
        love.graphics.draw(shot.img, shot.x, shot.y, 0, self.scale, self.scale)
    end
end

function Shot:collidesWith(thing)
    
end