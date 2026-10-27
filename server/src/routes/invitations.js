const express = require('express');
const WeddingInvitation = require('../models/WeddingInvitation');
const RSVP = require('../models/RSVP');
const GuestbookEntry = require('../models/GuestbookEntry');
const { requireAdmin } = require('../middleware/adminAuth');

const router = express.Router();

function cleanText(value) {
  return typeof value === 'string' ? value.replace(/<[^>]*>/g, '').trim() : value;
}

async function findInvitation(slug) {
  return WeddingInvitation.findOne({ slug: slug.toLowerCase() });
}

router.get('/:slug', async (req, res) => {
  const invitation = await findInvitation(req.params.slug);
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });
  return res.json({ data: invitation });
});

router.post('/:slug/rsvps', async (req, res) => {
  const invitation = await findInvitation(req.params.slug);
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });

  const { guestName, attendance, guestCount, phone, note } = req.body;
  if (!['attending', 'not-attending'].includes(attendance)) {
    return res.status(400).json({ message: 'attendance phải là attending hoặc not-attending.' });
  }

  const guests = attendance === 'attending' ? (guestCount ?? 1) : 0;
  if (!Number.isInteger(guests) || guests < 0 || guests > 20) {
    return res.status(400).json({ message: 'guestCount phải là số nguyên từ 0 đến 20.' });
  }

  const rsvp = await RSVP.create({
    invitation: invitation._id,
    guestName: cleanText(guestName),
    attendance,
    guestCount: guests,
    phone: cleanText(phone ?? ''),
    note: cleanText(note ?? ''),
  });
  return res.status(201).json({ message: 'Đã ghi nhận xác nhận tham dự.', data: rsvp });
});

router.get('/:slug/guestbook', async (req, res) => {
  const invitation = await findInvitation(req.params.slug);
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });

  const requestedPage = Number.parseInt(req.query.page, 10) || 1;
  const requestedLimit = Number.parseInt(req.query.limit, 10) || 20;
  const page = Math.max(1, requestedPage);
  const limit = Math.min(50, Math.max(1, requestedLimit));
  const filter = { invitation: invitation._id, approved: true };
  const [entries, total] = await Promise.all([
    GuestbookEntry.find(filter).sort({ createdAt: -1 }).skip((page - 1) * limit).limit(limit).lean(),
    GuestbookEntry.countDocuments(filter),
  ]);

  return res.json({ data: entries, pagination: { page, limit, total } });
});

router.post('/:slug/guestbook', async (req, res) => {
  const invitation = await findInvitation(req.params.slug);
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });

  const entry = await GuestbookEntry.create({
    invitation: invitation._id,
    name: cleanText(req.body.name),
    message: cleanText(req.body.message),
    approved: !invitation.guestbookRequiresApproval,
  });
  return res.status(201).json({
    message: entry.approved ? 'Đã gửi lời chúc.' : 'Lời chúc đang chờ duyệt.',
    data: entry,
  });
});

router.post('/', requireAdmin, async (req, res) => {
  const invitation = await WeddingInvitation.create(req.body);
  return res.status(201).json({ data: invitation });
});

router.patch('/:slug', requireAdmin, async (req, res) => {
  const invitation = await WeddingInvitation.findOneAndUpdate(
    { slug: req.params.slug.toLowerCase() },
    req.body,
    { new: true, runValidators: true, strict: 'throw' },
  );
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });
  return res.json({ data: invitation });
});

router.get('/:slug/rsvps', requireAdmin, async (req, res) => {
  const invitation = await findInvitation(req.params.slug);
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });
  const data = await RSVP.find({ invitation: invitation._id }).sort({ createdAt: -1 }).lean();
  return res.json({ data });
});

router.get('/:slug/guestbook/pending', requireAdmin, async (req, res) => {
  const invitation = await findInvitation(req.params.slug);
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });
  const data = await GuestbookEntry.find({ invitation: invitation._id, approved: false })
    .sort({ createdAt: -1 }).lean();
  return res.json({ data });
});

router.patch('/:slug/guestbook/:entryId', requireAdmin, async (req, res) => {
  if (typeof req.body.approved !== 'boolean') {
    return res.status(400).json({ message: 'approved phải là true hoặc false.' });
  }
  const invitation = await findInvitation(req.params.slug);
  if (!invitation) return res.status(404).json({ message: 'Không tìm thấy thiệp cưới.' });
  const entry = await GuestbookEntry.findOneAndUpdate(
    { _id: req.params.entryId, invitation: invitation._id },
    { approved: req.body.approved },
    { new: true, runValidators: true },
  );
  if (!entry) return res.status(404).json({ message: 'Không tìm thấy lời chúc.' });
  return res.json({ data: entry });
});

module.exports = router;
