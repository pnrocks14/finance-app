import '../models/enums.dart';

/// What a bank narration says about a transaction, e.g.
/// `UPI-SWIGGY-swiggy@ybl-YESB0000001-412233445566-Payment`.
final class ParsedDescription {
  const ParsedDescription({
    required this.channel,
    this.counterpartyName,
    this.vpa,
    this.upiRef,
    this.bankRef,
    this.bankCode,
    this.cardLast4,
    this.merchantKey,
    this.counterpartyKind = CounterpartyKind.unknown,
  });

  final Channel channel;

  /// Payee or payer as written, cleaned of codes: `SWIGGY`.
  final String? counterpartyName;

  /// UPI handle: `swiggy@ybl`.
  final String? vpa;

  /// 12-digit UPI reference (RRN).
  final String? upiRef;

  /// NEFT/IMPS/RTGS UTR or other bank reference.
  final String? bankRef;

  /// Bank short code or IFSC prefix: `YESB`.
  final String? bankCode;
  final String? cardLast4;

  /// Stable lowercase key for rules: `swiggy`.
  final String? merchantKey;
  final CounterpartyKind counterpartyKind;

  Map<String, Object?> toJson() => {
    'channel': channel.wire,
    'counterpartyName': counterpartyName,
    'vpa': vpa,
    'upiRef': upiRef,
    'bankRef': bankRef,
    'bankCode': bankCode,
    'cardLast4': cardLast4,
    'merchantKey': merchantKey,
    'counterpartyKind': counterpartyKind.wire,
  };
}

// Hyphens are left out: in narrations they separate fields.
final _vpa = RegExp(r'[A-Za-z0-9._]{2,256}@[A-Za-z][A-Za-z0-9]{1,64}');
final _upiRef = RegExp(r'(?<!\d)\d{12}(?!\d)');
final _ifsc = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
final _bankCode = RegExp(r'^[A-Z]{4}$');
final _maskedCard = RegExp(r'\d{4,6}[Xx*]{4,8}(\d{4})|[Xx*]{4,12}(\d{4})');

/// UTRs and references: a bank prefix with mostly digits, or all digits.
final _utr = RegExp(r'^[A-Z]{4}[A-Z0-9]*\d{6,}[A-Z0-9]*$|^\d{10,22}$');

/// Words that are part of the format, not the payee.
const _noise = {
  'upi', 'dr', 'cr', 'p2a', 'p2m', 'p2p', 'to', 'by', 'from', 'transfer', //
  'payment', 'pay', 'paid', 'sent', 'using', 'neft', 'imps', 'rtgs', 'mmt',
  'pos', 'ecom', 'atw', 'atm', 'nwd', 'eaw', 'inb', 'ib', 'mb', 'ach', 'nach',
  'ecs', 'ref', 'no', 'txn', 'collect', 'request', 'ok', 'na', 'null',
  'trf', 'ft', 'imp', 'other', 'others', 'remarks', 'upiintent', 'intent',
};

/// First words of the free-text note a payer types into UPI.
const _notePrefixes = {
  'payment', 'paid', 'sent', 'pay', 'upi', 'collect', 'request', 'note', //
  'via', 'for', 'from', 'transfer', 'txn', 'ref',
};

/// Banks that appear as the 4-letter code in UPI narrations. A token that
/// is one of these is the bank, not the payee.
const _bankCodes = {
  'HDFC', 'ICIC', 'SBIN', 'UTIB', 'KKBK', 'YESB', 'PUNB', 'BARB', 'CNRB', //
  'UBIN', 'IDIB', 'IOBA', 'INDB', 'IDFB', 'FDRL', 'AUBL', 'PYTM', 'AIRP',
  'JIOP', 'RATN', 'BKID', 'MAHB', 'CBIN', 'UCBA', 'PSIB', 'SCBL', 'CITI',
  'HSBC', 'DBSS', 'KARB', 'KVBL', 'SIBL', 'TMBL', 'CSBK', 'DLXB', 'ESFB',
  'UJVN', 'FINO', 'NSPB', 'IPOS', 'MAHG', 'APGB', 'ABHY', 'COSB', 'SVCB',
  'TJSB', 'BDBL', 'KSCB', 'PJSB', 'SRCB', 'IBKL', 'USFB', 'SURY', 'JSFB',
};

/// VPA patterns that belong to merchants rather than people.
final _merchantVpa = RegExp(
  r'(paytmqr|bharatpe|\.rzp@|razorpay|cashfree|payu|billdesk|^q\d+@|'
  r'merchant|@okbizaxis|@hdfcbankmerch|ombk\.|gpay-\d+@|^mab\.|^yespay\.|'
  r'@ptys|@pthdfc|@paytm$|@ikwik|@axisb$)',
  caseSensitive: false,
);
final _companyName = RegExp(
  r'\b(pvt|private|ltd|limited|llp|technologies|tech|services|solutions|'
  r'enterprises|industries|retail|stores?|mart|foods?|restaurant|cafe|'
  r'hotel|hospital|pharma|medical|motors|fuels?|petroleum|airlines?|'
  r'railway|irctc|insurance|broking|securities|finance|financial|bank)\b',
  caseSensitive: false,
);

/// Interest credited by the bank: `Int.Pd:1234567890:01-07-2026 to …`,
/// `CREDIT INTEREST`, `SB INT`.
final _interest = RegExp(
  r'^(int\.?\s*pd\b|int\.?\s*paid\b|interest\b|credit\s*interest|'
  r'sb\s*int\b|int\.?\s*credit)',
  caseSensitive: false,
);

/// Fees: `CHRG:SMS ALERT FEE FOR THE MONTH OF JUN26`, `SMS CHARGES`,
/// `DEBIT CARD ANNUAL FEE`, `MIN BAL CHGS`.
final _charges = RegExp(
  r'^(chrg\b|chgs?\b|charges?\b)|\b(sms\s*(alert|chg|charges)|annual\s*fee|'
  r'min(imum)?\s*bal(ance)?\s*(chg|charge)|non\s*maint)',
  caseSensitive: false,
);

/// Turns a bank narration into channel, payee, VPA and references.
/// Never throws; unknown formats come back as [Channel.other] with the
/// cleaned text as the payee.
ParsedDescription parseDescription(String raw) {
  final text = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  final upper = text.toUpperCase();

  // The bank's own entries: interest paid to you and fees it charged.
  if (_interest.hasMatch(text)) {
    return const ParsedDescription(
      channel: Channel.other,
      counterpartyName: 'Interest',
      merchantKey: 'bank_interest',
      counterpartyKind: CounterpartyKind.merchant,
    );
  }
  if (!upper.startsWith('UPI') && _charges.hasMatch(text)) {
    return const ParsedDescription(
      channel: Channel.other,
      counterpartyName: 'Bank charges',
      merchantKey: 'bank_charges',
      counterpartyKind: CounterpartyKind.merchant,
    );
  }

  if (_startsWithAny(upper, const [
        'UPI',
        'TO TRANSFER-UPI',
        'BY TRANSFER-UPI',
      ]) ||
      upper.contains('/UPI/') ||
      upper.contains('-UPI/') ||
      upper.contains('UPI/') && _vpa.hasMatch(text)) {
    return _parseUpi(text);
  }
  if (upper.contains('NEFT')) return _parseBankTransfer(text, Channel.neft);
  if (upper.contains('RTGS')) return _parseBankTransfer(text, Channel.rtgs);
  if (upper.contains('IMPS') || upper.startsWith('MMT/')) {
    return _parseBankTransfer(text, Channel.imps);
  }
  if (RegExp(r'^(ATW|NWD|EAW|ATM|CASH WDL|ATM WDL)\b|ATM WDL|CASH WITHDRAWAL')
      .hasMatch(upper)) {
    return ParsedDescription(
      channel: Channel.atm,
      counterpartyName: 'Cash withdrawal',
      cardLast4: _cardLast4(text),
      merchantKey: 'atm_cash',
      counterpartyKind: CounterpartyKind.self,
    );
  }
  if (RegExp(r'^(POS|ECOM|PCD|VPS|IPS|VIN|CRV POS|ME DC)\b|^POS[\/ -]')
      .hasMatch(upper)) {
    return _parseCard(text);
  }
  if (RegExp(r'\b(ACH|NACH|ECS)\b').hasMatch(upper)) {
    return _parseNamedOther(text, Channel.netBanking);
  }
  if (RegExp(r'^(CHQ|CHEQUE|CLG|CLEARING)\b').hasMatch(upper)) {
    return _parseNamedOther(text, Channel.cheque);
  }
  if (RegExp(r'^(INB|IB |NETBANKING|NET BANKING|BIL/|BILLPAY|BPAY)')
      .hasMatch(upper)) {
    return _parseNamedOther(text, Channel.netBanking);
  }
  return _parseNamedOther(text, Channel.other);
}

/// Merchant key and kind for a payee a payment app names in full
/// (`SHARMA DAIRY`, `Flipkart Payments`). App statements have no narration
/// to pick apart, only the name.
ParsedDescription parsePayee(String name, {String? upiRef}) {
  final clean = _cleanName(name);
  return ParsedDescription(
    channel: Channel.upi,
    counterpartyName: clean.isEmpty ? null : clean,
    upiRef: upiRef,
    merchantKey: _merchantKey(clean, null),
    counterpartyKind: _kindOf(clean, null),
  );
}

bool _startsWithAny(String s, List<String> prefixes) =>
    prefixes.any(s.startsWith);

List<String> _tokens(String text) => text
    .split(RegExp(r'[\/\-|:]+'))
    .map((t) => t.trim())
    .where((t) => t.isNotEmpty)
    .toList();

ParsedDescription _parseUpi(String text) {
  final vpa = _vpa.firstMatch(text)?.group(0)?.toLowerCase();
  // Look for the RRN outside the VPA (a VPA may be a phone number).
  final withoutVpa = vpa == null
      ? text
      : text.replaceFirst(
          RegExp(RegExp.escape(vpa), caseSensitive: false),
          ' ',
        );
  final upiRef = _upiRef.firstMatch(withoutVpa)?.group(0);
  String? bankCode;
  String? name;
  for (final token in _tokens(withoutVpa)) {
    final t = token.toUpperCase();
    if (_ifsc.hasMatch(t)) {
      bankCode ??= t.substring(0, 4);
      continue;
    }
    if (_bankCode.hasMatch(t) && _bankCodes.contains(t)) {
      bankCode ??= t;
      continue;
    }
    if (name == null && _looksLikeName(token)) name = _cleanName(token);
  }
  // Without a readable name, fall back to the VPA's local part.
  if (name == null && vpa != null) {
    final local = vpa.split('@').first;
    if (!RegExp(r'^\d+$').hasMatch(local)) name = local;
  }
  return ParsedDescription(
    channel: Channel.upi,
    counterpartyName: name,
    vpa: vpa,
    upiRef: upiRef,
    bankCode: bankCode,
    merchantKey: _merchantKey(name, vpa),
    counterpartyKind: _kindOf(name, vpa),
  );
}

ParsedDescription _parseBankTransfer(String text, Channel channel) {
  String? ref;
  String? name;
  String? bankCode;
  for (final token in _tokens(text)) {
    final t = token.toUpperCase();
    if (_noise.contains(t.toLowerCase())) continue;
    if (_ifsc.hasMatch(t)) {
      bankCode ??= t.substring(0, 4);
      continue;
    }
    if (ref == null && _utr.hasMatch(t.replaceAll(' ', ''))) {
      ref = t.replaceAll(' ', '');
      continue;
    }
    if (_bankCode.hasMatch(t) && _bankCodes.contains(t)) {
      bankCode ??= t;
      continue;
    }
    if (name == null && _looksLikeName(token)) name = _cleanName(token);
  }
  return ParsedDescription(
    channel: channel,
    counterpartyName: name,
    bankRef: ref,
    bankCode: bankCode,
    merchantKey: _merchantKey(name, null),
    counterpartyKind: _kindOf(name, null),
  );
}

ParsedDescription _parseCard(String text) {
  final last4 = _cardLast4(text);
  final stripped = text
      .replaceAll(_maskedCard, ' ')
      .replaceFirst(
        RegExp(
          r'^(POS|ECOM|PCD|VPS|IPS|VIN|CRV POS|ME DC)\b[\/ -]*',
          caseSensitive: false,
        ),
        '',
      );
  String? name;
  for (final token in _tokens(stripped)) {
    if (_looksLikeName(token)) {
      name = _cleanName(token);
      break;
    }
  }
  return ParsedDescription(
    channel: Channel.card,
    counterpartyName: name,
    cardLast4: last4,
    merchantKey: _merchantKey(name, null),
    counterpartyKind: name == null
        ? CounterpartyKind.unknown
        : CounterpartyKind.merchant,
  );
}

ParsedDescription _parseNamedOther(String text, Channel channel) {
  String? name;
  for (final token in _tokens(text)) {
    if (_looksLikeName(token)) {
      name = _cleanName(token);
      break;
    }
  }
  return ParsedDescription(
    channel: channel,
    counterpartyName: name,
    merchantKey: _merchantKey(name, null),
    counterpartyKind: _kindOf(name, null),
  );
}

String? _cardLast4(String text) {
  final m = _maskedCard.firstMatch(text);
  return m?.group(1) ?? m?.group(2);
}

bool _looksLikeName(String token) {
  final t = token.trim();
  if (t.length < 2) return false;
  final words = t.toLowerCase().split(' ');
  // Format words ("TO TRANSFER"), notes ("Payment from Ph") and bank names
  // ("YES BANK LIMITED") are not the payee.
  if (words.every(_noise.contains)) return false;
  if (_notePrefixes.contains(words.first)) return false;
  if (words.contains('bank')) return false;
  if (_vpa.hasMatch(t)) return false;
  // Mostly letters: at least two, and more letters than digits.
  final letters = RegExp('[A-Za-z]').allMatches(t).length;
  final digits = RegExp(r'\d').allMatches(t).length;
  if (letters < 2 || digits > letters) return false;
  if (_ifsc.hasMatch(t.toUpperCase())) return false;
  if (_bankCodes.contains(t.toUpperCase())) return false;
  return true;
}

String _cleanName(String token) => token
    .replaceAll(RegExp(r'[*_]+'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

const _suffixes = [
  'private limited', 'pvt ltd', 'pvt. ltd.', 'pvt', 'ltd', 'limited', //
  'llp', 'india', 'technologies', 'online', 'services', 'internet',
  'com', 'in', 'co',
];

/// `Swiggy Pvt Ltd` and `swiggy@ybl` both become `swiggy`.
String? _merchantKey(String? name, String? vpa) {
  var base = name?.toLowerCase();
  if (base == null || base.trim().isEmpty) {
    final local = vpa?.split('@').first.toLowerCase();
    if (local == null || RegExp(r'^\d+$').hasMatch(local)) return null;
    base = local;
  }
  base = base.replaceAll(RegExp(r'[^a-z0-9 ]'), ' ');
  var words = base.split(' ').where((w) => w.isNotEmpty).toList();
  var changed = true;
  while (changed && words.length > 1) {
    changed = false;
    for (final s in _suffixes) {
      final parts = s.split(' ');
      if (words.length > parts.length &&
          words.sublist(words.length - parts.length).join(' ') == s) {
        words = words.sublist(0, words.length - parts.length);
        changed = true;
      }
    }
  }
  final key = words.join('_');
  return key.isEmpty ? null : key;
}

CounterpartyKind _kindOf(String? name, String? vpa) {
  if (vpa != null) {
    if (_merchantVpa.hasMatch(vpa)) return CounterpartyKind.merchant;
    final local = vpa.split('@').first;
    // A 10-digit mobile number handle is almost always a person.
    if (RegExp(r'^[6-9]\d{9}$').hasMatch(local)) return CounterpartyKind.person;
  }
  if (name != null && _companyName.hasMatch(name)) {
    return CounterpartyKind.merchant;
  }
  return CounterpartyKind.unknown;
}
