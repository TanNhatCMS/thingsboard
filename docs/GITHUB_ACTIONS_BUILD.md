# GitHub Actions Build Workflow

## Overview

A GitHub Actions workflow has been added to automatically build ThingsBoard using Maven and Docker.

## Workflow File

- **Location**: `.github/workflows/maven-build.yml`
- **Triggers**: Push to master/main branches, Pull Requests, Manual dispatch

## Build Jobs

### 1. Maven Build Job

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

**RedHat/CentOS:**
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

You can manually trigger the workflow:

1. Go to Actions tab
2. Select "Maven Build with Docker" workflow
3. Click "Run workflow"
4. Select the branch
5. Click "Run workflow" button

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
