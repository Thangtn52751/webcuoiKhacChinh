const nodemailer = require('nodemailer');

let transporter;

function getTransporter() {
  const { SMTP_HOST, SMTP_USER, SMTP_PASS } = process.env;
  if (!SMTP_HOST || !SMTP_USER || !SMTP_PASS) {
    throw new Error('Thiếu SMTP_HOST, SMTP_USER hoặc SMTP_PASS trong .env');
  }

  if (!transporter) {
    const port = Number(process.env.SMTP_PORT) || 587;
    const secure = process.env.SMTP_SECURE === 'true' || port === 465;
    transporter = nodemailer.createTransport({
      host: SMTP_HOST,
      port,
      secure,
      auth: { user: SMTP_USER, pass: SMTP_PASS },
    });
  }
  return transporter;
}

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (character) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
  })[character]);
}

async function sendRsvpNotification({ invitation, rsvp }) {
  const to = process.env.RSVP_NOTIFICATION_EMAIL;
  if (!to) {
    throw new Error('Thiếu RSVP_NOTIFICATION_EMAIL trong .env');
  }

  const attending = rsvp.attendance === 'attending';
  const attendanceLabel = attending ? 'Sẽ tham dự' : 'Rất tiếc, không thể đến';
  const guestCount = attending ? rsvp.guestCount : 0;
  const groom = invitation.couple?.groom?.name || 'Chú rể';
  const bride = invitation.couple?.bride?.name || 'Cô dâu';
  const submittedAt = new Date(rsvp.createdAt || Date.now()).toLocaleString('vi-VN', {
    timeZone: 'Asia/Ho_Chi_Minh',
  });

  const fields = [
    ['Khách mời', rsvp.guestName],
    ['Trạng thái', attendanceLabel],
    ['Số người', String(guestCount)],
    ['Số điện thoại', rsvp.phone || 'Không cung cấp'],
    ['Lời nhắn', rsvp.note || 'Không có'],
    ['Thời gian xác nhận', submittedAt],
  ];
  const text = [
    `Có xác nhận tham dự mới cho thiệp ${groom} & ${bride}.`,
    '',
    ...fields.map(([label, value]) => `${label}: ${value}`),
  ].join('\n');
  const rows = fields.map(([label, value]) => (
    `<tr><th style="padding:8px;text-align:left">${escapeHtml(label)}</th>`
    + `<td style="padding:8px">${escapeHtml(value)}</td></tr>`
  )).join('');
  const html = `<div style="font-family:Arial,sans-serif;color:#3b3029">`
    + `<h2>Xác nhận tham dự mới</h2>`
    + `<p>Thiệp cưới ${escapeHtml(groom)} &amp; ${escapeHtml(bride)}</p>`
    + `<table style="border-collapse:collapse">${rows}</table></div>`;

  const from = process.env.SMTP_FROM || process.env.SMTP_USER;
  return getTransporter().sendMail({
    from,
    to,
    subject: `[WebCuoi] RSVP ${attendanceLabel} — ${rsvp.guestName}`,
    text,
    html,
  });
}

module.exports = { sendRsvpNotification };
