import '../models/enums.dart';
import 'merchant_dictionary.dart';
import 'seed_categories.dart';

/// What the categoriser looks at for one transaction.
final class CategorizeInput {
  const CategorizeInput({
    required this.direction,
    required this.flow,
    this.flowReason = FlowReason.direction,
    this.counterpartyName,
    this.merchantKey,
    this.vpa,
    this.description,
    this.counterpartyKind = CounterpartyKind.unknown,
  });

  final Direction direction;
  final TransactionFlow flow;
  final FlowReason flowReason;
  final String? counterpartyName;
  final String? merchantKey;
  final String? vpa;
  final String? description;
  final CounterpartyKind counterpartyKind;
}

/// One of your rules, as stored in `category_rules`.
///
/// [match] by [type]:
/// - merchantKey: `{"key": "swiggy"}`
/// - vpa: `{"vpa": "ravi@ybl"}`
/// - keyword: `{"contains": "rent"}`, matched as whole words
/// - regex: `{"pattern": "..."}`, case-insensitive, on the narration
///
/// Any rule may add `"direction": "debit"` or `"credit"`.
final class CategoryRuleSpec {
  const CategoryRuleSpec({
    required this.id,
    required this.type,
    required this.match,
    required this.categoryId,
    this.priority = 100,
  });

  final String id;
  final RuleType type;
  final Map<String, Object?> match;
  final String categoryId;
  final int priority;
}

/// Why a category was picked, for "see why".
enum CategoryBasis {
  /// One of your rules.
  rule,

  /// The built-in merchant dictionary matched the payee or UPI ID.
  merchant,

  /// The dictionary matched a word in the narration only.
  narration,

  /// The transaction is a transfer between your own accounts.
  ownTransfer,

  /// A credit card bill payment.
  cardBill,

  /// A refund or reversal of an earlier spend.
  refund,

  /// The bank's own interest, charges or ATM cash entries.
  bankEntry,

  /// The narration says salary.
  salary,

  /// A payment to or from a person rather than a business.
  person,
}

final class CategoryDecision {
  const CategoryDecision({
    required this.categoryId,
    required this.method,
    required this.confidence,
    required this.basis,
    this.ruleId,
    this.matched,
    this.why,
  });

  final String categoryId;
  final CategorizationMethod method;

  /// 0 to 1. Rules are 1; guesses from a payee looking like a person are
  /// lower and shown for review.
  final double confidence;
  final CategoryBasis basis;
  final String? ruleId;

  /// The word or value that matched, e.g. `swiggy`.
  final String? matched;

  /// From the dictionary, e.g. `a food delivery app`.
  final String? why;

  /// A sentence for "see why".
  String explain() => switch (basis) {
    CategoryBasis.rule => 'Your rule for "$matched" puts it here.',
    CategoryBasis.merchant => '"$matched" looks like $why.',
    CategoryBasis.narration =>
      'The statement mentions "$matched", which looks like $why.',
    CategoryBasis.ownTransfer => 'Money moved between your own accounts.',
    CategoryBasis.cardBill => 'A payment towards your credit card bill.',
    CategoryBasis.refund => 'Money back for an earlier payment.',
    CategoryBasis.bankEntry => "The bank's own entry: $why.",
    CategoryBasis.salary => 'The statement says salary.',
    CategoryBasis.person =>
      'The payee looks like a person, not a business. Change it if it was '
          'for something.',
  };
}

/// Decisions below this go to review instead of counting as categorised.
const categoryReviewBelow = 0.75;

/// Picks a category, on the device, in this order:
/// 1. transfers and card bills, which are never spending;
/// 2. your rules, lowest priority number first;
/// 3. the built-in merchant dictionary on the payee and UPI ID, then on
///    the narration;
/// 4. bank entries, salary, refunds and payments to people.
///
/// Returns null when nothing fits; the transaction stays uncategorised.
final class Categorizer {
  Categorizer(Iterable<CategoryRuleSpec> rules)
    : _rules = [...rules]..sort((a, b) => a.priority.compareTo(b.priority));

  final List<CategoryRuleSpec> _rules;

  CategoryDecision? categorize(CategorizeInput t) {
    if (t.flow == TransactionFlow.transfer) {
      final card = t.flowReason == FlowReason.cardBill;
      return CategoryDecision(
        categoryId: card ? Cat.cardBill : Cat.ownTransfers,
        method: CategorizationMethod.pattern,
        confidence: 1,
        basis: card ? CategoryBasis.cardBill : CategoryBasis.ownTransfer,
      );
    }
    for (final r in _rules) {
      final matched = _ruleMatch(r, t);
      if (matched != null) {
        return CategoryDecision(
          categoryId: r.categoryId,
          method: CategorizationMethod.rule,
          confidence: 1,
          basis: CategoryBasis.rule,
          ruleId: r.id,
          matched: matched,
        );
      }
    }
    return t.direction == Direction.debit ? _debit(t) : _credit(t);
  }

  CategoryDecision? _debit(CategorizeInput t) {
    if (_bankEntry(t) case final d?) return d;
    if (_dictionary(t) case final d?) return d;
    if (t.counterpartyKind == CounterpartyKind.person) {
      return const CategoryDecision(
        categoryId: Cat.sentToPeople,
        method: CategorizationMethod.pattern,
        confidence: 0.6,
        basis: CategoryBasis.person,
      );
    }
    return null;
  }

  CategoryDecision? _credit(CategorizeInput t) {
    if (t.flow == TransactionFlow.refund) {
      return const CategoryDecision(
        categoryId: Cat.refunds,
        method: CategorizationMethod.pattern,
        confidence: 0.95,
        basis: CategoryBasis.refund,
      );
    }
    if (_bankEntry(t) case final d?) return d;
    final words = _words(t.description);
    if (words.contains(' salary ') || words.contains(' sal ')) {
      return const CategoryDecision(
        categoryId: Cat.salary,
        method: CategorizationMethod.pattern,
        confidence: 0.9,
        basis: CategoryBasis.salary,
      );
    }
    if (t.counterpartyKind == CounterpartyKind.person) {
      return const CategoryDecision(
        categoryId: Cat.receivedFromPeople,
        method: CategorizationMethod.pattern,
        confidence: 0.6,
        basis: CategoryBasis.person,
      );
    }
    return null;
  }

  CategoryDecision? _bankEntry(CategorizeInput t) {
    final (id, why) = switch (t.merchantKey) {
      'bank_interest' => (Cat.interest, 'interest'),
      'bank_charges' => (Cat.bankCharges, 'a fee or charge'),
      'atm_cash' => (Cat.cash, 'cash from an ATM'),
      _ => (null, null),
    };
    if (id == null) return null;
    // Interest is money in; charges and cash are money out.
    if ((id == Cat.interest) != (t.direction == Direction.credit)) return null;
    return CategoryDecision(
      categoryId: id,
      method: CategorizationMethod.pattern,
      confidence: 0.95,
      basis: CategoryBasis.bankEntry,
      why: why,
    );
  }

  CategoryDecision? _dictionary(CategorizeInput t) {
    final payee = _words(
      [
        t.counterpartyName,
        t.merchantKey,
        t.vpa?.split('@').first,
      ].whereType<String>().join(' '),
    );
    final narration = _words(t.description);
    for (final (text, basis, confidence) in [
      (payee, CategoryBasis.merchant, 0.9),
      (narration, CategoryBasis.narration, 0.8),
    ]) {
      if (text.trim().isEmpty) continue;
      for (final p in merchantPatterns) {
        for (final k in p.keywords) {
          if (text.contains(' $k ')) {
            return CategoryDecision(
              categoryId: p.categoryId,
              method: CategorizationMethod.pattern,
              confidence: confidence,
              basis: basis,
              matched: k,
              why: p.why,
            );
          }
        }
      }
    }
    return null;
  }
}

/// Lower case words with single spaces and a space at each end, so a
/// keyword matches with `contains(' $k ')`.
String _words(String? s) {
  if (s == null) return ' ';
  final w = s
      .toLowerCase()
      .replaceAll("'", '')
      .replaceAll(RegExp('[^a-z0-9]+'), ' ')
      .trim();
  return ' $w ';
}

/// The matched value, or null when [r] doesn't apply to [t].
String? _ruleMatch(CategoryRuleSpec r, CategorizeInput t) {
  final dir = r.match['direction'];
  if (dir is String && dir != t.direction.wire) return null;
  switch (r.type) {
    case RuleType.merchantKey:
      final key = r.match['key'];
      return key is String && key == t.merchantKey ? key : null;
    case RuleType.vpa:
      final vpa = r.match['vpa'];
      return vpa is String && vpa.toLowerCase() == t.vpa?.toLowerCase()
          ? vpa
          : null;
    case RuleType.keyword:
      final k = r.match['contains'];
      if (k is! String || k.trim().isEmpty) return null;
      final text = _words(
        [
          t.counterpartyName,
          t.vpa,
          t.description,
        ].whereType<String>().join(' '),
      );
      return text.contains(_words(k)) ? k : null;
    case RuleType.regex:
      final pattern = r.match['pattern'];
      if (pattern is! String) return null;
      final RegExp re;
      try {
        re = RegExp(pattern, caseSensitive: false);
      } on FormatException {
        return null;
      }
      final text = [
        t.counterpartyName,
        t.description,
      ].whereType<String>().join(' ');
      return re.firstMatch(text)?[0];
    case RuleType.pattern:
      // Reserved for amount ranges and other shapes later.
      return null;
  }
}

/// The rule a correction should create: by merchant when the payee has a
/// merchant key, else by UPI ID. Null when there is nothing stable to
/// match on, so the correction stays a one-off.
({RuleType type, Map<String, Object?> match})? ruleForCorrection(
  CategorizeInput t,
) {
  if (t.merchantKey case final key? when !_bankKeys.contains(key)) {
    return (
      type: RuleType.merchantKey,
      match: {'key': key, 'direction': t.direction.wire},
    );
  }
  if (t.vpa case final vpa?) {
    return (
      type: RuleType.vpa,
      match: {'vpa': vpa.toLowerCase(), 'direction': t.direction.wire},
    );
  }
  return null;
}

const _bankKeys = {'bank_interest', 'bank_charges', 'atm_cash'};
