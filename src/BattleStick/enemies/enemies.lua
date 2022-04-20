Enemies = {
    enemyTypes = {
        Aku,
        Boomba,
        Coyotank,
    },
}

function Enemies:load()
    self.enemies = {Coyotank:createEnemy()}
    self.createTimer = 0
end

function Enemies:update(dt)
    if not self.randomTimeCreation then
        self.randomTimeCreation = math.random(3, 6)
    end
    self.createTimer = self.createTimer + dt
    self.createTimer = math.min(self.createTimer, self.randomTimeCreation)
    if self.createTimer >= self.randomTimeCreation then
        self:createEnemy()
        self.createTimer = 0
        self.randomTimeCreation = nil
    end

    for i, enemy in ipairs(self.enemies) do
        enemy:update(dt)
    end

    self:removeDeadEnemies()
end

function Enemies:createEnemy()
    local randomEnemyType = self.enemyTypes[math.random(1, #self.enemyTypes)]
    local newEnemy = randomEnemyType:createEnemy()
    
    table.insert(self.enemies, newEnemy)
    return newEnemy
end

function Enemies:removeDeadEnemies()
    for i = #self.enemies, 1, -1 do
        if self.enemies[i]:isDead() then
            table.remove(self.enemies, i)
        end
    end
end

function Enemies:draw()
    for i, enemy in ipairs(self.enemies) do
        enemy:draw()
    end
end

function Enemies:reset()
    self.enemies = {}
end