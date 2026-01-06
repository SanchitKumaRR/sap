#!/bin/bash

# SAP - Simple AUR Packager
# Author: Sanchit Kumar (SanchitKumaRR)
# Version: 0.5 Alpha (2026)

CACHE_DIR="$HOME/.cache/sap"

# Colors
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
WHITE='\033[1;37m'
NC='\033[0m' 

case "$1" in
    install|-S)
        pkg="$2"
        [ -z "$pkg" ] && echo -e "${RED}Error: Specify a package name.${NC}" && exit 1
        
        mkdir -p "$CACHE_DIR"
        cd "$CACHE_DIR" || exit
        
        if [ -d "$pkg" ]; then
            echo -e "${BLUE}🔄 Updating $pkg...${NC}"
            cd "$pkg" && git pull
        else
            echo -e "${BLUE}🚀 Cloning $pkg...${NC}"
            # Check if clone works, if not, show your custom error
            if ! git clone "https://aur.archlinux.org/$pkg.git"; then
                echo -e "${RED}Package Not Found: AUR doesn't have $pkg${NC}"
                exit 1
            fi
            cd "$pkg"
        fi
        makepkg -sic --noconfirm
        ;;

    remove|-R)
        [ -z "$2" ] && echo -e "${RED}Error: Specify a package to remove.${NC}" && exit 1
        sudo pacman -Rns "$2"
        ;;

    search|-Ss)
        [ -z "$2" ] && echo -e "${RED}Error: Enter a search term.${NC}" && exit 1
        echo -e "${BLUE}🔎 Searching AUR for: $2...${NC}"
        curl -s "https://aur.archlinux.org/rpc/v5/search/$2" | \
        sed 's/},{/\n/g' | \
        grep -Po '(?<="Name":")[^"]*|(?<="Description":")[^"]*' | \
        sed "N;s/\(.*\)\n\(.*\)/${GREEN}aur\/${WHITE}\1${NC}\n    \2/"
        ;;

    clean|-Sc)
        rm -rf "$CACHE_DIR"/*
        echo -e "${GREEN}🧹 Cache cleared.${NC}"
        ;;

    info|-i)
        echo -e "${YELLOW}SAP - Simple AUR Packager${NC}"
        echo -e "---------------------------"
        echo -e "• Version: 0.5 Alpha (2026)"
        echo -e "• Solo Project by Sanchit Kumar"
        echo -e "• User: SanchitKumaRR"
        echo -e "• Status: Solo Project"
        ;;

    *)
        echo -e "${WHITE}Usage:${NC}"
        echo "  sap install OR -S  <pkg>"
        echo "  sap remove  OR -R  <pkg>"
        echo "  sap search  OR -Ss <pkg>"
        echo "  sap clean   OR -Sc"
        echo "  sap info    OR -i"
        ;;
esac
