
ClassicPlayer = baseCharacter:new()

function ClassicPlayer:load()
    baseCharacter.load(self, {
        scale = 0.035 * utils.vh,
        xCenter = 20 * utils.vw, -- uhh vai ter q calcular como q fica certo antes era 15.5 * utils.vw
        yCenter = love.graphics.getHeight() / 2,
    })

    -- flap sound
    self.flap = love.audio.newSource("assets/wing-flap.wav", "static")
    self.flap:setVolume(0.5)

    self.shape = shapes.newPolygonShape(
        self.x, self.y,
        self.x + self.width * 0.85, self.y,
        self.x + self.width * 0.85, self.y + self.height * 0.775,
        self.x, self.y + self.height * 0.775
    )
end

function ClassicPlayer:update(dt)
    objectGravity(ClassicPlayer, dt)
    self:classicPlayerScreenCollision()
    self:classicPlayerCoinCollision()
    self.shape:moveTo(self.x + self.width / 2, self.y + self.height * 0.775 / 2)

    if not self.wings.isAnimating then
        self:animateWings()
    end

    if gameState:getName() == "classic" then
        objectRotation(ClassicPlayer, dt)
        self.shape:setRotation(self.rotation)
        self:classicPlayerObstacleCollision()

    elseif gameState:getName() == "gameOver" then
        self.crying.currentTime = self.crying.currentTime + dt
        if self.crying.currentTime >= self.crying.duration then
            self.crying.currentTime = math.fmod(self.crying.currentTime, self.crying.duration) 
        end
    end
end

function objectGravity(object, dt)
    object.ySpeed = object.ySpeed + object.yAcceleration * dt 
    object.y = object.y + object.ySpeed * dt
end

function objectRotation(object, dt)
    object.rotationSpeed = object.rotationSpeed + object.rotationAcceleration * dt
    object.rotation = clamp(-math.pi / 4, object.rotation + object.rotationSpeed * dt, math.pi / 2)

    if ClassicPlayer.rotation == (-math.pi / 4) then
        ClassicPlayer.rotationSpeed = math.max(-1.5, ClassicPlayer.rotationSpeed)
    end
end

function ClassicPlayer:reset()
    self.rotation = 0
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.ySpeed = -3 * utils.vh -- 20
    self.rotationSpeed = 0
end

function ClassicPlayer:classicPlayerScreenCollision()
    if ClassicPlayer.y <= 0 then
        ClassicPlayer.y = 0
        ClassicPlayer.ySpeed = 0

    elseif ClassicPlayer.y + ClassicPlayer.height >= love.graphics.getHeight() then
        ClassicPlayer.y = love.graphics.getHeight() - ClassicPlayer.height
        ClassicGameOver:gameOver()

    end
end

function ClassicPlayer:changesColor(color)
    self.changeColorShader = newColoredPlayerShader(color)
end


function ClassicPlayer:draw()
    local crying = gameState:getName() == "gameOver"
    self:drawPlayerModel(crying)
end

function ClassicPlayer:jump()
    self.flap:stop()
    self.flap:play()
    ClassicPlayer.ySpeed = -52 * utils.vh -- -375
    ClassicPlayer.rotationSpeed = -2.5
end

function ClassicPlayer:updateWings()
    self.wings.front.rotation = self.rotation + self.animationRotation
    self.wings.back.rotation = self.rotation + self.animationRotation
end

function ClassicPlayer:animateWings()
    if self.ySpeed <= 0 then
        self.wings.isAnimating = true
        Timer.after(0.1, function()
            self.wings.back.rotation = math.pi / 6
            self.wings.front.rotation = math.pi / 6

            Timer.after(0.1, function()
                self.wings.back.rotation = 0
                self.wings.front.rotation = 0

                Timer.after(0.1, function()
                    self.wings.back.rotation = -math.pi / 6
                    self.wings.front.rotation = -math.pi / 6
                
                    Timer.after(0.1, function()
                        self.wings.back.rotation = 0
                         self.wings.front.rotation = 0
                         self.wings.isAnimating = false
                
                    end)
                end)
            end)
        end)
    else
        self.wings.isAnimating = false
    end
end

function ClassicPlayer:classicPlayerObstacleCollision()
    for i, obstacle in ipairs(ClassicObstacles.obstacles) do
        if ClassicObstacle.checkObstacleCollision(ClassicPlayer, obstacle) then
            ClassicGameOver:gameOver()
        end
    end
end

function ClassicPlayer:classicPlayerCoinCollision()
    for i, coin in ipairs(Coin.coins) do
        return Coin:checkCoinCollision(ClassicPlayer, i, coin)
    end
end
