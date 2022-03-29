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
    local image_map = imagemap:clone()
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

    for i, whiteColor in ipairs(whiteColors) do
        for x = 0, width - 1 do
            for y = 0, height - 1 do
                local r, g, b, a = image_map:getPixel(x, y)
                if r == whiteColor[1] and g == whiteColor[2] and b == whiteColor[3] then
                    local new_differentiated_color = {
                        color_r - differences_between_each_color[i * 3 - 2],
                        color_g - differences_between_each_color[i * 3 - 1],
                        color_b - differences_between_each_color[i * 3 - 0],
                        color_a,
                    }

                    image_map:setPixel(x, y, 
                    new_differentiated_color[1], 
                    new_differentiated_color[2], 
                    new_differentiated_color[3], 
                    new_differentiated_color[4])
                end
            end
        end
    end
    return love.graphics.newImage(image_map)
end
