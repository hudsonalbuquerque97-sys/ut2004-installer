# UT2004 GOG Linux Installer / Instalador UT2004 GOG para Linux

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/Shell_Script-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

**[English](#english)** | **[Português](#português)**

---

## English

### 📖 Description

Automated installation script for **Unreal Tournament 2004 GOG Editor's Choice Edition** on modern Linux systems. This script handles everything from downloading the game to creating desktop shortcuts, with automatic language detection.

### ✨ Features

- 🌍 **Bilingual** - Automatic language detection (Portuguese/English)
- 🤖 **Fully automated** - No manual intervention required
- 📦 **Complete installation** - Downloads game, patch, and dependencies
- 🔧 **Library fixes** - Automatically resolves libSDL and OpenAL issues
- 🎮 **Ready to play** - Creates launcher script and desktop shortcut
- 🖼️ **Icon conversion** - Converts and installs game icon in multiple resolutions

### 📋 Requirements

- Modern Linux distribution (Ubuntu 20.04+, Debian 10+, or derivatives)
- ~3GB free disk space for temporary files
- ~6GB free disk space for installation
- Internet connection for downloads
- sudo privileges for installing dependencies

### 🚀 Installation

1. **Download the script:**
```bash
git clone https://github.com/hudsonalbuquerque97-sys/ut2004-installer.git
cd ut2004-installer
```

2. **Make it executable:**
```bash
chmod +x ut2004_installer_online_linux.sh
```

3. **Run the installer:**
```bash
./ut2004_installer_online_linux.sh
```

The script will:
- Detect your system language
- Install all required dependencies
- Download UT2004 GOG Edition (~2.5GB)
- Download Linux patch 3369-2
- Extract and install the game
- Apply the Linux patch
- Fix library issues
- Create launcher script
- Install desktop shortcut with icon

### 🎮 How to Play

After installation, you can launch the game by:

- **From the menu:** Search for "Unreal Tournament 2004"
- **From terminal:** `~/Games/ut2004/ut2004`
- **Desktop shortcut:** Click the UT2004 icon in your applications menu

### 📁 Installation Directory

The game is installed at: `~/Games/ut2004`

### 🔑 CD Key

The script automatically creates a CD key file with a valid key for offline play.

### 🛠️ What the Script Does

1. Detects system language (Portuguese or English)
2. Adds 32-bit architecture support (`i386`)
3. Installs dependencies:
   - `wget` - For downloading files
   - `p7zip-full`, `p7zip-rar` - For extracting RAR archives
   - `innoextract` - For extracting GOG installer
   - `libsdl1.2debian:i386` - SDL library (32-bit)
   - `libopenal1:i386` - OpenAL library (32-bit)
   - `libstdc++5:i386` - Standard C++ library (32-bit)
   - `imagemagick` - For icon conversion
4. Downloads game from Archive.org
5. Downloads official Linux patch
6. Extracts game files with innoextract
7. Applies Linux patch (merges folders and replaces files)
8. Fixes libSDL-1.2.so.0 library
9. Creates launcher script
10. Converts and installs icon in multiple sizes
11. Creates desktop shortcut (.desktop file)
12. Cleans up temporary files

### 🐛 Troubleshooting

**Problem:** Script fails to download files
- **Solution:** Check your internet connection and try again

**Problem:** Permission denied errors
- **Solution:** Don't run the script as root, but ensure you have sudo privileges

**Problem:** Missing dependencies
- **Solution:** The script will attempt to install them automatically

**Problem:** Game doesn't start
- **Solution:** Try running from terminal: `~/Games/ut2004/ut2004` to see error messages

### 📝 Notes

- The game files are downloaded from Archive.org (legal backup)
- Linux patch is downloaded from official Unreal Archive
- This script is for educational and preservation purposes
- Please support the developers by purchasing games legally

### 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### ⚠️ Disclaimer

This script is provided "as is" without warranty. The authors are not responsible for any damage caused by the use of this script. Unreal Tournament 2004 is property of Epic Games.

---

## Português

### 📖 Descrição

Script de instalação automatizada do **Unreal Tournament 2004 GOG Editor's Choice Edition** em sistemas Linux modernos. Este script cuida de tudo, desde o download do jogo até a criação de atalhos, com detecção automática de idioma.

### ✨ Funcionalidades

- 🌍 **Bilíngue** - Detecção automática de idioma (Português/Inglês)
- 🤖 **Totalmente automatizado** - Nenhuma intervenção manual necessária
- 📦 **Instalação completa** - Baixa jogo, patch e dependências
- 🔧 **Correção de bibliotecas** - Resolve automaticamente problemas com libSDL e OpenAL
- 🎮 **Pronto para jogar** - Cria script de inicialização e atalho
- 🖼️ **Conversão de ícone** - Converte e instala ícone em múltiplas resoluções

### 📋 Requisitos

- Distribuição Linux moderna (Ubuntu 20.04+, Debian 10+ ou derivados)
- ~3GB de espaço livre para arquivos temporários
- ~6GB de espaço livre para instalação
- Conexão com internet para downloads
- Privilégios sudo para instalar dependências

### 🚀 Instalação

1. **Baixe o script:**
```bash
git clone https://github.com/hudsonalbuquerque97-sys/ut2004-installer.git
cd ut2004-installer
```

2. **Torne-o executável:**
```bash
chmod +x ut2004_installer_online_linux.sh
```

3. **Execute o instalador:**
```bash
./ut2004_installer_online_linux.sh
```

O script irá:
- Detectar o idioma do seu sistema
- Instalar todas as dependências necessárias
- Baixar UT2004 GOG Edition (~2.5GB)
- Baixar patch Linux 3369-2
- Extrair e instalar o jogo
- Aplicar o patch Linux
- Corrigir problemas de bibliotecas
- Criar script de inicialização
- Instalar atalho com ícone

### 🎮 Como Jogar

Após a instalação, você pode iniciar o jogo por:

- **Pelo menu:** Procure por "Unreal Tournament 2004"
- **Pelo terminal:** `~/Games/ut2004/ut2004`
- **Atalho:** Clique no ícone do UT2004 no menu de aplicativos

### 📁 Diretório de Instalação

O jogo é instalado em: `~/Games/ut2004`

### 🔑 Chave do CD

O script cria automaticamente um arquivo de chave de CD com uma chave válida para jogo offline.

### 🛠️ O que o Script Faz

1. Detecta o idioma do sistema (Português ou Inglês)
2. Adiciona suporte para arquitetura 32-bit (`i386`)
3. Instala dependências:
   - `wget` - Para baixar arquivos
   - `p7zip-full`, `p7zip-rar` - Para extrair arquivos RAR
   - `innoextract` - Para extrair instalador GOG
   - `libsdl1.2debian:i386` - Biblioteca SDL (32-bit)
   - `libopenal1:i386` - Biblioteca OpenAL (32-bit)
   - `libstdc++5:i386` - Biblioteca C++ padrão (32-bit)
   - `imagemagick` - Para conversão de ícone
4. Baixa o jogo do Archive.org
5. Baixa patch oficial Linux
6. Extrai arquivos do jogo com innoextract
7. Aplica patch Linux (mescla pastas e substitui arquivos)
8. Corrige biblioteca libSDL-1.2.so.0
9. Cria script de inicialização
10. Converte e instala ícone em múltiplos tamanhos
11. Cria atalho no menu (.desktop file)
12. Limpa arquivos temporários

### 🐛 Solução de Problemas

**Problema:** Script falha ao baixar arquivos
- **Solução:** Verifique sua conexão com internet e tente novamente

**Problema:** Erros de permissão negada
- **Solução:** Não execute o script como root, mas certifique-se de ter privilégios sudo

**Problema:** Dependências faltando
- **Solução:** O script tentará instalá-las automaticamente

**Problema:** Jogo não inicia
- **Solução:** Tente executar pelo terminal: `~/Games/ut2004/ut2004` para ver mensagens de erro

### 📝 Notas

- Os arquivos do jogo são baixados do Archive.org (backup legal)
- Patch Linux é baixado do Unreal Archive oficial
- Este script é para fins educacionais e de preservação
- Por favor, apoie os desenvolvedores comprando jogos legalmente

### 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se livre para enviar um Pull Request.

### 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

### ⚠️ Aviso Legal

Este script é fornecido "como está" sem garantias. Os autores não são responsáveis por quaisquer danos causados pelo uso deste script. Unreal Tournament 2004 é propriedade da Epic Games.

---

### 🙏 Credits / Créditos

- Epic Games - Unreal Tournament 2004
- GOG.com - DRM-free game distribution
- Archive.org - Game preservation
- Unreal Archive - Linux patches
- Community contributors

### 📞 Support / Suporte

For issues and questions / Para problemas e questões:
- Open an issue on GitHub
- Abra uma issue no GitHub

---

**Made with ❤️ for the UT2004 community**
