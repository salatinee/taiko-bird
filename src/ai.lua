AI = {}

function AI:load()

    self.img = love.graphics.newImage("assets/ekiBirb.png")
    self.scale = 0.035 * utils.vh -- 0.25
    self.width = self.img:getWidth() * self.scale
    self.height = self.img:getHeight() * self.scale

    self.x = love.graphics.getWidth() / 2 - self.width / 2
    self.y = love.graphics.getHeight() / 2 - self.height / 2
    self.ySpeed = 7 * utils.vh
    self.timer = 0

    self.rotation = 0

    local wingsScale = 0.052 * utils.vh -- 0.375
    local wingsImage = love.graphics.newImage("assets/wing.png")
    local wingsWidth = wingsImage:getWidth() * wingsScale
    local wingsHeight = wingsImage:getHeight() * wingsScale
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

    self.image_map = love.image.newImageData("assets/ekiBirb.png")
end

function AI:update(dt)
    self.timer = self.timer + dt
    self:animate(dt)
    self:animateWings()
    if self.timer >= 0.5 then
        self.ySpeed = self.ySpeed * -1
        self.timer = 0
    end
end

function AI:draw()
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
        love.graphics.draw(self.img, canvasWidth / 2 - self.width / 2, canvasHeight / 2 - self.height / 2, 0, self.scale, self.scale)
        love.graphics.draw(self.wings.front.img, wingFrontCenterX, wingCenterY, self.wings.front.rotation, self.wings.scale, self.wings.scale, wingAssetCenterX, wingAssetCenterY)


    end)

    love.graphics.draw(playerWithWingsCanvas, canvasCenterX, canvasCenterY, self.rotation, 1, 1, canvasAssetCenterX, canvasAssetCenterY)
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

function AI:changesColor(new_r, new_g, new_b, new_a)
    local width = self.image_map:getWidth()
    local height = self.image_map:getHeight()
    local player_most_white_color = {self.image_map:getPixel(width * 0.3, height / 2)}
    local player_second_most_white_color = {self.image_map:getPixel(width * 0.225, height / 2)}
    local player_third_most_white_color = {self.image_map:getPixel(width * 0.1, height / 2)}
    local player_fourth_most_white_color = {self.image_map:getPixel(width * 0.375, height / 2)}
    local player_fifth_most_white_color = {self.image_map:getPixel(width * 0.4125, height / 2)}
    local player_sixth_most_white_color = {self.image_map:getPixel(width * 0.4125, height * 0.015)}
    local player_least_white_color = {self.image_map:getPixel(width * 0.15, height / 2)}
    local colors = {
        player_most_white_color,
        player_second_most_white_color,
        player_third_most_white_color,
        player_fourth_most_white_color,
        player_fifth_most_white_color,
        player_sixth_most_white_color,
        player_least_white_color,
    }
    local differences_between_each_color = {}
    
    for i = 1, #colors do
        for component = 1, 3 do   
            local difference = colors[1][component] - colors[i][component]
            table.insert(differences_between_each_color, difference)
        end
    end

    for i, color in ipairs(colors) do
        for x = 0, width - 1 do
            for y = 0, height - 1 do
                local r, g, b, a = self.image_map:getPixel(x, y)
                if r == color[1] and g == color[2] and b == color[3] then
                    local new_differentiated_color = {
                        new_r - differences_between_each_color[i * 3 - 2],
                        new_g - differences_between_each_color[i * 3 - 1],
                        new_b - differences_between_each_color[i * 3 - 0],
                        new_a,
                    }

                    self.image_map:setPixel(x, y, 
                    new_differentiated_color[1], 
                    new_differentiated_color[2], 
                    new_differentiated_color[3], 
                    new_differentiated_color[4])
                end
            end
        end
    end
    self.img = love.graphics.newImage(self.image_map)
end


function AI:animate(dt)
    self.y = self.y + self.ySpeed * dt
end