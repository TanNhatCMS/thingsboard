#!/bin/bash

###############################################################################
# ThingsBoard UI Rebuild and Package Update Script
# 
# This script rebuilds ONLY the frontend (ui-ngx) without rebuilding the
# backend, then repackages the complete application with the new UI.
#
# This is useful for:
# - Quick UI iterations during development
# - Updating UI translations or styles
# - Testing UI changes without full rebuild
#
# Usage: ./build-ui-update.sh
#
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   ThingsBoard UI Rebuild & Package Update Script         ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check requirements
echo -e "${YELLOW}Checking requirements...${NC}"

# Check Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}ERROR: Java is not installed!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Java: $(java -version 2>&1 | head -n 1)${NC}"

# Check Maven
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}ERROR: Maven is not installed!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Maven: $(mvn -version | head -n 1)${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}ERROR: Node.js is not installed!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js: $(node -v)${NC}"

echo ""
echo -e "${BLUE}This script will:${NC}"
echo -e "${YELLOW}  1. Clean UI build artifacts${NC}"
echo -e "${YELLOW}  2. Rebuild ONLY the frontend (ui-ngx)${NC}"
echo -e "${YELLOW}  3. Repackage the application with new UI${NC}"
echo ""
echo -e "${BLUE}Backend will NOT be rebuilt (much faster!)${NC}"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cancelled${NC}"
    exit 0
fi

START_TIME=$(date +%s)

# Step 1: Clean UI artifacts only
echo ""
echo -e "${BLUE}[1/3] Cleaning UI build artifacts...${NC}"
mvn clean -pl ui-ngx -q
echo -e "${GREEN}✓ UI artifacts cleaned${NC}"

# Step 2: Build UI only
echo ""
echo -e "${BLUE}[2/3] Building UI (this may take 5-10 minutes)...${NC}"
mvn install -pl ui-ngx -DskipTests -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ UI build completed${NC}"
else
    echo -e "${RED}✗ UI build failed!${NC}"
    exit 1
fi

# Step 3: Repackage application with new UI
echo ""
echo -e "${BLUE}[3/3] Repackaging application with new UI...${NC}"
mvn package -pl application -DskipTests -q
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Application repackaged${NC}"
else
    echo -e "${RED}✗ Application packaging failed!${NC}"
    exit 1
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          BUILD COMPLETED SUCCESSFULLY!                    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}Time: ${MINUTES}m ${SECONDS}s${NC}"
echo ""
echo -e "${BLUE}Updated packages are available in:${NC}"
echo -e "${YELLOW}  application/target/${NC}"
echo ""

# List the packages
if [ -d "application/target" ]; then
    echo -e "${BLUE}Generated packages:${NC}"
    ls -lh application/target/*.deb application/target/*.rpm application/target/*.zip 2>/dev/null || echo -e "${YELLOW}  (packages available in application/target/)${NC}"
fi

echo ""
echo -e "${BLUE}What was rebuilt:${NC}"
echo -e "${GREEN}  ✓ Frontend (ui-ngx)${NC}"
echo -e "${GREEN}  ✓ Application package${NC}"
echo ""
echo -e "${BLUE}What was NOT rebuilt (saved time):${NC}"
echo -e "${YELLOW}  ✗ Backend services${NC}"
echo -e "${YELLOW}  ✗ Rule engine${NC}"
echo -e "${YELLOW}  ✗ Transport protocols${NC}"
echo -e "${YELLOW}  ✗ DAO layer${NC}"
echo ""
echo -e "${GREEN}Ready to install or deploy!${NC}"
