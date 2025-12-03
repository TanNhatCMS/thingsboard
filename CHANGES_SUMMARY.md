# Tóm Tắt Thay Đổi / Changes Summary

## Tiếng Việt

### 1. Hỗ Trợ Ngôn Ngữ Tiếng Việt

✅ **Đã thêm hỗ trợ đầy đủ cho tiếng Việt trong giao diện người dùng ThingsBoard**

**Các tệp đã thêm/sửa đổi:**
- `ui-ngx/src/assets/locale/locale.constant-vi_VN.json` - Tệp dịch tiếng Việt (MỚI)
- `ui-ngx/src/assets/locale/locale.constant-en_US.json` - Đã cập nhật danh sách ngôn ngữ
- `ui-ngx/src/assets/locale/locale.constant-vi_VN.json` - Đã cập nhật danh sách ngôn ngữ

**Cách sử dụng:**
1. Đăng nhập vào ThingsBoard
2. Vào cài đặt hồ sơ cá nhân
3. Chọn "Tiếng Việt (Việt Nam)" từ menu ngôn ngữ

**Tài liệu:** `docs/VIETNAMESE_LOCALE.md`

### 2. GitHub Actions Build Workflow

✅ **Đã thêm workflow tự động build với Maven và Docker**

**Tính năng:**
- **Kích hoạt thủ công** - Chỉ chạy khi bạn muốn (không tự động)
- **Tùy chọn build linh hoạt:**
  - `packages` - Chỉ build gói DEB, RPM, ZIP
  - `docker` - Chỉ build Docker images
  - `both` - Build tất cả
- **Tùy chọn kiểm thử:**
  - Có thể bỏ qua tests để build nhanh hơn
  - Hoặc chạy đầy đủ tests

**Cách kích hoạt:**
1. Vào tab **Actions** trên GitHub
2. Chọn workflow **"Maven Build with Docker"**
3. Nhấn **"Run workflow"**
4. Chọn các tùy chọn:
   - Branch muốn build
   - Loại build (packages/docker/both)
   - Có bỏ qua tests không
5. Nhấn **"Run workflow"** để bắt đầu

**Kết quả:**
- Gói Debian (`.deb`)
- Gói RPM (`.rpm`)
- Gói Windows (`.zip`)
- Docker images (dạng file `.tar`)

**Tải xuống:** Vào tab Actions → Chọn workflow run → Cuộn xuống phần "Artifacts"

**Tài liệu:** `docs/GITHUB_ACTIONS_BUILD.md`

### 3. Scripts Build Cho Máy Cấu Hình Yếu

✅ **Đã thêm 4 scripts shell để build trên máy cấu hình thấp**

#### a) `build-low-spec.sh` - Build Thông Minh
- Tự động phát hiện RAM và tối ưu hóa
- Hỗ trợ máy từ 2GB RAM trở lên
- Nhiều tùy chọn linh hoạt

```bash
# Build tiêu chuẩn (bỏ qua tests)
./build-low-spec.sh

# Build nhanh (bỏ qua UI)
./build-low-spec.sh --skip-ui

# Build đầy đủ với Docker
./build-low-spec.sh --clean --docker
```

#### b) `build-incremental.sh` - Build Từng Module
- Dành cho máy < 2GB RAM
- Build từng module một
- Tiết kiệm bộ nhớ tối đa

```bash
./build-incremental.sh
```

#### c) `build-ui-only.sh` - Chỉ Build Giao Diện
- Nhanh nhất (5-10 phút)
- Chỉ build phần frontend
- Không cần build backend

```bash
# Build production
./build-ui-only.sh prod

# Chạy development server
./build-ui-only.sh dev
```

#### d) `clean-build.sh` - Dọn Dẹp
- Xóa các file build cũ
- Giải phóng dung lượng ổ đĩa
- 3 mức độ: light, medium, full

```bash
# Dọn nhẹ
./clean-build.sh light

# Dọn vừa
./clean-build.sh medium

# Dọn sạch hoàn toàn
./clean-build.sh full
```

**Tài liệu:** `BUILD_SCRIPTS_README.md`

### Yêu Cầu Hệ Thống

| RAM | Disk | Script Khuyến Nghị | Thời Gian |
|-----|------|-------------------|-----------|
| < 2GB | 10GB | build-incremental.sh | 60-90 phút |
| 2GB | 15GB | build-low-spec.sh | 45-60 phút |
| 4GB | 20GB | build-low-spec.sh | 30-45 phút |
| 8GB+ | 30GB+ | mvn clean install | 20-30 phút |

### Tất Cả Tệp Đã Thay Đổi

```
Thêm mới:
- ui-ngx/src/assets/locale/locale.constant-vi_VN.json
- .github/workflows/maven-build.yml
- docs/VIETNAMESE_LOCALE.md
- docs/GITHUB_ACTIONS_BUILD.md
- BUILD_SCRIPTS_README.md
- build-low-spec.sh
- build-incremental.sh
- build-ui-only.sh
- clean-build.sh

Đã sửa đổi:
- ui-ngx/src/assets/locale/locale.constant-en_US.json
```

---

## English

### 1. Vietnamese Language Support

✅ **Added full Vietnamese language support for ThingsBoard UI**

**Files added/modified:**
- `ui-ngx/src/assets/locale/locale.constant-vi_VN.json` - Vietnamese translation file (NEW)
- `ui-ngx/src/assets/locale/locale.constant-en_US.json` - Updated with Vietnamese in language list
- `ui-ngx/src/assets/locale/locale.constant-vi_VN.json` - Updated with Vietnamese in language list

**How to use:**
1. Login to ThingsBoard
2. Go to profile settings
3. Select "Tiếng Việt (Việt Nam)" from language dropdown

**Documentation:** `docs/VIETNAMESE_LOCALE.md`

### 2. GitHub Actions Build Workflow

✅ **Added automated build workflow with Maven and Docker**

**Features:**
- **Manual trigger only** - Runs only when you want it
- **Flexible build options:**
  - `packages` - Build only DEB, RPM, ZIP packages
  - `docker` - Build only Docker images
  - `both` - Build everything
- **Test options:**
  - Skip tests for faster builds
  - Or run full test suite

**How to trigger:**
1. Go to **Actions** tab on GitHub
2. Select **"Maven Build with Docker"** workflow
3. Click **"Run workflow"**
4. Choose options:
   - Branch to build
   - Build type (packages/docker/both)
   - Skip tests or not
5. Click **"Run workflow"** to start

**Results:**
- Debian package (`.deb`)
- RPM package (`.rpm`)
- Windows package (`.zip`)
- Docker images (as `.tar` files)

**Download:** Go to Actions → Select workflow run → Scroll to "Artifacts" section

**Documentation:** `docs/GITHUB_ACTIONS_BUILD.md`

### 3. Build Scripts for Low-Spec Machines

✅ **Added 4 shell scripts for building on low-resource machines**

#### a) `build-low-spec.sh` - Smart Build
- Auto-detects RAM and optimizes
- Supports machines with 2GB+ RAM
- Multiple flexible options

```bash
# Standard build (skip tests)
./build-low-spec.sh

# Fast build (skip UI)
./build-low-spec.sh --skip-ui

# Full build with Docker
./build-low-spec.sh --clean --docker
```

#### b) `build-incremental.sh` - Module-by-Module Build
- For machines < 2GB RAM
- Builds one module at a time
- Minimal memory footprint

```bash
./build-incremental.sh
```

#### c) `build-ui-only.sh` - UI Build Only
- Fastest (5-10 minutes)
- Frontend only
- No backend build needed

```bash
# Production build
./build-ui-only.sh prod

# Development server
./build-ui-only.sh dev
```

#### d) `clean-build.sh` - Cleanup
- Remove old build artifacts
- Free up disk space
- 3 levels: light, medium, full

```bash
# Light cleanup
./clean-build.sh light

# Medium cleanup
./clean-build.sh medium

# Full cleanup
./clean-build.sh full
```

**Documentation:** `BUILD_SCRIPTS_README.md`

### System Requirements

| RAM | Disk | Recommended Script | Build Time |
|-----|------|-------------------|------------|
| < 2GB | 10GB | build-incremental.sh | 60-90 min |
| 2GB | 15GB | build-low-spec.sh | 45-60 min |
| 4GB | 20GB | build-low-spec.sh | 30-45 min |
| 8GB+ | 30GB+ | mvn clean install | 20-30 min |

### All Changed Files

```
New files:
- ui-ngx/src/assets/locale/locale.constant-vi_VN.json
- .github/workflows/maven-build.yml
- docs/VIETNAMESE_LOCALE.md
- docs/GITHUB_ACTIONS_BUILD.md
- BUILD_SCRIPTS_README.md
- build-low-spec.sh
- build-incremental.sh
- build-ui-only.sh
- clean-build.sh

Modified files:
- ui-ngx/src/assets/locale/locale.constant-en_US.json
```

## Quick Start Guide

### To use Vietnamese in UI:
```
Login → Profile Settings → Language → "Tiếng Việt (Việt Nam)"
```

### To build on GitHub Actions:
```
GitHub → Actions → "Maven Build with Docker" → Run workflow
```

### To build locally (low-spec machine):
```bash
# Clean first
./clean-build.sh full

# Then build
./build-low-spec.sh --skip-tests
```

### To build UI only:
```bash
./build-ui-only.sh prod
```

## Support

For questions or issues:
- Check documentation files in `docs/` directory
- Check `BUILD_SCRIPTS_README.md` for build scripts
- Open an issue on GitHub

## License

Apache License 2.0 - Same as ThingsBoard
