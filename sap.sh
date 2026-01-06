#!/bin/bash

# SAP - Simple AUR Packager
# Author: Sanchit Kumar (SanchitKumaRR)
# Version: 1.0 (Stable)

CACHE_DIR="$HOME/.cache/sap"

# Colors for a professional UI
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
WHITE='\033[1;37m'
NC='\033[0m' 

# ---------------------------------------------------------
# Helper Functions
# ---------------------------------------------------------

error_exit() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# ---------------------------------------------------------
# Main Logic
# ---------------------------------------------------------

case "$1" in
    install|-S)
        pkg="$2"
        [ -z "$pkg" ] && error_exit "Specify a package name."
        
        # Check Official Repos first
        if pacman -Si "$pkg" > /dev/null 2>&1; then
            echo -e "${YELLOW}📦 $pkg found in official repos. Using pacman...${NC}"
            sudo pacman -S "$pkg"
        else
            # Build AUR Package
            mkdir -p "$CACHE_DIR"
            cd "$CACHE_DIR" || exit
            
            if [ -d "$pkg" ]; then
                echo -e "${BLUE}🔄 Updating $pkg...${NC}"
                cd "$pkg" && git pull
            else
                echo -e "${BLUE}🚀 Cloning $pkg from AUR...${NC}"
                if ! git clone "https://aur.archlinux.org/$pkg.git"; then
                    error_exit "Package Not Found: AUR doesn't have $pkg"
                fi
                cd "$pkg"
            fi
            makepkg -sic --noconfirm
        fi
        ;;

    remove|-R)
        [ -z "$2" ] && error_exit "Specify a package to remove."
        sudo pacman -Rns "$2"
        ;;

    search|-Ss)
        [ -z "$2" ] && error_exit "Enter a search term."
        echo -e "${BLUE}🔎 Searching AUR for: $2...${NC}"
        curl -s "https://aur.archlinux.org/rpc/v5/search/$2" | \
        sed 's/},{/\n/g' | \
        grep -Po '(?<="Name":")[^"]*|(?<="Description":")[^"]*' | \
        sed "N;s/\(.*\)\n\(.*\)/${GREEN}aur\/${WHITE}\1${NC}\n    \2/"
        ;;

    list|-Qs)
        echo -e "${BLUE}📦 Installed AUR Packages:${NC}"
        pacman -Qm
        ;;

    clean|-Sc)
        rm -rf "$CACHE_DIR"/*
        echo -e "${GREEN}🧹 Cache cleared.${NC}"
        ;;

    doctor)
        echo -e "${BLUE}🩺 Checking system health...${NC}"
        for tool in git makepkg curl sudo; do
            if command -v $tool >/dev/null; then
                echo -e "${GREEN}  ✓ $tool is installed${NC}"
            else
                echo -e "${RED}  ✗ $tool is missing!${NC}"
            fi
        done
        ;;

    info|-i)
        echo -e "${YELLOW}SAP - Simple AUR Packager${NC}"
        echo -e "---------------------------"
        echo -e "• Version: 1.0 Stable (2026)"
        echo -e "• Lead Dev: Sanchit Kumar (SanchitKumaRR)"
        echo -e "• License: MIT"
        echo -e "• Status: System Ready"
        ;;

    *)
        echo -e "${WHITE}SAP (Simple AUR Packager) v1.0${NC}"
        echo -e "Usage:"
        echo -e "  sap install  <pkg>  (or -S)"
        echo -e "  sap remove   <pkg>  (or -R)"
        echo -e "  sap search   <pkg>  (or -Ss)"
        echo -e "  sap list            (or -Qs)"
        echo -e "  sap clean           (or -Sc)"
        echo -e "  sap doctor          (Check system)"
        echo -e "  sap info            (or -i)"
        ;;
esac
