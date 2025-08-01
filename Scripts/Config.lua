-- Config.lua
-- Configurações do jogo Spider

local Config = {
    -- Configurações da aranha
    SPIDER = {
        SPEED = 15,
        JUMP_POWER = 50,
        HEALTH = 100,
        DAMAGE = 25,
        ATTACK_COOLDOWN = 2,
        DETECTION_RANGE = 100,
        ATTACK_RANGE = 8
    },
    
    -- Configurações do jogador
    PLAYER = {
        WALK_SPEED = 20,
        JUMP_POWER = 50,
        HEALTH = 100,
        ATTACK_DAMAGE = 15,
        ATTACK_RANGE = 5
    },
    
    -- Configurações do jogo
    GAME = {
        SPIDER_ARRIVAL_TIME = 30, -- segundos
        INTRO_DURATION = 5, -- segundos
        WARNING_DURATION = 3 -- segundos
    },
    
    -- Configurações do mundo
    WORLD = {
        ISLAND_SIZE = Vector3.new(200, 10, 200),
        HOUSE_SIZE = Vector3.new(30, 20, 25),
        TREE_COUNT = 10,
        SPIDER_SPAWN_DISTANCE = 100
    },
    
    -- Configurações de iluminação
    LIGHTING = {
        AMBIENT = Color3.fromRGB(40, 40, 60),
        BRIGHTNESS = 0.3,
        CLOCK_TIME = 20, -- Noite
        FOG_START = 100,
        FOG_END = 500
    },
    
    -- Cores
    COLORS = {
        SPIDER_BODY = BrickColor.new("Really black"),
        SPIDER_EYES = BrickColor.new("Really red"),
        HEALTH_GOOD = Color3.fromRGB(0, 255, 0),
        HEALTH_WARNING = Color3.fromRGB(255, 255, 0),
        HEALTH_DANGER = Color3.fromRGB(255, 0, 0),
        ATTACK_EFFECT = BrickColor.new("Bright blue"),
        SPIDER_ATTACK_EFFECT = BrickColor.new("Really red")
    }
}

return Config 