const mongoose = require('mongoose');

const { Schema } = mongoose;

const personSchema = new Schema({
  name: { type: String, required: true, trim: true, maxlength: 100 },
  title: { type: String, trim: true, maxlength: 100, default: '' },
}, { _id: false });

const familySchema = new Schema({
  side: { type: String, enum: ['groom', 'bride'], required: true },
  parents: { type: [personSchema], default: [] },
  address: { type: String, trim: true, maxlength: 300, default: '' },
  placeId: { type: String, trim: true, maxlength: 256, default: '' },
  latitude: { type: Number, min: -90, max: 90 },
  longitude: { type: Number, min: -180, max: 180 },
}, { _id: false });

const placeSchema = new Schema({
  name: { type: String, trim: true, maxlength: 160, default: '' },
  address: { type: String, trim: true, maxlength: 400, default: '' },
  placeId: { type: String, trim: true, maxlength: 256, default: '' },
  mapUrl: { type: String, trim: true, maxlength: 1000, default: '' },
  latitude: { type: Number, min: -90, max: 90 },
  longitude: { type: Number, min: -180, max: 180 },
}, { _id: false });

const eventSchema = new Schema({
  startsAt: { type: Date },
  doorsOpenAt: { type: Date },
  lunarDate: { type: String, trim: true, maxlength: 120, default: '' },
  place: { type: placeSchema, default: () => ({}) },
}, { _id: false });

const galleryPhotoSchema = new Schema({
  url: { type: String, required: true, trim: true, maxlength: 1000 },
  alt: { type: String, trim: true, maxlength: 180, default: '' },
  order: { type: Number, default: 0 },
}, { _id: false });

const scheduleItemSchema = new Schema({
  time: { type: String, required: true, trim: true, maxlength: 40 },
  title: { type: String, required: true, trim: true, maxlength: 120 },
  iconUrl: { type: String, trim: true, maxlength: 1000, default: '' },
  order: { type: Number, default: 0 },
}, { _id: false });

const giftAccountSchema = new Schema({
  side: { type: String, enum: ['groom', 'bride'], required: true },
  owner: { type: String, trim: true, maxlength: 120, required: true },
  bankName: { type: String, trim: true, maxlength: 120, default: '' },
  accountNumber: { type: String, trim: true, maxlength: 60, default: '' },
  qrImageUrl: { type: String, trim: true, maxlength: 1000, default: '' },
}, { _id: false });

const weddingInvitationSchema = new Schema({
  slug: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
    match: /^[a-z0-9]+(?:-[a-z0-9]+)*$/,
    maxlength: 100,
  },
  title: { type: String, trim: true, maxlength: 160, default: 'The Wedding Of' },
  cover: {
    subtitle: { type: String, trim: true, maxlength: 160, default: '' },
    imageUrl: { type: String, trim: true, maxlength: 1000, default: '' },
  },
  couple: {
    groom: { type: personSchema, required: true },
    bride: { type: personSchema, required: true },
  },
  families: { type: [familySchema], default: [] },
  ceremony: { type: eventSchema, default: () => ({}) },
  reception: { type: eventSchema, default: () => ({}) },
  gallery: { type: [galleryPhotoSchema], default: [] },
  dressCode: {
    title: { type: String, trim: true, maxlength: 100, default: 'Dress code' },
    description: { type: String, trim: true, maxlength: 500, default: '' },
    colors: { type: [String], default: [] },
  },
  schedule: { type: [scheduleItemSchema], default: [] },
  giftAccounts: { type: [giftAccountSchema], default: [] },
  theme: {
    name: { type: String, trim: true, maxlength: 80, default: 'Minimalism Nâu' },
    primaryColor: { type: String, match: /^#[0-9a-fA-F]{6}$/, default: '#755C49' },
    backgroundColor: { type: String, match: /^#[0-9a-fA-F]{6}$/, default: '#F5F0E8' },
  },
}, { timestamps: true, strict: 'throw' });

module.exports = mongoose.model('WeddingInvitation', weddingInvitationSchema);
