require('dotenv').config();

const app = require('./app');
const mongoose = require('mongoose');
const { connectDatabase } = require('./config/database');

const port = Number(process.env.PORT) || 3000;

async function start() {
  await connectDatabase();
  const server = app.listen(port, () => {
    console.log(`WebCuoi API đang chạy tại http://localhost:${port}`);
  });

  const shutdown = async (signal) => {
    console.log(`Nhận ${signal}, đang đóng máy chủ...`);
    server.close(async () => {
      await mongoose.disconnect();
      process.exit(0);
    });
  };

  process.once('SIGINT', () => shutdown('SIGINT'));
  process.once('SIGTERM', () => shutdown('SIGTERM'));
}

start().catch((error) => {
  console.error('Không thể khởi động WebCuoi API:', error.message);
  process.exit(1);
});
