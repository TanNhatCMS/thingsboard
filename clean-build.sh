#!/bin/bash

###############################################################################
# ThingsBoard Cleanup Script
# 
# This script cleans build artifacts and caches to free up disk space.
# Useful before starting a fresh build on low-spec machines.
#
# Usage: ./clean-build.sh [option]
#
# Options:
#   light    - Clean Maven build artifacts only (default)
#   medium   - Clean Maven + Node.js artifacts
#   full     - Deep clean including all caches
#
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CLEAN_LEVEL=${1:-light}

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         ThingsBoard Cleanup Script                       ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to get directory size
get_size() {
    if [ -d "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1
    else
        echo "0"
    fi
}

# Function to remove directory with size info
remove_with_info() {
    if [ -d "$1" ]; then
        SIZE=$(get_size "$1")
        echo -e "${YELLOW}  Removing $1 ($SIZE)${NC}"
        rm -rf "$1"
        echo -e "${GREEN}  ✓ Removed${NC}"
    fi
}

echo -e "${BLUE}Cleanup level: ${YELLOW}$CLEAN_LEVEL${NC}"
echo ""

case $CLEAN_LEVEL in
    light)
        echo -e "${YELLOW}Light cleanup - Maven build artifacts only${NC}"
        echo ""
        
        echo -e "${BLUE}Cleaning Maven build artifacts...${NC}"
        mvn clean -q
        echo -e "${GREEN}✓ Maven clean completed${NC}"
        ;;
        
    medium)
        echo -e "${YELLOW}Medium cleanup - Maven + Node.js artifacts${NC}"
        echo ""
        
        echo -e "${BLUE}Cleaning Maven build artifacts...${NC}"
        mvn clean -q
        echo -e "${GREEN}✓ Maven clean completed${NC}"
        
        echo ""
        echo -e "${BLUE}Cleaning UI build artifacts...${NC}"
        if [ -d "ui-ngx" ]; then
            remove_with_info "ui-ngx/node_modules"
            remove_with_info "ui-ngx/target"
            remove_with_info "ui-ngx/dist"
            remove_with_info "ui-ngx/.angular"
        fi
        ;;
        
    full)
        echo -e "${YELLOW}Full cleanup - All build artifacts and caches${NC}"
        echo ""
        
        echo -e "${BLUE}Cleaning Maven build artifacts...${NC}"
        mvn clean -q
        echo -e "${GREEN}✓ Maven clean completed${NC}"
        
        echo ""
        echo -e "${BLUE}Cleaning UI build artifacts...${NC}"
        if [ -d "ui-ngx" ]; then
            remove_with_info "ui-ngx/node_modules"
            remove_with_info "ui-ngx/target"
            remove_with_info "ui-ngx/dist"
            remove_with_info "ui-ngx/.angular"
            remove_with_info "ui-ngx/yarn.lock"
        fi
        
        echo ""
        echo -e "${BLUE}Cleaning Maven local repository cache (ThingsBoard artifacts)...${NC}"
        if [ -d "$HOME/.m2/repository/org/thingsboard" ]; then
            remove_with_info "$HOME/.m2/repository/org/thingsboard"
        fi
        
        echo ""
        echo -e "${BLUE}Cleaning other target directories...${NC}"
        find . -type d -name "target" -not -path "*/node_modules/*" -exec rm -rf {} + 2>/dev/null || true
        echo -e "${GREEN}✓ All target directories cleaned${NC}"
        ;;
        
    *)
        echo -e "${RED}Unknown cleanup level: $CLEAN_LEVEL${NC}"
        echo ""
        echo "Usage: $0 [light|medium|full]"
        echo ""
        echo "  light   - Clean Maven build artifacts only (default)"
        echo "  medium  - Clean Maven + Node.js artifacts"
        echo "  full    - Deep clean including all caches"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              CLEANUP COMPLETED!                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Show disk space
echo -e "${BLUE}Available disk space:${NC}"
df -h . | tail -1
echo ""
