#!/bin/bash

###############################################################################
# ThingsBoard UI-Only Build Script
# 
# This script builds only the UI (ui-ngx) without building the backend.
# Much faster and requires less resources.
#
# Usage: ./build-ui-only.sh [dev|prod]
#
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

MODE=${1:-prod}

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         ThingsBoard UI Build Script                      ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if ui-ngx directory exists
if [ ! -d "ui-ngx" ]; then
    echo -e "${RED}ERROR: ui-ngx directory not found!${NC}"
    echo "Please run this script from the ThingsBoard root directory"
    exit 1
fi

cd ui-ngx

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}ERROR: Node.js is not installed!${NC}"
    echo "Please install Node.js 18 or higher"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
echo -e "${GREEN}✓ Node.js version: $(node -v)${NC}"

# Check Yarn
if ! command -v yarn &> /dev/null; then
    echo -e "${YELLOW}WARNING: Yarn is not installed. Installing Yarn...${NC}"
    npm install -g yarn
fi

YARN_VERSION=$(yarn -v)
echo -e "${GREEN}✓ Yarn version: $YARN_VERSION${NC}"

echo ""
echo -e "${BLUE}Build mode: ${YELLOW}$MODE${NC}"
echo ""

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing dependencies...${NC}"
    yarn install
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${GREEN}✓ Dependencies already installed${NC}"
fi

echo ""
START_TIME=$(date +%s)

# Build based on mode
if [ "$MODE" = "dev" ]; then
    echo -e "${YELLOW}Starting development server...${NC}"
    echo -e "${YELLOW}UI will be available at: http://localhost:4200${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    echo ""
    yarn start
else
    echo -e "${YELLOW}Building production UI...${NC}"
    echo ""
    yarn build:prod
    
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              UI BUILD COMPLETED!                          ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo -e "${GREEN}Build completed in ${MINUTES}m ${SECONDS}s${NC}"
    echo ""
    echo -e "${BLUE}Build output directory:${NC}"
    echo -e "${YELLOW}  ui-ngx/target/generated-resources/public${NC}"
    echo ""
fi
