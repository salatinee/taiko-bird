ColorsState = GameState:new()

function GameState:getName()
    return 'colors'
end

function ColorsState:update(dt)
    Background:update(dt)
    AIColors:update(dt)
    Colors:update(dt)
end

function ColorsState:draw()
    Background:draw()
    Colors:draw()
    AIColors:draw()
end

function ColorsState:onMousePressed(mousePosition)
    if Colors.colorButton:isHovered(mousePosition) then
        Colors.colorButton:setButtonAsPressed()
    elseif Colors.rightArrowButton:isHovered(mousePosition) then
        Colors.rightArrowButton:setButtonAsPressed()
    elseif Colors.leftArrowButton:isHovered(mousePosition) then
        Colors.leftArrowButton:setButtonAsPressed()
    elseif Colors.backButton:isHovered(mousePosition) then
        Colors.backButton:setButtonAsPressed()
        Save:updateCurrentColor()
    end
end

function ColorsState:onMouseReleased(mousePosition)
    Colors.colorButton:onMouseReleased()
    Colors.rightArrowButton:onHovered(mousePosition, function() Colors:nextColor() end)
    Colors.rightArrowButton:onMouseReleased()
    Colors.leftArrowButton:onHovered(mousePosition, function() Colors:previousColor() end)
    Colors.leftArrowButton:onMouseReleased()
    Colors.backButton:onHovered(mousePosition, function() 
        Save:updateCurrentColor()
        gameState = MenuState
    end)
    Colors.backButton:onMouseReleased()
end

function ColorsState:onKeyPressed(key)
    if key == "c" then
        Save:updateCurrentColor()

        gameState = MenuState
    elseif key == "right" then
        Colors.rightArrowButton:setButtonAsPressed()
    elseif key == "left" then
        Colors.leftArrowButton:setButtonAsPressed()
    end
end

function ColorsState:onKeyReleased(key)
    if key == "left" then
        Colors.leftArrowButton:onMouseReleased()
        Colors:previousColor()
    elseif key == "right" then
        Colors.rightArrowButton:onMouseReleased()
        Colors:nextColor()
    end
end

function ColorsState:onFocus(focus)
    
end