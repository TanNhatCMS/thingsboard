#!/bin/bash
#
# Copyright © 2016-2025 The Thingsboard Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


###############################################################################
# ThingsBoard Incremental Build Script
# 
# This script builds ThingsBoard modules one by one to reduce memory usage.
# Useful for machines with very limited RAM (< 2GB).
#
# Usage: ./build-incremental.sh
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
echo "║   ThingsBoard Incremental Build (Low Memory Mode)        ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Set minimal memory options
export MAVEN_OPTS="-Xmx768m -Xms256m -XX:MaxMetaspaceSize=256m"

echo -e "${YELLOW}Memory settings: $MAVEN_OPTS${NC}"
echo -e "${YELLOW}Building modules one by one...${NC}"
echo ""

START_TIME=$(date +%s)

# Core modules in order
MODULES=(
    "common/util"
    "common/data"
    "common/cache"
    "common/message"
    "common/queue"
    "common/transport/transport-api"
    "common/script/script-api"
    "common/stats"
    "dao"
    "rule-engine/rule-engine-api"
    "rule-engine/rule-engine-components"
    "application"
)

TOTAL=${#MODULES[@]}
CURRENT=0

for module in "${MODULES[@]}"; do
    CURRENT=$((CURRENT + 1))
    echo -e "${BLUE}[$CURRENT/$TOTAL] Building module: $module${NC}"
    
    if [ -d "$module" ]; then
        mvn install -DskipTests -pl "$module" -am -T 1 -q
        echo -e "${GREEN}✓ Module $module completed${NC}"
    else
        echo -e "${YELLOW}⚠ Module $module not found, skipping...${NC}"
    fi
    echo ""
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          INCREMENTAL BUILD COMPLETED!                     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}Build completed in ${MINUTES}m ${SECONDS}s${NC}"
echo ""
echo -e "${BLUE}Artifacts location: application/target/${NC}"
