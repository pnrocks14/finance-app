import '../models/enums.dart';
import '../money/paise.dart';
import '../time/local_date.dart';

final _refund = RegExp(
  r'\b(refund|reversal|reversed|rev|chargeback|cashback|return)\b',
  caseSensitive: false,
);

/// The flow before transfer detection: debits are spend, credits are income,
/// and credits that read like refunds or reversals are refunds.
(TransactionFlow, FlowReason) defaultFlow(
  Direction direction,
  String description,
) {
  if (direction == Direction.debit) {
    return (TransactionFlow.spend, FlowReason.direction);
  }
  return _refund.hasMatch(description)
      ? (TransactionFlow.refund, FlowReason.refundKeyword)
      : (TransactionFlow.income, FlowReason.direction);
}

/// A credit card bill paid from a bank account.
final _cardBill = RegExp(
  r'(\bcred\b|cred club|credclub|\bcc\s*(payment|pymt|bill)|credit\s*card|'
  r'card\s*(payment|bill|dues)|autopay\s*cc|\bccbill|billdesk.*card|'
  r'payment\s*received.*thank|'
  // Topping up a card at its bank: `UPI/UNITY SMALL FI/…/topup`.
  r'(bank|small\s*fi|finance)\b.*\btop\s*-?\s*up\b)',
  caseSensitive: false,
);

/// Lowercase letters only, without a trailing "ltd"/"limited", so
/// `UNITY SMALL FI` and `Unity Small Finance Bank Ltd` can be compared.
String _issuerKey(String name) => name
    .toLowerCase()
    .replaceAll(RegExp(r'\b(ltd|limited|pvt|private)\b'), '')
    .replaceAll(RegExp('[^a-z]'), '');

/// Whether [payee] names the bank behind one of your credit cards. Bank
/// narrations cut names short (`UNITY SMALL FI`), so a long enough prefix of
/// either name counts.
bool _paysCardIssuer(String? payee, Set<String> issuerKeys) {
  if (payee == null) return false;
  final p = _issuerKey(payee);
  if (p.length < 8) return false;
  for (final issuer in issuerKeys) {
    if (issuer.length < 8) continue;
    if (issuer.startsWith(p) || p.startsWith(issuer)) return true;
    var common = 0;
    while (common < p.length &&
        common < issuer.length &&
        p[common] == issuer[common]) {
      common++;
    }
    if (common >= 12) return true;
  }
  return false;
}

/// The ledger fields transfer detection needs.
final class TransferCandidate {
  const TransferCandidate({
    required this.id,
    required this.accountId,
    required this.accountKind,
    required this.direction,
    required this.amount,
    required this.date,
    required this.description,
    this.vpa,
    this.counterpartyName,
    this.upiRef,
  });

  final String id;
  final String? accountId;
  final AccountKind? accountKind;
  final Direction direction;
  final Paise amount;
  final LocalDate date;
  final String description;
  final String? vpa;
  final String? counterpartyName;
  final String? upiRef;
}

final class TransferMatch {
  const TransferMatch(this.reason, {this.counterpartId});

  /// [FlowReason.transferPair], [FlowReason.cardBill] or [FlowReason.ownVpa].
  final FlowReason reason;

  /// The other side, for [FlowReason.transferPair].
  final String? counterpartId;
}

/// Marks transfers between your own accounts so they never count as spend
/// or income. Returns a match per transaction id that is a transfer.
///
/// Pairs need a different account, the same amount, and the credit landing
/// within [window] days of the debit, and no conflicting UPI references.
/// Each transaction pairs at most once, closest date first.
///
/// [cardIssuers] are the banks behind your credit cards (`Unity Small
/// Finance Bank`). A bank debit paid to one of them is a card bill.
Map<String, TransferMatch> detectTransfers(
  List<TransferCandidate> items, {
  Set<String> ownVpas = const {},
  Set<String> cardIssuers = const {},
  int window = 2,
}) {
  final result = <String, TransferMatch>{};
  final own = {for (final v in ownVpas) v.toLowerCase()};
  final issuers = {for (final i in cardIssuers) _issuerKey(i)};

  for (final t in items) {
    if (t.vpa != null && own.contains(t.vpa!.toLowerCase())) {
      result[t.id] = const TransferMatch(FlowReason.ownVpa);
      continue;
    }
    final isBankDebit =
        t.direction == Direction.debit &&
        t.accountKind != AccountKind.creditCard;
    final isCardCredit =
        t.direction == Direction.credit &&
        t.accountKind == AccountKind.creditCard;
    if ((isBankDebit || isCardCredit) && _cardBill.hasMatch(t.description) ||
        isBankDebit && _paysCardIssuer(t.counterpartyName, issuers)) {
      result[t.id] = const TransferMatch(FlowReason.cardBill);
    }
  }

  final debits = items
      .where((t) => t.direction == Direction.debit && t.accountId != null)
      .toList();
  final credits = items
      .where((t) => t.direction == Direction.credit && t.accountId != null)
      .toList();
  final pairs = <(int gap, TransferCandidate d, TransferCandidate c)>[];
  for (final d in debits) {
    for (final c in credits) {
      if (c.accountId == d.accountId || c.amount != d.amount) continue;
      // Both sides of one UPI transfer carry the same reference. Different
      // references mean two unrelated payments that happen to match.
      if (d.upiRef != null && c.upiRef != null && d.upiRef != c.upiRef) {
        continue;
      }
      final gap = d.date.daysUntil(c.date);
      // Money can show up a day "early" when statements post on value date.
      if (gap < -1 || gap > window) continue;
      pairs.add((gap.abs(), d, c));
    }
  }
  pairs.sort((a, b) => a.$1.compareTo(b.$1));
  final used = <String>{};
  for (final (_, d, c) in pairs) {
    if (used.contains(d.id) || used.contains(c.id)) continue;
    used
      ..add(d.id)
      ..add(c.id);
    result[d.id] = TransferMatch(FlowReason.transferPair, counterpartId: c.id);
    result[c.id] = TransferMatch(FlowReason.transferPair, counterpartId: d.id);
  }
  return result;
}
