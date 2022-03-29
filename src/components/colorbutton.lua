
ColorButton = {}
setmetatable(ColorButton, { __index = Button })


function ColorButton:new(options)
    local colorButton = Button:new(options) -- inherit from Button
    colorButton.image_map = options.image_map
    colorButton.image_map_pressed = options.image_map_pressed

    self.__index = self
    setmetatable(colorButton, self)

    return colorButton
end

function ColorButton:setColor(color)
    local color_r, color_g, color_b, color_a = love.math.colorFromBytes(color.r, color.g, color.b, color.a)
    for i, original_button in pairs({["img"] = self.image_map:clone(), ["pressedImg"] = self.image_map_pressed:clone()}) do
        local original_button_width = original_button:getWidth()
        local original_button_height = original_button:getHeight()
        for x = 0, original_button_width - 1 do
            for y = 0, original_button_height - 1 do
                local r, g, b, a = original_button:getPixel(x, y)

                -- only change the color of the button if it's not on its borders
                if (r + g + b) / 3 >= 100 / 255 then
                    r_difference = 1- r
                    g_difference = 1 - g
                    b_difference = 1 - b
                    new_r = color_r - r_difference
                    new_g = color_g - g_difference
                    new_b = color_b - b_difference
                    original_button:setPixel(x, y, new_r, new_g, new_b, color_a)
                end
            end
        end
        self[i] = love.graphics.newImage(original_button)
    end
end