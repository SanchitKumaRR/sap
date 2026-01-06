#!/bin/bash

# SAP - Simple AUR Packager
# Author: Sanchit Kumar (SanchitKumaRR)
# Version: 0.6 Alpha (2026)

CACHE_DIR="$HOME/.cache/sap"

# Colors
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' 

case "$1" in
    -S)
        pkg="$2"
        [ -z "$pkg" ] && echo "Specify a package" && exit 1
        
        # 1. Check Official Repos
        if pacman -Si "$pkg" > /dev/null 2>&1; then
            echo -e "${YELLOW}📦 $pkg found in official repos. Using pacman...${NC}"
            sudo pacman -S "$pkg"
        else
            # 2. Check AUR
            echo -e "${BLUE}🔍 Checking AUR for $pkg...${NC}"
            if curl -s "https://aur.archlinux.org/rpc/v5/info/$pkg" | grep -q '"resultcount":0'; then
                echo -e "${RED}Package Not Found: AUR doesn't have $pkg${NC} 😞"
                exit 1
            fi

            # 3. Build AUR Package
            mkdir -p "$CACHE_DIR"
            cd "$CACHE_DIR" || exit
            if [ -d "$pkg" ]; then
                echo -e "${BLUE}🔄 Updating $pkg...${NC}"
                cd "$pkg" && git pull
            else
                git clone "https://aur.archlinux.org/$pkg.git" && cd "$pkg"
            fi
            makepkg -sic --noconfirm
        fi
        ;;

    -Ss)
        echo -e "${BLUE}🔎 Searching AUR for: $2...${NC}"
        # Pure Bash search using the AUR API and grep
        curl -s "https://aur.archlinux.org/rpc/v5/search/$2" | sed 's/},{/\n/g' | grep -Po '(?<="Name":")[^"]*|(?<="Description":")[^"]*' | sed 'N;s/\n/ - /'
        ;;

    -R)
        sudo pacman -Rns "$2"
        ;;

    -Sc)
        rm -rf "$CACHE_DIR"/*
        echo -e "${GREEN}🧹 Cache cleared.${NC}"
        ;;

    -i)
        echo -e "${YELLOW}SAP - Simple AUR Packager${NC}"
        echo -e "---------------------------"
        echo -e "• Version: 0.6 Alpha (2026)"
        echo -e "• Solo Project by Sanchit Kumar 😎"
        ;;

    *)
        echo "Usage: sap [-S install] [-Ss search] [-R remove] [-Sc clean] [-i info]"
        ;;
esac
