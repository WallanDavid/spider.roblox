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
        if spiderController then
            -- Aqui você chamaria o método de dano da aranha
            print("Aranha atingida!")
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