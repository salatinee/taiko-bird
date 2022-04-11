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
            { resizable = false, fullscreen = utils.isRealMobile, }
        ))
        utils:updateUnits()
    end

    ico = love.image.newImageData("assets/taikobird.png")
    love.window.setIcon(ico)

    admob.createBanner(
        "ca-app-pub-8325876102881485/4297079877",
        "top")
    admob.showBanner() 

    music = love.audio.newSource("assets/sawssquarenoisetoweldefencecomic.mp3", "stream")
    music:setVolume(0.025)
    music:setLooping(true)
    music:play()

    Pipe:load()
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
    Coins:load()
    Coin:load()

    -- ok this is kinda too big rn..
    Items:load()
    Inventory:load()
    Store:load()
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
        Coin:update(dt)
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

    if gameState == "store" then
        Store:update(dt)
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
        Coins:draw()
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
        Coin:draw()
    end

    if gameState == "paused" then
        Player:draw()
        Pause:draw()
    end

    if gameState == "credits" then
        Credits:draw()
    end

    if gameState == "store" then
        Store:draw()
    end
end

function love.keyreleased(key)
    if gameState == "colors" then
        if key == "left" then
            Colors.leftArrowButton:onMouseReleased()
            Colors:previousColor()
        elseif key == "right" then
            Colors.rightArrowButton:onMouseReleased()
            Colors:nextColor()
        end
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

    elseif gameState == "colors" then
        if key == "c" then
            if Save:updateCurrentColor() then
            end

            gameState = "menu"

        elseif key == "right" then
            Colors.rightArrowButton:setButtonAsPressed()
        elseif key == "left" then
            Colors.leftArrowButton:setButtonAsPressed()
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

        if Menu.colorsButton:isHovered(mousePress) then
            Menu.colorsButton:setButtonAsPressed()
        end
        
        if Menu.shopButton:isHovered(mousePress) then
            Menu.shopButton:setButtonAsPressed()
        end
    elseif gameState == "inGame" then
        Player:jump()
    elseif gameState == "paused" then
        Pause.playButton:setButtonAsPressed()
    elseif gameState == "gameOver" then
        if GameOver.playButton:isHovered(mousePress) then
            GameOver.playButton:setButtonAsPressed()
        elseif GameOver.menuButton:isHovered(mousePress) then
            GameOver.menuButton:setButtonAsPressed()
        end
    elseif gameState == "colors" then
        if Colors.colorButton:isHovered(mousePress) then
            Colors.colorButton:setButtonAsPressed()
        
        elseif Colors.rightArrowButton:isHovered(mousePress) then
            Colors.rightArrowButton:setButtonAsPressed()
        elseif Colors.leftArrowButton:isHovered(mousePress) then
            Colors.leftArrowButton:setButtonAsPressed()
        elseif Colors.backButton:isHovered(mousePress) then
            Colors.backButton:setButtonAsPressed()
            if Save:updateCurrentColor() then
            end
        end
    elseif gameState == 'store' then
        Store:onMousePressed(mousePress)
    end
end

function love.mousereleased(x, y, button, istouch)
    local mousePosition = {x = x, y = y, width = 1, height = 1}

    if gameState == "menu" then
        Menu:onMouseReleased()

        if Menu.playButton:isHovered(mousePosition) then
            Menu:playGame()
        end

        if Menu.rateButton:isHovered(mousePosition) then
            -- Menu:rateGame()
            Credits:showCredits()
        end

        if Menu.colorsButton:isHovered(mousePosition) then
            gameState = 'colors'
        end

        if Menu.shopButton:isHovered(mousePosition) then
            Menu:openStore()
        end
    elseif gameState == "paused" then
        Pause.playButton:onMouseReleased()

        if Pause.playButton:isHovered(mousePosition) then
            Pause:continueGame()
        end
    elseif gameState == "gameOver" then
        GameOver.playButton:onMouseReleased()
        GameOver.menuButton:onMouseReleased()

        if GameOver.playButton:isHovered(mousePosition) then
            GameOver:playAgain()
        elseif GameOver.menuButton:isHovered(mousePosition) then
            GameOver:goToMenu()
        end
    elseif gameState == "credits" then
        Credits:backToMenu()
    elseif gameState == "colors" then
        Colors.colorButton:onMouseReleased()
        Colors.rightArrowButton:onMouseReleased()
        Colors.leftArrowButton:onMouseReleased()
        Colors.backButton:onMouseReleased()

        if Colors.rightArrowButton:isHovered(mousePosition) then
            Colors:nextColor()
        elseif Colors.leftArrowButton:isHovered(mousePosition) then
            Colors:previousColor()
        elseif Colors.backButton:isHovered(mousePosition) then
            if Save:updateCurrentColor() then
            end

            gameState = "menu"
        end
    elseif gameState == 'store' then
        Store:onMouseReleased(mousePosition)
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