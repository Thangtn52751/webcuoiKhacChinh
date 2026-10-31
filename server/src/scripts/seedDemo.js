require('dotenv').config();

const mongoose = require('mongoose');
const { connectDatabase } = require('../config/database');
const WeddingInvitation = require('../models/WeddingInvitation');

async function seedDemo() {
  await connectDatabase();
  await WeddingInvitation.findOneAndUpdate(
    { slug: 'minimalism-nau-demo' },
    {
      $set: {
        title: 'The Wedding Of',
        cover: { subtitle: 'Thân mời bạn đến dự lễ cưới', imageUrl: '' },
        couple: {
          groom: { name: 'Hoàng Nam', title: 'Trưởng Nam' },
          bride: { name: 'Thảo Vy', title: 'Út Nữ' },
        },
        families: [
          { side: 'groom', parents: [], address: 'Số 300 đường Thân Công Tài, Phường Nếnh, Thành phố Bắc Ninh' },
          { side: 'bride', parents: [], address: 'Tổ Dân Phố Dĩnh Sơn, Phường Vân Hà, Thành phố Bắc Ninh' },
        ],
        ceremony: {
          startsAt: new Date('2026-01-03T09:00:00+07:00'),
          lunarDate: '15 tháng 11 năm Ất Tỵ',
          place: { name: 'Tư gia' },
        },
        reception: {
          startsAt: new Date('2026-01-03T18:00:00+07:00'),
          doorsOpenAt: new Date('2026-01-03T17:30:00+07:00'),
          lunarDate: '15 tháng 11 năm Ất Tỵ',
          place: {
            name: 'Trung Tâm Hội Nghị White Palace',
            address: '194 Hoàng Văn Thụ, Phường 9, Quận Phú Nhuận, TP. Hồ Chí Minh',
            mapUrl: '',
          },
        },
        gallery: [],
        dressCode: { title: 'Dress code', description: 'Trang phục dự tiệc', colors: [] },
        schedule: [
          { time: '17:00', title: 'Đón khách', order: 0 },
          { time: '18:00', title: 'Khai tiệc', order: 1 },
          { time: '18:30', title: 'Nghi thức cưới', order: 2 },
          { time: '19:00', title: 'Cắt bánh và nâng ly', order: 3 },
          { time: '20:30', title: 'Kết thúc tiệc', order: 4 },
        ],
        giftAccounts: [],
        theme: { name: 'Minimalism Nâu', primaryColor: '#755C49', backgroundColor: '#F5F0E8' },
      },
    },
    { upsert: true, new: true, runValidators: true, setDefaultsOnInsert: true },
  );
  console.log('Đã tạo/cập nhật thiệp demo: minimalism-nau-demo');
}

seedDemo()
  .catch((error) => {
    console.error('Không thể tạo dữ liệu demo:', error.message);
    process.exitCode = 1;
  })
  .finally(async () => mongoose.disconnect());
