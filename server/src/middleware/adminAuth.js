const crypto = require('node:crypto');

function requireAdmin(req, res, next) {
  const expected = process.env.ADMIN_API_KEY;
  if (!expected) {
    return res.status(503).json({ message: 'API quản trị chưa được cấu hình.' });
  }

  const supplied = req.get('authorization')?.replace(/^Bearer\s+/i, '') ?? '';
  const expectedBuffer = Buffer.from(expected);
  const suppliedBuffer = Buffer.from(supplied);
  const matches = expectedBuffer.length === suppliedBuffer.length
    && crypto.timingSafeEqual(expectedBuffer, suppliedBuffer);

  if (!matches) {
    return res.status(401).json({ message: 'Không có quyền truy cập.' });
  }
  return next();
}

module.exports = { requireAdmin };
