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