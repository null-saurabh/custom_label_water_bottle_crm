
import 'dart:ui';


enum RecurringCycle { weekly, monthly, quarterly }


class WeeklyBarData {
  final String day;
  final int delivered;
  final int scheduled;

  WeeklyBarData({
    required this.day,
    required this.delivered,
    required this.scheduled,
  });
}



class StandingOrderSummary {
  final String client;
  final String orderId;
  final RecurringCycle cycle; // 🔥 weekly / monthly
  final int committedQty;     // total expected for the cycle
  final int fulfilledQty;     // shipped so far
  final bool isActive;

  StandingOrderSummary({
    required this.client,
    required this.orderId,
    required this.cycle,
    required this.committedQty,
    required this.fulfilledQty,
    required this.isActive,
  });
}


class DueNextWeek {
  final String client;
  final String orderId;
  final int quantity;
  final String dayLabel;
  final Color dayBg;
  final Color dayText;

  DueNextWeek({
    required this.orderId,
    required this.client,
    required this.quantity,
    required this.dayLabel,
    required this.dayBg,
    required this.dayText,
  });
}
class DueDeliveryToday {
  final String orderId;
  final String client;
  final int quantity;
  final String timeLabel;
  final bool completed;

  DueDeliveryToday({

    required this.orderId,
    required this.client,
    required this.quantity,
    required this.timeLabel,
    required this.completed,
  });
}



class ChipStyle {
  final Color bg;
  final Color fg;
  ChipStyle(this.bg, this.fg);
}

class DateRange {
  final DateTime start;
  final DateTime end;
  DateRange(this.start, this.end);
}


class Range {
  final DateTime start;
  final DateTime end; // exclusive
  const Range(this.start, this.end);
}
