import 'package:flutter/material.dart';

import 'party_section_style.dart';

class WeddingCalendarCard extends StatelessWidget {
  const WeddingCalendarCard({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) => _buildCalendarCard(scale);

  static Widget _buildCalendarCard(double s) {
    const List<String> headers = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    const List<List<String>> weeks = [
      ['', '1', '2', '3', '4', '5', '6'],
      ['7', '8', '9', '10', '11', '12', '13'],
      ['14', '15', '16', '17', '18', '19', '20'],
      ['21', '22', '23', '24', '25', '26', '27'],
      ['28', '29', '30', '31', '', '', ''],
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16 * s, horizontal: 22 * s),
      decoration: BoxDecoration(
        color: PartySectionStyle.calendarBgColor,
        borderRadius: BorderRadius.circular(10 * s),
      ),
      child: Column(
        children: [
          Text(
            'Tháng 12 / 2026',
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontFamilyFallback: const ['Georgia', 'serif'],
              fontSize: 18 * s,
              fontStyle: FontStyle.italic,
              color: PartySectionStyle.calendarTextColor,
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
                          fontFamily: 'CormorantGaramond',
                          fontFamilyFallback: const ['Georgia', 'serif'],
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
            color: const Color(0xFFEAE3DC).withValues(alpha: 0.72),
            thickness: 1.1 * s,
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
                  if (day == '13') {
                    return Expanded(
                      child: Center(child: _buildHeartDayCell(day, s)),
                    );
                  }
                  return Expanded(child: Center(child: _buildDayCell(day, s)));
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
        fontFamily: 'CormorantGaramond',
        fontFamilyFallback: const ['Georgia', 'serif'],
        color: PartySectionStyle.calendarTextColor,
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
          Icon(Icons.favorite, size: 24 * s, color: const Color(0xFFF3EFEA)),
          Text(
            day,
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontFamilyFallback: const ['Georgia', 'serif'],
              fontSize: 11 * s,
              fontWeight: FontWeight.w700,
              color: PartySectionStyle.calendarBgColor,
            ),
          ),
        ],
      ),
    );
  }
}
