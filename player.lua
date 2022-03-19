
Player = {}

function Player:load()
    self.img = love.graphics.newImage("assets/ekiBirb.png")
    self.scale = 0.035 * utils.vh -- 0.25
    self.width = self.img:getWidth() * self.scale
    self.height = self.img:getHeight() * self.scale

    self.x = 15.5 * utils.vw -- 200
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.yAcceleration = 104 * utils.vh -- 750
    self.ySpeed = -3 * utils.vh -- -20

    self.rotation = 0
    self.rotationSpeed = 0
    self.rotationAcceleration = 4

    -- mas esses scales precisa
    local wingsScale = 0.052 * utils.vh -- 0.375
    local wingsImage = love.graphics.newImage("assets/wing.png")
    local wingsWidth = wingsImage:getWidth() * wingsScale
    local wingsHeight = wingsImage:getHeight() * wingsScale
    -- (#^%)
    local wingFrontX =  0.215 * self.width - wingsWidth / 2
    local wingBackX = 0.315 * self.width - wingsWidth / 2
    local wingsY = wingsHeight / 2 + 3 * utils.vh
    self.animationRotation = 0

    self.wings = {
        isAnimating = false,

        scale = wingsScale,

        front = {
            img = wingsImage,
            width = wingsWidth,
            height = wingsHeight,
            x = wingFrontX,
            y = wingsY,
            rotation = self.rotation + self.animationRotation,
        },

        back = {
            img = wingsImage,
            width = wingsWidth,
            height = wingsHeight,
            x = wingBackX,
            y = wingsY,
            rotation = self.rotation + self.animationRotation,
        },
    }

    self.crying = {
        currentTime = 0,
        duration = 0.9,
    }
end

function Player:update(dt)
    objectGravity(Player, dt)
    self:playerScreenCollision()

    if not self.wings.isAnimating then
        self:animateWings()
    end

    if gameState == "inGame" then
        objectRotation(Player, dt)
        self:playerObstacleCollision()
    else
        self.crying.currentTime = self.crying.currentTime + dt
        if self.crying.currentTime >= self.crying.duration then
            self.crying.currentTime = self.crying.currentTime - self.crying.duration
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


function Player:playerScreenCollision()
    if Player.y <= 0 then
        Player.y = 0
        Player.ySpeed = 0

    elseif Player.y + Player.height >= love.graphics.getHeight() then
        Player.y = love.graphics.getHeight() - Player.height
        GameOver:gameOver()

    end
end

function Player:draw()
    


    local canvasWidth = self.width
    local canvasHeight = self.height + 14 * utils.vh -- self.height + 100
    local canvasAssetCenterX = canvasWidth / 2
    local canvasAssetCenterY = canvasHeight / 2
    local canvasCenterX = self.x + canvasWidth / 2
    local canvasCenterY = self.y + canvasHeight / 2 - 7 * utils.vh -- self.y + canvasHeight / 2 - 50 

    local wingAssetCenterX = self.wings.front.img:getWidth() / 2
    local wingAssetCenterY = self.wings.front.img:getHeight() / 2
    local wingFrontCenterX = self.wings.front.x + self.wings.front.width / 2
    local wingBackCenterX = self.wings.back.x + self.wings.back.width / 2
    local wingCenterY = self.wings.front.y + self.wings.front.height / 2

    local playerWithWingsCanvas = love.graphics.newCanvas(canvasWidth, canvasHeight)
    playerWithWingsCanvas:renderTo(function()
        love.graphics.draw(self.wings.back.img, wingBackCenterX, wingCenterY, self.wings.back.rotation, self.wings.scale, self.wings.scale, wingAssetCenterX, wingAssetCenterY)
        if gameState == "inGame" then
            love.graphics.draw(self.img, canvasWidth / 2 - self.width / 2, canvasHeight / 2 - self.height / 2, 0, self.scale, self.scale)
        else
            love.graphics.draw(self:cryingAnimation(), canvasWidth / 2 - self.width / 2, canvasHeight / 2 - self.height / 2, 0, self.scale, self.scale)
        end

        love.graphics.draw(self.wings.front.img, wingFrontCenterX, wingCenterY, self.wings.front.rotation, self.wings.scale, self.wings.scale, wingAssetCenterX, wingAssetCenterY)


    end)

    love.graphics.draw(playerWithWingsCanvas, canvasCenterX, canvasCenterY, self.rotation, 1, 1, canvasAssetCenterX, canvasAssetCenterY)

end

function Player:jump()
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

function Player:cryingAnimation()
    local animationNumber = math.floor(self.crying.currentTime / 0.1)
    local currentAnimation = love.graphics.newImage("assets/sad-ekiBirb" .. animationNumber .. ".png")
    return currentAnimation
end