#!/bin/bash

# UT2004 GOG Editor's Choice Edition - Automated Installer
# Instalador Automatizado do UT2004 GOG Editor's Choice Edition
# Compatible with modern Linux systems / Compatível com sistemas Linux modernos

# Comentado temporariamente para debug - não sair no primeiro erro
# set -e

# Função para debug
debug_msg() {
    echo -e "\n[DEBUG] $1"
}

# Trap para capturar erros
trap 'echo -e "\n[ERRO NA LINHA $LINENO] Pressione ENTER para ver detalhes..."; read' ERR

# Detecção automática do idioma do sistema
# Automatic system language detection
if [[ "$LANG" =~ ^pt ]]; then
    LANG_MODE="pt"
else
    LANG_MODE="en"
fi

# Função para mensagens bilíngues
msg() {
    if [ "$LANG_MODE" = "pt" ]; then
        echo -e "\n[INFO] $1"
    else
        echo -e "\n[INFO] $2"
    fi
}

error_msg() {
    if [ "$LANG_MODE" = "pt" ]; then
        echo -e "\n[ERRO] $1"
    else
        echo -e "\n[ERROR] $2"
    fi
}

success_msg() {
    if [ "$LANG_MODE" = "pt" ]; then
        echo -e "\n[SUCESSO] $1"
    else
        echo -e "\n[SUCCESS] $2"
    fi
}

# Variáveis
GAME_URL="https://archive.org/download/unreal-tournament-2004-editors-choice-edition-gog-igg/Unreal.Tournament.2004.ece.GOG.rar"
PATCH_URL="https://unreal-archive-files.eu-central-1.linodeobjects.com/patches-updates/Unreal%20Tournament%202004/Patches/ut2004-lnxpatch3369-2.tar.bz2"
INSTALL_DIR="$HOME/Games/ut2004"
TEMP_DIR="/tmp/ut2004_install"
CDKEY="AJACQ-BKZMM-AE9GZ-F3V7B"

# Banner
clear
echo "=============================================="
if [ "$LANG_MODE" = "pt" ]; then
    echo "  Instalador UT2004 GOG Editor's Choice"
    echo "  Para sistemas Linux modernos"
else
    echo "  UT2004 GOG Editor's Choice Installer"
    echo "  For modern Linux systems"
fi
echo "=============================================="

# Verificar se está rodando como root
if [ "$EUID" -eq 0 ]; then 
    error_msg "Não execute este script como root!" "Do not run this script as root!"
    exit 1
fi

# Criar diretórios
msg "Criando diretórios necessários..." "Creating necessary directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Instalar dependências
msg "Instalando dependências do sistema..." "Installing system dependencies..."
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y wget p7zip-full p7zip-rar unrar innoextract libsdl1.2debian:i386 libopenal1:i386 libstdc++5:i386 imagemagick || {
    error_msg "Falha ao instalar dependências. Verifique sua conexão e repositórios." "Failed to install dependencies. Check your connection and repositories."
    exit 1
}

# Verificar se arquivos já existem
if [ -f "$TEMP_DIR/ut2004.rar" ] && [ -f "$TEMP_DIR/patch.tar.bz2" ]; then
    msg "Arquivos já existem em $TEMP_DIR, pulando download..." "Files already exist in $TEMP_DIR, skipping download..."
else
    # Baixar arquivo do jogo
    if [ ! -f "$TEMP_DIR/ut2004.rar" ]; then
        msg "Baixando Unreal Tournament 2004 (~2.5GB)..." "Downloading Unreal Tournament 2004 (~2.5GB)..."
        msg "Isso pode levar algum tempo..." "This may take a while..."
        wget -c "$GAME_URL" -O ut2004.rar || {
            error_msg "Falha ao baixar o jogo." "Failed to download the game."
            exit 1
        }
    fi

    # Baixar patch Linux
    if [ ! -f "$TEMP_DIR/patch.tar.bz2" ]; then
        msg "Baixando patch Linux 3369-2..." "Downloading Linux patch 3369-2..."
        wget -c "$PATCH_URL" -O patch.tar.bz2 || {
            error_msg "Falha ao baixar o patch." "Failed to download the patch."
            exit 1
        }
    fi
fi

# Descompactar arquivo RAR
msg "Descompactando arquivo do jogo..." "Extracting game archive..."
debug_msg "Extraindo RAR para: $TEMP_DIR/game_files"

# Verificar integridade do arquivo primeiro
debug_msg "Verificando arquivo RAR..."
if [ ! -f "ut2004.rar" ]; then
    error_msg "Arquivo ut2004.rar não encontrado em $TEMP_DIR" "File ut2004.rar not found in $TEMP_DIR"
    ls -lah "$TEMP_DIR/"
    echo "Pressione ENTER para continuar..."
    read
    exit 1
fi

FILE_SIZE=$(stat -c%s "ut2004.rar" 2>/dev/null || stat -f%z "ut2004.rar" 2>/dev/null)
debug_msg "Tamanho do arquivo: $FILE_SIZE bytes"

# Tentar com unrar primeiro (melhor para RAR)
if command -v unrar &> /dev/null; then
    msg "Usando unrar para extração..." "Using unrar for extraction..."
    unrar x -o+ ut2004.rar "$TEMP_DIR/game_files/" || {
        error_msg "Falha com unrar, tentando 7z..." "Failed with unrar, trying 7z..."
        
        # Fallback para 7z
        7z x ut2004.rar -o"$TEMP_DIR/game_files" -y || {
            error_msg "Falha ao descompactar o arquivo RAR." "Failed to extract RAR file."
            echo "Tentando método alternativo com p7zip-rar..."
            
            # Instalar p7zip-rar se necessário
            sudo apt install -y p7zip-rar
            7z x ut2004.rar -o"$TEMP_DIR/game_files" -y || {
                error_msg "Todas as tentativas de extração falharam." "All extraction attempts failed."
                echo "Pressione ENTER para continuar..."
                read
                exit 1
            }
        }
    }
else
    msg "unrar não encontrado, usando 7z..." "unrar not found, using 7z..."
    
    # Tentar com 7z
    7z x ut2004.rar -o"$TEMP_DIR/game_files" -y 2>&1 | tee 7z.log || {
        error_msg "Falha com 7z. Instalando unrar..." "Failed with 7z. Installing unrar..."
        
        # Instalar unrar
        sudo apt install -y unrar
        
        # Tentar novamente com unrar
        unrar x -o+ ut2004.rar "$TEMP_DIR/game_files/" || {
            error_msg "Todas as tentativas de extração falharam." "All extraction attempts failed."
            echo "Log do 7z:"
            cat 7z.log 2>/dev/null
            echo ""
            echo "O arquivo pode estar corrompido. Tente baixar novamente."
            echo "Pressione ENTER para continuar..."
            read
            exit 1
        }
    }
fi

debug_msg "Extração do RAR concluída. Listando arquivos..."
ls -lah "$TEMP_DIR/game_files" || true

# Encontrar o arquivo setup correto
msg "Localizando arquivo de instalação..." "Locating setup file..."
SETUP_FILE=$(find "$TEMP_DIR/game_files" -type f -iname "setup*.exe" 2>/dev/null | head -n 1)

if [ -z "$SETUP_FILE" ]; then
    error_msg "Arquivo setup não encontrado!" "Setup file not found!"
    echo "Conteúdo da pasta game_files:"
    ls -laR "$TEMP_DIR/game_files"
    echo "Pressione ENTER para continuar..."
    read
    exit 1
fi

msg "Encontrado: $(basename "$SETUP_FILE")" "Found: $(basename "$SETUP_FILE")"
debug_msg "Caminho completo: $SETUP_FILE"

# Extrair com innoextract
msg "Extraindo arquivos do instalador GOG..." "Extracting files from GOG installer..."
cd "$TEMP_DIR"

debug_msg "Testando innoextract com listagem primeiro..."
innoextract -l "$SETUP_FILE" || {
    error_msg "innoextract não consegue ler o arquivo." "innoextract cannot read the file."
    echo "Pressione ENTER para continuar..."
    read
    exit 1
}

debug_msg "Iniciando extração real com innoextract..."
innoextract -s -p -d "$TEMP_DIR/extracted" "$SETUP_FILE" 2>&1 | tee innoextract.log || {
    error_msg "Falha ao extrair com innoextract. Tentando método alternativo..." "Failed to extract with innoextract. Trying alternative method..."
    
    # Método alternativo sem verificação de integridade
    debug_msg "Tentando com flags alternativas..."
    innoextract -s -p -m -d "$TEMP_DIR/extracted" "$SETUP_FILE" 2>&1 | tee innoextract_alt.log || {
        error_msg "Falha crítica na extração." "Critical extraction failure."
        echo "Log da primeira tentativa:"
        cat innoextract.log 2>/dev/null || echo "Sem log"
        echo ""
        echo "Log da segunda tentativa:"
        cat innoextract_alt.log 2>/dev/null || echo "Sem log"
        echo ""
        echo "Pressione ENTER para sair..."
        read
        exit 1
    }
}

debug_msg "Extração do innoextract concluída. Listando estrutura..."
ls -lah "$TEMP_DIR/extracted" || true

# Mover arquivos para diretório de instalação
msg "Movendo arquivos para $INSTALL_DIR..." "Moving files to $INSTALL_DIR..."

# Verificar qual estrutura de pasta foi criada
debug_msg "Verificando estrutura de pastas..."
find "$TEMP_DIR/extracted" -maxdepth 2 -type d

if [ -d "$TEMP_DIR/extracted/app" ]; then
    debug_msg "Estrutura app/ encontrada"
    cp -rv "$TEMP_DIR/extracted/app/"* "$INSTALL_DIR/" || {
        error_msg "Falha ao copiar arquivos de app/." "Failed to copy files from app/."
        echo "Pressione ENTER para continuar..."
        read
        exit 1
    }
elif [ -d "$TEMP_DIR/extracted/tmp" ]; then
    debug_msg "Estrutura tmp/ encontrada"
    cp -rv "$TEMP_DIR/extracted/tmp/"* "$INSTALL_DIR/" || {
        error_msg "Falha ao copiar arquivos de tmp/." "Failed to copy files from tmp/."
        echo "Pressione ENTER para continuar..."
        read
        exit 1
    }
else
    # Listar e copiar tudo que encontrar
    msg "Estrutura diferente detectada, adaptando..." "Different structure detected, adapting..."
    debug_msg "Copiando todas as subpastas..."
    find "$TEMP_DIR/extracted" -mindepth 1 -maxdepth 1 -type d -exec cp -rv {} "$INSTALL_DIR/" \; || {
        error_msg "Falha ao copiar arquivos." "Failed to copy files."
        echo "Pressione ENTER para continuar..."
        read
        exit 1
    }
fi

debug_msg "Verificando se System/ foi criada..."
ls -lah "$INSTALL_DIR/" || true
ls -lah "$INSTALL_DIR/System" 2>/dev/null || echo "AVISO: Pasta System não encontrada ainda"

# Criar arquivo cdkey
msg "Criando arquivo de CD Key..." "Creating CD Key file..."
echo "$CDKEY" > "$INSTALL_DIR/System/cdkey"

# Extrair patch Linux
msg "Aplicando patch Linux..." "Applying Linux patch..."
tar -xjf patch.tar.bz2 -C "$TEMP_DIR/"

# Mesclar arquivos do patch
msg "Mesclando arquivos do patch..." "Merging patch files..."
cp -rf "$TEMP_DIR/UT2004-Patch/"* "$INSTALL_DIR/" 2>/dev/null || true

# Corrigir libSDL
msg "Corrigindo biblioteca libSDL-1.2.so.0..." "Fixing libSDL-1.2.so.0 library..."
if [ -f "/usr/lib/i386-linux-gnu/libSDL-1.2.so.0" ]; then
    cp /usr/lib/i386-linux-gnu/libSDL-1.2.so.0 "$INSTALL_DIR/System/"
elif [ -f "/usr/lib32/libSDL-1.2.so.0" ]; then
    cp /usr/lib32/libSDL-1.2.so.0 "$INSTALL_DIR/System/"
else
    error_msg "libSDL-1.2.so.0 não encontrada!" "libSDL-1.2.so.0 not found!"
fi

# Corrigir OpenAL
msg "Corrigindo biblioteca OpenAL..." "Fixing OpenAL library..."
OPENAL_FOUND=false

# Procurar libopenal.so.1 (versão genérica)
if [ -f "/usr/lib/i386-linux-gnu/libopenal.so.1" ]; then
    cp /usr/lib/i386-linux-gnu/libopenal.so.1 "$INSTALL_DIR/System/openal.so"
    debug_msg "OpenAL copiada de /usr/lib/i386-linux-gnu/libopenal.so.1"
    OPENAL_FOUND=true
elif [ -f "/usr/lib32/libopenal.so.1" ]; then
    cp /usr/lib32/libopenal.so.1 "$INSTALL_DIR/System/openal.so"
    debug_msg "OpenAL copiada de /usr/lib32/libopenal.so.1"
    OPENAL_FOUND=true
# Procurar versões específicas
elif [ -f "/usr/lib/i386-linux-gnu/libopenal.so.1.23.1" ]; then
    cp /usr/lib/i386-linux-gnu/libopenal.so.1.23.1 "$INSTALL_DIR/System/openal.so"
    debug_msg "OpenAL copiada de /usr/lib/i386-linux-gnu/libopenal.so.1.23.1"
    OPENAL_FOUND=true
elif [ -f "/usr/lib32/libopenal.so.1.23.1" ]; then
    cp /usr/lib32/libopenal.so.1.23.1 "$INSTALL_DIR/System/openal.so"
    debug_msg "OpenAL copiada de /usr/lib32/libopenal.so.1.23.1"
    OPENAL_FOUND=true
# Procurar qualquer libopenal
else
    OPENAL_PATH=$(find /usr/lib/i386-linux-gnu /usr/lib32 -name "libopenal.so*" 2>/dev/null | head -n 1)
    if [ -n "$OPENAL_PATH" ]; then
        cp "$OPENAL_PATH" "$INSTALL_DIR/System/openal.so"
        debug_msg "OpenAL copiada de $OPENAL_PATH"
        OPENAL_FOUND=true
    fi
fi

if [ "$OPENAL_FOUND" = false ]; then
    error_msg "OpenAL não encontrada! Instalando..." "OpenAL not found! Installing..."
    sudo apt install -y libopenal1:i386
    
    # Tentar novamente após instalação
    if [ -f "/usr/lib/i386-linux-gnu/libopenal.so.1" ]; then
        cp /usr/lib/i386-linux-gnu/libopenal.so.1 "$INSTALL_DIR/System/openal.so"
        debug_msg "OpenAL instalada e copiada"
    else
        error_msg "Falha ao configurar OpenAL!" "Failed to configure OpenAL!"
    fi
fi

# Verificar se os arquivos foram copiados corretamente
debug_msg "Verificando bibliotecas em System/..."
ls -lah "$INSTALL_DIR/System/" | grep -E "(libSDL|openal)" || echo "Aviso: Bibliotecas não encontradas"

# Criar script de inicialização
msg "Criando script de inicialização..." "Creating launcher script..."
cat > "$INSTALL_DIR/ut2004" << 'EOF'
#!/bin/sh
#
# Unreal Tournament 2004 startup script
#
# Function to find the real directory a program resides in.
# Feb. 17, 2000 - Sam Lantinga, Loki Entertainment Software
FindPath()
{
    fullpath=`echo $1 | grep /`
    if [ "$fullpath" = "" ]; then
        oIFS="$IFS"
        IFS=:
        for path in $PATH
        do if [ -x "$path/$1" ]; then
               if [ "$path" = "" ]; then
                   path="."
               fi
               fullpath="$path/$1"
               break
           fi
        done
        IFS="$oIFS"
    fi
    if [ "$fullpath" = "" ]; then
        fullpath="$1"
    fi
    # Is the sed/ls magic portable?
    if [ -L "$fullpath" ]; then
        #fullpath=`ls -l "$fullpath" | awk '{print $11}'`
        fullpath=`ls -l "$fullpath" |sed -e 's/.* -> //' |sed -e 's/\*//'`
    fi
    dirname $fullpath
}
# Set the home if not already set.
if [ "${UT2004_DATA_PATH}" = "" ]; then
    UT2004_DATA_PATH=`FindPath $0`/System
fi
LD_LIBRARY_PATH=.:${UT2004_DATA_PATH}:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH
# Let's boogie!
if [ -x "${UT2004_DATA_PATH}/ut2004-bin" ]
then
	cd "${UT2004_DATA_PATH}/"
	exec "./ut2004-bin" $*
fi
echo "Couldn't run Unreal Tournament 2004 (ut2004-bin). Is UT2004_DATA_PATH set?"
exit 1
# end of ut2004 ...
EOF

chmod +x "$INSTALL_DIR/ut2004"

# Converter e copiar ícone
msg "Convertendo e instalando ícone..." "Converting and installing icon..."
if [ -f "$INSTALL_DIR/Help/Unreal.ico" ]; then
    convert "$INSTALL_DIR/Help/Unreal.ico[0]" "$INSTALL_DIR/ut2004.png" 2>/dev/null || {
        msg "Aviso: Falha ao converter ícone." "Warning: Failed to convert icon."
    }
    
    # Copiar ícone para múltiplos locais
    mkdir -p "$HOME/.local/share/icons/hicolor/48x48/apps"
    mkdir -p "$HOME/.local/share/icons/hicolor/64x64/apps"
    mkdir -p "$HOME/.local/share/icons/hicolor/128x128/apps"
    
    if [ -f "$INSTALL_DIR/ut2004.png" ]; then
        convert "$INSTALL_DIR/ut2004.png" -resize 48x48 "$HOME/.local/share/icons/hicolor/48x48/apps/ut2004.png" 2>/dev/null
        convert "$INSTALL_DIR/ut2004.png" -resize 64x64 "$HOME/.local/share/icons/hicolor/64x64/apps/ut2004.png" 2>/dev/null
        convert "$INSTALL_DIR/ut2004.png" -resize 128x128 "$HOME/.local/share/icons/hicolor/128x128/apps/ut2004.png" 2>/dev/null
    fi
fi

# Criar atalho no menu
msg "Criando atalho no menu do sistema..." "Creating system menu shortcut..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/ut2004.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Unreal Tournament 2004
Comment=Unreal Tournament 2004 GOG Edition
Exec=$INSTALL_DIR/ut2004
Icon=ut2004
Terminal=false
Categories=Game;ActionGame;
EOF

chmod +x "$HOME/.local/share/applications/ut2004.desktop"

# Atualizar cache de ícones
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" 2>/dev/null || true

# Limpar arquivos temporários
msg "Limpando arquivos temporários..." "Cleaning up temporary files..."
cd "$HOME"
rm -rf "$TEMP_DIR"

# Mensagem final
success_msg "=============================================" "============================================="
if [ "$LANG_MODE" = "pt" ]; then
    echo "  INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
    echo ""
    echo "  Jogo instalado em: $INSTALL_DIR"
    echo ""
    echo "  Para jogar:"
    echo "  - Procure 'Unreal Tournament 2004' no menu"
    echo "  - Ou execute: $INSTALL_DIR/ut2004"
    echo ""
    echo "  Divirta-se!"
else
    echo "  INSTALLATION COMPLETED SUCCESSFULLY!"
    echo ""
    echo "  Game installed at: $INSTALL_DIR"
    echo ""
    echo "  To play:"
    echo "  - Search for 'Unreal Tournament 2004' in menu"
    echo "  - Or run: $INSTALL_DIR/ut2004"
    echo ""
    echo "  Have fun!"
fi
success_msg "=============================================" "============================================="
