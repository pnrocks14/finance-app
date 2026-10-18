import '../models/enums.dart';
import '../money/paise.dart';
import '../time/local_date.dart';
import 'statement_date.dart';

/// What a bank's transaction SMS says.
final class ParsedSms {
  const ParsedSms({
    required this.direction,
    required this.amount,
    required this.channel,
    this.institution,
    this.accountLast4,
    this.cardLast4,
    this.counterparty,
    this.vpa,
    this.upiRef,
    this.balance,
    this.availableLimit,
    this.date,
    this.isCreditCard = false,
  });

  final Direction direction;
  final Paise amount;
  final Channel channel;

  /// The bank, from the sender id: `VM-HDFCBK` → HDFC Bank.
  final String? institution;
  final String? accountLast4;
  final String? cardLast4;

  /// Merchant or person, as the SMS names them.
  final String? counterparty;
  final String? vpa;

  /// 12-digit UPI reference, matching the bank statement's.
  final String? upiRef;
  final Paise? balance;

  /// Credit cards report the limit left instead of a balance.
  final Paise? availableLimit;

  /// The date in the message, when it has one.
  final LocalDate? date;
  final bool isCreditCard;

  Map<String, Object?> toJson() => {
    'direction': direction.wire,
    'amountPaise': amount.value,
    'channel': channel.wire,
    'institution': institution,
    'accountLast4': accountLast4,
    'cardLast4': cardLast4,
    'counterparty': counterparty,
    'vpa': vpa,
    'upiRef': upiRef,
    'balancePaise': balance?.value,
    'availableLimitPaise': availableLimit?.value,
    'date': date?.toIso(),
    'isCreditCard': isCreditCard,
  };
}

/// Sender id cores (`HDFCBK` in `VM-HDFCBK-S`) and their banks.
const smsSenders = <String, String>{
  'HDFCBK': 'HDFC Bank',
  'HDFCBN': 'HDFC Bank',
  'ICICIB': 'ICICI Bank',
  'ICICIT': 'ICICI Bank',
  'SBIUPI': 'State Bank of India',
  'SBIINB': 'State Bank of India',
  'SBMSMS': 'State Bank of India',
  'CBSSBI': 'State Bank of India',
  'ATMSBI': 'State Bank of India',
  'SBICRD': 'SBI Card',
  'AXISBK': 'Axis Bank',
  'AXISMR': 'Axis Bank',
  'KOTAKB': 'Kotak Mahindra Bank',
  'KOTAKM': 'Kotak Mahindra Bank',
  'IPBMSG': 'India Post Payments Bank',
  'IPPBNK': 'India Post Payments Bank',
  'UNTYCC': 'Unity Small Finance Bank',
  'UNTYBK': 'Unity Small Finance Bank',
  'IDFCFB': 'IDFC First Bank',
  'YESBNK': 'Yes Bank',
  'INDUSB': 'IndusInd Bank',
  'PNBSMS': 'Punjab National Bank',
  'BOBTXN': 'Bank of Baroda',
  'BOBSMS': 'Bank of Baroda',
  'CANBNK': 'Canara Bank',
  'UNIONB': 'Union Bank of India',
  'AUBANK': 'AU Small Finance Bank',
  'FEDBNK': 'Federal Bank',
  'PAYTMB': 'Paytm Payments Bank',
  'AIRBNK': 'Airtel Payments Bank',
  'ONECRD': 'OneCard',
  'ONECARD': 'OneCard',
  'SLCEIT': 'Slice',
  'SLICEIT': 'Slice',
  'SLCBNK': 'Slice',
  'JUPITR': 'Jupiter',
  'JTEDGE': 'Jupiter Edge CSB card',
  'KOTAKD': 'Kotak Mahindra Bank',
  'HDFCB': 'HDFC Bank',
  'SBIPSG': 'State Bank of India',
  'SBIBK': 'State Bank of India',
  'IDFCBK': 'IDFC First Bank',
  'INDUSIND': 'IndusInd Bank',
  'PNBBNK': 'Punjab National Bank',
  'PUNBN': 'Punjab National Bank',
  'BOBCRD': 'Bank of Baroda',
  'UBOI': 'Union Bank of India',
  'FEDFIB': 'Federal Bank',
  'FEDSMS': 'Federal Bank',
  'FEDSCP': 'Federal Bank',
  'DOPBNK': 'India Post',
};

/// The bank behind a sender id such as `VM-HDFCBK` or `JD-KOTAKB-S`, or
/// null for senders that aren't banks.
String? institutionForSender(String sender) {
  final upper = sender.toUpperCase();
  // DLT headers end in -S/-T (service, transactional), -G (government) or
  // -P (promotional). Promotions are never transactions.
  if (upper.endsWith('-P')) return null;
  final parts = upper.split(RegExp('[^A-Z0-9]'));
  for (final p in parts) {
    final bank = smsSenders[p];
    if (bank != null) return bank;
  }
  return null;
}

/// Maps styled Unicode letters and digits (SBI Card writes `𝗌𝗉𝖾𝗇𝗍`) to
/// plain ASCII so the patterns below match. A small stand-in for NFKC.
String plainLetters(String s) {
  if (!s.runes.any((r) => r >= 0x1D400 && r <= 0x1D7FF)) return s;
  final out = StringBuffer();
  for (final r in s.runes) {
    if (r >= 0x1D400 && r <= 0x1D6A3) {
      // 13 styles of 52 letters each: A–Z then a–z.
      final i = (r - 0x1D400) % 52;
      out.writeCharCode(i < 26 ? 0x41 + i : 0x61 + i - 26);
    } else if (r >= 0x1D7CE && r <= 0x1D7FF) {
      out.writeCharCode(0x30 + (r - 0x1D7CE) % 10);
    } else {
      out.writeCharCode(r);
    }
  }
  return out.toString();
}

final _amount = RegExp(
  r'(?:Rs\.?|INR|₹)\s*([\d,]+(?:\.\d{1,2})?)',
  caseSensitive: false,
);

/// "debited by 20.0", "credited with 500" (SBI and others leave out Rs).
final _bareAmount = RegExp(
  r'(?:debited|credited)\s+(?:by|with|for)\s+([\d,]+(?:\.\d{1,2})?)',
  caseSensitive: false,
);

/// Messages that mention money but are not a transaction that happened:
/// one-time passwords, requests, reminders, offers and declines.
final _notATransaction = RegExp(
  r'(\bOTP\b|one.time.password|verification code|\bis your\b.*\bcode\b|'
  r'bill alert|mandate\b.*\b(received|created|registered|set up)|e-?voucher|\bASBA\b|has avl bal|ignore if already|'
  r'collect request|has requested|requesting|payment request|'
  r'will be debited|will be credited|is due|due date|due on|min(imum)? amt|'
  r'minimum amount due|statement (is )?generated|bill (is )?generated|'
  r'pre-?approved|offer|cashback up to|eligible for|apply now|loan of|'
  r'declined|unsuccessful|could not be|not been processed|'
  r'has been blocked|insufficient)',
  caseSensitive: false,
);

final _debitWords = RegExp(
  r'\b(debited|spent|sent|paid|withdrawn|withdrawal|purchase|deducted|'
  r'used for|txn of|transferred from|transferred|trf to|debit)\b|'
  r'\bDr\.(?=\s)',
  caseSensitive: false,
);
final _creditWords = RegExp(
  r'\b(credited|received|deposited|refund(ed)?|reversed|reversal|added to|'
  r'credit)\b|\bCr\.?(?=\s+INR)',
  caseSensitive: false,
);

final _account = RegExp(
  r'\b(?:a/?c|acct|account|ac)\b\.?\s*(?:no\.?|number)?\s*(?:ending\s*)?'
  r'[:\s]*[Xx*•.]*\s*(\d{3,6})\b',
  caseSensitive: false,
);

/// "from XXXXXX1234" with no "A/c" in front (Kotak UPI).
final _maskedNumber = RegExp(r'\b(?:from|in|to)\s+[Xx*]{2,}(\d{3,6})\b');
final _card = RegExp(
  r'\bcard\b(?:\s*(?:no\.?|number|ending(?:\s*with)?))?\s*[:\s]*[Xx*•.]*\s*'
  r'(\d{4})\b',
  caseSensitive: false,
);
final _vpa = RegExp(r'[A-Za-z0-9._-]{2,256}@[A-Za-z][A-Za-z0-9]{1,64}');
final _upiRef = RegExp(
  r'(?:UPI\s*Ref(?:erence)?(?:\s*(?:No|ID))?|UPI|Ref(?:erence)?\s*No|Refno|RRN|'
  r'UTR|Ref)[\s.:#-]*(\d{12})(?!\d)',
  caseSensitive: false,
);
final _balance = RegExp(
  r'(?:Avl\.?\s*Bal(?:ance)?|Available\s*Bal(?:ance)?|A/c\s*Bal(?:ance)?|'
  r'\bBal(?:ance)?\b)\s*(?:is|:|-)?\s*(?:Rs\.?|INR|₹)\s*([\d,]+(?:\.\d{1,2})?)',
  caseSensitive: false,
);
final _limit = RegExp(
  r'(?:Avl\.?\s*(?:Cr\.?\s*)?Lmt|Avl\.?\s*Limit|Available\s*(?:Credit\s*)?'
  r'Limit)\s*(?:is|:|-)?\s*(?:Rs\.?|INR|₹)\s*([\d,]+(?:\.\d{1,2})?)',
  caseSensitive: false,
);

/// Where the money went or came from: "at SWIGGY", "to ASHA KUMAR",
/// "from ravi@ybl", "; RAVI credited" (ICICI), "Info: SWIGGY".
final _counterparty = <RegExp>[
  RegExp(
    r"\b(?:spent|txn|purchase|used)\b.*?\bat\s+([A-Za-z0-9][A-Za-z0-9 &'._*-]{1,40}?)"
    r'(?=\s*(?:\.|,|;|\bon\b|\bvia\b|\bRef\b|\bAvl\b|\bCard\b|\bTime\b|$))',
    caseSensitive: false,
  ),
  // "spent ... on 05-Jul-26 on SOME SHOP": skip the date and the card.
  RegExp(
    r'\b(?:spent|txn|purchase|used)\b.*?\bon\s+'
    r'(?!\d{1,2}[-/ ]?(?:\d{1,2}|[A-Za-z]{3})\b|your\b|'
    r'(?:\w+\s+){0,2}(?:credit|debit|bank)\s+card\b)'
    r"([A-Za-z0-9][A-Za-z0-9 &'._*-]{1,40}?)"
    r'(?=\s*(?:\.|,|;|\bon\b|\bvia\b|\bRef\b|\bAvl\b|\bCard\b|\bTime\b|$))',
    caseSensitive: false,
  ),
  RegExp(
    r'\b(?:to|towards|trf to|transferred to|paid to)\s+(?!your\b)(?:VPA\s+)?'
    r"([A-Za-z0-9][A-Za-z0-9 &'@._-]{1,40}?)"
    r'(?=\s*(?:\.|,|;|\bon\b|\bvia\b|\bRef|\bUPI\b|\bAvl\b|\(|$))',
    caseSensitive: false,
  ),
  RegExp(
    r'\bfrom\s+(?!your\b|a/c\b|ac\b|account\b)(?:VPA\s+)?'
    r"([A-Za-z0-9][A-Za-z0-9 &'@._-]{1,40}?)"
    r'(?=\s*(?:\.|,|;|\bon\b|\bvia\b|\bRef|\bUPI\b|\bAvl\b|\(|$))',
    caseSensitive: false,
  ),
  RegExp(
    r";\s*([A-Za-z0-9][A-Za-z0-9 &'._-]{1,40}?)\s+credited",
    caseSensitive: false,
  ),
  RegExp(r'\bInfo:?\s*([A-Za-z0-9][\w &./*-]{1,40}?)(?=\s*(?:\.|$))'),
];

/// Dates as banks write them in SMS: `07/08/2026`, `07-08-26`,
/// `07Aug26`, `07-Aug-26`, `01Jul2026`.
final _date = RegExp(
  r'\b(\d{1,2})[-/ ]?(\d{1,2}|[A-Za-z]{3})[-/ ]?(\d{4}|\d{2})\b',
);

LocalDate? _findDate(String body) {
  for (final m in _date.allMatches(body)) {
    final month = m[2]!;
    final text = int.tryParse(month) != null
        ? '${m[1]}/$month/${m[3]}'
        : '${m[1]}-$month-${m[3]}';
    // Numeric runs without separators (phone numbers) are not dates.
    if (int.tryParse(month) != null && !RegExp(r'[-/]').hasMatch(m[0]!)) {
      continue;
    }
    final d = parseStatementDate(text);
    if (d != null) return d;
  }
  return null;
}

Paise? _money(RegExpMatch? m) => m == null ? null : Paise.tryParse(m[1]!);

/// Reads a transaction SMS from a bank or card. Returns null for anything
/// that is not money that already moved: OTPs, payment requests, bill
/// reminders, offers and declined payments. Never throws.
ParsedSms? parseTransactionSms(String sender, String body) {
  if (sender.toUpperCase().endsWith('-P')) return null;
  final text = plainLetters(body).replaceAll(RegExp(r'\s+'), ' ').trim();
  if (_notATransaction.hasMatch(text)) return null;
  // "Txn failed" is not money moving, but "refund of failed txn" is.
  if (RegExp(r'\bfailed\b', caseSensitive: false).hasMatch(text) &&
      !RegExp(
        r'refunded|has been reversed|\breversed to|reversal of|credited',
        caseSensitive: false,
      ).hasMatch(text)) {
    return null;
  }
  final institution = institutionForSender(sender);

  final amount =
      _money(_amount.firstMatch(text)) ?? _money(_bareAmount.firstMatch(text));
  if (amount == null || amount.value <= 0) return null;

  // Whichever word comes first decides: "debited ... credited to NAME"
  // (ICICI) is a debit, "credited ... from NAME" a credit.
  final debit = _debitWords.firstMatch(text);
  final credit = _creditWords.firstMatch(text);
  final Direction direction;
  if (debit != null && (credit == null || debit.start < credit.start)) {
    direction = Direction.debit;
  } else if (credit != null) {
    direction = Direction.credit;
  } else {
    return null;
  }

  final card = _card.firstMatch(text)?[1];
  final limit = _money(_limit.firstMatch(text));
  final isCreditCard =
      RegExp(r'credit\s*card|\bCC\b', caseSensitive: false).hasMatch(text) ||
      limit != null ||
      sender.toUpperCase().contains('CC') && card != null;
  final vpa = _vpa.firstMatch(text)?[0];
  final upiRef = _upiRef.firstMatch(text)?[1];
  final upper = text.toUpperCase();

  final Channel channel;
  if (upiRef != null || vpa != null || upper.contains('UPI')) {
    channel = Channel.upi;
  } else if (RegExp(
    r'\b(ATM|CASH WDL|withdrawn)\b',
    caseSensitive: false,
  ).hasMatch(text)) {
    channel = Channel.atm;
  } else if (upper.contains('NEFT')) {
    channel = Channel.neft;
  } else if (upper.contains('IMPS')) {
    channel = Channel.imps;
  } else if (upper.contains('RTGS')) {
    channel = Channel.rtgs;
  } else if (card != null) {
    channel = Channel.card;
  } else {
    channel = Channel.other;
  }

  String? counterparty;
  for (final re in _counterparty) {
    final m = re.firstMatch(text);
    if (m == null) continue;
    final c = m[1]!.trim();
    final lower = c.toLowerCase();
    // Skip phrases that are the format, not a payee.
    if (RegExp(r'^(your|a/?c|ac|account|card|bank|rs|inr)\b').hasMatch(lower)) {
      continue;
    }
    counterparty = c;
    break;
  }

  final accountMatch =
      _account.firstMatch(text) ?? _maskedNumber.firstMatch(text);
  return ParsedSms(
    direction: direction,
    amount: amount,
    channel: channel,
    institution: institution,
    accountLast4: card == null ? (accountMatch?[1]) : null,
    cardLast4: card,
    counterparty: counterparty,
    vpa: vpa?.toLowerCase(),
    upiRef: upiRef,
    balance: limit == null ? _money(_balance.firstMatch(text)) : null,
    availableLimit: limit,
    date: _findDate(text),
    isCreditCard: isCreditCard,
  );
}
