require('require')

Timer = require('libraries/timer')

gameState = "inGame"

function love.load()
    Background:load()
    obstacles:load()
    Player:load()
    Score:load()
    GameOver:loadImages()
end

function love.update(dt)
    Background:update(dt)
    Player:update(dt)
    if gameState == "inGame" then
        obstacles:update(dt)
        Score:update(dt)
    end

    if gameState == "gameOver" then
        GameOver:update(dt)
    end

    Timer.update(dt)
end

function love.draw()
    Background:draw()
    obstacles:draw()
    Player:draw()

    if gameState == "gameOver" then
        GameOver:draw()
    end

    if gameState == "inGame" then
        Score:draw()
    end

end

function love.keypressed(key)
    if gameState == "inGame" then
        if key == "space" then
            Player:jump()
        end
    
    elseif gameState == "gameOver" then
        if key == "space" then
            GameOver:setPlayButtonAsPressed()

            Timer.after(0.125, function()
                GameOver:playAgain()
            end)
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    if gameState == "inGame" then
        Player:jump()
    elseif gameState == "gameOver" then
        mousePress = {x = x, y = y, width = 1, height = 1}
        if checkCollision(mousePress, GameOver.playButton) then
            GameOver:setPlayButtonAsPressed()
        end
    end
end

function love.mousereleased(x, y, button, istouch)
    if gameState == 'gameOver' then
        GameOver:onMouseReleased()

        mousePress = {x = x, y = y, width = 1, height = 1}
        if checkCollision(mousePress, GameOver.playButton) then
            GameOver:playAgain()
        end
    end
end

function checkCollision(a, b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    end
    return false
end