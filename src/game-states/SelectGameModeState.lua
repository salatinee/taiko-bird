SelectGameModeState = GameState:new()

function SelectGameModeState:getName()
    return 'selectGameMode'
end

function SelectGameModeState:update(dt)
    Background:update(dt)
end

function SelectGameModeState:draw()
    selectGameMode:draw()
end

function SelectGameModeState:onMousePressed(mousePosition)
    if selectGameMode.classicButton:isHovered(mousePosition) then
        selectGameMode.classicButton:setButtonAsPressed()
    end
    if selectGameMode.battleStickButton:isHovered(mousePosition) then
        selectGameMode.battleStickButton:setButtonAsPressed()
    end

    if selectGameMode.backButton:isHovered(mousePosition) then
        selectGameMode.backButton:setButtonAsPressed()
    end
end

function SelectGameModeState:onMouseReleased(mousePosition)
    selectGameMode.classicButton:onHovered(mousePosition, function() 
        admob.hideBanner()
        gameState = ClassicState 
    end)

    selectGameMode.battleStickButton:onHovered(mousePosition, function() 
        admob.hideBanner()
        gameState = BattleStickState 
    end)

    selectGameMode.backButton:onHovered(mousePosition, function() 
        gameState = MenuState 
    end)

    selectGameMode:onMouseReleased(mousePosition)
end

function SelectGameModeState:onKeyPressed(key)

end

function SelectGameModeState:onKeyReleased(key)

end

function SelectGameModeState:onFocus(focus)

end