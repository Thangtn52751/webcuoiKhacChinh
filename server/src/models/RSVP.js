const mongoose = require('mongoose');

const rsvpSchema = new mongoose.Schema({
  invitation: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'WeddingInvitation',
    required: true,
    index: true,
  },
  guestName: { type: String, required: true, trim: true, maxlength: 100 },
  phone: { type: String, trim: true, maxlength: 30, default: '' },
  attendance: { type: String, enum: ['attending', 'not-attending'], required: true },
  guestCount: { type: Number, min: 0, max: 20, default: 1 },
  note: { type: String, trim: true, maxlength: 500, default: '' },
}, { timestamps: true });

rsvpSchema.index({ invitation: 1, createdAt: -1 });

module.exports = mongoose.model('RSVP', rsvpSchema);
