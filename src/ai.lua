AI = baseCharacter:new()

function AI:load()

    baseCharacter:load({
        scale = 0.035 * utils.vh, -- 0.25
        xCenter = love.graphics.getWidth() / 2,
        yCenter = love.graphics.getHeight() / 2,
    })

    self.ySpeed = 7 * utils.vh
    self.timer = 0

    self.rotation = 0
end

function AI:update(dt)
    dt = math.min(dt, 0.5)
    self.timer = self.timer + dt
    self:animate(dt)
    self:animateWings()
    if self.timer >= 0.5 then
        self.ySpeed = self.ySpeed * -1
        self.timer = 0
    end

end

function AI:draw()
    self:drawPlayerModel()
end

function AI:animateWings()
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

function AI:animate(dt)
    self.y = self.y + self.ySpeed * dt
end