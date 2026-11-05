import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../rsvp/rsvp_dialog.dart';
import 'party_section_style.dart';

class PartySectionActions extends StatelessWidget {
  const PartySectionActions({super.key, required this.scale});

  final double scale;

  Future<void> _addToCalendar(BuildContext context) async {
    final calendarUrl = Uri.https('calendar.google.com', '/calendar/render', {
      'action': 'TEMPLATE',
      'text': 'Lễ cưới Khắc Chính & Nguyễn Trang',
      'dates': '20261213T011500Z/20261213T040000Z',
      'details':
          'Lễ cưới bắt đầu lúc 08:15, Chủ nhật ngày 13 tháng 12 năm 2026.',
      'location': 'White Palace, Thành phố Hồ Chí Minh',
    });

    final opened = await launchUrl(
      calendarUrl,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Không thể mở lịch.')));
    }
  }

  Future<void> _openRsvp(BuildContext context) async {
    final submitted = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x99000000),
      builder: (_) => const RsvpDialog(),
    );

    if (submitted == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã gửi xác nhận tham dự.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = scale;
    final linkStyle = TextStyle(
      fontFamily: PartySectionStyle.serifFont,
      fontFamilyFallback: PartySectionStyle.serifFallback,
      fontSize: 14 * s,
      fontStyle: FontStyle.italic,
      color: PartySectionStyle.primaryColor,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => _addToCalendar(context),
          borderRadius: BorderRadius.circular(4 * s),
          child: Padding(
            padding: EdgeInsets.only(bottom: 2 * s),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: PartySectionStyle.primaryColor,
                    width: 1 * s,
                  ),
                ),
              ),
              child: Text('Thêm vào lịch', style: linkStyle),
            ),
          ),
        ),
        SizedBox(height: 14 * s),
        SizedBox(
          height: 34 * s,
          child: ElevatedButton(
            onPressed: () => _openRsvp(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: PartySectionStyle.calendarBgColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 24 * s),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'XÁC NHẬN THAM DỰ',
              style: TextStyle(
                fontFamily: PartySectionStyle.serifFont,
                fontFamilyFallback: PartySectionStyle.serifFallback,
                fontSize: 12.5 * s,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8 * s,
                color: const Color(0xFFF3EFEA),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
