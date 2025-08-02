-- gerar_arquivo_rbxl.lua
-- Script para gerar um arquivo .rbxl completo do Spider Game
-- Execute este script no Roblox Studio para criar o arquivo

print("🕷️ Gerando arquivo .rbxl completo do Spider Game...")
print("Desenvolvido por: Wallan Peixoto")

-- Serviços necessários
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- Verificar se estamos no Roblox Studio
if not RunService:IsStudio() then
    print("❌ Este script deve ser executado no Roblox Studio!")
    return
end

-- Função para criar script
local function createScript(name, code, parent)
    local script = Instance.new("Script")
    script.Name = name
    script.Source = code
    script.Parent = parent
    return script
end

-- Função para criar pasta
local function createFolder(name, parent)
    local folder = Instance.new("Folder")
    folder.Name = name
    folder.Parent = parent
    return folder
end

-- Configurações do jogo
local CONFIG_CODE = [[
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
]]

-- Código do PlayerController
local PLAYER_CONTROLLER_CODE = [[
-- PlayerController.lua
-- Script para controlar a experiência do jogador

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local PlayerController = {}
PlayerController.__index = PlayerController

function PlayerController.new(player)
    local self = setmetatable({}, PlayerController)
    
    self.player = player
    self.character = nil
    self.humanoid = nil
    self.rootPart = nil
    self.health = 100
    self.maxHealth = 100
    self.isAlive = true
    
    -- Configurar eventos do jogador
    self:setupPlayerEvents()
    
    return self
end

function PlayerController:setupPlayerEvents()
    -- Quando o personagem carregar
    self.player.CharacterAdded:Connect(function(character)
        self:onCharacterAdded(character)
    end)
    
    -- Se o jogador já tem personagem
    if self.player.Character then
        self:onCharacterAdded(self.player.Character)
    end
end

function PlayerController:onCharacterAdded(character)
    self.character = character
    self.humanoid = character:WaitForChild("Humanoid")
    self.rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Configurar personagem
    self:setupCharacter()
    
    -- Configurar interface
    self:setupInterface()
    
    -- Configurar controles
    self:setupControls()
    
    -- Monitorar saúde
    self:monitorHealth()
end

function PlayerController:setupCharacter()
    -- Configurar velocidade de movimento
    self.humanoid.WalkSpeed = 20
    self.humanoid.JumpPower = 50
    
    -- Configurar saúde
    self.humanoid.MaxHealth = self.maxHealth
    self.humanoid.Health = self.health
end

function PlayerController:setupInterface()
    -- Criar interface do jogador
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PlayerInterface"
    screenGui.Parent = self.player.PlayerGui
    
    -- Barra de saúde
    local healthFrame = Instance.new("Frame")
    healthFrame.Name = "HealthFrame"
    healthFrame.Size = UDim2.new(0, 200, 0, 20)
    healthFrame.Position = UDim2.new(0, 10, 0, 10)
    healthFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthFrame.BackgroundTransparency = 0.3
    healthFrame.BorderSizePixel = 0
    healthFrame.Parent = screenGui
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthFrame
    
    -- Texto de saúde
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.Text = "Saúde: 100/100"
    healthText.TextScaled = true
    healthText.Font = Enum.Font.GothamBold
    healthText.Parent = healthFrame
    
    -- Instruções
    local instructions = Instance.new("TextLabel")
    instructions.Name = "Instructions"
    instructions.Size = UDim2.new(0, 300, 0, 80)
    instructions.Position = UDim2.new(0, 10, 0, 40)
    instructions.BackgroundTransparency = 0.5
    instructions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    instructions.TextColor3 = Color3.fromRGB(255, 255, 255)
    instructions.Text = "Controles:\nWASD - Mover\nEspaço - Pular\nClique - Atacar"
    instructions.TextScaled = true
    instructions.Font = Enum.Font.Gotham
    instructions.Parent = screenGui
end

function PlayerController:setupControls()
    -- Configurar controles de ataque
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:attack()
        end
    end)
end

function PlayerController:attack()
    if not self.isAlive or not self.character then return end
    
    -- Criar efeito de ataque
    local attackEffect = Instance.new("Part")
    attackEffect.Size = Vector3.new(3, 3, 3)
    attackEffect.Position = self.rootPart.Position + self.rootPart.CFrame.LookVector * 3
    attackEffect.Anchored = true
    attackEffect.CanCollide = false
    attackEffect.Material = Enum.Material.Neon
    attackEffect.BrickColor = BrickColor.new("Bright blue")
    attackEffect.Shape = Enum.PartType.Ball
    attackEffect.Parent = workspace
    
    -- Animação do efeito
    local tween = TweenService:Create(attackEffect, TweenInfo.new(0.3), {
        Size = Vector3.new(0, 0, 0),
        Transparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        attackEffect:Destroy()
    end)
    
    -- Verificar se acertou a aranha
    self:checkSpiderHit()
end

function PlayerController:checkSpiderHit()
    local spider = workspace:FindFirstChild("Spider")
    if not spider then return end
    
    local spiderRoot = spider:FindFirstChild("HumanoidRootPart")
    if not spiderRoot then return end
    
    local distance = (spiderRoot.Position - self.rootPart.Position).Magnitude
    if distance <= 5 then
        -- Causar dano na aranha
        local spiderController = spider:FindFirstChild("SpiderController")
        if spiderController and spiderController.Value then
            -- Chamar o método de dano da aranha
            spiderController.Value:takeDamage(15)
            print("Aranha atingida! Dano: 15")
        end
    end
end

function PlayerController:monitorHealth()
    if not self.humanoid then return end
    
    self.humanoid.HealthChanged:Connect(function(health)
        self.health = health
        self:updateHealthDisplay()
        
        if health <= 0 then
            self:onDeath()
        end
    end)
end

function PlayerController:updateHealthDisplay()
    local playerGui = self.player.PlayerGui
    local healthFrame = playerGui:FindFirstChild("PlayerInterface")
    if not healthFrame then return end
    
    local healthBar = healthFrame:FindFirstChild("HealthFrame"):FindFirstChild("HealthBar")
    local healthText = healthFrame:FindFirstChild("HealthFrame"):FindFirstChild("HealthText")
    
    if healthBar and healthText then
        local healthPercent = self.health / self.maxHealth
        healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
        
        -- Mudar cor baseada na saúde
        if healthPercent > 0.6 then
            healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif healthPercent > 0.3 then
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
        
        healthText.Text = string.format("Saúde: %d/%d", self.health, self.maxHealth)
    end
end

function PlayerController:onDeath()
    self.isAlive = false
    
    -- Mostrar tela de game over
    self:showGameOver()
end

function PlayerController:showGameOver()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GameOverScreen"
    screenGui.Parent = self.player.PlayerGui
    
    local gameOverFrame = Instance.new("Frame")
    gameOverFrame.Size = UDim2.new(1, 0, 1, 0)
    gameOverFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    gameOverFrame.BackgroundTransparency = 0.3
    gameOverFrame.Parent = screenGui
    
    local gameOverText = Instance.new("TextLabel")
    gameOverText.Size = UDim2.new(0, 400, 0, 100)
    gameOverText.Position = UDim2.new(0.5, -200, 0.5, -50)
    gameOverText.BackgroundTransparency = 1
    gameOverText.TextColor3 = Color3.fromRGB(255, 0, 0)
    gameOverText.Text = "GAME OVER\nA aranha te pegou!"
    gameOverText.TextScaled = true
    gameOverText.Font = Enum.Font.GothamBold
    gameOverText.Parent = gameOverFrame
    
    -- Remover após 5 segundos
    game:GetService("Debris"):AddItem(screenGui, 5)
end

function PlayerController:takeDamage(damage)
    if not self.isAlive or not self.humanoid then return end
    
    self.humanoid.Health = self.humanoid.Health - damage
    
    -- Efeito visual de dano
    self:showDamageEffect()
end

function PlayerController:showDamageEffect()
    local playerGui = self.player.PlayerGui
    local playerInterface = playerGui:FindFirstChild("PlayerInterface")
    if not playerInterface then return end
    
    -- Criar efeito de dano
    local damageEffect = Instance.new("Frame")
    damageEffect.Size = UDim2.new(1, 0, 1, 0)
    damageEffect.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    damageEffect.BackgroundTransparency = 0.8
    damageEffect.Parent = playerInterface
    
    -- Animação do efeito
    local tween = TweenService:Create(damageEffect, TweenInfo.new(0.5), {
        BackgroundTransparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        damageEffect:Destroy()
    end)
end

return PlayerController
]]

-- Código do SpiderController
local SPIDER_CONTROLLER_CODE = [[
-- SpiderController.lua
-- Script principal para controlar a aranha e suas mecânicas

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local SpiderController = {}
SpiderController.__index = SpiderController

-- Configurações da aranha
local SPIDER_SPEED = 15
local SPIDER_JUMP_POWER = 50
local SPIDER_HEALTH = 100
local SPIDER_DAMAGE = 25

function SpiderController.new(spiderModel)
    local self = setmetatable({}, SpiderController)
    
    self.spiderModel = spiderModel
    self.humanoid = spiderModel:FindFirstChild("Humanoid")
    self.rootPart = spiderModel:FindFirstChild("HumanoidRootPart")
    self.health = SPIDER_HEALTH
    self.isAlive = true
    self.targetPlayer = nil
    self.lastAttack = 0
    self.attackCooldown = 2
    
    -- Sons da aranha
    self.spiderSounds = {
        attack = Instance.new("Sound"),
        death = Instance.new("Sound"),
        movement = Instance.new("Sound")
    }
    
    self:setupSounds()
    self:setupAI()
    
    return self
end

function SpiderController:setupSounds()
    -- Configurar sons (seriam carregados de arquivos reais)
    for _, sound in pairs(self.spiderSounds) do
        sound.Parent = self.spiderModel
        sound.Volume = 0.5
    end
end

function SpiderController:setupAI()
    -- Sistema de IA básico para a aranha
    RunService.Heartbeat:Connect(function(deltaTime)
        if not self.isAlive then return end
        
        self:findNearestPlayer()
        self:moveTowardsTarget()
        self:attackIfInRange()
    end)
end

function SpiderController:findNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - self.rootPart.Position).Magnitude
            if distance < shortestDistance and distance < 100 then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end
    
    self.targetPlayer = nearestPlayer
end

function SpiderController:moveTowardsTarget()
    if not self.targetPlayer or not self.targetPlayer.Character then return end
    
    local targetRoot = self.targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local direction = (targetRoot.Position - self.rootPart.Position).Unit
    local distance = (targetRoot.Position - self.rootPart.Position).Magnitude
    
    if distance > 10 then
        -- Mover em direção ao jogador
        self.humanoid:Move(direction)
        
        -- Animação de movimento
        if not self.spiderSounds.movement.IsPlaying then
            self.spiderSounds.movement:Play()
        end
    end
end

function SpiderController:attackIfInRange()
    if not self.targetPlayer or not self.targetPlayer.Character then return end
    
    local targetRoot = self.targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    local distance = (targetRoot.Position - self.rootPart.Position).Magnitude
    local currentTime = tick()
    
    if distance <= 8 and currentTime - self.lastAttack >= self.attackCooldown then
        self:performAttack()
        self.lastAttack = currentTime
    end
end

function SpiderController:performAttack()
    if not self.targetPlayer or not self.targetPlayer.Character then return end
    
    local targetHumanoid = self.targetPlayer.Character:FindFirstChild("Humanoid")
    if not targetHumanoid then return end
    
    -- Animação de ataque
    self.spiderSounds.attack:Play()
    
    -- Causar dano
    targetHumanoid.Health = targetHumanoid.Health - SPIDER_DAMAGE
    
    -- Efeito visual de ataque
    self:createAttackEffect()
end

function SpiderController:createAttackEffect()
    -- Criar efeito visual de ataque
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(2, 2, 2)
    effect.Position = self.rootPart.Position
    effect.Anchored = true
    effect.CanCollide = false
    effect.Material = Enum.Material.Neon
    effect.BrickColor = BrickColor.new("Really red")
    effect.Parent = workspace
    
    -- Animação do efeito
    local tween = TweenService:Create(effect, TweenInfo.new(0.5), {
        Size = Vector3.new(0, 0, 0),
        Transparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        effect:Destroy()
    end)
end

function SpiderController:takeDamage(damage)
    self.health = self.health - damage
    
    if self.health <= 0 then
        self:die()
    end
end

function SpiderController:die()
    self.isAlive = false
    self.spiderSounds.death:Play()
    
    -- Animação de morte
    local tween = TweenService:Create(self.spiderModel, TweenInfo.new(2), {
        Transparency = 1
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        self.spiderModel:Destroy()
    end)
end

return SpiderController
]]

-- Código do GameManager
local GAME_MANAGER_CODE = [[
-- GameManager.lua
-- Script principal que gerencia o jogo Spider

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local SpiderController = require(script.Parent.SpiderController)
local PlayerController = require(script.Parent.PlayerController)

local GameManager = {}
GameManager.__index = GameManager

-- Estados do jogo
local GAME_STATES = {
    WAITING = "waiting",
    INTRO = "intro",
    PLAYING = "playing",
    SPIDER_ARRIVAL = "spider_arrival",
    GAME_OVER = "game_over"
}

function GameManager.new()
    local self = setmetatable({}, GameManager)
    
    self.currentState = GAME_STATES.WAITING
    self.spiderSpawned = false
    self.gameStartTime = 0
    self.spiderArrivalTime = 30 -- 30 segundos para a aranha chegar
    
    -- Referências aos objetos do mundo
    self.island = workspace:FindFirstChild("Island")
    self.abandonedHouse = workspace:FindFirstChild("AbandonedHouse")
    self.spiderSpawnPoint = workspace:FindFirstChild("SpiderSpawnPoint")
    self.playerSpawnPoint = workspace:FindFirstChild("PlayerSpawnPoint")
    
    self:setupWorld()
    self:setupEvents()
    
    return self
end

function GameManager:setupWorld()
    -- Configurar iluminação atmosférica
    Lighting.Ambient = Color3.fromRGB(40, 40, 60)
    Lighting.Brightness = 0.3
    Lighting.ClockTime = 20 -- Noite
    Lighting.FogEnd = 500
    Lighting.FogStart = 100
    
    -- Criar ilha se não existir
    if not self.island then
        self.island = self:createIsland()
    end
    
    -- Criar casa abandonada se não existir
    if not self.abandonedHouse then
        self.abandonedHouse = self:createAbandonedHouse()
    end
    
    -- Criar pontos de spawn se não existirem
    if not self.spiderSpawnPoint then
        self.spiderSpawnPoint = self:createSpiderSpawnPoint()
    end
    
    if not self.playerSpawnPoint then
        self.playerSpawnPoint = self:createPlayerSpawnPoint()
    end
end

function GameManager:createIsland()
    local island = Instance.new("Part")
    island.Name = "Island"
    island.Size = Vector3.new(200, 10, 200)
    island.Position = Vector3.new(0, -5, 0)
    island.Anchored = true
    island.Material = Enum.Material.Grass
    island.BrickColor = BrickColor.new("Dark green")
    island.Parent = workspace
    
    -- Adicionar vegetação
    self:addVegetation(island)
    
    return island
end

function GameManager:createAbandonedHouse()
    local house = Instance.new("Model")
    house.Name = "AbandonedHouse"
    house.Parent = workspace
    
    -- Base da casa
    local base = Instance.new("Part")
    base.Size = Vector3.new(30, 20, 25)
    base.Position = Vector3.new(0, 10, 0)
    base.Anchored = true
    base.Material = Enum.Material.Wood
    base.BrickColor = BrickColor.new("Brown")
    base.Parent = house
    
    -- Telhado
    local roof = Instance.new("Part")
    roof.Size = Vector3.new(35, 5, 30)
    roof.Position = Vector3.new(0, 22.5, 0)
    roof.Anchored = true
    roof.Material = Enum.Material.Wood
    roof.BrickColor = BrickColor.new("Dark stone grey")
    roof.Parent = house
    
    -- Porta
    local door = Instance.new("Part")
    door.Size = Vector3.new(4, 8, 1)
    door.Position = Vector3.new(0, 4, 12.5)
    door.Anchored = true
    door.Material = Enum.Material.Wood
    door.BrickColor = BrickColor.new("Dark orange")
    door.Parent = house
    
    -- Janelas
    for i = 1, 2 do
        local window = Instance.new("Part")
        window.Size = Vector3.new(3, 3, 1)
        window.Position = Vector3.new(i * 8 - 4, 12, 12.5)
        window.Anchored = true
        window.Material = Enum.Material.Glass
        window.Transparency = 0.5
        window.Parent = house
    end
    
    return house
end

function GameManager:createSpiderSpawnPoint()
    local spawnPoint = Instance.new("Part")
    spawnPoint.Name = "SpiderSpawnPoint"
    spawnPoint.Size = Vector3.new(5, 5, 5)
    spawnPoint.Position = Vector3.new(100, 5, 100)
    spawnPoint.Anchored = true
    spawnPoint.Transparency = 1
    spawnPoint.CanCollide = false
    spawnPoint.Parent = workspace
    
    return spawnPoint
end

function GameManager:createPlayerSpawnPoint()
    local spawnPoint = Instance.new("Part")
    spawnPoint.Name = "PlayerSpawnPoint"
    spawnPoint.Size = Vector3.new(5, 5, 5)
    spawnPoint.Position = Vector3.new(0, 5, 0)
    spawnPoint.Anchored = true
    spawnPoint.Transparency = 1
    spawnPoint.CanCollide = false
    spawnPoint.Parent = workspace
    
    return spawnPoint
end

function GameManager:addVegetation(island)
    -- Adicionar árvores e arbustos
    for i = 1, 10 do
        local tree = Instance.new("Part")
        tree.Size = Vector3.new(2, 8, 2)
        tree.Position = Vector3.new(
            math.random(-80, 80),
            4,
            math.random(-80, 80)
        )
        tree.Anchored = true
        tree.Material = Enum.Material.Wood
        tree.BrickColor = BrickColor.new("Brown")
        tree.Parent = workspace
        
        -- Copa da árvore
        local leaves = Instance.new("Part")
        leaves.Size = Vector3.new(6, 4, 6)
        leaves.Position = tree.Position + Vector3.new(0, 6, 0)
        leaves.Anchored = true
        leaves.Material = Enum.Material.Grass
        leaves.BrickColor = BrickColor.new("Dark green")
        leaves.Shape = Enum.PartType.Ball
        leaves.Parent = workspace
    end
end

function GameManager:setupEvents()
    -- Evento quando um jogador entra
    Players.PlayerAdded:Connect(function(player)
        self:onPlayerAdded(player)
    end)
    
    -- Evento quando um jogador sai
    Players.PlayerRemoving:Connect(function(player)
        self:onPlayerRemoving(player)
    end)
    
    -- Loop principal do jogo
    RunService.Heartbeat:Connect(function(deltaTime)
        self:update(deltaTime)
    end)
end

function GameManager:onPlayerAdded(player)
    -- Criar controlador do jogador
    local playerController = PlayerController.new(player)
    
    -- Aguardar o personagem carregar
    player.CharacterAdded:Connect(function(character)
        self:setupPlayer(character)
    end)
    
    -- Se o jogador já tem personagem
    if player.Character then
        self:setupPlayer(player.Character)
    end
end

function GameManager:onPlayerRemoving(player)
    -- Limpeza quando o jogador sai
end

function GameManager:setupPlayer(character)
    -- Teleportar para o ponto de spawn
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoidRootPart.CFrame = self.playerSpawnPoint.CFrame
    
    -- Configurar interface do jogador
    self:setupPlayerGui(character)
    
    -- Iniciar jogo se for o primeiro jogador
    if self.currentState == GAME_STATES.WAITING then
        self:startGame()
    end
end

function GameManager:setupPlayerGui(character)
    local player = Players:GetPlayerFromCharacter(character)
    if not player then return end
    
    -- Criar interface básica
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpiderGameGui"
    screenGui.Parent = player.PlayerGui
    
    -- Texto de instruções
    local instructions = Instance.new("TextLabel")
    instructions.Size = UDim2.new(0, 300, 0, 100)
    instructions.Position = UDim2.new(0, 10, 0, 10)
    instructions.BackgroundTransparency = 0.5
    instructions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    instructions.TextColor3 = Color3.fromRGB(255, 255, 255)
    instructions.Text = "Bem-vindo à Ilha da Aranha!\nAguarde a chegada da aranha..."
    instructions.TextScaled = true
    instructions.Font = Enum.Font.GothamBold
    instructions.Parent = screenGui
end

function GameManager:startGame()
    self.currentState = GAME_STATES.INTRO
    self.gameStartTime = tick()
    
    -- Mostrar introdução
    self:showIntro()
    
    -- Transicionar para gameplay após 5 segundos
    wait(5)
    self.currentState = GAME_STATES.PLAYING
    self:showGameplayMessage()
end

function GameManager:showIntro()
    -- Mostrar mensagem de introdução para todos os jogadores
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui:FindFirstChild("SpiderGameGui") then
            local introLabel = player.PlayerGui.SpiderGameGui:FindFirstChild("IntroLabel")
            if not introLabel then
                introLabel = Instance.new("TextLabel")
                introLabel.Name = "IntroLabel"
                introLabel.Size = UDim2.new(0, 400, 0, 200)
                introLabel.Position = UDim2.new(0.5, -200, 0.5, -100)
                introLabel.BackgroundTransparency = 0.2
                introLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                introLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                introLabel.Text = "SPIDER GAME\n\nVocê está em uma ilha misteriosa...\nUma casa abandonada aguarda...\nE a aranha está chegando..."
                introLabel.TextScaled = true
                introLabel.Font = Enum.Font.GothamBold
                introLabel.Parent = player.PlayerGui.SpiderGameGui
            end
        end
    end
end

function GameManager:showGameplayMessage()
    -- Remover introdução e mostrar mensagem de gameplay
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui:FindFirstChild("SpiderGameGui") then
            local introLabel = player.PlayerGui.SpiderGameGui:FindFirstChild("IntroLabel")
            if introLabel then
                introLabel:Destroy()
            end
            
            -- Atualizar instruções
            local instructions = player.PlayerGui.SpiderGameGui:FindFirstChild("TextLabel")
            if instructions then
                instructions.Text = "Explore a ilha!\nA aranha chegará em breve..."
            end
        end
    end
end

function GameManager:update(deltaTime)
    if self.currentState == GAME_STATES.PLAYING then
        local elapsedTime = tick() - self.gameStartTime
        
        -- Verificar se é hora da aranha chegar
        if elapsedTime >= self.spiderArrivalTime and not self.spiderSpawned then
            self:spawnSpider()
        end
    end
end

function GameManager:spawnSpider()
    self.currentState = GAME_STATES.SPIDER_ARRIVAL
    self.spiderSpawned = true
    
    -- Mostrar aviso da chegada da aranha
    self:showSpiderWarning()
    
    -- Aguardar 3 segundos e spawnar a aranha
    wait(3)
    self:createSpider()
end

function GameManager:showSpiderWarning()
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui:FindFirstChild("SpiderGameGui") then
            local warningLabel = Instance.new("TextLabel")
            warningLabel.Name = "SpiderWarning"
            warningLabel.Size = UDim2.new(0, 400, 0, 100)
            warningLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
            warningLabel.BackgroundTransparency = 0.1
            warningLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            warningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            warningLabel.Text = "⚠️ ATENÇÃO! ⚠️\nA ARANHA ESTÁ CHEGANDO!"
            warningLabel.TextScaled = true
            warningLabel.Font = Enum.Font.GothamBold
            warningLabel.Parent = player.PlayerGui.SpiderGameGui
            
            -- Remover após 3 segundos
            game:GetService("Debris"):AddItem(warningLabel, 3)
        end
    end
end

function GameManager:createSpider()
    -- Criar modelo da aranha
    local spider = Instance.new("Model")
    spider.Name = "Spider"
    spider.Parent = workspace
    
    -- Corpo da aranha
    local body = Instance.new("Part")
    body.Size = Vector3.new(4, 2, 6)
    body.Position = self.spiderSpawnPoint.Position
    body.Anchored = false
    body.Material = Enum.Material.SmoothPlastic
    body.BrickColor = BrickColor.new("Really black")
    body.Parent = spider
    
    -- Cabeça da aranha
    local head = Instance.new("Part")
    head.Size = Vector3.new(3, 2, 3)
    head.Position = body.Position + Vector3.new(0, 0, 4.5)
    head.Anchored = false
    head.Material = Enum.Material.SmoothPlastic
    head.BrickColor = BrickColor.new("Really black")
    head.Parent = spider
    
    -- Olhos da aranha
    for i = 1, 2 do
        local eye = Instance.new("Part")
        eye.Size = Vector3.new(0.5, 0.5, 0.5)
        eye.Position = head.Position + Vector3.new(i * 0.8 - 0.4, 0.5, 1.5)
        eye.Anchored = false
        eye.Material = Enum.Material.Neon
        eye.BrickColor = BrickColor.new("Really red")
        eye.Shape = Enum.PartType.Ball
        eye.Parent = spider
        
        -- Conectar ao corpo
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = head
        weld.Part1 = eye
        weld.Parent = eye
    end
    
    -- Pernas da aranha
    for i = 1, 8 do
        local leg = Instance.new("Part")
        leg.Size = Vector3.new(0.5, 3, 0.5)
        local angle = (i - 1) * math.pi / 4
        leg.Position = body.Position + Vector3.new(
            math.cos(angle) * 3,
            -1.5,
            math.sin(angle) * 3
        )
        leg.Anchored = false
        leg.Material = Enum.Material.SmoothPlastic
        leg.BrickColor = BrickColor.new("Really black")
        leg.Parent = spider
        
        -- Conectar ao corpo
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = body
        weld.Part1 = leg
        weld.Parent = leg
    end
    
    -- Conectar cabeça ao corpo
    local headWeld = Instance.new("WeldConstraint")
    headWeld.Part0 = body
    headWeld.Part1 = head
    headWeld.Parent = head
    
    -- Adicionar Humanoid para movimento
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = spider
    
    -- Adicionar HumanoidRootPart
    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 2)
    rootPart.Position = body.Position
    rootPart.Anchored = false
    rootPart.CanCollide = false
    rootPart.Transparency = 1
    rootPart.Parent = spider
    
    -- Conectar ao corpo
    local rootWeld = Instance.new("WeldConstraint")
    rootWeld.Part0 = rootPart
    rootWeld.Part1 = body
    rootWeld.Parent = rootPart
    
    -- Configurar Humanoid
    humanoid.RootPart = rootPart
    
    -- Criar controlador da aranha
    local spiderController = SpiderController.new(spider)
    
    -- Adicionar referência ao controlador na aranha
    local controllerRef = Instance.new("ObjectValue")
    controllerRef.Name = "SpiderController"
    controllerRef.Value = spiderController
    controllerRef.Parent = spider
    
    -- Atualizar interface dos jogadores
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui:FindFirstChild("SpiderGameGui") then
            local instructions = player.PlayerGui.SpiderGameGui:FindFirstChild("TextLabel")
            if instructions then
                instructions.Text = "A ARANHA CHEGOU!\nFuja ou lute pela sua vida!"
                instructions.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end
    
    return spider
end

-- Criar instância do GameManager
local gameManager = GameManager.new()

return GameManager
]]

-- Código do script principal (init)
local INIT_CODE = [[
-- init.lua
-- Script de inicialização do jogo Spider

local GameManager = require(script.GameManager)

-- Aguardar um momento para garantir que tudo carregou
wait(1)

print("Spider Game Demo - Inicializado com sucesso!")
print("Desenvolvido por: Wallan Peixoto")
print("Versão: 1.0")

-- O GameManager já foi criado automaticamente no require
-- O jogo está pronto para receber jogadores!
]]

-- Função principal para configurar o jogo
local function setupSpiderGame()
    print("🕷️ Configurando Spider Game completo...")
    
    -- Aguardar um momento para garantir que o Roblox Studio carregou
    wait(1)
    
    -- Limpar scripts existentes se houver
    local existingScripts = ServerScriptService:FindFirstChild("init")
    if existingScripts then
        print("🗑️ Removendo scripts existentes...")
        existingScripts:Destroy()
    end
    
    local existingFolder = ServerScriptService:FindFirstChild("Scripts")
    if existingFolder then
        print("🗑️ Removendo pasta de scripts existente...")
        existingFolder:Destroy()
    end
    
    -- Criar script principal
    print("📝 Criando script principal...")
    local initScript = createScript("init", INIT_CODE, ServerScriptService)
    if initScript then
        print("✅ Script principal criado com sucesso!")
    end
    
    -- Criar pasta de scripts
    print("📁 Criando pasta de scripts...")
    local scriptsFolder = createFolder("Scripts", ServerScriptService)
    if scriptsFolder then
        print("✅ Pasta de scripts criada com sucesso!")
    end
    
    -- Criar scripts individuais
    print("🔧 Criando GameManager...")
    local gameManagerScript = createScript("GameManager", GAME_MANAGER_CODE, scriptsFolder)
    if gameManagerScript then
        print("✅ GameManager criado com sucesso!")
    end
    
    print("🕷️ Criando SpiderController...")
    local spiderControllerScript = createScript("SpiderController", SPIDER_CONTROLLER_CODE, scriptsFolder)
    if spiderControllerScript then
        print("✅ SpiderController criado com sucesso!")
    end
    
    print("👤 Criando PlayerController...")
    local playerControllerScript = createScript("PlayerController", PLAYER_CONTROLLER_CODE, scriptsFolder)
    if playerControllerScript then
        print("✅ PlayerController criado com sucesso!")
    end
    
    print("⚙️ Criando Config...")
    local configScript = createScript("Config", CONFIG_CODE, scriptsFolder)
    if configScript then
        print("✅ Config criado com sucesso!")
    end
    
    -- Verificar se tudo foi criado corretamente
    local success = true
    if not ServerScriptService:FindFirstChild("init") then
        print("❌ Erro: Script principal não foi criado!")
        success = false
    end
    
    if not ServerScriptService:FindFirstChild("Scripts") then
        print("❌ Erro: Pasta de scripts não foi criada!")
        success = false
    end
    
    if success then
        print("\n🎉 CONFIGURAÇÃO CONCLUÍDA COM SUCESSO!")
        print("🎮 Clique em PLAY para testar o jogo!")
        print("🕷️ A aranha aparecerá após 30 segundos...")
        
        -- Mostrar instruções no console
        print("\n📋 INSTRUÇÕES DO JOGO:")
        print("• Use WASD para mover")
        print("• Clique para atacar a aranha")
        print("• A aranha chegará após 30 segundos")
        print("• Mantenha sua saúde acima de zero")
        print("• Explore a ilha e a casa abandonada")
        
        print("\n💡 DICA: Se algo não funcionar, tente:")
        print("1. Parar o jogo (Stop)")
        print("2. Executar este script novamente")
        print("3. Clicar em PLAY novamente")
        
        -- Salvar o lugar como arquivo .rbxl
        print("\n💾 Salvando como arquivo .rbxl...")
        local success, result = pcall(function()
            game:Save("spider_game_completo.rbxl")
        end)
        
        if success then
            print("✅ Arquivo spider_game_completo.rbxl criado com sucesso!")
            print("📁 Local: Workspace do Roblox Studio")
            print("🎯 Agora você pode importar este arquivo em qualquer lugar!")
        else
            print("❌ Erro ao salvar: " .. tostring(result))
            print("💡 Use File → Save As no Roblox Studio")
        end
    else
        print("\n❌ ERRO NA CONFIGURAÇÃO!")
        print("Tente executar o script novamente.")
    end
end

-- Executar configuração com tratamento de erro
local success, error = pcall(setupSpiderGame)
if not success then
    print("❌ Erro durante a configuração: " .. tostring(error))
    print("💡 Tente executar o script novamente.")
end 