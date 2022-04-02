
ColorButton = {
    -- TODO terminar!
    colorsToChange = {
        {255 / 255, 255 / 255, 255 / 255, 1},
        {251 / 255, 251 / 255, 251 / 255, 1},
        {242 / 255, 240 / 255, 240 / 255, 1},
        {236 / 255, 235 / 255, 235 / 255, 1},
        {235 / 255, 234 / 255, 234 / 255, 1},
        {228 / 255, 227 / 255, 227 / 255, 1},
        {224 / 255, 223 / 255, 223 / 255, 1},
        {213 / 255, 212 / 255, 212 / 255, 1},
        {172 / 255, 171 / 255, 171 / 255, 1},
        {139 / 255, 139 / 255, 139 / 255, 1},
        {142 / 255, 142 / 255, 142 / 255, 1},
    },
}
setmetatable(ColorButton, { __index = Button })


function ColorButton:new(options)
    local colorButton = Button:new(options) -- inherit from Button
    colorButton.image_map = options.image_map
    colorButton.image_map_pressed = options.image_map_pressed
    colorButton.changeColorShader = Shaders.newNoOpShader()

    self.__index = self
    setmetatable(colorButton, self)

    return colorButton
end

function ColorButton:setColor(color)
    local shaderColor = {color[1] / 255, color[2] / 255, color[3] / 255}

    self.changeColorShader = Shaders.newChangeColorShader(ColorButton.colorsToChange, shaderColor)
end

function ColorButton:draw()
    love.graphics.setShader(self.changeColorShader)
        Button.draw(self)
    love.graphics.setShader()
end