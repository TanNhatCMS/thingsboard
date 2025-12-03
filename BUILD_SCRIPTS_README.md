# ThingsBoard Build Scripts for Low-Spec Machines

This directory contains shell scripts to help build ThingsBoard on machines with limited resources.

## Available Scripts

### 1. `build-low-spec.sh` - Smart Build for Low-Spec Machines

Automatically detects system resources and optimizes build settings accordingly.

**Features:**
- Auto-detects available RAM and adjusts Maven memory settings
- Configurable build options
- Progress indicators
- Error handling with helpful troubleshooting tips

**Usage:**
```bash
./build-low-spec.sh [options]
```

**Options:**
- `--skip-tests` - Skip running tests (default, recommended)
- `--with-tests` - Run tests during build
- `--skip-ui` - Skip building UI (faster)
- `--docker` - Build Docker images (requires more resources)
- `--clean` - Clean before building
- `--help` - Show help message

**Examples:**
```bash
# Standard build (skip tests, include UI)
./build-low-spec.sh

# Fast build (skip tests and UI)
./build-low-spec.sh --skip-ui

# Clean build with Docker images
./build-low-spec.sh --clean --docker

# Build with tests (slower, requires more memory)
./build-low-spec.sh --with-tests
```

**System Requirements:**
- **Minimum:** 2GB RAM, 10GB free disk space
- **Recommended:** 4GB RAM, 20GB free disk space
- Java 17 or higher
- Maven 3.1.0 or higher

**Build Time:**
- 2GB RAM: 45-60 minutes
- 4GB RAM: 30-45 minutes
- 8GB+ RAM: 20-30 minutes

### 2. `build-incremental.sh` - Module-by-Module Build

Builds ThingsBoard modules one at a time to minimize memory usage.

**Best for:**
- Machines with < 2GB RAM
- Systems that crash with standard build
- When you encounter OutOfMemoryError

**Usage:**
```bash
./build-incremental.sh
```

**Features:**
- Minimal memory footprint (768MB heap)
- Sequential module building
- Progress tracking
- No configuration needed

**Build Time:** 60-90 minutes

### 3. `build-ui-only.sh` - UI Build Only

Builds only the Angular UI without the backend.

**Best for:**
- UI development
- Testing UI changes
- Machines with limited resources
- Quick iteration

**Usage:**
```bash
# Production build
./build-ui-only.sh prod

# Development server
./build-ui-only.sh dev
```

**Modes:**
- `prod` - Production build (default)
- `dev` - Start development server at http://localhost:4200

**Requirements:**
- Node.js 18 or higher
- Yarn (auto-installed if missing)

**Build Time:**
- Production: 5-10 minutes
- Development server: 2-3 minutes to start

### 4. `clean-build.sh` - Cleanup Script

Removes build artifacts and caches to free disk space.

**Usage:**
```bash
./clean-build.sh [level]
```

**Cleanup Levels:**
- `light` - Maven build artifacts only (fastest)
- `medium` - Maven + Node.js artifacts
- `full` - All artifacts + caches (most thorough)

**Examples:**
```bash
# Quick cleanup
./clean-build.sh light

# Remove UI dependencies too
./clean-build.sh medium

# Deep clean everything
./clean-build.sh full
```

**Freed Space:**
- Light: 1-2 GB
- Medium: 3-5 GB
- Full: 5-10 GB

## Recommended Workflow

### For Very Low-Spec Machines (< 2GB RAM)

1. Clean first:
```bash
./clean-build.sh full
```

2. Close all other applications

3. Build incrementally:
```bash
./build-incremental.sh
```

4. If that fails, build UI separately:
```bash
./build-ui-only.sh prod
```

### For Low-Spec Machines (2-4GB RAM)

1. Clean first:
```bash
./clean-build.sh medium
```

2. Use smart build:
```bash
./build-low-spec.sh --skip-tests
```

3. If UI development only:
```bash
./build-ui-only.sh dev
```

### For Normal Machines (4GB+ RAM)

Use the standard build with optimizations:
```bash
./build-low-spec.sh
```

## Troubleshooting

### OutOfMemoryError

**Problem:** Build crashes with Java heap space error

**Solutions:**
1. Use `build-incremental.sh` instead
2. Close all other applications
3. Add swap space (Linux):
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Build Takes Too Long

**Problem:** Build runs for hours without completing

**Solutions:**
1. Use `--skip-tests` option
2. Use `--skip-ui` if you don't need the UI
3. Check disk space: `df -h`
4. Clean old artifacts: `./clean-build.sh full`

### Disk Space Full

**Problem:** Build fails due to insufficient disk space

**Solutions:**
1. Run cleanup: `./clean-build.sh full`
2. Remove Docker images: `docker system prune -a`
3. Clear Maven cache: `rm -rf ~/.m2/repository/org/thingsboard`

### UI Build Fails

**Problem:** UI build fails with Node.js errors

**Solutions:**
1. Update Node.js to version 18+
2. Remove node_modules: `rm -rf ui-ngx/node_modules`
3. Clear Yarn cache: `yarn cache clean`
4. Reinstall: `cd ui-ngx && yarn install`

### Dependencies Download Fails

**Problem:** Maven can't download dependencies

**Solutions:**
1. Check internet connection
2. Try different Maven mirror
3. Clear Maven cache: `rm -rf ~/.m2/repository`
4. Use VPN if behind restrictive firewall

## Performance Tips

### Before Building

1. **Close unnecessary applications**
   - Web browsers
   - IDEs
   - Docker Desktop (if not building Docker images)

2. **Check available resources:**
```bash
free -h           # Check RAM
df -h            # Check disk space
top              # Check running processes
```

3. **Clear caches:**
```bash
./clean-build.sh full
```

### During Building

1. **Monitor resource usage:**
```bash
# In another terminal
watch -n 1 free -h
```

2. **Don't run other heavy tasks**

3. **Keep terminal open** - Don't close it or the build will stop

### After Building

1. **Find artifacts:**
```bash
ls -lh application/target/*.deb
ls -lh application/target/*.rpm
ls -lh application/target/*.zip
```

2. **Check Docker images:**
```bash
docker images | grep thingsboard
```

3. **Clean up to free space:**
```bash
./clean-build.sh medium
```

## System Resource Recommendations

| RAM | Disk Space | Build Script | Expected Time |
|-----|-----------|--------------|---------------|
| < 2GB | 10GB | build-incremental.sh | 60-90 min |
| 2GB | 15GB | build-low-spec.sh | 45-60 min |
| 4GB | 20GB | build-low-spec.sh | 30-45 min |
| 8GB+ | 30GB+ | mvn clean install | 20-30 min |

## Common Build Commands Reference

### Maven

```bash
# Standard build
mvn clean install -DskipTests

# Build specific module
mvn install -pl application -am -DskipTests

# Build with Docker
mvn clean install -DskipTests -Ddockerfile.skip=false

# Skip UI build
mvn clean install -DskipTests -Dui.skip=true
```

### UI Only

```bash
cd ui-ngx

# Install dependencies
yarn install

# Development server
yarn start

# Production build
yarn build:prod

# Lint
yarn lint
```

## Getting Help

If you encounter issues:

1. Check the error message carefully
2. Review the troubleshooting section above
3. Check ThingsBoard documentation: https://thingsboard.io/docs/
4. Open an issue on GitHub with:
   - Error message
   - System specifications
   - Script and options used
   - Build log

## License

These scripts are provided as-is under the Apache License 2.0, same as ThingsBoard.
