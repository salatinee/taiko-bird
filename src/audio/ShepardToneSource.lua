ShepardToneSource = {}

function ShepardToneSource:new(filenameIncreasingOneSemitone, filenameIncreasingTwoSemitones)
    local increasingOneSemitoneSource = love.audio.newSource(filenameIncreasingOneSemitone, "static")
    local increasingTwoSemitonesSource = love.audio.newSource(filenameIncreasingTwoSemitones, "static")
    local newSource = {
        tracksIncreasingOneSemitone = {
            upper = increasingOneSemitoneSource,
            middle = increasingOneSemitoneSource:clone(),
            lower = increasingOneSemitoneSource:clone(),
        },
        tracksIncreasingTwoSemitones = {
            upper = increasingTwoSemitonesSource,
            middle = increasingTwoSemitonesSource:clone(),
            lower = increasingTwoSemitonesSource:clone(),
        },
        semitones = {0, 2, 4, 5, 7, 9, 11},
        totalSteps = 7,
        currentStep = 0,
    }

    self.__index = self
    setmetatable(newSource, self)

    return newSource
end

function ShepardToneSource:playWithIncreasedPitch()
    -- Considerando que aumentar uma octave dobra o pitch, aumentar um semitom multiplica o pitch atual por esse valor (aproximadamente 1.059)
    local semitoneRatio = math.pow(2, 1/12)
    local volumeChangePerStep = 0.1

    -- Ve quantos semitons teremos na proxima vez que tocarmos o audio, de modo a escolher o audio correto (o que aumenta 1 semitom enquanto é tocado,
    -- ou o que aumenta 2 semitons)
    local semitonesDifferenceToNextStep = nil
    local currentStepIndex = self.currentStep + 1
    if currentStepIndex < self.totalSteps then
        semitonesDifferenceToNextStep = self.semitones[currentStepIndex + 1] - self.semitones[currentStepIndex]
    else
        -- Quando aumenta do ultimo semitone pra proxima octave, sempre é um aumento de 1 semitone
        semitonesDifferenceToNextStep = 1
    end

    -- Escolher o conjunto de faixas de acordo com a diferença de semitons para a proxima vez que tocarmos o audio,
    -- como visto acima.
    local tracksUsed = nil
    if semitonesDifferenceToNextStep == 1 then
        tracksUsed = self.tracksIncreasingOneSemitone
    else
        tracksUsed = self.tracksIncreasingTwoSemitones
    end 

    -- The upper track is 1 octave above, with decreasing volume (starting at 70% of the middle track's volume) and increasing pitch
    tracksUsed.upper:setPitch(2 * (semitoneRatio ^ self.semitones[self.currentStep + 1]))
    tracksUsed.upper:setVolume(0.7 - volumeChangePerStep * self.currentStep)

    -- The middle track is on the same octave, with constant volume and increasing pitch
    tracksUsed.middle:setPitch(semitoneRatio ^ self.semitones[self.currentStep + 1])

    -- The lower track is 1 octave below, with increasing volume (starting at 0% of the middle track's volume) and pitch
    tracksUsed.lower:setPitch(1/2 * math.pow(semitoneRatio, self.semitones[self.currentStep + 1]))
    tracksUsed.lower:setVolume(0.0 + volumeChangePerStep * self.currentStep)

    love.audio.play(tracksUsed.upper, tracksUsed.middle, tracksUsed.lower)

    self.currentStep = math.fmod(self.currentStep + 1, self.totalSteps)
end

function ShepardToneSource:resetPitch()
    self.currentStep = 0
end