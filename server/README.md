# WebCuoi API

REST API Node.js, Express và MongoDB/Mongoose cho các nội dung và tương tác trong thiệp cưới Minimalism Nâu.

## Chạy local

1. Cài Node.js `>=20.19` và chạy MongoDB local hoặc chuẩn bị MongoDB Atlas.
2. Trong thư mục `server`, sao chép `.env.example` thành `.env` và chỉnh `MONGODB_URI`, `CORS_ORIGINS`, `ADMIN_API_KEY` cùng các biến SMTP và `RSVP_NOTIFICATION_EMAIL`.
3. Chạy `npm install`.
4. Tạo dữ liệu thiệp mẫu bằng `npm run seed:demo`.
5. Khởi động API bằng `npm run dev` hoặc `npm start`.

Mặc định API chạy ở `http://localhost:3000`. Kiểm tra trạng thái tại `GET /api/health`.

## API công khai

| Method | Endpoint | Mục đích |
| --- | --- | --- |
| GET | `/api/invitations/:slug` | Lấy thông tin cặp đôi, lễ cưới, album, địa điểm, dress code, lịch trình, theme và tài khoản mừng |
| POST | `/api/invitations/:slug/rsvps` | Gửi xác nhận tham dự |
| GET | `/api/invitations/:slug/guestbook` | Đọc các lời chúc |
| POST | `/api/invitations/:slug/guestbook` | Thêm lời chúc mới |

Ví dụ RSVP:

```json
{
  "guestName": "Nguyễn An",
  "phone": "0900000000",
  "attendance": "attending",
  "guestCount": 2,
  "note": "Mình sẽ đến đúng giờ"
}
```

Sau khi lưu RSVP vào MongoDB, server gửi email đến `RSVP_NOTIFICATION_EMAIL` cho cả lựa chọn `attending` và `not-attending`. Cấu hình `SMTP_HOST`, `SMTP_PORT`, `SMTP_SECURE`, `SMTP_USER`, `SMTP_PASS` và tùy chọn `SMTP_FROM` trong `.env`. Nếu email lỗi, RSVP vẫn được lưu; API trả `notificationSent: false` để frontend có thể báo trạng thái.

Ví dụ lời chúc:

```json
{
  "name": "Nguyễn An",
  "message": "Chúc hai bạn trăm năm hạnh phúc!"
}
```

## API quản trị

Gửi header `Authorization: Bearer <ADMIN_API_KEY>` cho các endpoint dưới đây. API key phải được đặt trong `.env`.

| Method | Endpoint | Mục đích |
| --- | --- | --- |
| POST | `/api/invitations` | Tạo thiệp |
| PATCH | `/api/invitations/:slug` | Cập nhật dữ liệu thiệp |
| GET | `/api/invitations/:slug/rsvps` | Xem danh sách RSVP |

Album, dress code, lịch trình, thông tin địa điểm và hộp quà được lưu trong tài liệu thiệp để frontend tải cùng một lần. Countdown được tính từ `ceremony.startsAt` hoặc `reception.startsAt`, không lưu số đếm ngược vào DB.

Sổ lưu bút chỉ hỗ trợ xem và thêm lời chúc. Không có API sửa hoặc xóa lời chúc.

`npm run seed:demo` tạo/cập nhật thiệp `minimalism-nau-demo`. Dữ liệu mẫu không chứa tài khoản ngân hàng hoặc ảnh cá nhân; hãy cấu hình các nội dung đó qua API quản trị trước khi dùng thiệp thật.
