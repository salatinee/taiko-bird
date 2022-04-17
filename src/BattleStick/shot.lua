Shot = {}

function Shot:load()
    self.shots = {}
    self.img = love.graphics.newImage("assets/coin0.png") -- FIXME yeah
    self.sound = love.audio.newSource("assets/coinbing.wav", "static") -- FIXME yeah
    self.scale = 0.05 * utils.vh -- 0.33
    self.timer = 0
    self.duration = 0.2
end

function Shot:update(dt)
    self.timer = self.timer + dt
    self.timer = math.min(self.timer, self.duration)
    if self.timer >= self.duration then
        self.timer = 0
    end
end

function Shot:createShot()
    local newShot = {}
    newShot.x = Player.x
    newShot.y = Player.y - Player.height + utils.vh
    newShot.width = self.img:getWidth() * self.scale
    newShot.height = self.img:getHeight() * self.scale
    newShot.img = self.img
    newShot.sound = self.sound
    table.insert(self.shots, newShot)
    return newShot
end

function Shot:moveShot(dt, shot)
    shot.y = shot.y - utils.vh * 0.5 * dt
end