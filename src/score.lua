
Score = {}

function Score:load()
    self.font = love.graphics.newFont("assets/Pixeled.ttf", 7 * utils.vh)
    self.score = 0
    self.x = love.graphics.getWidth() / 2
    self.y = 1.5 * utils.vh
    self.scored = ShepardToneSource:new(
        "assets/bing2-increasing-1-semitone.wav",
        "assets/bing2-increasing-2-semitones.wav"
    )
    -- self.scored:setVolume(0.5)
end

function Score:update(dt)
    self:playerScores()
end

function Score:reset()
    self.score = 0
    self.scored:resetPitch()
end

function Score:draw()
    xAdjustment = self.font:getWidth(self.score) / 2
    
    local fontBackgroundOffset = utils.vh / 2
    love.graphics.print({{0, 0, 0, 1}, self.score}, self.font, self.x - xAdjustment + fontBackgroundOffset, self.y + fontBackgroundOffset)
    love.graphics.print(self.score, self.font, self.x - xAdjustment, self.y)
end

function Score:playScoredEffect()
    self.scored:playWithIncreasedPitch()
end

function Score:playerScores()
    for i, obstacle in ipairs(ClassicObstacles.obstacles) do
        if not obstacle.wasSeen and obstacle.top.x <= ClassicPlayer.x then
            self:playScoredEffect()
            obstacle.wasSeen = true
            self.score = self.score + 1
        end
    end
end