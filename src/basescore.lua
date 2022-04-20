
BaseScore = {}

function BaseScore:new()
    local newScore = {}
    self.__index = self
    setmetatable(newScore, self)

    return newScore
end

function BaseScore:load()
    self.font = love.graphics.newFont("assets/Pixeled.ttf", 7 * utils.vh)
    self.score = 0
    self.x = love.graphics.getWidth() / 2
    self.y = 9 * utils.vh
    self.scored = ShepardToneSource:new(
        "assets/bing2-increasing-1-semitone.wav",
        "assets/bing2-increasing-2-semitones.wav"
    )
    -- self.scored:setVolume(0.5)
end

function BaseScore:update(dt)

end

function BaseScore:reset()
    self.score = 0
    self.scored:resetPitch()
end

function BaseScore:draw()
    drawTextWithShadow({
        content = self.score,
        x = self.x,
        y = self.y,
        font = self.font,
    })
end

function BaseScore:playScoredEffect()
    self.scored:playWithIncreasedPitch()
end

function BaseScore:onPlayerScored()
    self.score = self.score + 1
    self:playScoredEffect()
end
