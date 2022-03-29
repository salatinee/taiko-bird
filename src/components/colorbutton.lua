
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
    if not self.pressed then
        local original_button = self.image_map
    else
        local original_button = self.image_map_pressed
    end

    local original_button_width = original_button:getWidth()
    local original_button_height = original_button:getHeight()
    for x = 0, original_button_width - 1 do
        for y = 0, original_button_height - 1 do
            local r, g, b, a = original_button:getPixel(x, y)

            -- only change the color of the button if it's not on its borders
            if (r + g + b) / 3 >= 150 / 255 then
                r_difference = 255 - r
                g_difference = 255 - g
                b_difference = 255 - b
                new_r = color.r - r_difference
                new_g = color.g - g_difference
                new_b = color.b - b_difference
                original_button:setPixel(x, y, new_r, new_g, new_b, a)
                self.button.img = love.graphics.newImage(original_button)
            end
        end
    end
end