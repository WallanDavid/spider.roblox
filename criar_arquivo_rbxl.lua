-- criar_arquivo_rbxl.lua
-- Script para criar um arquivo .rbxl válido do Spider Game

print("🕷️ Criando arquivo .rbxl do Spider Game...")

-- Primeiro, executar a configuração do jogo
-- (Cole aqui todo o conteúdo do setup_spider_game.lua)

-- Depois de configurar, salvar o lugar
local function salvarLugar()
    local success, result = pcall(function()
        -- Salvar o lugar atual
        game:Save("spider_game_demo.rbxl")
        print("✅ Arquivo spider_game_demo.rbxl criado com sucesso!")
        print("📁 Local: " .. game:GetService("RunService"):IsStudio() and "Workspace" or "Server")
    end)
    
    if not success then
        print("❌ Erro ao salvar: " .. tostring(result))
        print("💡 Dica: Use File → Save As no Roblox Studio")
    end
end

-- Aguardar um momento para a configuração terminar
wait(5)
salvarLugar()

print("\n📋 INSTRUÇÕES:")
print("1. Execute o setup_spider_game.lua primeiro")
print("2. Depois execute este script")
print("3. Ou use File → Save As no Roblox Studio")
print("4. Salve como 'spider_game_demo.rbxl'") 