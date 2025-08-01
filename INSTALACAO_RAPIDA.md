# 🚀 Instalação Rápida - Spider Game Demo

## Passos para testar a demonstração:

### 1. Abrir Roblox Studio
- Baixe e instale o Roblox Studio
- Abra o programa

### 2. Criar novo lugar
- Clique em "New Place"
- Escolha "Baseplate" como template

### 3. Configurar scripts (5 minutos)

#### Passo 1: Script principal
- No Explorer, clique em "ServerScriptService"
- Clique com botão direito → "Insert Object" → "Script"
- Renomeie para "init"
- Cole o conteúdo do arquivo `Scripts/init.lua`

#### Passo 2: Pasta de scripts
- Em ServerScriptService, clique com botão direito → "Insert Object" → "Folder"
- Renomeie para "Scripts"

#### Passo 3: Scripts individuais
- Dentro da pasta "Scripts", crie 4 scripts:
  - `GameManager` → Cole conteúdo de `Scripts/GameManager.lua`
  - `SpiderController` → Cole conteúdo de `Scripts/SpiderController.lua`
  - `PlayerController` → Cole conteúdo de `Scripts/PlayerController.lua`
  - `Config` → Cole conteúdo de `Scripts/Config.lua`

### 4. Testar o jogo
- Clique no botão "Play" (▶️)
- O jogo criará automaticamente:
  - ✅ Ilha com vegetação
  - ✅ Casa abandonada
  - ✅ Interface do jogador
  - ✅ Aranha após 30 segundos

## 🎮 Como jogar:

1. **Explore a ilha** - Use WASD para mover
2. **Visite a casa** - Casa abandonada no centro
3. **Aguarde a aranha** - Aparecerá após 30 segundos
4. **Fuja ou lute** - Clique para atacar a aranha
5. **Sobreviva** - Mantenha sua saúde acima de zero

## 🔧 Personalização rápida:

Edite o arquivo `Config.lua` para ajustar:
```lua
GAME = {
    SPIDER_ARRIVAL_TIME = 10, -- Aranha chega em 10 segundos
}
```

## 📞 Suporte:

Se tiver problemas:
1. Verifique se todos os scripts estão nas pastas corretas
2. Certifique-se de que os nomes dos scripts estão exatos
3. Reinicie o Roblox Studio se necessário

## ✅ Checklist de instalação:

- [ ] Roblox Studio instalado
- [ ] Novo lugar criado
- [ ] Script "init" criado e configurado
- [ ] Pasta "Scripts" criada
- [ ] 4 scripts adicionados na pasta
- [ ] Jogo testado e funcionando

---

**Tempo estimado de instalação: 5-10 minutos**

**Resultado: Demonstração completa do jogo Spider funcionando!** 