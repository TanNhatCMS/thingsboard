#!/bin/bash

###############################################################################
# ThingsBoard Build Script for Low-Spec Machines
# 
# This script helps build ThingsBoard on machines with limited resources
# by using optimized Maven settings and building modules sequentially.
#
# Usage: ./build-low-spec.sh [options]
#
# Options:
#   --skip-tests       Skip running tests (default)
#   --with-tests       Run tests during build
#   --skip-ui          Skip building UI (faster)
#   --docker           Build Docker images (requires more resources)
#   --clean            Clean before building
#   --help             Show this help message
#
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default settings
SKIP_TESTS=true
BUILD_UI=true
BUILD_DOCKER=false
CLEAN_BUILD=false
MAVEN_OPTS_CUSTOM="-Xmx1024m -Xms512m -XX:MaxMetaspaceSize=512m"
MAVEN_ARGS="-T 1"  # Single thread for low-spec machines

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-tests)
            SKIP_TESTS=true
            shift
            ;;
        --with-tests)
            SKIP_TESTS=false
            shift
            ;;
        --skip-ui)
            BUILD_UI=false
            shift
            ;;
        --docker)
            BUILD_DOCKER=true
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --help)
            echo "ThingsBoard Build Script for Low-Spec Machines"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --skip-tests    Skip running tests (default)"
            echo "  --with-tests    Run tests during build"
            echo "  --skip-ui       Skip building UI (faster)"
            echo "  --docker        Build Docker images"
            echo "  --clean         Clean before building"
            echo "  --help          Show this help message"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Print banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║   ThingsBoard Build Script for Low-Spec Machines         ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check system requirements
echo -e "${YELLOW}Checking system requirements...${NC}"

# Check Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}ERROR: Java is not installed!${NC}"
    echo "Please install Java 17 or higher"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo -e "${RED}ERROR: Java version must be 17 or higher!${NC}"
    echo "Current version: $JAVA_VERSION"
    exit 1
fi
echo -e "${GREEN}✓ Java version: $(java -version 2>&1 | head -n 1)${NC}"

# Check Maven
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}ERROR: Maven is not installed!${NC}"
    echo "Please install Maven 3.1.0 or higher"
    exit 1
fi

MVN_VERSION=$(mvn -version | head -n 1 | awk '{print $3}')
echo -e "${GREEN}✓ Maven version: $MVN_VERSION${NC}"

# Check available memory
TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
echo -e "${YELLOW}System RAM: ${TOTAL_MEM}MB${NC}"

if [ "$TOTAL_MEM" -lt 2048 ]; then
    echo -e "${YELLOW}WARNING: Low memory detected (< 2GB)${NC}"
    echo -e "${YELLOW}Build may be slow or fail. Consider closing other applications.${NC}"
    MAVEN_OPTS_CUSTOM="-Xmx512m -Xms256m -XX:MaxMetaspaceSize=256m"
elif [ "$TOTAL_MEM" -lt 4096 ]; then
    echo -e "${YELLOW}Moderate memory detected (2-4GB)${NC}"
    MAVEN_OPTS_CUSTOM="-Xmx1024m -Xms512m -XX:MaxMetaspaceSize=512m"
else
    echo -e "${GREEN}Good memory available (>= 4GB)${NC}"
    MAVEN_OPTS_CUSTOM="-Xmx2048m -Xms1024m -XX:MaxMetaspaceSize=512m"
    MAVEN_ARGS="-T 2"  # Can use 2 threads
fi

# Set Maven options
export MAVEN_OPTS="$MAVEN_OPTS_CUSTOM"
echo -e "${BLUE}Maven memory settings: $MAVEN_OPTS${NC}"

# Build command
BUILD_CMD="mvn"

if [ "$CLEAN_BUILD" = true ]; then
    BUILD_CMD="$BUILD_CMD clean"
fi

BUILD_CMD="$BUILD_CMD install $MAVEN_ARGS"

if [ "$SKIP_TESTS" = true ]; then
    BUILD_CMD="$BUILD_CMD -DskipTests"
fi

if [ "$BUILD_UI" = false ]; then
    BUILD_CMD="$BUILD_CMD -Dui.skip=true"
fi

if [ "$BUILD_DOCKER" = true ]; then
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}ERROR: Docker is not installed!${NC}"
        exit 1
    fi
    BUILD_CMD="$BUILD_CMD -Ddockerfile.skip=false"
else
    BUILD_CMD="$BUILD_CMD -Ddockerfile.skip=true"
fi

# Show configuration
echo ""
echo -e "${BLUE}Build Configuration:${NC}"
echo -e "  Skip Tests: ${YELLOW}$SKIP_TESTS${NC}"
echo -e "  Build UI: ${YELLOW}$BUILD_UI${NC}"
echo -e "  Build Docker: ${YELLOW}$BUILD_DOCKER${NC}"
echo -e "  Clean Build: ${YELLOW}$CLEAN_BUILD${NC}"
echo ""
echo -e "${BLUE}Build Command:${NC}"
echo -e "${YELLOW}$BUILD_CMD${NC}"
echo ""

# Confirm
read -p "Continue with build? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Build cancelled${NC}"
    exit 0
fi

# Start build
echo ""
echo -e "${GREEN}Starting build...${NC}"
echo -e "${YELLOW}This may take 20-60 minutes depending on your system.${NC}"
echo ""

START_TIME=$(date +%s)

# Run build
if $BUILD_CMD; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              BUILD SUCCESSFUL!                            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo -e "${GREEN}Build completed in ${MINUTES}m ${SECONDS}s${NC}"
    echo ""
    echo -e "${BLUE}Build artifacts are available in:${NC}"
    echo -e "${YELLOW}  application/target/${NC}"
    echo ""
    
    # List artifacts
    if [ -d "application/target" ]; then
        echo -e "${BLUE}Generated files:${NC}"
        ls -lh application/target/*.deb application/target/*.rpm application/target/*.zip 2>/dev/null || echo "  (packages will be generated in application/target/)"
    fi
    
    if [ "$BUILD_DOCKER" = true ]; then
        echo ""
        echo -e "${BLUE}Docker images:${NC}"
        docker images | grep thingsboard || echo "  (no ThingsBoard images found)"
    fi
else
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    echo ""
    echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║              BUILD FAILED!                                ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo -e "${RED}Build failed after ${MINUTES}m ${SECONDS}s${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting tips:${NC}"
    echo "  1. Check the error messages above"
    echo "  2. Try running with --clean option"
    echo "  3. Close other applications to free memory"
    echo "  4. Check Java and Maven versions"
    echo "  5. Check internet connection for dependencies"
    echo ""
    exit 1
fi
