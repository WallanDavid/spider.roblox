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