utils = {
    vh = love.graphics.getHeight() / 100,
    vw = love.graphics.getWidth() / 100,
}

function clamp(min, x, max)
    return math.max(min, math.min(x, max))
end