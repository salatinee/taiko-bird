
ColorButton = {}
setmetatable(ColorButton, { __index = Button })

local function changeButtonColor(imagemap, color)
    local color_r, color_g, color_b, color_a = love.math.colorFromBytes(color.r, color.g, color.b, color.a)
    local imagemapClone = imagemap:clone()

    imagemapClone:mapPixel(function (x, y, r, g, b, a)
        -- only change the color of the button if it's not on its borders
        if (r + g + b) / 3 >= 100 / 255 then
            r_difference = 1 - r
            g_difference = 1 - g
            b_difference = 1 - b
            new_r = color_r - r_difference
            new_g = color_g - g_difference
            new_b = color_b - b_difference

            return new_r, new_g, new_b, a
        end

        return r, g, b, a
    end)

    return love.graphics.newImage(imagemapClone)
end

local function precomputeChangedColorButtonImagesForAvailableColors(imagemap, availableColors)
    local output = {}

    for i, color in ipairs(availableColors) do
        output[color] = changeButtonColor(imagemap, color)
    end

    return output
end

function ColorButton:new(options)
    local colorButton = Button:new(options) -- inherit from Button
    colorButton.image_map = options.image_map
    colorButton.image_map_pressed = options.image_map_pressed

    colorButton.precomputedColorImages = precomputeChangedColorButtonImagesForAvailableColors(
        colorButton.image_map,
        Colors.availableColors
    )

    colorButton.precomputedColorPressedImages = precomputeChangedColorButtonImagesForAvailableColors(
        colorButton.image_map_pressed,
        Colors.availableColors
    )

    self.__index = self
    setmetatable(colorButton, self)

    return colorButton
end

function ColorButton:setColor(color)
    self.img = self.precomputedColorImages[color] or changeButtonColor(self.image_map, color)
    self.pressedImg = self.precomputedColorPressedImages[color] or changeButtonColor(self.image_map_pressed, color)
end