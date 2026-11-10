import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'party_section_style.dart';

class WeddingCalendarCard extends StatelessWidget {
  const WeddingCalendarCard({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.widthOf(context) < 600;
    final calendarScale = isCompact ? 0.8 : scale;
    final textScale = isCompact ? 1.1 : (scale > 1 ? scale * 0.9 : scale);
    final weddingDay = DateTime(2026, 12, 13);
    final dowLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final bodyStyle = TextStyle(
      color: PartySectionStyle.calendarTextColor,
      fontSize: isCompact ? 11.5 : 11 * textScale,
      fontWeight: DefaultTextStyle.of(context).style.fontWeight,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowHeight = isCompact
            ? math.max(
                ((constraints.maxWidth - 20) / 7 * 0.82).clamp(24.0, 32.0),
                MediaQuery.textScalerOf(context).scale(11.5) * 2.1,
              )
            : 30 * scale;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isCompact ? 10 : 18 * scale,
            horizontal: isCompact ? 10 : 20 * scale,
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompact ? 16 : 24 * textScale,
                  color: PartySectionStyle.calendarTextColor,
                ),
              ),
              SizedBox(height: isCompact ? 6 : 8 * scale),
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
                rowHeight: rowHeight,
                daysOfWeekHeight: isCompact ? 18 : 18 * scale,
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
                  tableBorder: TableBorder.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                calendarBuilders: CalendarBuilders<DateTime>(
                  dowBuilder: (context, day) => Center(
                    child: Text(
                      dowLabels[day.weekday - 1],
                      style: TextStyle(
                        color: const Color(0xFFD6CEC6),
                        fontSize: isCompact ? 10.5 : 10 * textScale,
                        fontWeight: DefaultTextStyle.of(context)
                            .style
                            .fontWeight,
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
      },
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
    final fontSize = 10.5 * textScale;
    final size = math.max(
      30 * scale,
      MediaQuery.textScalerOf(context).scale(fontSize) * 2.05,
    );
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: size * 0.93,
            color: const Color(0xFFF3EFEA),
          ),
          Text(
            day,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: PartySectionStyle.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
