#!/bin/bash

# SAP - Simple AUR Packager
# Author: SanchitKumaRR
# Version: 0.5 Alpha (2026)

CACHE_DIR="$HOME/.cache/sap"
VERSION="0.5 Alpha (2026)"

# Colors
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Information Display
show_info() {
    echo -e "${YELLOW}SAP - Simple AUR Packager${NC}"
    echo -e "---------------------------"
    echo -e "• ${BOLD}Version:${NC} $VERSION"
    echo -e "• ${BOLD}Author:${NC} Sanchit Kumar"
    echo -e "• ${BOLD}User:${NC} SanchitKumaRR"
    echo -e "• ${BOLD}Status:${NC} Solo Project"
}

# Search using AUR RPC API (curl + jq recommended, but using grep for zero-deps)
search_aur() {
    echo -e "${BLUE}Searching AUR for: $1...${NC}"
    curl -s "https://aur.archlinux.org/rpc/v5/search/$1" | jq -r '.results[] | "\u001b[1;32maur/\u001b[1;37m\(.Name) \u001b[0;32m\(.Version)\u001b[0m\n    \(.Description)"'
}

# Main Logic
case "$1" in
    -S)
        pkg="$2"
        mkdir -p "$CACHE_DIR"
        cd "$CACHE_DIR" || exit
        
        echo -e "${BLUE}🚀 SAP Building: $pkg${NC}"
        if [ -d "$pkg" ]; then
            cd "$pkg" && git pull
        else
            git clone "https://aur.archlinux.org/$pkg.git" && cd "$pkg"
        fi
        
        makepkg -sic --noconfirm
        ;;
        
    -Ss)
        search_aur "$2"
        ;;
        
    -R)
        echo -e "${BLUE}🗑️ SAP Removing: $2${NC}"
        sudo pacman -Rns "$2"
        ;;
        
    -Sc)
        rm -rf "$CACHE_DIR"/*
        echo -e "${GREEN}🧹 Cache cleared.${NC}"
        ;;
        
    -i)
        show_info
        ;;
        
    *)
        echo "Usage: sap [-S install] [-Ss search] [-R remove] [-Sc clean] [-i info]"
        ;;
esac
