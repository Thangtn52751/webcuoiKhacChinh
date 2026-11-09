import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'party_section_style.dart';

class WeddingCalendarCard extends StatelessWidget {
  const WeddingCalendarCard({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final calendarScale = isCompact ? 0.55 : scale;
    final textScale = isCompact ? 0.9 : (scale > 1 ? scale * 0.9 : scale);
    final weddingDay = DateTime(2026, 12, 13);
    final dowLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final bodyStyle = TextStyle(
      color: PartySectionStyle.calendarTextColor,
      fontSize: isCompact ? 9.5 : 11 * textScale,
      fontWeight: DefaultTextStyle.of(context).style.fontWeight,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isCompact ? 8 : 18 * scale,
        horizontal: isCompact ? 7 : 20 * scale,
      ),
      decoration: BoxDecoration(
        color: PartySectionStyle.calendarBgColor,
        borderRadius: BorderRadius.circular(10 * calendarScale),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Th\u{00E1}ng 12 / 2026',
            style: TextStyle(
              fontSize: isCompact ? 16 : 24 * textScale,
              color: PartySectionStyle.calendarTextColor,
            ),
          ),
          SizedBox(height: isCompact ? 3 : 8 * scale),
          TableCalendar<DateTime>(
            firstDay: DateTime(2026, 12, 1),
            lastDay: DateTime(2026, 12, 31),
            focusedDay: weddingDay,
            currentDay: weddingDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerVisible: false,
            daysOfWeekVisible: true,
            sixWeekMonthsEnforced: false,
            shouldFillViewport: false,
            pageAnimationEnabled: false,
            availableGestures: AvailableGestures.none,
            rowHeight: isCompact ? 15.6 : 30 * scale,
            daysOfWeekHeight: isCompact ? 11 : 18 * scale,
            selectedDayPredicate: (day) => isSameDay(day, weddingDay),
            daysOfWeekStyle: DaysOfWeekStyle(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFEAE3DC).withValues(alpha: 0.72),
                    width: 1.1 * calendarScale,
                  ),
                ),
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              isTodayHighlighted: false,
              cellMargin: EdgeInsets.zero,
              cellPadding: EdgeInsets.zero,
              cellAlignment: Alignment.center,
              tablePadding: EdgeInsets.zero,
              defaultTextStyle: bodyStyle,
              weekendTextStyle: bodyStyle,
              selectedTextStyle: bodyStyle,
              selectedDecoration: const BoxDecoration(),
              todayDecoration: const BoxDecoration(),
              tableBorder: TableBorder.all(color: Colors.transparent, width: 0),
            ),
            calendarBuilders: CalendarBuilders<DateTime>(
              dowBuilder: (context, day) => Center(
                child: Text(
                  dowLabels[day.weekday - 1],
                  style: TextStyle(
                    color: const Color(0xFFD6CEC6),
                    fontSize: isCompact ? 9 : 10 * textScale,
                    fontWeight: DefaultTextStyle.of(context).style.fontWeight,
                  ),
                ),
              ),
              defaultBuilder: (context, day, focusedDay) =>
                  Center(child: Text('${day.day}', style: bodyStyle)),
              selectedBuilder: (context, day, focusedDay) => Center(
                child: _HeartDayCell(
                  day: '${day.day}',
                  scale: calendarScale,
                  textScale: textScale,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeartDayCell extends StatelessWidget {
  const _HeartDayCell({
    required this.day,
    required this.scale,
    required this.textScale,
  });

  final String day;
  final double scale;
  final double textScale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30 * scale,
      height: 30 * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 28 * scale,
            color: const Color(0xFFF3EFEA),
          ),
          Text(
            day,
            style: TextStyle(
              fontSize: 10.5 * textScale,
              fontWeight: FontWeight.w600,
              color: PartySectionStyle.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
