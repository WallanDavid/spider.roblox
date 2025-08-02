# 🕷️ Spider Game Demo - Roblox

Roblox Luau GitHub

## 📖 Descrição

Demonstração completa do jogo Spider para Roblox, criada como teste técnico para o cliente Marcelo R. Este projeto demonstra habilidades avançadas em desenvolvimento de jogos para a plataforma Roblox usando Luau.

**🎯 VERSÃO CORRIGIDA - Sistema de Armas e IA Melhorada**

## ✨ Características

* 🏝️ **Ilha atmosférica** com vegetação e iluminação de tarde
* 🏠 **Casa abandonada** detalhada com porta, janelas e telhado
* 🕷️ **Sistema de IA avançado** - aranhas perseguem ativamente o jogador
* 🔫 **Sistema de armas completo** - Pistola, Rifle e Shotgun
* 📦 **Inventário de armas** com interface visual
* ⏰ **Chegada dramática** das aranhas após 10 segundos
* 🎮 **Interface completa** com barra de saúde e contador de aranhas
* ⚔️ **Sistema de combate** com projéteis visuais
* ❤️ **Barras de vida** das aranhas em tempo real
* ⚡ **Sistema de power-ups** - Speed, Health, Damage, Shield
* 🎨 **Efeitos visuais** e atmosfera imersiva
* 🚀 **Performance otimizada** para diferentes dispositivos

## 🚀 Instalação Rápida

### Pré-requisitos

* Roblox Studio instalado

### Passos

1. Clone este repositório:

```bash
git clone https://github.com/WallanDavid/spider.roblox.git
```

2. Abra o Roblox Studio e crie um novo lugar (Baseplate)
3. No ServerScriptService, crie um novo Script
4. Cole o conteúdo do arquivo `spider_game_final.lua`
5. Clique em **Play** para testar!

## 🎮 Como Jogar

### Controles
* **WASD** - Mover o personagem
* **1** - Selecionar Pistola (Dano: 25, Alcance: 20)
* **2** - Selecionar Rifle (Dano: 40, Alcance: 30)
* **3** - Selecionar Shotgun (Dano: 60, Alcance: 10)
* **Clique** - Atirar na direção do mouse

### Objetivo
1. **Explore a ilha** - Use WASD para mover
2. **Visite a casa** - Casa abandonada no centro da ilha
3. **Aguarde as aranhas** - Aparecerão após 10 segundos
4. **Troque armas** - Use 1, 2, 3 para selecionar
5. **Atire nas aranhas** - Clique para atacar
6. **Colete power-ups** - Para vantagens temporárias
7. **Sobreviva** - Derrote todas as aranhas para vencer

## 🔫 Sistema de Armas

| Arma | Tecla | Dano | Alcance | Cooldown | Cor |
|------|-------|------|---------|----------|-----|
| Pistola | 1 | 25 | 20 | 0.6s | Azul |
| Rifle | 2 | 40 | 30 | 1.0s | Vermelho |
| Shotgun | 3 | 60 | 10 | 1.5s | Amarelo |

## ⚡ Power-ups

* **SpeedBoost** (Azul) - Aumenta velocidade por 10 segundos
* **HealthPack** (Verde) - Restaura 25 de saúde
* **DamageBoost** (Vermelho) - Aumenta dano das armas por 15 segundos
* **Shield** (Amarelo) - Escudo protetor temporário
* **WeaponCrate** (Violeta) - Arma especial

## 📁 Estrutura do Projeto

```
spider.roblox/
├── 📄 README.md                 # Documentação principal
├── 📄 DEMONSTRACAO.md           # Guia detalhado da demonstração
├── 📄 INSTALACAO_RAPIDA.md      # Instruções de instalação
├── 📄 spider_game_final.lua     # Script principal corrigido
├── 📄 spider_game_simples.lua   # Versão simplificada
├── 📄 setup_spider_game.lua     # Script de configuração automática
├── 📄 gerar_rbxl_simples.lua    # Gerador de arquivo .rbxl
├── 📄 COMO_USAR.md              # Instruções de uso
├── 📁 Scripts/                  # Scripts modulares (versão anterior)
│   ├── 🚀 init.lua              # Script de inicialização
│   ├── 🎮 GameManager.lua       # Sistema principal do jogo
│   ├── 🕷️ SpiderController.lua  # IA da aranha
│   ├── 👤 PlayerController.lua  # Controles do jogador
│   └── ⚙️ Config.lua            # Configurações personalizáveis
└── 📄 .gitignore               # Arquivos ignorados pelo Git
```

## 🔧 Personalização

Edite as variáveis no início do `spider_game_final.lua` para ajustar:

```lua
local SPIDER_SPEED = 12          -- Velocidade da aranha
local SPIDER_HEALTH = 100        -- Saúde da aranha
local PLAYER_HEALTH = 100        -- Saúde do jogador
local SPIDER_ARRIVAL_TIME = 10   -- Tempo para aranhas chegarem
local MAX_SPIDERS = 2            -- Número de aranhas
local POWERUP_SPAWN_TIME = 8     -- Frequência de power-ups
```

## 🆕 Novidades da Versão Corrigida

### ✅ Correções Implementadas
- **Aranhas perseguem corretamente** - IA melhorada com movimento real
- **Sistema de armas funcional** - Troca com teclas 1, 2, 3
- **Barras de vida das aranhas** - Visíveis e atualizadas em tempo real
- **Iluminação de tarde** - Cenário mais claro e visível
- **Projéteis visuais** - Efeitos coloridos para cada arma
- **Interface melhorada** - Contador de aranhas e inventário

### 🎯 Melhorias de Gameplay
- **Combate mais dinâmico** - Múltiplas armas com características únicas
- **Power-ups estratégicos** - Vantagens temporárias para sobrevivência
- **Feedback visual** - Efeitos de dano e coleta
- **Balanceamento** - Dano e cooldowns equilibrados

## 📊 Tecnologias Utilizadas

* **Luau** - Linguagem de programação moderna do Roblox
* **Roblox Studio** - IDE oficial para desenvolvimento
* **Git** - Controle de versão
* **GitHub** - Hospedagem do código

## 👨‍💻 Desenvolvido por

**Wallan Peixoto** - Freelancer especializado em Roblox

* 🎮 Experiência em desenvolvimento de jogos
* 🕷️ Especialista em sistemas de IA
* 🎨 Foco em experiência do usuário
* 🚀 Código limpo e otimizado

## 📄 Licença

Este projeto foi criado como demonstração técnica. Todos os direitos reservados.

## 🤝 Contribuição

Este é um projeto de demonstração. Para dúvidas ou suporte, entre em contato.

---

⭐ **Se este projeto te ajudou, considere dar uma estrela no repositório!**

## 🎯 Status do Projeto

- ✅ **Versão Básica** - Funcional
- ✅ **Versão Dinâmica** - Com power-ups e múltiplas aranhas
- ✅ **Versão com Armas** - Sistema de combate completo
- ✅ **Versão Corrigida** - IA, armas e interface funcionais 