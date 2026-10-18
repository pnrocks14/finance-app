/// One bank's usual rule for its statement PDF password.
final class PasswordHint {
  const PasswordHint(this.source, this.rule, {this.example});

  /// The bank or app, and which statement: "HDFC Bank account".
  final String source;
  final String rule;

  /// A made-up example of the rule.
  final String? example;
}

/// The rules banks and their help pages describe. Banks change them, and
/// emailed and downloaded statements can differ, so these are hints, and
/// "Try my details" tries every known rule. Sources are listed in
/// knowledge/formats/README.md.
const statementPasswordHints = <PasswordHint>[
  PasswordHint(
    'Kotak Mahindra Bank',
    'Your date of birth as DDMMYYYY, or your 9-digit CRN.',
    example: '15081995',
  ),
  PasswordHint(
    'India Post Payments Bank',
    'First 4 letters of your name in capitals + date of birth as DDMMYY.',
    example: 'ASHA150895',
  ),
  PasswordHint('HDFC Bank account', 'Your customer ID.'),
  PasswordHint(
    'HDFC Bank credit card',
    'First 4 letters of your name in capitals + last 4 digits of the card.',
    example: 'ASHA1234',
  ),
  PasswordHint(
    'ICICI Bank',
    'First 4 letters of your name + date of birth as DDMM. Credit card '
        'statements use lower case.',
    example: 'asha1508',
  ),
  PasswordHint(
    'State Bank of India',
    'Emailed: last 5 digits of your mobile + date of birth as DDMMYY. '
        'Downloaded from net banking: your 11-digit account number.',
    example: '43210150895',
  ),
  PasswordHint(
    'SBI Card',
    'First 4 letters of your name in capitals + date of birth as DDMM.',
    example: 'ASHA1508',
  ),
  PasswordHint(
    'Axis, Union Bank, Federal Bank, IndusInd',
    'First 4 letters of your name in capitals + date of birth as DDMM.',
    example: 'ASHA1508',
  ),
  PasswordHint('IDFC First Bank', 'Your date of birth as DDMMYYYY.'),
  PasswordHint('Yes Bank', 'Customer ID + date of birth as DDMMYYYY.'),
  PasswordHint('Punjab National Bank', 'Your full account number.'),
  PasswordHint(
    'Bank of Baroda',
    'First 4 letters of your name in lower case + date of birth as DDMM.',
    example: 'asha1508',
  ),
  PasswordHint('Canara Bank, AU Small Finance Bank', 'Your customer ID.'),
];
