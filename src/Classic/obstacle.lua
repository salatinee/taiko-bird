
Obstacle = {}

function Obstacle.createObstacle(modifier)
    
    local obstacle = {}
    
    local pipeHeight = love.graphics.getHeight() * 0.33

    local limit = pipeHeight - 7 * utils.vh -- 50
    local yAdjustment = math.random(-limit, limit)

    obstacle.top = Pipe:createPipe(modifier, "top", yAdjustment)
    obstacle.bottom = Pipe:createPipe(modifier, "bottom", yAdjustment)
    obstacle.hasCoin = false
    obstacle.wasSeen = false

    return obstacle
end


function Obstacle.moveObstacle(obstacle, dt)
    Pipe.movePipe(obstacle.top, dt)
    Pipe.movePipe(obstacle.bottom, dt)
end

function Obstacle.drawObstacle(obstacle)
    Pipe.drawPipe(obstacle.top)
    Pipe.drawPipe(obstacle.bottom)
end

function Obstacle.checkObstacleCollision(thing, obstacle)
    if Pipe.checkPipeCollision(thing, obstacle.top) or Pipe.checkPipeCollision(thing, obstacle.bottom) then
        return true
    else
        return false
    end
end
