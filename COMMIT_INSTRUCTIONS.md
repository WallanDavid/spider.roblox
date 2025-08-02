# 📝 Instruções para Commit no GitHub

## 🚀 Como Atualizar o Repositório

### 1. Preparar os Arquivos

Certifique-se de que todos os arquivos estão prontos:

```
spider.roblox/
├── 📄 README.md                 ✅ Atualizado
├── 📄 CHANGELOG.md              ✅ Novo arquivo
├── 📄 spider_game_final.lua     ✅ Versão corrigida
├── 📄 spider_game_simples.lua   ✅ Versão simples
├── 📄 setup_spider_game.lua     ✅ Script de setup
├── 📄 gerar_rbxl_simples.lua    ✅ Gerador de .rbxl
├── 📄 COMO_USAR.md              ✅ Instruções
├── 📄 DEMONSTRACAO.md           ✅ Guia de demonstração
├── 📄 INSTALACAO_RAPIDA.md      ✅ Instruções de instalação
├── 📁 Scripts/                  ✅ Scripts modulares
└── 📄 .gitignore               ✅ Configuração Git
```

### 2. Comandos Git

Execute os seguintes comandos no terminal:

```bash
# Navegar para o diretório do projeto
cd spider.roblox

# Verificar status dos arquivos
git status

# Adicionar todos os arquivos modificados
git add .

# Fazer commit com mensagem descritiva
git commit -m "🎯 v2.0.0 - Versão Corrigida: Sistema de Armas e IA Melhorada

✅ Adicionado:
- Sistema de armas completo (Pistola, Rifle, Shotgun)
- Inventário de armas com interface visual
- Barras de vida das aranhas em tempo real
- Sistema de power-ups (5 tipos)
- Projéteis visuais coloridos
- Contador de aranhas na interface

🔧 Corrigido:
- IA das aranhas perseguem corretamente
- Sistema de troca de armas (teclas 1,2,3)
- Barras de vida visíveis e funcionais
- Iluminação de tarde para melhor visibilidade

⚡ Melhorado:
- Gameplay mais dinâmico e balanceado
- Interface mais informativa
- Performance otimizada

📚 Documentação:
- README.md atualizado com novas funcionalidades
- CHANGELOG.md com histórico completo
- Instruções de uso melhoradas"

# Enviar para o GitHub
git push origin main
```

### 3. Verificar no GitHub

Após o push, verifique no [repositório](https://github.com/WallanDavid/spider.roblox):

1. ✅ README.md atualizado
2. ✅ CHANGELOG.md adicionado
3. ✅ spider_game_final.lua (versão corrigida)
4. ✅ Todos os arquivos sincronizados

### 4. Criar Release (Opcional)

Para criar uma release oficial:

1. Vá para **Releases** no GitHub
2. Clique em **"Create a new release"**
3. Tag: `v2.0.0`
4. Title: `🎯 Versão Corrigida - Sistema de Armas e IA Melhorada`
5. Description: Copie o conteúdo do CHANGELOG.md
6. Publique a release

## 📋 Checklist de Verificação

- [ ] Todos os arquivos estão no diretório correto
- [ ] README.md foi atualizado com novas funcionalidades
- [ ] CHANGELOG.md foi criado
- [ ] spider_game_final.lua está funcionando
- [ ] Commit message é descritiva
- [ ] Push foi realizado com sucesso
- [ ] Repositório está atualizado no GitHub

## 🎯 Principais Melhorias da v2.0.0

### Sistema de Armas
- **Pistola (1)**: Dano 25, Alcance 20, Cooldown 0.6s
- **Rifle (2)**: Dano 40, Alcance 30, Cooldown 1.0s  
- **Shotgun (3)**: Dano 60, Alcance 10, Cooldown 1.5s

### IA das Aranhas
- Perseguição ativa dos jogadores
- Movimento real usando `humanoid:Move()`
- Barras de vida visíveis e funcionais
- Ataques automáticos quando próximas

### Interface Melhorada
- Inventário de armas visual
- Contador de aranhas em tempo real
- Instruções dinâmicas
- Efeitos visuais aprimorados

### Power-ups
- SpeedBoost, HealthPack, DamageBoost
- Shield, WeaponCrate
- Efeitos visuais de coleta

---

**🎉 Pronto para enviar para o cliente Marcelo R.!** 