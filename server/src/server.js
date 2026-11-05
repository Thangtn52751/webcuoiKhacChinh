
require('dotenv').config();

const app = require('./app');
const mongoose = require('mongoose');
const { connectDatabase } = require('./config/database');

const port = Number(process.env.PORT) || 3000;

const publicUrl = (
  process.env.API_PUBLIC_URL || `http://localhost:${port}`
).trim().replace(/\/+$/, '');

async function start() {
  await connectDatabase();

  const server = app.listen(port, '0.0.0.0', () => {
    console.log('================================');
    console.log('       WEBCUOI API SERVER       ');
    console.log('================================');
    console.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`API URL: ${publicUrl}`);
    console.log(`Health Check: ${publicUrl}/api/health`);
    console.log('================================');
  });

  const shutdown = async (signal) => {
    console.log(`Nhận ${signal}, đang đóng máy chủ...`);

    server.close(async () => {
      try {
        await mongoose.disconnect();
        console.log('Đã ngắt kết nối MongoDB.');
        process.exit(0);
      } catch (error) {
        console.error('Lỗi khi đóng MongoDB:', error.message);
        process.exit(1);
      }
    });
  };

  process.once('SIGINT', () => shutdown('SIGINT'));
  process.once('SIGTERM', () => shutdown('SIGTERM'));
}

start().catch((error) => {
  console.error('Không thể khởi động WebCuoi API:', error.message);
  process.exit(1);
});
