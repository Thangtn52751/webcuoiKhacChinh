const { onRequest } = require('firebase-functions/v2/https');
const { defineSecret, defineString } = require('firebase-functions/params');
const mongoose = require('mongoose');

const app = require('./src/app');
const { connectDatabase } = require('./src/config/database');

const MONGODB_URI = defineSecret('MONGODB_URI');
const SMTP_USER = defineSecret('SMTP_USER');
const SMTP_PASS = defineSecret('SMTP_PASS');
const RSVP_NOTIFICATION_EMAIL = defineSecret('RSVP_NOTIFICATION_EMAIL');
const ADMIN_API_KEY = defineSecret('ADMIN_API_KEY');

const SMTP_HOST = defineString('SMTP_HOST');
const SMTP_PORT = defineString('SMTP_PORT');
const SMTP_SECURE = defineString('SMTP_SECURE');
const GOOGLE_MAPS_EMBED_API_KEY = defineString(
  'GOOGLE_MAPS_EMBED_API_KEY',
  { default: '' },
);

let databaseConnection;

function loadEnvironment() {
  process.env.MONGODB_URI = MONGODB_URI.value();
  process.env.SMTP_USER = SMTP_USER.value();
  process.env.SMTP_PASS = SMTP_PASS.value();
  process.env.RSVP_NOTIFICATION_EMAIL = RSVP_NOTIFICATION_EMAIL.value();
  process.env.ADMIN_API_KEY = ADMIN_API_KEY.value();
  process.env.SMTP_HOST = SMTP_HOST.value();
  process.env.SMTP_PORT = SMTP_PORT.value();
  process.env.SMTP_SECURE = SMTP_SECURE.value();

  const mapsKey = GOOGLE_MAPS_EMBED_API_KEY.value();
  if (mapsKey) {
    process.env.GOOGLE_MAPS_EMBED_API_KEY = mapsKey;
  } else {
    delete process.env.GOOGLE_MAPS_EMBED_API_KEY;
  }
}

async function ensureDatabaseConnected() {
  if (mongoose.connection.readyState === 1) return;
  if (!databaseConnection) {
    databaseConnection = connectDatabase().catch((error) => {
      databaseConnection = undefined;
      throw error;
    });
  }
  await databaseConnection;
}

exports.api = onRequest({
  region: 'asia-southeast1',
  minInstances: 1,
  maxInstances: 5,
  memory: '512MiB',
  timeoutSeconds: 60,
  secrets: [
    MONGODB_URI,
    SMTP_USER,
    SMTP_PASS,
    RSVP_NOTIFICATION_EMAIL,
    ADMIN_API_KEY,
  ],
}, async (req, res) => {
  try {
    loadEnvironment();
    await ensureDatabaseConnected();
    app(req, res);
  } catch (error) {
    console.error('Không thể khởi tạo WebCuoi API:', error.message);
    res.status(503).json({ message: 'Máy chủ chưa sẵn sàng. Vui lòng thử lại.' });
  }
});
