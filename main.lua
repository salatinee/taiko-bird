require('src/require')

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
    AIColors:load()
    Colors:load()
end

function love.update(dt)
    if gameState == "menu" then
        Background:update(dt)
        Menu:update(dt)
        AI:update(dt)
    elseif gameState == "colors" then
        Background:update(dt)
        AIColors:update(dt)
        Colors:update(dt)
    elseif gameState == "inGame" or gameState == "gameOver" then
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

    if gameState == "colors" then
        Colors:draw()
        AIColors:draw()
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
    elseif gameState == "menu" then
        if key == "c" then
            gameState = "colors"
        end
    end
end

function love.mousepressed(x, y, button, istouch)
    local mousePress = {x = x, y = y, width = 1, height = 1}

    if gameState == "menu" then
        if Menu.playButton:isHovered(mousePress) then
            Menu.playButton:setButtonAsPressed()
        end

        if Menu.rateButton:isHovered(mousePress) then
            Menu.rateButton:setButtonAsPressed()
        end
    elseif gameState == "inGame" then
        Player:jump()
    elseif gameState == "paused" then
        Paused.playButton:setButtonAsPressed()
    elseif gameState == "gameOver" then
        if GameOver.playButton:isHovered(mousePress) then
            GameOver.playButton:setButtonAsPressed()
        end
    elseif gameState == "colors" then
        if Colors.colorButton:isHovered(mousePress) then
            Colors.colorButton:setButtonAsPressed()
        
        elseif Colors.rightArrowButton:isHovered(mousePress) then
            Colors.rightArrowButton:setButtonAsPressed()
        elseif Colors.leftArrowButton:isHovered(mousePress) then
            Colors.leftArrowButton:setButtonAsPressed()
        end
    end
end

function love.mousereleased(x, y, button, istouch)
    local mousePosition = {x = x, y = y, width = 1, height = 1}

    if gameState == "menu" then
        Menu.playButton:onMouseReleased()

        if Menu.playButton:isHovered(mousePosition) then
            -- meio estranho isso tbh
            Menu:playGame()
        end

        if Menu.rateButton:isHovered(mousePosition) then
            -- Menu:rateGame()
            Credits:showCredits()
        end
    elseif gameState == "paused" then
        Pause.playButton:onMouseReleased()

        if Pause.playButton:isHovered(mousePosition) then
            Pause:continueGame()
        end
    elseif gameState == "gameOver" then
        GameOver.playButton:onMouseReleased()

        if GameOver.playButton:isHovered(mousePosition) then
            GameOver:playAgain()
        end
    elseif gameState == "credits" then
        Credits:backToMenu()
    elseif gameState == "colors" then
        Colors.colorButton:onMouseReleased()
        Colors.rightArrowButton:onMouseReleased()
        Colors.leftArrowButton:onMouseReleased()

        if Colors.rightArrowButton:isHovered(mousePosition) then
            Colors:nextColor()
        elseif Colors.leftArrowButton:isHovered(mousePosition) then
            Colors:previousColor()
        end
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