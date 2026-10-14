import 'package:finance_core/finance_core.dart';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const _fullMonths = [
  'January', 'February', 'March', 'April', 'May', 'June', //
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// `Fri, 2 Oct`, or `Fri, 2 Oct 2025` outside the current year.
String formatDayHeader(LocalDate d, {LocalDate? today}) {
  final now = today ?? LocalDate.today();
  final weekday = _weekdays[DateTime.utc(d.year, d.month, d.day).weekday - 1];
  if (d == now) return 'Today';
  if (d == now.addDays(-1)) return 'Yesterday';
  final base = '$weekday, ${d.day} ${_months[d.month - 1]}';
  return d.year == now.year ? base : '$base ${d.year}';
}

/// `2 Oct 2026`.
String formatShortDate(LocalDate d) =>
    '${d.day} ${_months[d.month - 1]} ${d.year}';

/// `October 2026`.
String formatMonth(LocalDate d) => '${_fullMonths[d.month - 1]} ${d.year}';

/// `1 to 31 Oct 2026`, or across months `28 Sep to 4 Oct 2026`.
String formatPeriod(LocalDate from, LocalDate to) {
  if (from.year == to.year && from.month == to.month) {
    return '${from.day} to ${to.day} ${_months[to.month - 1]} ${to.year}';
  }
  final left = from.year == to.year
      ? '${from.day} ${_months[from.month - 1]}'
      : formatShortDate(from);
  return '$left to ${formatShortDate(to)}';
}

String channelLabel(Channel c) => switch (c) {
  Channel.upi => 'UPI',
  Channel.card => 'Card',
  Channel.neft => 'NEFT',
  Channel.imps => 'IMPS',
  Channel.rtgs => 'RTGS',
  Channel.atm => 'ATM',
  Channel.netBanking => 'Net banking',
  Channel.wallet => 'Wallet',
  Channel.cheque => 'Cheque',
  Channel.other => 'Other',
};

/// Plain-language "why" for a transaction's flow.
String flowReasonText(FlowReason r) => switch (r) {
  FlowReason.direction => 'Money out counts as spending, money in as income.',
  FlowReason.refundKeyword =>
    'The description mentions a refund or reversal, so this counts as money '
        'coming back, not income.',
  FlowReason.transferPair =>
    'The same amount left one of your accounts and arrived in another within '
        'two days, so it is a transfer and not counted as spending or income.',
  FlowReason.cardBill =>
    'This looks like a credit card bill payment. Card spends are counted '
        'when you make them, so the bill itself is a transfer.',
  FlowReason.ownVpa =>
    'This went to one of your own UPI IDs, so it is a transfer.',
  FlowReason.user => 'You set this yourself.',
};
