function notFound(req, res) {
  res.status(404).json({ message: `Không tìm thấy API: ${req.method} ${req.originalUrl}` });
}

function errorHandler(error, req, res, next) {
  if (res.headersSent) return next(error);

  if (error.name === 'ValidationError' || error.name === 'CastError') {
    return res.status(400).json({ message: 'Dữ liệu không hợp lệ.', details: error.message });
  }
  if (error.code === 11000) {
    return res.status(409).json({ message: 'Slug thiệp đã tồn tại.' });
  }
  if (error.type === 'entity.too.large') {
    return res.status(413).json({ message: 'Nội dung gửi lên quá lớn.' });
  }

  console.error(error);
  return res.status(500).json({ message: 'Đã xảy ra lỗi máy chủ.' });
}

module.exports = { notFound, errorHandler };
