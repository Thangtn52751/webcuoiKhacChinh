import 'package:flutter/material.dart';

class WeddingPartySection extends StatelessWidget {
  const WeddingPartySection({super.key, required this.scale});

  final double scale;

  // Bảng màu trích xuất chuẩn từ ảnh thiết kế gốc
  static const Color primaryColor = Color(0xFF5A524C);
  static const Color accentColor = Color(0xFF8C827A);
  static const Color calendarBgColor = Color(0xFF73675F);
  static const Color calendarTextColor = Color(0xFFEAE3DC);

  // Font có chân (Serif) tích hợp sẵn trên trình duyệt Web
  static const String serifFont = 'Georgia';
  static const List<String> serifFallback = ['Times New Roman', 'serif'];

  @override
  Widget build(BuildContext context) {
    final double targetImageWidth = 980 * scale;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 24 * scale),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: targetImageWidth),
        // AspectRatio khóa cứng tỷ lệ chuẩn 804:969 của ảnh Group_5.png,
        // giúp khung Positioned không bao giờ bị lệch khỏi tờ giấy kem
        child: AspectRatio(
          aspectRatio: 804 / 969,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double actualWidth = constraints.maxWidth;
              final double actualHeight = constraints.maxHeight;

              // Hệ số s tự động tính theo kích thước thực tế của ảnh trên màn hình
              final double s = actualWidth / 804.0;

              // Bù trừ độ lệch của cành hoa trái để tờ giấy kem nằm chính giữa trục dọc trang web
              final double paperCenterOffset = -actualWidth * 0.0398;

              return Transform.translate(
                offset: Offset(paperCenterOffset, 0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. ẢNH NỀN KHUNG HOA LÁ
                    Image.asset(
                      'assets/images/decorations/Group_5.png',
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),

                    // 2. VÙNG NỘI DUNG NẰM GỌN BÊN TRONG TỜ GIẤY KEM
                    // Đã lùi top xuống 7.5% và nâng bottom lên 11.5% để cách mép trên/dưới thoáng đẹp
                    Positioned(
                      left: actualWidth * 0.2288,
                      right: actualWidth * 0.1492,
                      top: actualHeight * 0.075,
                      bottom: actualHeight * 0.115,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 42 * s),
                        // FittedBox đảm bảo nội dung tự co nhẹ nếu khung bị hẹp, tuyệt đối không tràn mép
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: (actualWidth * (1 - 0.2288 - 0.1492)) - (84 * s),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // --- TIÊU ĐỀ ---
                                Text(
                                  'THÔNG TIN TIỆC CƯỚI',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: serifFont,
                                    fontFamilyFallback: serifFallback,
                                    fontSize: 15 * s,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5 * s,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 12 * s),
                                Text(
                                  'TIỆC CƯỚI SẼ DIỄN RA VÀO LÚC:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: serifFont,
                                    fontFamilyFallback: serifFallback,
                                    fontSize: 19 * s,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.0 * s,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 22 * s),

                                // --- GIỜ & NGÀY THÁNG NĂM ---
                                Text(
                                  '08:15',
                                  style: TextStyle(
                                    fontFamily: serifFont,
                                    fontFamilyFallback: serifFallback,
                                    fontSize: 27 * s,
                                    fontWeight: FontWeight.w400,
                                    height: 1.0,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 14 * s),

                                // Hàng CHỦ NHẬT | 13 | THÁNG 12 cân xứng 2 bên số 13
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'CHỦ NHẬT',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: serifFont,
                                          fontFamilyFallback: serifFallback,
                                          fontSize: 13 * s,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2 * s,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 24 * s,
                                      width: 1.2 * s,
                                      color: primaryColor,
                                      margin: EdgeInsets.symmetric(horizontal: 18 * s),
                                    ),
                                    Text(
                                      '13',
                                      style: TextStyle(
                                        fontFamily: serifFont,
                                        fontFamilyFallback: serifFallback,
                                        fontSize: 38 * s,
                                        fontWeight: FontWeight.w500,
                                        height: 0.95,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Container(
                                      height: 24 * s,
                                      width: 1.2 * s,
                                      color: primaryColor,
                                      margin: EdgeInsets.symmetric(horizontal: 18 * s),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'THÁNG 12',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontFamily: serifFont,
                                          fontFamilyFallback: serifFallback,
                                          fontSize: 13 * s,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.2 * s,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14 * s),
                                Text(
                                  '2026',
                                  style: TextStyle(
                                    fontFamily: serifFont,
                                    fontFamilyFallback: serifFallback,
                                    fontSize: 21 * s,
                                    fontWeight: FontWeight.w400,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(height: 10 * s),
                                Text(
                                  '(TỨC NGÀY 5 THÁNG 11 NĂM BÍNH NGỌ)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: serifFont,
                                    fontFamilyFallback: serifFallback,
                                    fontSize: 10.5 * s,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1.8 * s,
                                    color: accentColor,
                                  ),
                                ),
                                SizedBox(height: 24 * s),

                                // --- ĐÓN KHÁCH & KHAI TIỆC ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTimeColumn('ĐÓN KHÁCH', '8:00', s),
                                    SizedBox(width: 52 * s),
                                    _buildTimeColumn('KHAI TIỆC', '8:15', s),
                                  ],
                                ),
                                SizedBox(height: 24 * s),

                                // --- BẢNG LỊCH MÀU NÂU ---
                                _buildCalendarCard(s),
                                SizedBox(height: 22 * s),

                                // --- THÊM VÀO LỊCH & NÚT XÁC NHẬN THAM DỰ ---
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 2 * s),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: primaryColor,
                                          width: 1 * s,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Thêm vào lịch',
                                      style: TextStyle(
                                        fontFamily: serifFont,
                                        fontFamilyFallback: serifFallback,
                                        fontSize: 13 * s,
                                        fontStyle: FontStyle.italic,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 14 * s),
                                SizedBox(
                                  height: 36 * s,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: calendarBgColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 30 * s,
                                      ),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Text(
                                      'XÁC NHẬN THAM DỰ',
                                      style: TextStyle(
                                        fontFamily: serifFont,
                                        fontFamilyFallback: serifFallback,
                                        fontSize: 11.5 * s,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.4 * s,
                                        color: const Color(0xFFF3EFEA),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget _buildTimeColumn(String label, String time, double s) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: serifFont,
            fontFamilyFallback: serifFallback,
            fontSize: 10.5 * s,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0 * s,
            color: accentColor,
          ),
        ),
        SizedBox(height: 5 * s),
        Text(
          time,
          style: TextStyle(
            fontFamily: serifFont,
            fontFamilyFallback: serifFallback,
            fontSize: 18 * s,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  static Widget _buildCalendarCard(double s) {
    const List<String> headers = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    const List<List<String>> weeks = [
      ['', '', '', '1', '2', '3', '4'],
      ['5', '6', '7', '8', '9', '10', '11'],
      ['12', '13', '14', '15', '16', '17', '18'],
      ['19', '20', '21', '22', '23', '24', '25'],
      ['26', '27', '28', '29', '30', '31', ''],
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 16 * s,
        horizontal: 22 * s,
      ),
      decoration: BoxDecoration(
        color: calendarBgColor,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Column(
        children: [
          Text(
            'Tháng 1 / 2026',
            style: TextStyle(
              fontFamily: serifFont,
              fontFamilyFallback: serifFallback,
              fontSize: 18 * s,
              fontStyle: FontStyle.italic,
              color: calendarTextColor,
            ),
          ),
          SizedBox(height: 10 * s),

          // Hàng Thứ (T2 -> CN)
          Row(
            children: headers
                .map(
                  (h) => Expanded(
                    child: Center(
                      child: Text(
                        h,
                        style: TextStyle(
                          fontFamily: serifFont,
                          fontFamilyFallback: serifFallback,
                          color: const Color(0xFFD6CEC6),
                          fontSize: 10.5 * s,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 6 * s),

          Divider(
            color: const Color(0xFFD6CEC6).withValues(alpha: 0.45),
            thickness: 0.8 * s,
            height: 1 * s,
          ),
          SizedBox(height: 8 * s),

          // Các hàng ngày trong tháng
          ...weeks.map(
            (week) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4.5 * s),
              child: Row(
                children: week.map((day) {
                  if (day.isEmpty) {
                    return const Expanded(child: SizedBox());
                  }
                  if (day == '3') {
                    return Expanded(
                      child: Center(
                        child: _buildHeartDayCell(day, s),
                      ),
                    );
                  }
                  return Expanded(
                    child: Center(
                      child: _buildDayCell(day, s),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDayCell(String day, double s) {
    return Text(
      day,
      style: TextStyle(
        fontFamily: serifFont,
        fontFamilyFallback: serifFallback,
        color: calendarTextColor,
        fontSize: 12 * s,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  static Widget _buildHeartDayCell(String day, double s) {
    return SizedBox(
      width: 26 * s,
      height: 26 * s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 24 * s,
            color: const Color(0xFFF3EFEA),
          ),
          Text(
            day,
            style: TextStyle(
              fontFamily: serifFont,
              fontFamilyFallback: serifFallback,
              fontSize: 11 * s,
              fontWeight: FontWeight.w700,
              color: calendarBgColor,
            ),
          ),
        ],
      ),
    );
  }
}