local os = love.system.getOS()
local isMobile = os == "Android" or os == "iOS"

utils = {
    vh = love.graphics.getHeight() / 100,
    vw = love.graphics.getWidth() / 100,
    isMobile = isMobile,
    dimensions = {}
}

function utils:setGameDimensions()
    if isMobile then
        utils.dimensions.height = 800
        utils.dimensions.width = 600
    else
        utils.dimensions.height = 600
        utils.dimensions.width = 800
    end
end

function utils:updateUnits()
    utils.vh = love.graphics.getHeight() / 100
    utils.vw = love.graphics.getWidth() / 100
end

function clamp(min, x, max)
    return math.max(min, math.min(x, max))
end

function changesColor(imagemap, color)
    local start = love.timer.getTime()
    local image_map = imagemap:clone()
    local image_cloned = love.timer.getTime()

    print('Image map cloned in: ', image_cloned - start)

    local width = image_map:getWidth()
    local height = image_map:getHeight()
    local color_r, color_g, color_b, color_a = love.math.colorFromBytes(color.r, color.g, color.b, color.a)
    local player_most_white_color = {image_map:getPixel(width * 0.3, height / 2)}
    local player_second_most_white_color = {image_map:getPixel(width * 0.225, height / 2)}
    local player_third_most_white_color = {image_map:getPixel(width * 0.1, height / 2)}
    local player_fourth_most_white_color = {image_map:getPixel(width * 0.375, height / 2)}
    local player_fifth_most_white_color = {image_map:getPixel(width * 0.4125, height / 2)}
    local player_sixth_most_white_color = {image_map:getPixel(width * 0.4125, height * 0.015)}
    local player_least_white_color = {image_map:getPixel(width * 0.15, height / 2)}

    local colors_obtained = love.timer.getTime()

    print('Colors obtained in ', colors_obtained - image_cloned)

    local whiteColors = {
        player_most_white_color,
        player_second_most_white_color,
        player_third_most_white_color,
        player_fourth_most_white_color,
        player_fifth_most_white_color,
        player_sixth_most_white_color,
        player_least_white_color,
    }
    local differences_between_each_color = {}
    
    for i = 1, #whiteColors do
        for component = 1, 3 do   
            local difference = whiteColors[1][component] - whiteColors[i][component]
            table.insert(differences_between_each_color, difference)
        end
    end

    image_map:mapPixel(function (x, y, r, g, b, a)
        for i, whiteColor in ipairs(whiteColors) do
            -- Se for igual a uma das cores brancas que queremos mudar, retornar a cor nova
            if r == whiteColor[1] and g == whiteColor[2] and b == whiteColor[3] then
                local new_r = color_r - differences_between_each_color[i * 3 - 2]
                local new_g = color_g - differences_between_each_color[i * 3 - 1]
                local new_b = color_b - differences_between_each_color[i * 3 - 0]
                local new_a = color_a

                return new_r, new_g, new_b, new_a
            end
        end

        -- Se não for igual a nenhuma, manter a mesma cor.
        return r, g, b, a
    end)

    local pixels_updated = love.timer.getTime()

    print('Pixels updated in ', pixels_updated - colors_obtained)

    return love.graphics.newImage(image_map)
end

function precomputeChangedColorImages(imagemap, availableColors)
    local output = {}

    for i, color in ipairs(availableColors) do
        local image = changesColor(imagemap, color)
        output[color] = image
    end

    return output
end