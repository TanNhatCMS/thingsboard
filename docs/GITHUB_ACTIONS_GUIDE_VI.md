# Hướng Dẫn Sử Dụng GitHub Actions Build

## Tổng Quan

GitHub Actions workflow cho phép bạn build ThingsBoard trực tiếp trên GitHub mà không cần máy tính mạnh. Build được thực hiện trên server của GitHub (miễn phí).

## Bước 1: Truy Cập GitHub Actions

1. Mở repository ThingsBoard của bạn trên GitHub
2. Nhấn vào tab **"Actions"** ở trên cùng

```
https://github.com/TanNhatCMS/thingsboard → Actions
```

## Bước 2: Chọn Workflow

1. Trong sidebar bên trái, tìm và nhấn vào **"Maven Build with Docker"**
2. Bạn sẽ thấy nút **"Run workflow"** màu xanh ở bên phải
3. Nhấn vào nút **"Run workflow"**

## Bước 3: Cấu Hình Build

Một cửa sổ popup sẽ xuất hiện với các tùy chọn:

### 3.1. Chọn Branch
```
Use workflow from: [main ▼]
```
- Chọn branch bạn muốn build
- Thường là `main` hoặc `master`

### 3.2. Chọn Loại Build (Build Type)
```
Type of build: [packages ▼]
```

Có 3 lựa chọn:

#### 📦 packages (Khuyến nghị cho lần đầu)
- Build gói cài đặt: DEB, RPM, ZIP
- Nhanh nhất (~20-30 phút)
- Phù hợp nếu bạn chỉ cần cài đặt ThingsBoard

**Khi nào dùng:**
- Cài đặt trên Ubuntu/Debian (file .deb)
- Cài đặt trên CentOS/RHEL (file .rpm)
- Cài đặt trên Windows (file .zip)

#### 🐳 docker
- Build Docker images
- Trung bình (~25-35 phút)
- Phù hợp nếu bạn dùng Docker

**Khi nào dùng:**
- Chạy ThingsBoard bằng Docker
- Triển khai trên Kubernetes
- Cần Docker images để dùng local

#### 🚀 both
- Build cả packages và Docker
- Lâu nhất (~40-60 phút)
- Build đầy đủ mọi thứ

**Khi nào dùng:**
- Cần tất cả các artifacts
- Build release chính thức
- Có thời gian chờ

### 3.3. Bỏ Qua Tests (Skip Tests)
```
Skip tests: ☑️ (checked)
```

- ✅ **Đánh dấu (Khuyến nghị):** Build nhanh hơn, bỏ qua tests
- ❌ **Không đánh dấu:** Chạy đầy đủ tests (lâu hơn 2-3 lần)

**Khuyến nghị:** Nên đánh dấu để build nhanh hơn

## Bước 4: Chạy Build

1. Sau khi chọn xong các tùy chọn
2. Nhấn nút **"Run workflow"** màu xanh ở dưới cùng
3. Đợi vài giây để workflow bắt đầu

## Bước 5: Theo Dõi Tiến Trình

### 5.1. Xem Build Đang Chạy
- Workflow sẽ xuất hiện ở đầu danh sách
- Có biểu tượng màu vàng ⚫ (đang chạy)
- Nhấn vào tên workflow để xem chi tiết

### 5.2. Xem Logs Chi Tiết
1. Nhấn vào workflow đang chạy
2. Bạn sẽ thấy các jobs:
   - **Build ThingsBoard Packages** (nếu chọn packages hoặc both)
   - **Build Docker Images** (nếu chọn docker hoặc both)
3. Nhấn vào job để xem logs chi tiết

### 5.3. Biểu Tượng Trạng Thái
- ⚫ **Màu vàng:** Đang chạy
- ✅ **Màu xanh:** Thành công
- ❌ **Màu đỏ:** Thất bại

## Bước 6: Tải Xuống Artifacts

Sau khi build thành công (✅ màu xanh):

### 6.1. Vào Trang Workflow
1. Nhấn vào workflow đã hoàn thành
2. Cuộn xuống phần **"Artifacts"**

### 6.2. Danh Sách Artifacts

Tùy vào loại build, bạn sẽ thấy:

#### Nếu chọn "packages":
- 📦 **thingsboard-deb-package** - File .deb cho Ubuntu/Debian
- 📦 **thingsboard-rpm-package** - File .rpm cho CentOS/RHEL
- 📦 **thingsboard-windows-package** - File .zip cho Windows

#### Nếu chọn "docker":
- 🐳 **thingsboard-docker-images** - Docker images dạng .tar
- 📄 **docker-load-instructions** - Hướng dẫn load Docker images

#### Nếu chọn "both":
- Tất cả các artifacts ở trên

### 6.3. Tải Xuống
1. Nhấn vào tên artifact bạn cần
2. File sẽ được tải về dạng ZIP
3. Giải nén file ZIP để lấy artifacts

## Bước 7: Sử Dụng Artifacts

### 7.1. Cài Đặt Package

**Ubuntu/Debian (.deb):**
```bash
# Giải nén file tải về
unzip thingsboard-deb-package.zip

# Cài đặt
sudo dpkg -i thingsboard-*.deb
```

**CentOS/RHEL (.rpm):**
```bash
# Giải nén file tải về
unzip thingsboard-rpm-package.zip

# Cài đặt
sudo rpm -ivh thingsboard-*.rpm
```

**Windows (.zip):**
1. Giải nén file tải về
2. Chạy file cài đặt hoặc script

### 7.2. Load Docker Images

```bash
# Giải nén file tải về
unzip thingsboard-docker-images.zip

# Load image vào Docker
docker load -i thingsboard-*.tar

# Kiểm tra
docker images | grep thingsboard

# Chạy container
docker run -it -p 9090:9090 -p 1883:1883 -p 5683:5683/udp thingsboard/tb-postgres
```

## Các Ví Dụ Thực Tế

### Ví Dụ 1: Build Nhanh Để Test
```
Branch: main
Build type: packages
Skip tests: ✅ checked
→ Kết quả: Có file .deb, .rpm, .zip sau 20-30 phút
```

### Ví Dụ 2: Build Docker Cho Production
```
Branch: main
Build type: docker
Skip tests: ✅ checked
→ Kết quả: Có Docker images sau 25-35 phút
```

### Ví Dụ 3: Build Đầy Đủ
```
Branch: main
Build type: both
Skip tests: ✅ checked
→ Kết quả: Có tất cả sau 40-60 phút
```

## Thời Gian Build Dự Kiến

| Loại Build | Skip Tests | Thời Gian |
|-----------|------------|-----------|
| packages | ✅ Yes | 20-30 phút |
| packages | ❌ No | 40-60 phút |
| docker | ✅ Yes | 25-35 phút |
| docker | ❌ No | 50-70 phút |
| both | ✅ Yes | 40-60 phút |
| both | ❌ No | 80-120 phút |

## Xử Lý Lỗi

### Lỗi: Build Failed ❌

**Nguyên nhân thường gặp:**
1. Code có lỗi
2. Dependencies không tải được
3. Tests fail (nếu không skip tests)

**Giải pháp:**
1. Xem logs chi tiết để biết lỗi cụ thể
2. Sửa code nếu cần
3. Thử build lại với skip tests

### Lỗi: Không Thấy Artifacts

**Nguyên nhân:**
- Build chưa thành công (còn đang chạy hoặc bị lỗi)

**Giải pháp:**
- Đợi build hoàn thành (✅ màu xanh)
- Nếu build failed (❌ màu đỏ), xem logs và sửa lỗi

### Artifacts Hết Hạn

**Lưu ý:** Artifacts chỉ lưu trong 7 ngày

**Giải pháp:**
- Tải về trong vòng 7 ngày
- Hoặc chạy lại workflow để build mới

## Lưu Ý Quan Trọng

### ✅ Nên làm:
- Chọn skip tests để build nhanh hơn
- Chọn loại build phù hợp với nhu cầu
- Tải artifacts trong vòng 7 ngày

### ❌ Không nên:
- Chạy nhiều builds cùng lúc (tốn tài nguyên)
- Build với tests nếu không cần thiết
- Quên tải artifacts (sẽ mất sau 7 ngày)

## Câu Hỏi Thường Gặp

### Q: Build có mất phí không?
**A:** Không, GitHub Actions miễn phí cho public repositories.

### Q: Tôi có thể cancel build đang chạy không?
**A:** Có, nhấn nút "Cancel workflow" ở góc phải trên.

### Q: Build có chạy tự động không?
**A:** Không, workflow này chỉ chạy khi bạn trigger thủ công.

### Q: Tôi có thể xem lại builds cũ không?
**A:** Có, tất cả workflows được lưu trong tab Actions.

### Q: Artifacts có giới hạn dung lượng không?
**A:** Packages thường ~100-200MB, Docker images ~500MB-1GB.

## Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra logs chi tiết trong workflow
2. Xem tài liệu: `docs/GITHUB_ACTIONS_BUILD.md`
3. Mở issue trên GitHub với thông tin chi tiết

## Tóm Tắt Nhanh

```
1. GitHub → Actions → "Maven Build with Docker" → "Run workflow"
2. Chọn build type (packages/docker/both)
3. Check "Skip tests" (✅)
4. Click "Run workflow"
5. Đợi build xong (20-60 phút)
6. Tải artifacts từ phần "Artifacts"
7. Cài đặt hoặc load Docker images
```

**Thật đơn giản! Chúc bạn build thành công! 🚀**
