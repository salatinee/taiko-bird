require('src/background')

-- Testing nightIntensity module
local timeAt6AM = os.time({year = 2022, month = 1, day = 1, hour = 6, min = 0, sec = 0})
local timeAtMidday = os.time({year = 2022, month = 1, day = 1, hour = 12, min = 0, sec = 0})
local timeAt6PM = os.time({year = 2022, month = 1, day = 1, hour = 18, min = 0, sec = 0})
local timeAtMidnight = os.time({year = 2022, month = 1, day = 1, hour = 0, min = 0, sec = 0})

assert(Background:nightIntensity(timeAt6AM) == 0, "Night intensity should be 0 at 6AM")
assert(Background:nightIntensity(timeAtMidday) == 0, "Night intensity should be 0 at midday")
assert(Background:nightIntensity(timeAt6PM) == 0, "Night intensity should be 0 at 6PM")
assert(Background:nightIntensity(timeAtMidnight) == 1, "Night intensity should be 1 at midnight")