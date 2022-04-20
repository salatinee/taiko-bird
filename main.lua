require('src/require')

Timer = require('libraries/timer')
math.randomseed(os.time()) -- seed the random number generator
appleCake.setBuffer(true) -- Buffer any profile calls to increase performance
appleCake.beginSession() --Will write to "profile.json" by default in the save directory
appleCake.setName("taiko bird") -- eba birb

gameState = MenuState

function love.load()
    utils:setGameDimensions()
    love.window.setIcon(love.image.newImageData("assets/taikobird.png"))
    love.window.setTitle('taiko bird')
    assert(love.window.setMode(
        utils.dimensions.width,
        utils.dimensions.height,
        { resizable = false, fullscreen = utils.isRealMobile,}
    ))
    utils:updateUnits()

    ico = love.image.newImageData("assets/taikobird.png")
    love.window.setIcon(ico)

    admob.createBanner(
        "ca-app-pub-8325876102881485/4297079877",
        "top")
    admob.showBanner() 

    music = love.audio.newSource("assets/sawssquarenoisetoweldefencecomic.mp3", "stream")
    music:setVolume(0.025)

    if utils.isRealMobile then
        music:setVolume(0.125)
    end
    
    music:setLooping(true)
    music:play()
    loadAll()
end

function love.update(dt)
    gameState:update(dt)

    Timer.update(dt)
end

function love.draw()
    local _profileDraw = appleCake.profileFunc() -- This will create new profile table every time this function is ran

    gameState:draw()

    _profileDraw.args = love.graphics.getStats() -- Set args that we can view later in the viewer
    _profileDraw.args['gameState'] = gameState:getName()
    _profileDraw:stop() -- By setting it to love.graphics.getStats we can see details of the draw
    appleCake.flush() -- Flush any profiling data to be saved
end

function love.keyreleased(key)
    gameState:onKeyReleased(key)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    gameState:onKeyPressed(key)
end

function love.mousepressed(x, y, button, istouch)
    local mousePosition = {x = x, y = y, width = 1, height = 1}

    gameState:onMousePressed(mousePosition)
end

function love.mousereleased(x, y, button, istouch)
    local mousePosition = {x = x, y = y, width = 1, height = 1}

    gameState:onMouseReleased(mousePosition)
end

function checkCollision(a, b)
    if a.x + a.width > b.x and a.x < b.x + b.width and a.y + a.height > b.y and a.y < b.y + b.height then
        return true
    end
    return false
end

function love.focus(focus)
    gameState:onFocus(focus)
end

function love.quit()
    appleCake.endSession()   
    return false
end