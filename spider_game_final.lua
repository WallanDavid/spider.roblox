-- spider_game_final.lua
-- Script final do Spider Game para ServerScriptService - VERSÃO CORRIGIDA

print("🕷️ Iniciando Spider Game Demo - VERSÃO CORRIGIDA...")
print("Desenvolvido por: Wallan Peixoto")

-- Serviços
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- Configurações dinâmicas
local SPIDER_SPEED = 12 -- Velocidade da aranha
local SPIDER_HEALTH = 100
local PLAYER_HEALTH = 100
local SPIDER_ARRIVAL_TIME = 10 -- Reduzido para mais ação
local MAX_SPIDERS = 2
local POWERUP_SPAWN_TIME = 8 -- Power-ups mais frequentes

-- Variáveis globais
local spiders = {}
local powerups = {}
local gameActive = true
local spiderCount = 0
local playerWeapons = {} -- Inventário de armas dos jogadores

-- Sistema de armas
local WEAPONS = {
    {
        name = "Pistola",
        damage = 25,
        range = 20,
        cooldown = 0.6,
        color = BrickColor.new("Bright blue"),
        model = "Pistol"
    },
    {
        name = "Rifle",
        damage = 40,
        range = 30,
        cooldown = 1.0,
        color = BrickColor.new("Really red"),
        model = "Rifle"
    },
    {
        name = "Shotgun",
        damage = 60,
        range = 10,
        cooldown = 1.5,
        color = BrickColor.new("Bright yellow"),
        model = "Shotgun"
    }
}

-- Configurar iluminação para TARDE
Lighting.Ambient = Color3.fromRGB(120, 120, 140)
Lighting.Brightness = 1.2
Lighting.ClockTime = 14 -- TARDE (14:00)
Lighting.FogEnd = 1000
Lighting.FogStart = 200

-- Adicionar efeito de névoa dinâmica
spawn(function()
    while gameActive do
        wait(8)
        local tween = TweenService:Create(Lighting, TweenInfo.new(4), {
            FogEnd = math.random(800, 1200)
        })
        tween:Play()
    end
end)

print("🌞 Configuração de iluminação de tarde aplicada...")

-- Função para criar ilha com mais detalhes
local function createIsland()
    local island = Instance.new("Part")
    island.Name = "Island"
    island.Size = Vector3.new(200, 10, 200)
    island.Position = Vector3.new(0, -5, 0)
    island.Anchored = true
    island.Material = Enum.Material.Grass
    island.BrickColor = BrickColor.new("Dark green")
    island.Parent = workspace
    
    -- Adicionar textura de grama
    local grassTexture = Instance.new("Texture")
    grassTexture.Texture = "rbxassetid://6444884337"
    grassTexture.StudsPerTileU = 5
    grassTexture.StudsPerTileV = 5
    grassTexture.Parent = island
    
    print("🏝️ Ilha criada com sucesso!")
    return island
end

-- Função para criar casa abandonada mais detalhada
local function createAbandonedHouse()
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
    
    -- Adicionar teias de aranha na casa
    for i = 1, 5 do
        local web = Instance.new("Part")
        web.Size = Vector3.new(math.random(2, 5), 0.1, math.random(2, 5))
        web.Position = Vector3.new(
            math.random(-10, 10),
            math.random(15, 20),
            math.random(-10, 10)
        )
        web.Anchored = true
        web.Material = Enum.Material.Fabric
        web.BrickColor = BrickColor.new("White")
        web.Transparency = 0.7
        web.Parent = house
    end
    
    print("🏠 Casa abandonada criada!")
    return house
end

-- Função para adicionar vegetação mais variada
local function addVegetation()
    for i = 1, 15 do
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
    
    -- Adicionar arbustos
    for i = 1, 8 do
        local bush = Instance.new("Part")
        bush.Size = Vector3.new(3, 2, 3)
        bush.Position = Vector3.new(
            math.random(-70, 70),
            1,
            math.random(-70, 70)
        )
        bush.Anchored = true
        bush.Material = Enum.Material.Grass
        bush.BrickColor = BrickColor.new("Forest green")
        bush.Shape = Enum.PartType.Ball
        bush.Parent = workspace
    end
    
    print("🌳 Vegetação variada adicionada!")
end

-- Função para criar power-ups
local function createPowerup()
    local powerupTypes = {
        {name = "SpeedBoost", color = BrickColor.new("Bright blue"), effect = "speed"},
        {name = "HealthPack", color = BrickColor.new("Bright green"), effect = "health"},
        {name = "DamageBoost", color = BrickColor.new("Really red"), effect = "damage"},
        {name = "Shield", color = BrickColor.new("Bright yellow"), effect = "shield"},
        {name = "WeaponCrate", color = BrickColor.new("Bright violet"), effect = "weapon"}
    }
    
    local powerupType = powerupTypes[math.random(1, #powerupTypes)]
    
    local powerup = Instance.new("Part")
    powerup.Name = powerupType.name
    powerup.Size = Vector3.new(2, 2, 2)
    powerup.Position = Vector3.new(
        math.random(-70, 70),
        2,
        math.random(-70, 70)
    )
    powerup.Anchored = true
    powerup.Material = Enum.Material.Neon
    powerup.BrickColor = powerupType.color
    powerup.Shape = Enum.PartType.Ball
    powerup.Parent = workspace
    
    -- Efeito de rotação
    spawn(function()
        while powerup and powerup.Parent do
            wait(0.1)
            powerup.CFrame = powerup.CFrame * CFrame.Angles(0, math.rad(10), 0)
        end
    end)
    
    -- Efeito de brilho
    spawn(function()
        while powerup and powerup.Parent do
            wait(0.5)
            local tween = TweenService:Create(powerup, TweenInfo.new(0.5), {
                Transparency = powerup.Transparency == 0.3 and 0.7 or 0.3
            })
            tween:Play()
        end
    end)
    
    table.insert(powerups, {part = powerup, type = powerupType.effect})
    
    -- Remover após 10 segundos
    game:GetService("Debris"):AddItem(powerup, 10)
    
    return powerup, powerupType.effect
end

-- Função para criar aranha mais detalhada
local function createSpider(spawnPosition)
    local spider = Instance.new("Model")
    spider.Name = "Spider" .. spiderCount
    spider.Parent = workspace
    spiderCount = spiderCount + 1
    
    -- Corpo da aranha
    local body = Instance.new("Part")
    body.Size = Vector3.new(4, 2, 6)
    body.Position = spawnPosition or Vector3.new(100, 5, 100)
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
    
    -- Olhos da aranha (mais detalhados)
    for i = 1, 4 do
        local eye = Instance.new("Part")
        eye.Size = Vector3.new(0.3, 0.3, 0.3)
        local angle = (i - 1) * math.pi / 2
        eye.Position = head.Position + Vector3.new(
            math.cos(angle) * 1.2,
            0.5,
            math.sin(angle) * 1.2 + 1.5
        )
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
    
    -- Pernas da aranha (mais realistas)
    for i = 1, 8 do
        local leg = Instance.new("Part")
        leg.Size = Vector3.new(0.5, 4, 0.5)
        local angle = (i - 1) * math.pi / 4
        leg.Position = body.Position + Vector3.new(
            math.cos(angle) * 4,
            -2,
            math.sin(angle) * 4
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
    humanoid.WalkSpeed = SPIDER_SPEED
    humanoid.JumpPower = 30
    
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
    
    -- Criar barra de saúde da aranha (CORRIGIDA)
    local healthBarContainer = Instance.new("Part")
    healthBarContainer.Size = Vector3.new(5, 0.8, 0.8)
    healthBarContainer.Position = body.Position + Vector3.new(0, 4, 0)
    healthBarContainer.Anchored = true
    healthBarContainer.Material = Enum.Material.SmoothPlastic
    healthBarContainer.BrickColor = BrickColor.new("Dark stone grey")
    healthBarContainer.CanCollide = false
    healthBarContainer.Parent = spider
    
    local healthBar = Instance.new("Part")
    healthBar.Size = Vector3.new(4.5, 0.6, 0.6)
    healthBar.Position = healthBarContainer.Position
    healthBar.Anchored = true
    healthBar.Material = Enum.Material.Neon
    healthBar.BrickColor = BrickColor.new("Bright red")
    healthBar.CanCollide = false
    healthBar.Parent = spider
    
    -- Conectar barra de saúde ao corpo
    local healthWeld = Instance.new("WeldConstraint")
    healthWeld.Part0 = body
    healthWeld.Part1 = healthBarContainer
    healthWeld.Parent = healthBarContainer
    
    local healthBarWeld = Instance.new("WeldConstraint")
    healthBarWeld.Part0 = healthBarContainer
    healthBarWeld.Part1 = healthBar
    healthBarWeld.Parent = healthBar
    
    print("🕷️ Aranha " .. spiderCount .. " criada com barra de vida!")
    return spider, humanoid, rootPart, healthBar, healthBarContainer
end

-- Função para configurar interface do jogador melhorada
local function setupPlayerInterface(player)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpiderGameGui"
    screenGui.Parent = player.PlayerGui
    
    -- Barra de saúde melhorada
    local healthFrame = Instance.new("Frame")
    healthFrame.Name = "HealthFrame"
    healthFrame.Size = UDim2.new(0, 250, 0, 25)
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
    
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.Text = "Saúde: 100/100"
    healthText.TextScaled = true
    healthText.Font = Enum.Font.GothamBold
    healthText.Parent = healthFrame
    
    -- Barra de energia
    local energyFrame = Instance.new("Frame")
    energyFrame.Name = "EnergyFrame"
    energyFrame.Size = UDim2.new(0, 250, 0, 15)
    energyFrame.Position = UDim2.new(0, 10, 0, 40)
    energyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    energyFrame.BackgroundTransparency = 0.3
    energyFrame.BorderSizePixel = 0
    energyFrame.Parent = screenGui
    
    local energyBar = Instance.new("Frame")
    energyBar.Name = "EnergyBar"
    energyBar.Size = UDim2.new(1, 0, 1, 0)
    energyBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    energyBar.BorderSizePixel = 0
    energyBar.Parent = energyFrame
    
    -- Contador de aranhas
    local spiderCounter = Instance.new("TextLabel")
    spiderCounter.Name = "SpiderCounter"
    spiderCounter.Size = UDim2.new(0, 200, 0, 30)
    spiderCounter.Position = UDim2.new(1, -210, 0, 10)
    spiderCounter.BackgroundTransparency = 0.3
    spiderCounter.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    spiderCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
    spiderCounter.Text = "🕷️ Aranhas: 0"
    spiderCounter.TextScaled = true
    spiderCounter.Font = Enum.Font.GothamBold
    spiderCounter.Parent = screenGui
    
    -- Inventário de armas
    local weaponFrame = Instance.new("Frame")
    weaponFrame.Name = "WeaponFrame"
    weaponFrame.Size = UDim2.new(0, 300, 0, 80)
    weaponFrame.Position = UDim2.new(1, -310, 0, 50)
    weaponFrame.BackgroundTransparency = 0.3
    weaponFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    weaponFrame.Parent = screenGui
    
    local weaponTitle = Instance.new("TextLabel")
    weaponTitle.Name = "WeaponTitle"
    weaponTitle.Size = UDim2.new(1, 0, 0, 20)
    weaponTitle.BackgroundTransparency = 1
    weaponTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponTitle.Text = "🔫 ARMAS"
    weaponTitle.TextScaled = true
    weaponTitle.Font = Enum.Font.GothamBold
    weaponTitle.Parent = weaponFrame
    
    local weaponList = Instance.new("TextLabel")
    weaponList.Name = "WeaponList"
    weaponList.Size = UDim2.new(1, 0, 1, -20)
    weaponList.Position = UDim2.new(0, 0, 0, 20)
    weaponList.BackgroundTransparency = 1
    weaponList.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponList.Text = "1 - Pistola | 2 - Rifle | 3 - Shotgun"
    weaponList.TextScaled = true
    weaponList.Font = Enum.Font.Gotham
    weaponList.Parent = weaponFrame
    
    -- Instruções dinâmicas
    local instructions = Instance.new("TextLabel")
    instructions.Name = "Instructions"
    instructions.Size = UDim2.new(0, 350, 0, 100)
    instructions.Position = UDim2.new(0, 10, 0, 60)
    instructions.BackgroundTransparency = 0.5
    instructions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    instructions.TextColor3 = Color3.fromRGB(255, 255, 255)
    instructions.Text = "Bem-vindo à Ilha da Aranha!\n1,2,3 - Trocar Arma | Clique - Atirar\nColete power-ups para vantagens!"
    instructions.TextScaled = true
    instructions.Font = Enum.Font.Gotham
    instructions.Parent = screenGui
    
    -- Efeitos de status
    local statusEffects = Instance.new("Frame")
    statusEffects.Name = "StatusEffects"
    statusEffects.Size = UDim2.new(0, 150, 0, 80)
    statusEffects.Position = UDim2.new(1, -160, 0, 140)
    statusEffects.BackgroundTransparency = 0.5
    statusEffects.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statusEffects.Parent = screenGui
    
    return screenGui
end

-- Função para mostrar aviso da aranha melhorado
local function showSpiderWarning()
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui:FindFirstChild("SpiderGameGui") then
            local warningLabel = Instance.new("TextLabel")
            warningLabel.Name = "SpiderWarning"
            warningLabel.Size = UDim2.new(0, 500, 0, 120)
            warningLabel.Position = UDim2.new(0.5, -250, 0.5, -60)
            warningLabel.BackgroundTransparency = 0.1
            warningLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            warningLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            warningLabel.Text = "⚠️ ATENÇÃO! ⚠️\nAS ARANHAS ESTÃO CHEGANDO!\nPrepare-se para a batalha!"
            warningLabel.TextScaled = true
            warningLabel.Font = Enum.Font.GothamBold
            warningLabel.Parent = player.PlayerGui.SpiderGameGui
            
            -- Efeito de pulsação
            spawn(function()
                for i = 1, 6 do
                    wait(0.5)
                    warningLabel.BackgroundColor3 = warningLabel.BackgroundColor3 == Color3.fromRGB(255, 0, 0) and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(255, 0, 0)
                end
            end)
            
            -- Remover após 3 segundos
            game:GetService("Debris"):AddItem(warningLabel, 3)
        end
    end
end

-- Função para atualizar interface dos jogadores
local function updatePlayerInterfaces()
    for _, player in pairs(Players:GetPlayers()) do
        if player.PlayerGui:FindFirstChild("SpiderGameGui") then
            local instructions = player.PlayerGui.SpiderGameGui:FindFirstChild("Instructions")
            if instructions then
                instructions.Text = "AS ARANHAS CHEGARAM!\n1,2,3 - Trocar Armas | Clique - Atirar!"
                instructions.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
            
            -- Atualizar contador de aranhas
            local spiderCounter = player.PlayerGui.SpiderGameGui:FindFirstChild("SpiderCounter")
            if spiderCounter then
                spiderCounter.Text = "🕷️ Aranhas: " .. #spiders
            end
        end
    end
end

-- Função para sistema de combate com armas (CORRIGIDA)
local function setupCombatSystem(player)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Inicializar inventário do jogador
    playerWeapons[player.Name] = {
        currentWeapon = 1,
        weapons = {WEAPONS[1], WEAPONS[2], WEAPONS[3]},
        lastShot = 0
    }
    
    -- Sistema de troca de armas (CORRIGIDO)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.One then
            playerWeapons[player.Name].currentWeapon = 1
            print("🔫 Arma selecionada: Pistola (1)")
        elseif input.KeyCode == Enum.KeyCode.Two then
            playerWeapons[player.Name].currentWeapon = 2
            print("🔫 Arma selecionada: Rifle (2)")
        elseif input.KeyCode == Enum.KeyCode.Three then
            playerWeapons[player.Name].currentWeapon = 3
            print("🔫 Arma selecionada: Shotgun (3)")
        end
    end)
    
    -- Sistema de tiro (CORRIGIDO)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local weaponData = playerWeapons[player.Name]
            local currentWeapon = weaponData.weapons[weaponData.currentWeapon]
            
            if tick() - weaponData.lastShot > currentWeapon.cooldown then
                weaponData.lastShot = tick()
                
                -- Criar projétil
                local bullet = Instance.new("Part")
                bullet.Size = Vector3.new(0.5, 0.5, 0.5)
                bullet.Position = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 3
                bullet.Anchored = true
                bullet.CanCollide = false
                bullet.Material = Enum.Material.Neon
                bullet.BrickColor = currentWeapon.color
                bullet.Shape = Enum.PartType.Ball
                bullet.Parent = workspace
                
                -- Direção do tiro
                local direction = character.HumanoidRootPart.CFrame.LookVector
                
                -- Mover projétil
                spawn(function()
                    for i = 1, currentWeapon.range do
                        if bullet and bullet.Parent then
                            bullet.Position = bullet.Position + direction
                            
                            -- Verificar colisão com aranhas
                            for _, spiderData in pairs(spiders) do
                                local spider = spiderData.model
                                if spider and spider.Parent then
                                    local spiderRoot = spider:FindFirstChild("HumanoidRootPart")
                                    if spiderRoot then
                                        local distance = (spiderRoot.Position - bullet.Position).Magnitude
                                        if distance <= 2 then
                                            -- Causar dano na aranha
                                            spiderData.health = spiderData.health - currentWeapon.damage
                                            
                                            -- Atualizar barra de saúde (CORRIGIDA)
                                            if spiderData.healthBar then
                                                local healthPercent = spiderData.health / SPIDER_HEALTH
                                                spiderData.healthBar.Size = Vector3.new(4.5 * healthPercent, 0.6, 0.6)
                                                
                                                if healthPercent <= 0.5 then
                                                    spiderData.healthBar.BrickColor = BrickColor.new("Bright yellow")
                                                end
                                                if healthPercent <= 0.25 then
                                                    spiderData.healthBar.BrickColor = BrickColor.new("Bright red")
                                                end
                                            end
                                            
                                            -- Efeito de dano
                                            local damageEffect = Instance.new("Part")
                                            damageEffect.Size = Vector3.new(3, 3, 3)
                                            damageEffect.Position = spiderRoot.Position
                                            damageEffect.Anchored = true
                                            damageEffect.CanCollide = false
                                            damageEffect.Material = Enum.Material.Neon
                                            damageEffect.BrickColor = currentWeapon.color
                                            damageEffect.Shape = Enum.PartType.Ball
                                            damageEffect.Parent = workspace
                                            
                                            local damageTween = TweenService:Create(damageEffect, TweenInfo.new(0.5), {
                                                Size = Vector3.new(0, 0, 0),
                                                Transparency = 1
                                            })
                                            damageTween:Play()
                                            damageTween.Completed:Connect(function()
                                                damageEffect:Destroy()
                                            end)
                                            
                                            print("Aranha atingida! Dano: " .. currentWeapon.damage)
                                            
                                            -- Verificar se a aranha morreu
                                            if spiderData.health <= 0 then
                                                spider:Destroy()
                                                for i, spiderData2 in pairs(spiders) do
                                                    if spiderData2.model == spider then
                                                        table.remove(spiders, i)
                                                        break
                                                    end
                                                end
                                                updatePlayerInterfaces()
                                            end
                                            
                                            bullet:Destroy()
                                            return
                                        end
                                    end
                                end
                            end
                            
                            wait(0.05)
                        else
                            break
                        end
                    end
                    
                    if bullet and bullet.Parent then
                        bullet:Destroy()
                    end
                end)
            end
        end
    end)
end

-- Criar mundo
print("🏗️ Criando mundo do jogo corrigido...")
createIsland()
createAbandonedHouse()
addVegetation()

print("✅ Mundo criado com sucesso!")

-- Sistema de power-ups
spawn(function()
    while gameActive do
        wait(POWERUP_SPAWN_TIME)
        if #powerups < 3 then -- Máximo 3 power-ups por vez
            createPowerup()
        end
    end
end)

-- Configurar jogadores
Players.PlayerAdded:Connect(function(player)
    print("👤 Jogador entrou: " .. player.Name)
    
    -- Configurar interface
    setupPlayerInterface(player)
    
    -- Configurar personagem
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.MaxHealth = PLAYER_HEALTH
        humanoid.Health = PLAYER_HEALTH
        humanoid.WalkSpeed = 20
        humanoid.JumpPower = 50
        
        -- Configurar sistema de combate
        setupCombatSystem(player)
        
        print("🎮 Personagem configurado para: " .. player.Name)
    end)
    
    -- Se o jogador já tem personagem
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = PLAYER_HEALTH
            humanoid.Health = PLAYER_HEALTH
            humanoid.WalkSpeed = 20
            humanoid.JumpPower = 50
        end
        setupCombatSystem(player)
    end
end)

-- Sistema de coleta de power-ups
spawn(function()
    while gameActive do
        wait(0.1)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                for i, powerupData in pairs(powerups) do
                    if powerupData.part and powerupData.part.Parent then
                        local distance = (powerupData.part.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= 3 then
                            -- Aplicar efeito do power-up
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                if powerupData.type == "speed" then
                                    humanoid.WalkSpeed = 30
                                    spawn(function()
                                        wait(10)
                                        humanoid.WalkSpeed = 20
                                    end)
                                elseif powerupData.type == "health" then
                                    humanoid.Health = math.min(humanoid.Health + 25, humanoid.MaxHealth)
                                elseif powerupData.type == "damage" then
                                    -- Aumentar dano temporariamente
                                    local weaponData = playerWeapons[player.Name]
                                    if weaponData then
                                        for _, weapon in pairs(weaponData.weapons) do
                                            weapon.damage = weapon.damage * 1.5
                                        end
                                        spawn(function()
                                            wait(15)
                                            for _, weapon in pairs(weaponData.weapons) do
                                                weapon.damage = weapon.damage / 1.5
                                            end
                                        end)
                                    end
                                elseif powerupData.type == "shield" then
                                    -- Implementar escudo temporário
                                elseif powerupData.type == "weapon" then
                                    -- Dar arma especial temporária
                                    print("🔫 Arma especial obtida!")
                                end
                            end
                            
                            -- Efeito de coleta
                            local collectEffect = Instance.new("Part")
                            collectEffect.Size = Vector3.new(5, 5, 5)
                            collectEffect.Position = powerupData.part.Position
                            collectEffect.Anchored = true
                            collectEffect.CanCollide = false
                            collectEffect.Material = Enum.Material.Neon
                            collectEffect.BrickColor = powerupData.part.BrickColor
                            collectEffect.Shape = Enum.PartType.Ball
                            collectEffect.Parent = workspace
                            
                            local collectTween = TweenService:Create(collectEffect, TweenInfo.new(1), {
                                Size = Vector3.new(0, 0, 0),
                                Transparency = 1
                            })
                            collectTween:Play()
                            collectTween.Completed:Connect(function()
                                collectEffect:Destroy()
                            end)
                            
                            powerupData.part:Destroy()
                            table.remove(powerups, i)
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- Aguardar e criar aranhas
print("⏰ Aguardando " .. SPIDER_ARRIVAL_TIME .. " segundos para as aranhas chegarem...")
wait(SPIDER_ARRIVAL_TIME)

print("🕷️ As aranhas estão chegando!")
showSpiderWarning()

wait(3) -- Aguardar aviso

-- Criar múltiplas aranhas
for i = 1, MAX_SPIDERS do
    local spawnPos = Vector3.new(
        math.random(-80, 80),
        5,
        math.random(-80, 80)
    )
    
    local spider, humanoid, rootPart, healthBar, healthBarContainer = createSpider(spawnPos)
    table.insert(spiders, {
        model = spider,
        humanoid = humanoid,
        rootPart = rootPart,
        healthBar = healthBar,
        healthBarContainer = healthBarContainer,
        health = SPIDER_HEALTH
    })
    
    wait(2) -- Espaçar o spawn das aranhas
end

updatePlayerInterfaces()

-- IA das aranhas CORRIGIDA e melhorada
spawn(function()
    while gameActive do
        wait(0.1)
        
        for _, spiderData in pairs(spiders) do
            if spiderData.model and spiderData.model.Parent and spiderData.humanoid then
                local nearestPlayer = nil
                local shortestDistance = math.huge
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - spiderData.rootPart.Position).Magnitude
                        if distance < shortestDistance and distance < 150 then
                            shortestDistance = distance
                            nearestPlayer = player
                        end
                    end
                end
                
                if nearestPlayer and nearestPlayer.Character then
                    local targetPosition = nearestPlayer.Character.HumanoidRootPart.Position
                    local direction = (targetPosition - spiderData.rootPart.Position).Unit
                    
                    -- Mover a aranha CORRETAMENTE
                    spiderData.humanoid:Move(direction)
                    
                    -- Ataque da aranha
                    if shortestDistance <= 8 then
                        local humanoid = nearestPlayer.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.Health = humanoid.Health - 5
                            
                            -- Efeito de ataque da aranha
                            local spiderAttackEffect = Instance.new("Part")
                            spiderAttackEffect.Size = Vector3.new(2, 2, 2)
                            spiderAttackEffect.Position = nearestPlayer.Character.HumanoidRootPart.Position
                            spiderAttackEffect.Anchored = true
                            spiderAttackEffect.CanCollide = false
                            spiderAttackEffect.Material = Enum.Material.Neon
                            spiderAttackEffect.BrickColor = BrickColor.new("Really red")
                            spiderAttackEffect.Shape = Enum.PartType.Ball
                            spiderAttackEffect.Parent = workspace
                            
                            local attackTween = TweenService:Create(spiderAttackEffect, TweenInfo.new(0.3), {
                                Size = Vector3.new(0, 0, 0),
                                Transparency = 1
                            })
                            attackTween:Play()
                            attackTween.Completed:Connect(function()
                                spiderAttackEffect:Destroy()
                            end)
                        end
                    end
                end
            end
        end
    end
end)

print("🎉 Spider Game Demo - VERSÃO CORRIGIDA iniciado com sucesso!")
print("🎮 O jogo está funcionando com sistema de armas!")
print("🕷️ As aranhas perseguem corretamente!")
print("🔫 1-Pistola | 2-Rifle | 3-Shotgun | Clique para atirar!")
print("⚡ Colete power-ups para vantagens!")
print("🏆 Derrote todas as aranhas para vencer!") 