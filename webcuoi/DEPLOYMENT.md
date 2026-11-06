# Deploy frontend lên Vercel

Backend: `https://webcuoi-khac-chinh.vercel.app`.
API base URL: `https://webcuoi-khac-chinh.vercel.app/api`.

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

## CORS trên backend

Sau khi có domain frontend, thêm origin chính xác đó vào `CORS_ORIGINS`
trên project backend. Giữ các origin đang dùng và phân tách bằng dấu phẩy.
Origin frontend có dạng `https://<domain-frontend>`, không có `/api` hoặc dấu `/`
cuối. Redeploy backend sau khi thay đổi biến môi trường.

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

- Backend: `GET https://webcuoi-khac-chinh.vercel.app/api/health` trả HTTP 200.
- Mở domain frontend và kiểm tra tải sổ lưu bút, địa điểm.
- Network của trình duyệt phải gọi đúng backend, không bị lỗi CORS.
- Thiệp `minimalism-nau-demo` phải tồn tại trong database để các API của frontend hoạt động.
