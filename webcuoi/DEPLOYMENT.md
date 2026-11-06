# Deploy frontend lên Vercel

Frontend: `https://webcuoikhacchinh-webcuoi.vercel.app`.
Frontend đang mở theo log trình duyệt: `https://webcuoikhacchinh-webcuoi-92e7-mocha.vercel.app`.
Backend: `https://webcuoi-khac-chinh.vercel.app`.
API base URL: `https://webcuoi-khac-chinh.vercel.app/api`.

Hai domain thuộc hai project khác nhau. Không đặt `API_BASE_URL` bằng domain
frontend: `/api/health` trên frontend bị SPA rewrite thành trang HTML Flutter,
không phải phản hồi JSON của backend.

## Project frontend

Import repository vào một project Vercel riêng, với Root Directory là `webcuoi`
(thư mục chứa `pubspec.yaml`). Chọn Framework Preset `Other`.

File `vercel.json` đã cấu hình:

- Install Command: `bash scripts/vercel-install.sh`
- Build Command: `bash scripts/vercel-build.sh`
- Output Directory: `build/web`

Script build mặc định dùng backend ở trên. Có thể ghi đè bằng biến môi trường
`API_BASE_URL` trên project frontend; giá trị phải bao gồm `/api`.
Sau khi thay đổi URL, build/deploy lại frontend.

Nếu đã đặt biến này trên Vercel, kiểm tra giá trị trong môi trường Production:

```text
API_BASE_URL=https://webcuoi-khac-chinh.vercel.app/api
```

Giá trị trên Vercel ghi đè mặc định trong code và được nhúng vào Flutter lúc build.

## CORS trên backend

Trên project backend phục vụ `https://webcuoi-khac-chinh.vercel.app`
(Root Directory: `server`), vào Settings → Environment Variables và thêm origin frontend vào `CORS_ORIGINS`
của môi trường Production. Ví dụ nếu giữ các origin mặc định đang dùng:

```text
CORS_ORIGINS=http://localhost:3000,http://localhost:5000,http://localhost:8080,https://webcuoi-khac-chinh.vercel.app,https://webcuoikhacchinh-webcuoi.vercel.app,https://webcuoikhacchinh-webcuoi-92e7-mocha.vercel.app
```

Nếu cấu hình hiện tại có origin khác, giữ chúng và thêm domain frontend ở cuối,
phân tách bằng dấu phẩy. Origin không chứa `/api` hoặc dấu `/` cuối.

CORS đối chiếu chính xác origin mà trình duyệt gửi. Domain có hậu tố
`-92e7-mocha` là origin khác với domain không có hậu tố, nên cần khai báo cả hai
nếu sử dụng cả hai địa chỉ. Khi đổi domain frontend, thêm đúng origin mới vào danh sách.

Sửa `server/.env` chỉ thay đổi cấu hình local; thao tác đó không cập nhật biến môi
trường trên Vercel. Cần cập nhật `CORS_ORIGINS` trực tiếp trong project backend
trên Vercel rồi redeploy để bản online nhận cấu hình mới.

`CORS_ORIGINS` trên Vercel thay thế toàn bộ danh sách mặc định trong
`server/src/app.js`. Sửa danh sách mặc định trong code sẽ không có tác dụng nếu
biến môi trường vẫn chứa danh sách cũ. Sau khi cập nhật biến, redeploy **backend**
từ commit mới nhất; chỉ redeploy frontend không cập nhật CORS của API.

## Chạy trên máy với backend đã deploy

Trong thư mục `webcuoi`:

```powershell
flutter run -d chrome --web-port=8080 --dart-define=API_BASE_URL=https://webcuoi-khac-chinh.vercel.app/api
```

Build thủ công để deploy static:

```powershell
flutter build web --release --dart-define=API_BASE_URL=https://webcuoi-khac-chinh.vercel.app/api
```

## Kiểm tra sau khi deploy

- Backend: `GET https://webcuoi-khac-chinh.vercel.app/api/health` trả HTTP 200,
  `Content-Type: application/json` và `{"success":true,"status":"ok"}`.
- Mở domain frontend và kiểm tra tải sổ lưu bút, địa điểm.
- Network của trình duyệt phải gọi đúng backend, không bị lỗi CORS.
- Thiệp `minimalism-nau-demo` phải tồn tại trong database để các API của frontend hoạt động.

Kiểm tra preflight mà không ghi dữ liệu vào database:

```powershell
curl.exe -i -X OPTIONS "https://webcuoi-khac-chinh.vercel.app/api/invitations/minimalism-nau-demo/guestbook" --header "Origin: https://webcuoikhacchinh-webcuoi-92e7-mocha.vercel.app" --header "Access-Control-Request-Method: POST" --header "Access-Control-Request-Headers: content-type"
```

Phản hồi phải có `Access-Control-Allow-Origin: https://webcuoikhacchinh-webcuoi-92e7-mocha.vercel.app`
và cho phép method `POST`, header `Content-Type`. HTTP 204 mà thiếu
`Access-Control-Allow-Origin` vẫn bị trình duyệt chặn.

Nếu health trả HTTP 503, kiểm tra Runtime Logs của backend, biến `MONGODB_URI`
trên Vercel và quyền kết nối MongoDB Atlas. Đây là lỗi backend/database cần xử lý
riêng; đổi URL frontend không khắc phục được.
