# GitHub Actions Build Workflow

## Overview

A GitHub Actions workflow has been added to automatically build ThingsBoard using Maven and Docker.

## Workflow File

- **Location**: `.github/workflows/maven-build.yml`
- **Trigger**: Manual dispatch only (workflow_dispatch)
- **Manual Run**: Go to Actions tab → Select workflow → Click "Run workflow"

## Build Jobs

The workflow provides two build options that can be selected when running manually:

### Build Type Options

1. **packages** (default) - Build only DEB, RPM, and ZIP packages
2. **docker** - Build only Docker images
3. **both** - Build both packages and Docker images

### Test Options

- **Skip tests** (default: true) - Skip running tests to speed up build
- **Run tests** (false) - Run all tests during build

### 1. Maven Build Job (packages)

This job builds ThingsBoard packages without running tests.

**Steps:**
1. Checkout code
2. Set up JDK 17
3. Set up Maven 3.9.6+
4. Build with `mvn clean install -DskipTests`
5. Upload build artifacts

**Artifacts Produced:**
- Debian package (`.deb`)
- RPM package (`.rpm`)
- Windows package (`.zip`)

**Location**: `application/target/`

### 2. Docker Build Job

This job builds Docker images that can be used locally without Docker Hub.

**Steps:**
1. Checkout code
2. Set up JDK 17
3. Set up Maven 3.9.6+
4. Set up Docker Buildx
5. Build with `mvn clean install -DskipTests -Ddockerfile.skip=false`
6. Save Docker images to tar files
7. Upload tar files as artifacts

## Requirements

- **Java**: OpenJDK 17 (Temurin distribution)
- **Maven**: 3.9.6 or higher
- **Docker**: Latest (automatically available on GitHub Actions runners)

## Using Build Artifacts

### Downloading Artifacts

1. Go to the Actions tab in GitHub
2. Click on the workflow run
3. Scroll down to "Artifacts" section
4. Download the artifacts you need:
   - `thingsboard-deb-package` - Debian package
   - `thingsboard-rpm-package` - RPM package
   - `thingsboard-windows-package` - Windows package
   - `thingsboard-docker-images` - Docker images as tar files
   - `docker-load-instructions` - Instructions for loading Docker images

### Installing Packages

**Debian/Ubuntu:**
```bash
sudo dpkg -i thingsboard-*.deb
```

**Red Hat/CentOS:**
```bash
sudo rpm -ivh thingsboard-*.rpm
```

**Windows:**
Extract the ZIP file and follow the included installation instructions.

### Loading Docker Images

1. Download the Docker image tar files from artifacts

2. Load the image into Docker:
```bash
docker load -i thingsboard-*.tar
```

3. Verify the image is loaded:
```bash
docker images | grep thingsboard
```

4. Run the container:
```bash
docker run -it -p 9090:9090 -p 1883:1883 -p 5683:5683/udp thingsboard/tb-postgres
```

### Using with Docker Compose

Create a `docker-compose.yml`:

```yaml
version: '3.8'

services:
  thingsboard:
    image: thingsboard/tb-postgres:latest
    ports:
      - "9090:9090"
      - "1883:1883"
      - "5683:5683/udp"
    environment:
      - TB_QUEUE_TYPE=in-memory
    volumes:
      - tb-data:/data
      - tb-logs:/var/log/thingsboard

volumes:
  tb-data:
  tb-logs:
```

Run with:
```bash
docker-compose up -d
```

## Manual Workflow Dispatch

To manually trigger the build workflow:

### Step 1: Navigate to Actions

1. Go to your GitHub repository
2. Click on the **Actions** tab at the top

### Step 2: Select Workflow

1. In the left sidebar, find and click **"Maven Build with Docker"**
2. Click the **"Run workflow"** button on the right

### Step 3: Configure Build Options

You'll see a form with the following options:

**Branch Selection:**
- Choose the branch you want to build from (e.g., master, main, your feature branch)

**Build Type:**
- **packages** - Build DEB, RPM, and ZIP packages only (faster, ~20-30 min)
- **docker** - Build Docker images only (~25-35 min)
- **both** - Build everything (~40-60 min)

**Skip Tests:**
- ☑ **Checked (default)** - Skip tests for faster build (recommended)
- ☐ **Unchecked** - Run all tests (slower, but more thorough)

### Step 4: Run the Workflow

1. Click the green **"Run workflow"** button at the bottom
2. Wait for the workflow to start (may take a few seconds)
3. Click on the running workflow to see live progress

### Example Usage Scenarios

**Scenario 1: Quick build for testing**
```
Branch: main
Build type: packages
Skip tests: ✓ (checked)
→ Fast build, get DEB/RPM/ZIP files in ~20 minutes
```

**Scenario 2: Docker images for deployment**
```
Branch: main
Build type: docker
Skip tests: ✓ (checked)
→ Get Docker images as tar files in ~25 minutes
```

**Scenario 3: Full build with tests**
```
Branch: main
Build type: both
Skip tests: ☐ (unchecked)
→ Complete build with testing in ~60-90 minutes
```

**Scenario 4: Everything without tests (recommended)**
```
Branch: main
Build type: both
Skip tests: ✓ (checked)
→ All artifacts without tests in ~40 minutes
```

## Build Time

- Maven Build: ~15-30 minutes
- Docker Build: ~20-40 minutes

Times may vary based on GitHub Actions runner availability and cache status.

## Artifact Retention

Build artifacts are retained for **7 days** by default. Download them before they expire.

## Troubleshooting

### Build Fails

1. Check the build logs in GitHub Actions
2. Verify Java and Maven versions are correct
3. Ensure all dependencies are available

### Docker Images Not Found

1. Check if Docker build step completed successfully
2. Verify the Maven profile for Docker is activated
3. Check Docker daemon is running on the runner

### Artifacts Not Available

1. Check if the build completed successfully
2. Verify the artifact paths in the workflow
3. Check retention period hasn't expired

## Local Testing

To test the build locally before pushing:

### Maven Build
```bash
mvn clean install -DskipTests
```

### Docker Build
```bash
mvn clean install -DskipTests -Ddockerfile.skip=false
```

Check artifacts:
```bash
ls -lh application/target/
docker images | grep thingsboard
```

## Advanced Usage

### Building Specific Modules

```bash
mvn clean install -DskipTests -pl application -am
```

### Building with Tests

```bash
mvn clean install
```

### Building for Specific Database

```bash
mvn clean install -DskipTests -P postgres
mvn clean install -DskipTests -P cassandra
```

## References

- [ThingsBoard Documentation](https://thingsboard.io/docs/)
- [Maven Documentation](https://maven.apache.org/)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
