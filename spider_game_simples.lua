-- spider_game_simples.lua
-- Script simples para criar o Spider Game no ServerScriptService

print("🕷️ Criando Spider Game...")

-- Serviços
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- Configurar iluminação
Lighting.Ambient = Color3.fromRGB(40, 40, 60)
Lighting.Brightness = 0.3
Lighting.ClockTime = 20
Lighting.FogEnd = 500
Lighting.FogStart = 100

-- Criar ilha
local island = Instance.new("Part")
island.Name = "Island"
island.Size = Vector3.new(200, 10, 200)
island.Position = Vector3.new(0, -5, 0)
island.Anchored = true
island.Material = Enum.Material.Grass
island.BrickColor = BrickColor.new("Dark green")
island.Parent = workspace

-- Criar casa
local house = Instance.new("Model")
house.Name = "AbandonedHouse"
house.Parent = workspace

local base = Instance.new("Part")
base.Size = Vector3.new(30, 20, 25)
base.Position = Vector3.new(0, 10, 0)
base.Anchored = true
base.Material = Enum.Material.Wood
base.BrickColor = BrickColor.new("Brown")
base.Parent = house

local roof = Instance.new("Part")
roof.Size = Vector3.new(35, 5, 30)
roof.Position = Vector3.new(0, 22.5, 0)
roof.Anchored = true
roof.Material = Enum.Material.Wood
roof.BrickColor = BrickColor.new("Dark stone grey")
roof.Parent = house

-- Adicionar árvores
for i = 1, 10 do
    local tree = Instance.new("Part")
    tree.Size = Vector3.new(2, 8, 2)
    tree.Position = Vector3.new(math.random(-80, 80), 4, math.random(-80, 80))
    tree.Anchored = true
    tree.Material = Enum.Material.Wood
    tree.BrickColor = BrickColor.new("Brown")
    tree.Parent = workspace
    
    local leaves = Instance.new("Part")
    leaves.Size = Vector3.new(6, 4, 6)
    leaves.Position = tree.Position + Vector3.new(0, 6, 0)
    leaves.Anchored = true
    leaves.Material = Enum.Material.Grass
    leaves.BrickColor = BrickColor.new("Dark green")
    leaves.Shape = Enum.PartType.Ball
    leaves.Parent = workspace
end

-- Criar aranha após 30 segundos
wait(30)

local spider = Instance.new("Model")
spider.Name = "Spider"
spider.Parent = workspace

local body = Instance.new("Part")
body.Size = Vector3.new(4, 2, 6)
body.Position = Vector3.new(100, 5, 100)
body.Anchored = false
body.Material = Enum.Material.SmoothPlastic
body.BrickColor = BrickColor.new("Really black")
body.Parent = spider

local head = Instance.new("Part")
head.Size = Vector3.new(3, 2, 3)
head.Position = body.Position + Vector3.new(0, 0, 4.5)
head.Anchored = false
head.Material = Enum.Material.SmoothPlastic
head.BrickColor = BrickColor.new("Really black")
head.Parent = spider

-- Olhos vermelhos
for i = 1, 2 do
    local eye = Instance.new("Part")
    eye.Size = Vector3.new(0.5, 0.5, 0.5)
    eye.Position = head.Position + Vector3.new(i * 0.8 - 0.4, 0.5, 1.5)
    eye.Anchored = false
    eye.Material = Enum.Material.Neon
    eye.BrickColor = BrickColor.new("Really red")
    eye.Shape = Enum.PartType.Ball
    eye.Parent = spider
    
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = eye
    weld.Parent = eye
end

-- Humanoid para movimento
local humanoid = Instance.new("Humanoid")
humanoid.Parent = spider

local rootPart = Instance.new("Part")
rootPart.Name = "HumanoidRootPart"
rootPart.Size = Vector3.new(2, 2, 2)
rootPart.Position = body.Position
rootPart.Anchored = false
rootPart.CanCollide = false
rootPart.Transparency = 1
rootPart.Parent = spider

local rootWeld = Instance.new("WeldConstraint")
rootWeld.Part0 = rootPart
rootWeld.Part1 = body
rootWeld.Parent = rootPart

humanoid.RootPart = rootPart

-- IA simples da aranha
spawn(function()
    while true do
        wait(0.1)
        local nearestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if distance < shortestDistance and distance < 100 then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
        
        if nearestPlayer and nearestPlayer.Character then
            local direction = (nearestPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Unit
            humanoid:Move(direction)
        end
    end
end)

print("✅ Spider Game criado com sucesso!")
print("🎮 Clique em PLAY para testar!")
print("🕷️ A aranha aparecerá após 30 segundos...") 