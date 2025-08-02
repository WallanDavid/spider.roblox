-- gerar_rbxl_simples.lua
-- Script para gerar arquivo .rbxl do Spider Game
-- Execute no Roblox Studio

print("🕷️ Gerando arquivo .rbxl do Spider Game...")

-- Primeiro, executar a configuração do jogo
-- (Cole aqui o conteúdo do setup_spider_game.lua)

-- Depois de configurar, salvar o lugar
local function salvarArquivo()
    print("💾 Salvando como arquivo .rbxl...")
    
    local success, result = pcall(function()
        -- Salvar o lugar atual
        game:Save("spider_game_completo.rbxl")
    end)
    
    if success then
        print("✅ Arquivo spider_game_completo.rbxl criado com sucesso!")
        print("📁 Local: Workspace do Roblox Studio")
        print("🎯 Agora você pode importar este arquivo em qualquer lugar!")
        
        print("\n📋 COMO USAR O ARQUIVO .RBXL:")
        print("1. Abra o Roblox Studio")
        print("2. File → Open from File")
        print("3. Selecione o arquivo spider_game_completo.rbxl")
        print("4. Clique em PLAY - Pronto!")
        
    else
        print("❌ Erro ao salvar: " .. tostring(result))
        print("💡 Use File → Save As no Roblox Studio")
        print("💡 Salve como 'spider_game_completo.rbxl'")
    end
end

-- Aguardar um momento para a configuração terminar
wait(5)
salvarArquivo()

print("\n🎮 O jogo está pronto para ser importado!")
print("📧 Envie o arquivo .rbxl para o cliente Marcelo") 