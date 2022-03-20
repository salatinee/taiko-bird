require('require')

Timer = require('libraries/timer')

gameState = "menu"

function love.load()
    if gameState == "menu" then
        utils:setGameDimensions()
        love.window.setIcon(love.image.newImageData("assets/taikobird.png"))
        love.window.setTitle('taiko bird')
        assert(love.window.setMode(
            utils.dimensions.width,
            utils.dimensions.height,
            { resizable = false, fullscreen = utils.isMobile, }
        ))
        utils:updateUnits()
    end

    ico = love.image.newImageData("assets/taikobird.png")
    love.window.setIcon(ico)
    
    music = love.audio.newSource("assets/sawssquarenoisetoweldefencecomic.mp3", "stream")
    music:setVolume(0.025)
    music:setLooping(true)
    music:play()

    Score:load()
    Background:load()
    AI:load()
    Menu:load()
    obstacles:load()
    Player:load()
    GameOver:loadImages()
    Pause:load()
    Credits:load()
end

function love.update(dt)
    if gameState == "menu" then
        Background:update(dt)
        Menu:update(dt)
        AI:update(dt)
    elseif gameState ~= "paused" and gameState ~= "credits" then
        Player:update(dt)
    end

    if gameState == "inGame" then
        Background.xSpeed = -5 * utils.vh
        Background:update(dt)
        obstacles:update(dt)
        Score:update(dt)
    end

    if gameState == "gameOver" then
        GameOver:update(dt)
    end

    if gameState == "paused" then
        Pause:update(dt)
    end

    if gameState == "credits" then
        Credits:update(dt)
    end

    Timer.update(dt)
end

function love.draw()
    if gameState ~= "credits" then
        Background:draw()
        obstacles:draw()
    end

    if gameState == "menu" then
        Menu:draw()
        AI:draw()
    end

    if gameState == "gameOver" then
        Player:draw()
        GameOver:draw()
    end

    if gameState == "inGame" then
        Player:draw()
        Score:draw()
    end

    if gameState == "paused" then
        Player:draw()
        Pause:draw()
    end

    if gameState == "credits" then
        Credits:draw()
    end

end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if gameState == "inGame" then
        if key == "space" then
            Player:jump()
        end
    
    elseif gameState == "gameOver" then
        if key == "space" then
            GameOver:setPlayButtonAsPressed()
            GameOver:delayedPlayAgain()
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
    elseif gameState == "paused" then
        Pause:setPlayButtonAsPressed()
    elseif gameState == "gameOver" then
        if checkCollision(mousePress, GameOver.playButton) then
            GameOver:setPlayButtonAsPressed()
        end
    end
end

function love.mousereleased(x, y, button, istouch)
    local mousePress = {x = x, y = y, width = 1, height = 1}

    if gameState == "menu" then
        Menu:onMouseReleased()

        if checkCollision(mousePress, Menu.playButton) then
            Menu:playGame()
        end

        if checkCollision(mousePress, Menu.rateButton) then
            -- Menu:rateGame()
            Credits:showCredits()
        end
        
    elseif gameState == "paused" then
        Pause:onMouseReleased()

        if checkCollision(mousePress, Pause.playButton) then
            Pause:continueGame()
        end
    elseif gameState == 'gameOver' then
        GameOver:onMouseReleased()

        mousePress = {x = x, y = y, width = 1, height = 1}
        if checkCollision(mousePress, GameOver.playButton) then
            GameOver:playAgain()
        end
    elseif gameState == "credits" then
        Credits:backToMenu()
    end
end

function checkCollision(a, b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    end
    return false
end

function love.focus(focus)
    if not focus and gameState == "inGame" then
        Pause:pauseGame()
    end
end

function love.quit()
    return false
end