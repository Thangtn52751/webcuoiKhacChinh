import 'package:flutter/material.dart';

import '../../../../data/guestbook_entry.dart';
import '../../section_theme.dart';

class GuestbookEntryCard extends StatelessWidget {
  const GuestbookEntryCard({
    super.key,
    required this.entry,
    required this.scale,
  });

  final GuestbookEntry entry;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final textScale = (scale * 1.05).clamp(0.82, 1.08).toDouble();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14 * textScale,
        vertical: 10 * textScale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xEFFFFFFF),
        borderRadius: BorderRadius.circular(7 * textScale),
        border: Border.all(
          color: SectionTheme.inkMuted.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x225A473B),
            blurRadius: 12 * textScale,
            offset: Offset(0, 4 * textScale),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SectionTheme.inkSoft,
                    fontFamily: SectionTheme.fontFamily,
                    fontSize: 16 * textScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (entry.createdAt != null) ...[
                SizedBox(width: 8 * textScale),
                Text(
                  _formatDate(entry.createdAt!.toLocal()),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: SectionTheme.inkSoft,
                    fontFamily: SectionTheme.fontFamily,
                    fontSize: 13 * textScale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          if (entry.message.trim().isNotEmpty) ...[
            SizedBox(height: 5 * textScale),
            Text(
              entry.message,
              style: TextStyle(
                color: SectionTheme.inkSoft,
                fontFamily: SectionTheme.fontFamily,
                fontSize: 15 * textScale,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${twoDigits(value.hour)}:${twoDigits(value.minute)}:${twoDigits(value.second)} '
        '${value.day}/${value.month}/${value.year}';
  }
}
