
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { rateLimit } = require('express-rate-limit');
const mongoose = require('mongoose');

const invitationRoutes = require('./routes/invitations');
const { notFound, errorHandler } = require('./middleware/errorHandler');
const { connectDatabase } = require('./config/database');

const app = express();

let databaseConnection;

const configuredOrigins = (
  process.env.CORS_ORIGINS ||
  'http://localhost:3000,http://localhost:5000,http://localhost:8080,https://webcuoi-khac-chinh.vercel.app'
)
  .split(',')
  .map((origin) => origin.trim().replace(/\/+$/, ''))
  .filter(Boolean);

app.disable('x-powered-by');

app.use(helmet());

app.use(cors({
  origin: configuredOrigins.includes('*') ? '*' : configuredOrigins,
  methods: ['GET', 'POST', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(express.json({ limit: '1mb' }));

app.use((req, res, next) => {
  if (!req.body || typeof req.body !== 'object' || Array.isArray(req.body)) {
    req.body = {};
  }

  next();
});

app.use(rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 120,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
}));

async function ensureDatabaseConnected() {
  if (mongoose.connection.readyState === 1) {
    return;
  }

  if (!databaseConnection) {
    databaseConnection = connectDatabase().catch((error) => {
      databaseConnection = undefined;
      throw error;
    });
  }

  await databaseConnection;
}

app.use(async (req, res, next) => {
  try {
    await ensureDatabaseConnected();
    next();
  } catch (error) {
    console.error('Không thể kết nối MongoDB:', error.message);

    res.status(503).json({
      success: false,
      message: 'Máy chủ chưa sẵn sàng. Vui lòng thử lại.',
    });
  }
});

app.get('/api/health', (req, res) => {
  const ready = mongoose.connection.readyState === 1;

  res.status(ready ? 200 : 503).json({
    success: ready,
    status: ready ? 'ok' : 'database-unavailable',
  });
});

app.use('/api/invitations', invitationRoutes);

app.use(notFound);

app.use(errorHandler);

module.exports = app;
