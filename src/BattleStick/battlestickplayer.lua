
BattleStickPlayer = baseCharacter:new()

function BattleStickPlayer:load()
    baseCharacter.load(self, {
        scale = 0.035 * utils.vh,
        xCenter = love.graphics.getWidth() / 2,
        yCenter = love.graphics.getHeight() - 12 * utils.vh,
    })

    self.ySpeed = 9 * utils.vh

    self.shape = shapes.newPolygonShape(
        self.x, self.y,
        self.x + self.width * 0.85, self.y,
        self.x + self.width * 0.85, self.y + self.height * 0.775,
        self.x, self.y + self.height * 0.775
    )

    self.rotation = -math.pi / 2
    self.xSpeed = 35 * utils.vh -- 250
    self.timer = 0

    self.getMousePosition = utils.isMobile and love.touch.getPosition or love.mouse.getPosition
end

function BattleStickPlayer:moveAndShoot(dt)
    local mousePosition = {}
    mousePosition.x, mousePosition.y = self.getMousePosition()

    if self.x + self.width / 2 < mousePosition.x then
		self.x = self.x + (self.xSpeed * 2.5 * dt)
	end
	if self.x + self.width / 2 > mousePosition.x then
		self.x = self.x - (self.xSpeed * 2.5 * dt)
	end
    self:animateFlying(dt)
    self:shoot()
end

function BattleStickPlayer:update(dt)
    self:moveAndShoot(dt)
    self:animateWings()
end

function BattleStickPlayer:reset()

end

function BattleStickPlayer:BattleStickPlayerScreenCollision()

end

function BattleStickPlayer:changesColor(color)
    self.changeColorShader = newColoredPlayerShader(color)
end


function BattleStickPlayer:draw()
    local crying = gameState:getName() == "gameOver"
    self:drawPlayerModel(crying)
end

function BattleStickPlayer:shoot()

end

function BattleStickPlayer:updateWings()
    self.wings.front.rotation = self.rotation + self.animationRotation
    self.wings.back.rotation = self.rotation + self.animationRotation
end

function BattleStickPlayer:animateFlying(dt)
    self.timer = self.timer + dt
    dt = math.min(dt, 0.5)
    self.y = self.y + self.ySpeed * dt
    if self.timer >= 0.5 then
        self.ySpeed = self.ySpeed * -1
        self.timer = 0
    end
end

function BattleStickPlayer:animateWings()
    if not self.wings.isAnimating then
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
    end
end

function BattleStickPlayer:BattleStickPlayerObstacleCollision()

end

function BattleStickPlayer:BattleStickPlayerCoinCollision()

end
