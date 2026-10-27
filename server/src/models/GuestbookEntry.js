const mongoose = require('mongoose');

const guestbookEntrySchema = new mongoose.Schema({
  invitation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'WeddingInvitation',
    required: true,
    index: true,
  },
  name: { type: String, required: true, trim: true, maxlength: 100 },
  message: { type: String, required: true, trim: true, maxlength: 1000 },
  approved: { type: Boolean, default: false, index: true },
}, { timestamps: true });

guestbookEntrySchema.index({ invitation: 1, approved: 1, createdAt: -1 });

module.exports = mongoose.model('GuestbookEntry', guestbookEntrySchema);
