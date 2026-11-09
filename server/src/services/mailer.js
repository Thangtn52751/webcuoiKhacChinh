
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
    const host = SMTP_HOST.trim();
    const user = SMTP_USER.trim();
    // Google displays app passwords in groups separated by spaces. Gmail's
    // SMTP AUTH expects the 16-character password without those separators.
    const pass = host.toLowerCase() === 'smtp.gmail.com'
      ? SMTP_PASS.replace(/\s/g, '')
      : SMTP_PASS;

    transporter = nodemailer.createTransport({
      host,
      port,
      secure,
      auth: {
        user,
        pass,
      },
    });
  }

  return transporter;
}

function normalizeText(value) {
  return String(value ?? '').normalize('NFC');
}

function escapeHtml(value) {
  return normalizeText(value).replace(/[&<>"']/g, (character) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
  })[character]);
}

function formatDate(value) {
  const date = new Date(value || Date.now());

  if (Number.isNaN(date.getTime())) {
    return 'Không xác định';
  }

  return new Intl.DateTimeFormat('vi-VN', {
    timeZone: 'Asia/Ho_Chi_Minh',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  }).format(date);
}

async function sendRsvpNotification({ invitation, rsvp }) {
  const recipients = [
    process.env.RSVP_NOTIFICATION_EMAIL,
    process.env.RSVP_NOTIFICATION_EMAIL_2,
  ]
    .map((email) => email?.trim())
    .filter(Boolean);

  if (recipients.length === 0) {
    throw new Error('Thiếu RSVP_NOTIFICATION_EMAIL trong .env');
  }

  const attending = rsvp.attendance === 'attending';

  const attendanceLabel = attending
    ? 'Sẽ tham dự'
    : 'Rất tiếc, không thể đến';

  const groom = normalizeText(
    invitation.couple?.groom?.name || 'Chú rể'
  );

  const bride = normalizeText(
    invitation.couple?.bride?.name || 'Cô dâu'
  );

  const guestName = normalizeText(
    rsvp.guestName || 'Khách mời chưa cung cấp tên'
  );

  const submittedAt = formatDate(rsvp.createdAt);

  const statusColor = attending ? '#64745B' : '#A47769';
  const statusBackground = attending ? '#EEF2EA' : '#F7EEEA';
  const statusBorder = attending ? '#DDE5D6' : '#EBDCD5';
  const statusIcon = attending ? '&#10003;' : '&#10005;';

  const fontFamily = 'Tahoma, Arial, Helvetica, sans-serif';

  const fields = [
    ['Họ và tên khách mời', guestName],
    ['Phản hồi', attendanceLabel],
    ['Thời gian xác nhận', submittedAt],
  ];

  const detailRows = fields.map(([label, value], index) => {
    const isLast = index === fields.length - 1;

    return `
      <tr>
        <td
          align="left"
          valign="middle"
          width="42%"
          style="
            padding: 17px 10px 17px 0;
            border-bottom: ${isLast ? '0' : '1px solid #E9E1D8'};
            color: #806D62;
            font-family: ${fontFamily};
            font-size: 13px;
            line-height: 1.8;
          "
        >
          ${escapeHtml(label)}
        </td>

        <td
          align="right"
          valign="middle"
          style="
            padding: 17px 0 17px 10px;
            border-bottom: ${isLast ? '0' : '1px solid #E9E1D8'};
            color: #493C34;
            font-family: ${fontFamily};
            font-size: 14px;
            line-height: 1.8;
            font-weight: 600;
            word-break: break-word;
          "
        >
          ${escapeHtml(value)}
        </td>
      </tr>
    `;
  }).join('');

  const text = [
    'Thông báo khách mời đám cưới',
    '----------------------------------------',
    'Bạn vừa nhận được một phản hồi xác nhận tham dự mới.',
    '',
    `${groom} & ${bride}`,
    '',
    ...fields.map(([label, value]) => `${label}: ${value}`),
    '',
    '----------------------------------------',
    'Thông báo tự động từ website thiệp cưới WebCuoi.',
  ].join('\n').normalize('NFC');

  const html = `
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="x-apple-disable-message-reformatting">
  <title>Wedding RSVP - ${escapeHtml(groom)} & ${escapeHtml(bride)}</title>
</head>

<body
  bgcolor="#F1ECE6"
  style="
    margin: 0;
    padding: 0;
    background-color: #F1ECE6;
    font-family: ${fontFamily};
    -webkit-font-smoothing: antialiased;
  "
>

  <div style="
    display: none;
    max-height: 0;
    overflow: hidden;
    opacity: 0;
    color: transparent;
    font-size: 1px;
    line-height: 1px;
  ">
    Bạn vừa nhận được phản hồi RSVP mới từ khách mời.
  </div>

  <table
    role="presentation"
    width="100%"
    cellspacing="0"
    cellpadding="0"
    border="0"
    bgcolor="#F1ECE6"
    style="
      width: 100%;
      background-color: #F1ECE6;
      padding: 40px 12px;
    "
  >
    <tr>
      <td align="center">

        <table
          role="presentation"
          width="100%"
          cellspacing="0"
          cellpadding="0"
          border="0"
          style="
            width: 100%;
            max-width: 600px;
          "
        >

          <!-- Decorative top -->
          <tr>
            <td align="center" style="padding: 0 30px 22px;">
              <table
                role="presentation"
                width="100%"
                cellspacing="0"
                cellpadding="0"
                border="0"
              >
                <tr>
                  <td
                    width="40%"
                    style="border-top: 1px solid #C6B49F;"
                  ></td>

                  <td
                    width="20%"
                    align="center"
                    style="
                      color: #A88D72;
                      font-family: ${fontFamily};
                      font-size: 17px;
                    "
                  >
                    &#10087;
                  </td>

                  <td
                    width="40%"
                    style="border-top: 1px solid #C6B49F;"
                  ></td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Main card -->
          <tr>
            <td
              bgcolor="#FFFDFA"
              style="
                background-color: #FFFDFA;
                border: 1px solid #E6DCD1;
              "
            >

              <!-- Header -->
              <table
                role="presentation"
                width="100%"
                cellspacing="0"
                cellpadding="0"
                border="0"
              >
                <tr>
                  <td
                    align="center"
                    bgcolor="#F8F4EE"
                    style="
                      padding: 42px 24px 36px;
                      background-color: #F8F4EE;
                      border-bottom: 1px solid #E9E0D6;
                    "
                  >

                    <div style="
                      color: #806D62;
                      font-family: ${fontFamily};
                      font-size: 10px;
                      line-height: 1.8;
                      font-weight: 600;
                      letter-spacing: 3px;
                    ">
                      WEDDING INVITATION
                    </div>

                    <div style="
                      padding: 21px 0 16px;
                      color: #A88D72;
                      font-family: ${fontFamily};
                      font-size: 28px;
                      line-height: 1.5;
                    ">
                      &#10087;
                    </div>

                    <div style="
                      color: #493C34;
                      font-family: ${fontFamily};
                      font-size: 25px;
                      line-height: 1.8;
                      font-weight: 400;
                    ">
                      Một lời hồi đáp<br>
                      vừa được gửi đến
                    </div>

                    <table
                      role="presentation"
                      width="44"
                      cellspacing="0"
                      cellpadding="0"
                      border="0"
                      style="margin: 20px auto;"
                    >
                      <tr>
                        <td style="border-top: 1px solid #C7B49F;"></td>
                      </tr>
                    </table>

                    <div style="
                      color: #806D62;
                      font-family: ${fontFamily};
                      font-size: 14px;
                      line-height: 1.9;
                    ">
                      Trân trọng thông báo về thiệp cưới
                    </div>

                    <div style="
                      padding-top: 8px;
                      color: #493C34;
                      font-family: ${fontFamily};
                      font-size: 22px;
                      line-height: 1.8;
                      font-weight: 500;
                    ">
                      ${escapeHtml(groom)}
                      <span style="color: #B49A7E;">&amp;</span>
                      ${escapeHtml(bride)}
                    </div>

                  </td>
                </tr>

                <!-- Main content -->
                <tr>
                  <td style="padding: 36px 24px 38px;">

                    <div style="
                      color: #806D62;
                      font-family: ${fontFamily};
                      font-size: 10px;
                      line-height: 1.8;
                      letter-spacing: 2.5px;
                      font-weight: 600;
                      text-align: center;
                    ">
                      GUEST RESPONSE
                    </div>

                    <div style="
                      padding-top: 12px;
                      color: #493C34;
                      font-family: ${fontFamily};
                      font-size: 20px;
                      line-height: 1.8;
                      text-align: center;
                    ">
                      Thông tin xác nhận tham dự
                    </div>

                    <div style="
                      padding: 7px 0 25px;
                      color: #806D62;
                      font-family: ${fontFamily};
                      font-size: 13px;
                      line-height: 1.9;
                      text-align: center;
                    ">
                      Hệ thống đã ghi nhận phản hồi từ một vị khách mời.
                    </div>

                    <!-- Attendance status -->
                    <table
                      role="presentation"
                      cellspacing="0"
                      cellpadding="0"
                      border="0"
                      align="center"
                      style="margin: 0 auto 28px;"
                    >
                      <tr>
                        <td
                          align="center"
                          bgcolor="${statusBackground}"
                          style="
                            padding: 10px 22px;
                            border: 1px solid ${statusBorder};
                            border-radius: 30px;
                          "
                        >
                          <span style="
                            color: ${statusColor};
                            font-family: ${fontFamily};
                            font-size: 12px;
                            line-height: 1.8;
                            font-weight: 600;
                          ">
                            ${statusIcon}&nbsp;&nbsp;
                            ${escapeHtml(attendanceLabel)}
                          </span>
                        </td>
                      </tr>
                    </table>

                    <!-- Guest details -->
                    <table
                      role="presentation"
                      width="100%"
                      cellspacing="0"
                      cellpadding="0"
                      border="0"
                      bgcolor="#FCFAF7"
                      style="
                        width: 100%;
                        background-color: #FCFAF7;
                        border: 1px solid #EDE5DC;
                      "
                    >
                      <tr>
                        <td style="padding: 3px 16px;">
                          <table
                            role="presentation"
                            width="100%"
                            cellspacing="0"
                            cellpadding="0"
                            border="0"
                            style="border-collapse: collapse;"
                          >
                            ${detailRows}
                          </table>
                        </td>
                      </tr>
                    </table>

                    <!-- Closing message -->
                    <div style="
                      padding: 28px 8px 0;
                      color: #806D62;
                      font-family: ${fontFamily};
                      font-size: 13px;
                      line-height: 2;
                      text-align: center;
                      font-style: italic;
                    ">
                      Một lời hồi đáp nhỏ,<br>
                      một niềm vui lớn cho ngày trọng đại.
                    </div>

                  </td>
                </tr>

                <!-- Footer -->
                <tr>
                  <td
                    align="center"
                    bgcolor="#F8F4EE"
                    style="
                      padding: 26px 20px 28px;
                      background-color: #F8F4EE;
                      border-top: 1px solid #E9E0D6;
                    "
                  >

                    <div style="
                      color: #594A40;
                      font-family: ${fontFamily};
                      font-size: 19px;
                      line-height: 1.8;
                      font-weight: 500;
                    ">
                      ${escapeHtml(groom)}
                      <span style="color: #B49A7E;">&amp;</span>
                      ${escapeHtml(bride)}
                    </div>

                    <div style="
                      padding-top: 8px;
                      color: #806D62;
                      font-family: ${fontFamily};
                      font-size: 9px;
                      line-height: 1.8;
                      letter-spacing: 2px;
                    ">
                      MADE WITH LOVE · WEBCUOI
                    </div>

                    <div style="
                      padding-top: 14px;
                      color: #806D62;
                      font-family: ${fontFamily};
                      font-size: 11px;
                      line-height: 1.9;
                    ">
                      Đây là email thông báo tự động.<br>
                      Vui lòng không trả lời email này.
                    </div>

                  </td>
                </tr>

              </table>
            </td>
          </tr>

          <!-- Bottom decoration -->
          <tr>
            <td
              align="center"
              style="
                padding: 22px 20px 0;
                color: #AE9A85;
                font-family: ${fontFamily};
                font-size: 13px;
                letter-spacing: 4px;
              "
            >
              &#10087; &nbsp; &#10087; &nbsp; &#10087;
            </td>
          </tr>

        </table>

      </td>
    </tr>
  </table>

</body>
</html>
  `.normalize('NFC');

  const from = process.env.SMTP_FROM || process.env.SMTP_USER;

  const safeGuestName = guestName
    .replace(/[\r\n]+/g, ' ')
    .trim();

  return getTransporter().sendMail({
    from,
    to: recipients,
    subject: `[WebCuoi] RSVP ${attendanceLabel} — ${safeGuestName}`.normalize('NFC'),
    text,
    html,
  });
}

module.exports = { sendRsvpNotification };
