BaseEnemyType = {}

function BaseEnemyType:new()
    local newEnemyType = {}
    self.__index = self
    setmetatable(newEnemyType, self)
    return newEnemyType
end

-- preguicinha
function BaseEnemyType:defaultFields()
    return {

        hp = 3,
        hitAnimation = {
            increaseRed = 0.99,
            increaseRedSpeed = 7.5,
            blueMultiplier = 1,
            greenMultiplier = 1,
            timer = 0,
            duration = 0.075,
            animating = false,
        },
    }
end

function BaseEnemyType:createEnemy()
    error("to be implemented by child")
end

function BaseEnemyType:isDead()
    error("to be implemented by child")
end

function BaseEnemyType:updateShape()
    self.shape:moveTo(self.x - self.width / 2, self.y + self.height / 2)
    self.shape:setRotation(self.rotation)
end

function BaseEnemyType:followPlayer(dt)
    self.y = self.y - self.ySpeed * dt
    
    if self.x - self.width / 2 < BattleStickPlayer.x + BattleStickPlayer.width / 2 then
		self.x = self.x + (self.xSpeed * dt)
	end
	if self.x - self.width / 2 > BattleStickPlayer.x + BattleStickPlayer.width / 2 then
		self.x = self.x - (self.xSpeed * dt)
	end
end

function BaseEnemyType:gotHit()
    for i, shot in ipairs(Shot.shots) do
        if self.shape:collidesWith(shot.shape) then
            self.hp = self.hp - 1
            self.hitAnimation.animating = true
            Shot:deleteShot(i)
        end
    end
end

function BaseEnemyType:tryToPerformHitAnimation(dt)
    if self.hitAnimation.animating then
        self.hitAnimation.timer = self.hitAnimation.timer + dt
        self.hitAnimation.timer = math.min(self.hitAnimation.timer, self.hitAnimation.duration)
        
        self.hitAnimation.blueMultiplier = self.hitAnimation.blueMultiplier - self.hitAnimation.increaseRed * self.hitAnimation.increaseRedSpeed * dt
        self.hitAnimation.greenMultiplier = self.hitAnimation.greenMultiplier - self.hitAnimation.increaseRed * self.hitAnimation.increaseRedSpeed * dt

        if self.hitAnimation.timer >= self.hitAnimation.duration then
            self.hitAnimation.timer = 0
            if self.hitAnimation.increaseRed > 0 then
                self.hitAnimation.increaseRed = -self.hitAnimation.increaseRed
                return
            end
            self.hitAnimation.animating = false
            self.hitAnimation.increaseRed = -self.hitAnimation.increaseRed
            self.hitAnimation.blueMultiplier = 1
            self.hitAnimation.greenMultiplier = 1
        end
    end
end

function BaseEnemyType:calculateAngleToPlayer()
    local a = BattleStickPlayer.x - self.x
    local b = math.sqrt((BattleStickPlayer.x - self.x)^2 + (BattleStickPlayer.y - self.y)^2)
    local angle = math.acos(a/b)
    if angle > (math.pi / 2) then
        -- se ele for maior do que pi/2, deve ser ao menos menor que 5pi/6
        angle = math.min(angle, 5 * math.pi / 6)
    else
        -- se ele for menor do que pi/2, deve ser ao menos maior que pi/6
        angle = math.max(angle, math.pi / 6)
    end

    self.rotation = angle
end

function BaseEnemyType:collidesWithPlayer()
    return self.shape:collidesWith(BattleStickPlayer.shape)
end