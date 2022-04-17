function requireAll()
    require("src/load")
    require("src/utils")
    require("src/background")
    require("src/basecharacter")
    require("src/score")
    require("src/save")
    require("src/menu")
    require("src/ai")
    require("src/pause")
    require("src/credits")
    require("src/colors")
    require("src/aicolors")
    require("src/shaders")
    require("src/audio/ShepardToneSource")
    require("src/coins")
    require("src/store")
    require("src/selectgamemode")
    require("src/Classic/require")
    require("src/BattleStick/require")
    require("src/components/require")
    require('src/items/require')
    require('src/game-states/require')
    shapes = require("libraries.HC.shapes")
    binser = require("libraries.binser")
    -- passar false desativa profiling!
    appleCake = require("libraries.AppleCake")(false)

    if utils.isRealMobile then
        admob = require('admob')
        leaderboards = require('leaderboards')
    else
        admob = require('src/polyfills/admob')
        leaderboards = require('src/polyfills/leaderboards')
    end
end

requireAll()