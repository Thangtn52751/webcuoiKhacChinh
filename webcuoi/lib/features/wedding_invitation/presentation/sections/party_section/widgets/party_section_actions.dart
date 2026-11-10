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
    final isCompact = MediaQuery.widthOf(context) < 600;
    final linkStyle = TextStyle(
      fontSize: isCompact ? 14 : 14 * s,
      fontStyle: FontStyle.italic,
      color: PartySectionStyle.primaryColor,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => _addToCalendar(context),
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: isCompact ? 44 : 34 * s,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 12 : 8 * s,
                ),
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
            ),
          ),
        ),
        SizedBox(height: (isCompact ? 4 : 8) * s),
        SizedBox(
          height: isCompact ? 44 : 34 * s,
          child: ElevatedButton(
            onPressed: () => _openRsvp(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: PartySectionStyle.calendarBgColor,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: Size(44, isCompact ? 44 : 34 * s),
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 18 : 24 * s,
              ),
              shape: const StadiumBorder(),
              tapTargetSize: MaterialTapTargetSize.padded,
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              'XÁC NHẬN THAM DỰ',
              style: TextStyle(
                fontSize: isCompact ? 12.5 : 12.5 * s,
                fontWeight: FontWeight.w500,
                letterSpacing: isCompact ? 0.2 : 0.8 * s,
                color: const Color(0xFFF3EFEA),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
