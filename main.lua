require('require')

Timer = require('libraries/timer')

gameState = "menu"

function love.load()
    music = love.audio.newSource("assets/sawssquarenoisetoweldefencecomic.mp3", "stream")
    music:setVolume(0.025)
    music:setLooping(true)
    music:play()

    Score:load()
    Background:load()
    Menu:load()
    obstacles:load()
    Player:load()
    GameOver:loadImages()
end

function love.update(dt)
    Background:update(dt)

    if gameState == "menu" then
        Menu:update(dt)
    
    else
        Player:update(dt)
    end

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

    if gameState == "menu" then
        Menu:draw()
    end

    if gameState == "gameOver" then
        Player:draw()
        GameOver:draw()
    end

    if gameState == "inGame" then
        Player:draw()
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
    local mousePress = {x = x, y = y, width = 1, height = 1}

    if gameState == "menu" then
        if checkCollision(mousePress, Menu.playButton) then
            Menu:setPlayButtonAsPressed()
        end

        if checkCollision(mousePress, Menu.rateButton) then
            Menu:setRateButtonAsPressed()
        end
    elseif gameState == "inGame" then
        Player:jump()
    elseif gameState == "gameOver" then
        if checkCollision(mousePress, GameOver.playButton) then
            GameOver:setPlayButtonAsPressed()
        end
    end
end

function love.mousereleased(x, y, button, istouch)
    if gameState == "menu" then
        Menu:onMouseReleased()

        mousePress = {x = x, y = y, width = 1, height = 1}
        if checkCollision(mousePress, Menu.playButton) then
            Menu:playGame()
        end

        if checkCollision(mousePress, Menu.rateButton) then
            Menu:rateGame()
        end
    elseif gameState == 'gameOver' then
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