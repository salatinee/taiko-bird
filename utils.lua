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

function clamp(min, x, max)
    return math.max(min, math.min(x, max))
end