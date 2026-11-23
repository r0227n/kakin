import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:month_calendar/month_calendar.dart';

void main() {
  group('CalendarMonth', () {
    test('counts days including leap years', () {
      expect(CalendarMonth(2026, 2).dayCount, 28);
      expect(CalendarMonth(2028, 2).dayCount, 29);
      expect(CalendarMonth(2026, 11).dayCount, 30);
    });

    test('moves across year boundaries', () {
      expect(CalendarMonth(2026, 12).next, CalendarMonth(2027, 1));
      expect(CalendarMonth(2027, 1).previous, CalendarMonth(2026, 12));
    });

    test('computes leading blanks for the week start', () {
      // 2026-11-01 is a Sunday.
      expect(CalendarMonth(2026, 11).leadingBlankCount(DateTime.sunday), 0);
      expect(CalendarMonth(2026, 11).leadingBlankCount(DateTime.monday), 6);
      // 2026-12-01 is a Tuesday.
      expect(CalendarMonth(2026, 12).leadingBlankCount(DateTime.sunday), 2);
    });

    test('rejects invalid months and orders chronologically', () {
      expect(() => CalendarMonth(2026, 13), throwsArgumentError);
      expect(
        CalendarMonth(2026, 12).compareTo(CalendarMonth(2027, 1)),
        isNegative,
      );
    });
  });

  testWidgets('builds one cell per day and reports swipes', (tester) async {
    var previous = 0;
    var next = 0;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: MonthCalendarGrid(
          month: CalendarMonth(2026, 12),
          weekdayLabels: const ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
          dayBuilder: (context, day) => Text('d$day'),
          onSwipePrevious: () => previous++,
          onSwipeNext: () => next++,
        ),
      ),
    );
    expect(find.text('d1'), findsOneWidget);
    expect(find.text('d31'), findsOneWidget);
    expect(find.text('d32'), findsNothing);

    await tester.fling(find.text('d10'), const Offset(-300, 0), 1000);
    await tester.fling(find.text('d10'), const Offset(300, 0), 1000);
    expect(next, 1);
    expect(previous, 1);
  });
}
