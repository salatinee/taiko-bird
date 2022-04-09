AIColors = baseCharacter:new()

function AIColors:load()
    baseCharacter.load(self, {
        scale = 0.07 * utils.vh,
        xCenter = love.graphics.getWidth() / 2,
        yCenter = love.graphics.getHeight() / 2,
    })

    self.ySpeed = 7 * utils.vh
    self.timer = 0
end

function AIColors:update(dt)
    dt = math.min(dt, 0.5)
    self.timer = self.timer + dt
    self:animate(dt)
    self:animateWings()
    if self.timer >= 0.5 then
        self.ySpeed = self.ySpeed * -1
        self.timer = 0
    end
end

function AIColors:draw()
    self:drawPlayerModel()
end

function AIColors:animateWings()
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

function AIColors:animate(dt)
    self.y = self.y + self.ySpeed * dt
end