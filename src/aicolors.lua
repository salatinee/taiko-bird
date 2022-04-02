AIColors = {}

function AIColors:load()

    self.img = love.graphics.newImage("assets/ekiBirb.png")
    self.scale = 0.07 * utils.vh -- 0.5
    self.width = self.img:getWidth() * self.scale
    self.height = self.img:getHeight() * self.scale

    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.ySpeed = 7 * utils.vh
    self.timer = 0

    self.rotation = 0
    local wingsScale = 0.1 * utils.vh -- 0.75
    local wingsImage = love.graphics.newImage("assets/wing.png")
    local wingsWidth = wingsImage:getWidth() * wingsScale
    local wingsHeight = wingsImage:getHeight() * wingsScale
    local wingFrontX =  0.215 * self.width - wingsWidth / 2
    local wingBackX = 0.315 * self.width - wingsWidth / 2
    local wingsY = wingsHeight / 2
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

    self.image_map = love.image.newImageData("assets/ekiBirb.png")
    self.changeColorShader = Shaders.newNoOpShader()
end

function AIColors:update(dt)
    self.timer = self.timer + dt
    self:animate(dt)
    self:animateWings()
    if self.timer >= 0.5 then
        self.ySpeed = self.ySpeed * -1
        self.timer = 0
    end
end

function AIColors:draw()
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
        love.graphics.setShader(self.changeColorShader)
        love.graphics.draw(self.img, canvasWidth / 2 - self.width / 2, canvasHeight / 2 - self.height / 2, 0, self.scale, self.scale)
        love.graphics.setShader()
        love.graphics.draw(self.wings.front.img, wingFrontCenterX, wingCenterY, self.wings.front.rotation, self.wings.scale, self.wings.scale, wingAssetCenterX, wingAssetCenterY)


    end)

    love.graphics.draw(playerWithWingsCanvas, canvasCenterX, canvasCenterY, self.rotation, 1, 1, canvasAssetCenterX, canvasAssetCenterY)
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

function AIColors:changesColor(color)
    self.changeColorShader = newColoredPlayerShader(color)
end



function AIColors:animate(dt)
    self.y = self.y + self.ySpeed * dt
end