Wedding Website 💍
Website thiệp cưới trực tuyến được xây dựng với Flutter Web ở frontend và Node.js + Express + MongoDB (Mongoose) ở backend. Website giúp cô dâu chú rể chia sẻ thông tin ngày cưới, gửi thiệp mời trực tuyến và nhận lời chúc từ khách mời.
✨ Tính năng
Khách mời
- Xem thiệp cưới và thông tin cô dâu, chú rể.
- Xem ngày giờ, địa điểm tổ chức lễ cưới và hướng dẫn đường đi.
- Xem album ảnh cưới.
- Gửi lời chúc đến cô dâu chú rể.
- Xem danh sách lời chúc được cập nhật từ hệ thống.
- Trải nghiệm giao diện tương thích với máy tính, máy tính bảng và điện thoại.
Quản lý (có thể phát triển thêm)
- Quản lý nội dung thiệp cưới và album ảnh.
- Xem, tìm kiếm hoặc ẩn lời chúc không phù hợp.
- Thống kê lượt truy cập và lời chúc.
- Quản lý danh sách khách mời và xác nhận tham dự (RSVP).
Các tính năng quản trị, RSVP và thống kê là định hướng mở rộng, không mặc định đã được triển khai.

🧰 Công nghệ sử dụng
Thành phần	Công nghệ
Frontend	Flutter Web, Dart
Gọi API	http hoặc dio
Backend	Node.js, Express.js
Cơ sở dữ liệu	MongoDB
ODM	Mongoose
Cấu hình môi trường	dotenv
Bảo mật HTTP cơ bản	helmet
Cho phép truy cập API từ frontend	cors
Kiểm thử API	Postman hoặc Bruno
Quản lý mã nguồn	Git, GitHub


📁 Cấu trúc dự án tham khảo
wedding-website/
├── client/                         # Flutter Web frontend
│   ├── lib/
│   │   ├── app/
│   │   │   ├── app.dart
│   │   │   └── routes.dart
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   ├── theme/
│   │   │   └── utils/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── services/
│   │   ├── features/
│   │   │   ├── invitation/
│   │   │   ├── gallery/
│   │   │   └── wishes/
│   │   ├── widgets/
│   │   └── main.dart
│   ├── assets/
│   │   ├── images/
│   │   └── fonts/
│   ├── web/
│   ├── pubspec.yaml
│   └── README.md
│
├── server/                         # Node.js backend
│   ├── src/
│   │   ├── config/
│   │   │   └── database.js
│   │   ├── controllers/
│   │   │   └── wish.controller.js
│   │   ├── middleware/
│   │   │   └── error.middleware.js
│   │   ├── models/
│   │   │   └── Wish.js
│   │   ├── routes/
│   │   │   └── wish.routes.js
│   │   ├── services/
│   │   ├── app.js
│   │   └── server.js
│   ├── .env.example
│   ├── .gitignore
│   └── package.json
│
├── .gitignore
└── README.md
Đây là cấu trúc gợi ý; có thể điều chỉnh tên thư mục và module cho phù hợp với mã nguồn thực tế.
⚙️ Yêu cầu môi trường
Cài đặt trước:
- Flutter SDK
- Node.js LTS
- MongoDB Atlas hoặc MongoDB cài trên máy
- Git
- Trình duyệt hiện đại
Kiểm tra cài đặt:
flutter --version
dart --version
node --version
npm --version
git --version
🚀 Cài đặt và chạy dự án
1. Clone repository
git clone <YOUR_REPOSITORY_URL>
cd wedding-website
Thay <YOUR_REPOSITORY_URL> bằng URL repository thực tế.
2. Khởi chạy backend
cd server
npm install
Tạo file .env trong thư mục server/ dựa trên .env.example:
PORT=3000
NODE_ENV=development
MONGODB_URI=mongodb+srv://<username>:<password>@<cluster>/<database>
CLIENT_URL=http://localhost:xxxxx
- Thay các giá trị MongoDB bằng thông tin kết nối của bạn.
- Thay xxxxx bằng cổng mà Flutter Web đang chạy.
- Không commit file .env lên Git.
- Nếu mật khẩu MongoDB có ký tự đặc biệt, hãy URL-encode theo yêu cầu của MongoDB.
Khởi chạy backend theo script đã khai báo trong package.json, ví dụ:
npm run dev
Nếu dự án chưa có script dev, hãy thêm script phù hợp hoặc chạy entry point đã cấu hình, ví dụ node src/server.js.
3. Khởi chạy Flutter Web
Mở terminal mới:
cd client
flutter pub get
flutter run -d chrome
Nếu backend chạy ở địa chỉ khác, hãy cập nhật API base URL trong cấu hình của frontend. Không nên cố định localhost trong bản production.
4. Build frontend để triển khai
cd client
flutter build web --release
Thư mục build thường nằm tại:
client/build/web/
Có thể triển khai thư mục này lên dịch vụ hosting web tĩnh có hỗ trợ cấu hình đường dẫn SPA. Backend Node.js cần được triển khai riêng hoặc qua nền tảng hỗ trợ cả frontend và backend.
🔐 Biến môi trường backend
Ví dụ nội dung server/.env.example:
PORT=3000
NODE_ENV=development
MONGODB_URI=
CLIENT_URL=
Không đưa API key, mật khẩu, URI có thông tin xác thực hoặc dữ liệu nhạy cảm lên repository công khai. Cấu hình biến môi trường production tại nền tảng triển khai.
🗃️ MongoDB và Mongoose
MongoDB lưu dữ liệu dạng document; Mongoose giúp định nghĩa schema, kiểm tra dữ liệu và thao tác với collection.

Ví dụ dữ liệu lời chúc:
{
  "name": "Nguyễn Văn A",
  "message": "Chúc hai bạn trăm năm hạnh phúc!",
  "createdAt": "2026-10-27T05:00:00.000Z"
}
Schema thực tế nên quy định độ dài tối đa cho tên và lời chúc, tự tạo createdAt, và không cho phép client tự gửi các trường hệ thống.
🔌 API dự kiến
Tiền tố API ví dụ: /api
Method	Endpoint	Mục đích
GET	/api/wishes	Lấy danh sách lời chúc
POST	/api/wishes	Gửi lời chúc mới
GET	/api/health	Kiểm tra trạng thái backend


Ví dụ request gửi lời chúc:
POST /api/wishes
Content-Type: application/json
{
  "name": "Nguyễn Văn A",
  "message": "Chúc hai bạn luôn hạnh phúc!"
}
Ví dụ response thành công:
{
  "success": true,
  "data": {
    "name": "Nguyễn Văn A",
    "message": "Chúc hai bạn luôn hạnh phúc!",
    "createdAt": "2026-10-27T05:00:00.000Z"
  }
}
Đây là hợp đồng API tham khảo; response thực tế phụ thuộc vào phần backend được triển khai.
Luồng gửi lời chúc
1. Khách nhập tên và lời chúc trên Flutter Web.
2. Frontend kiểm tra dữ liệu cơ bản rồi gửi POST /api/wishes.
3. Express kiểm tra dữ liệu và Mongoose lưu vào MongoDB.
4. Backend trả kết quả cho frontend.
5. Frontend cập nhật danh sách lời chúc bằng cách gọi lại API hoặc thêm bản ghi vừa tạo vào giao diện.
Nếu muốn lời chúc cập nhật tức thời trên nhiều thiết bị mà không cần tải lại, có thể bổ sung polling hoặc WebSocket/Socket.IO.
🛡️ Lưu ý bảo mật và triển khai
- Chỉ cho phép origin frontend cần thiết trong cấu hình CORS.
- Validate dữ liệu ở backend; không chỉ dựa vào validation của Flutter.
- Giới hạn độ dài tên và nội dung lời chúc.
- Cân nhắc rate limiting, chống spam và cơ chế kiểm duyệt lời chúc.
- Không kết nối trực tiếp Flutter Web với MongoDB; mọi thao tác dữ liệu phải đi qua backend.
- Dùng HTTPS trong môi trường production.
- Lưu ảnh trên dịch vụ lưu trữ ảnh/object storage thay vì lưu file ảnh lớn trực tiếp trong document MongoDB.
- Cấu hình URL API theo môi trường development/staging/production.
- Sao lưu dữ liệu MongoDB định kỳ và hạn chế quyền truy cập database.
🧪 Kiểm thử
- Kiểm tra API bằng Postman hoặc Bruno.
- Kiểm tra trường hợp gửi thiếu tên, thiếu lời chúc hoặc nội dung quá dài.
- Kiểm tra lỗi kết nối database và lỗi server.
- Kiểm tra giao diện trên màn hình điện thoại và máy tính.
- Kiểm tra CORS khi frontend và backend chạy ở các origin khác nhau.
🌐 Triển khai tham khảo
- Frontend Flutter Web: Firebase Hosting, Cloudflare Pages hoặc dịch vụ static hosting phù hợp.
- Backend Node.js: Render, Railway, Fly.io hoặc VPS.
- Database: MongoDB Atlas.
Các dịch vụ có thể thay đổi giới hạn, giá và cách cấu hình; hãy kiểm tra tài liệu chính thức trước khi triển khai.
🗺️ Lộ trình phát triển
- [ ] Hoàn thiện giao diện thiệp cưới responsive.
- [ ] Hiển thị thông tin cô dâu, chú rể và lịch trình.
- [ ] Album ảnh cưới.
- [ ] API gửi và đọc lời chúc.
- [ ] Trạng thái tải, lỗi và thông báo thành công trên frontend.
- [ ] RSVP xác nhận tham dự.
- [ ] Trang quản trị lời chúc.
- [ ] Chống spam và kiểm duyệt nội dung.
- [ ] Tối ưu SEO, metadata và chia sẻ liên kết.
- [ ] Triển khai production và cấu hình tên miền.
🤝 Đóng góp
1. Fork repository.
2. Tạo branch mới: git checkout -b feature/ten-tinh-nang.
3. Commit thay đổi: git commit -m "feat: mo ta tinh nang".
4. Push branch và tạo Pull Request.
📄 License
Chưa xác định. Hãy bổ sung giấy phép phù hợp trước khi công bố hoặc cho phép người khác sử dụng mã nguồn.

Made with ❤️ for a beautiful beginning.
