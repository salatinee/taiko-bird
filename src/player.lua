
Player = baseCharacter:new()

function Player:load()
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

function Player:update(dt)
    objectGravity(Player, dt)
    self:playerScreenCollision()
    self:playerCoinCollision()
    self.shape:moveTo(self.x + self.width / 2, self.y + self.height * 0.775 / 2)
    self.shape:setRotation(self.rotation)
    

    if not self.wings.isAnimating then
        self:animateWings()
    end

    if gameState == "inGame" then
        objectRotation(Player, dt)
        self:playerObstacleCollision()

    elseif gameState == "gameOver" then
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
    local rotation = object.rotation + object.rotationSpeed * dt
    object.rotation = clamp(-math.pi / 4, rotation, math.pi / 2)

    if Player.rotation == (-math.pi / 4) then
        Player.rotationSpeed = math.max(-1.5, Player.rotationSpeed)
    end
end

function Player:reset()
    self.rotation = 0
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.ySpeed = -3 * utils.vh -- 20
    self.rotationSpeed = 0
end

function Player:playerScreenCollision()
    if Player.y <= 0 then
        Player.y = 0
        Player.ySpeed = 0

    elseif Player.y + Player.height >= love.graphics.getHeight() then
        Player.y = love.graphics.getHeight() - Player.height
        GameOver:gameOver()

    end
end

function Player:changesColor(color)
    self.changeColorShader = newColoredPlayerShader(color)
end


function Player:draw()
    local crying = gameState == "gameOver"
    self:drawPlayerModel(crying)
end

function Player:jump()
    self.flap:stop()
    self.flap:play()
    Player.ySpeed = -52 * utils.vh -- -375
    Player.rotationSpeed = -2.5
end

function Player:updateWings()
    self.wings.front.rotation = self.rotation + self.animationRotation
    self.wings.back.rotation = self.rotation + self.animationRotation
end

function Player:animateWings()
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

function Player:playerObstacleCollision()
    for i, obstacle in ipairs(obstacles.obstacles) do
        if Obstacle.checkObstacleCollision(Player, obstacle) then
            GameOver:gameOver()
        end
    end
end

function Player:playerCoinCollision()
    for i, coin in ipairs(Coin.coins) do
        return Coin:checkCoinCollision(Player, i, coin)
    end
end
