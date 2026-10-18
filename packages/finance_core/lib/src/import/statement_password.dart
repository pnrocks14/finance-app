import '../time/local_date.dart';

/// Details banks build statement PDF passwords from. Typed on the password
/// screen, used to try candidates, and never saved.
final class PasswordDetails {
  const PasswordDetails({
    this.name,
    this.dateOfBirth,
    this.mobile,
    this.customerId,
    this.accountNumber,
    this.cardLast4,
  });

  /// As printed on the account: first name first.
  final String? name;
  final LocalDate? dateOfBirth;
  final String? mobile;

  /// Customer ID, CRN or CIF.
  final String? customerId;
  final String? accountNumber;
  final String? cardLast4;
}

String _two(int n) => n.toString().padLeft(2, '0');

/// Every password Indian banks are known to use for statement PDFs, built
/// from [d], most common rules first and without repeats. Rules vary by
/// bank and change over time, so the app tries them all rather than
/// guessing the bank. See knowledge/formats/README.md.
List<String> statementPasswordCandidates(PasswordDetails d) {
  final out = <String>{};
  void add(String? s) {
    if (s != null && s.isNotEmpty) out.add(s);
  }

  final letters = (d.name ?? '').replaceAll(RegExp('[^A-Za-z]'), '');
  final name4 = letters.length >= 4 ? letters.substring(0, 4) : null;
  final dob = d.dateOfBirth;
  final ddmm = dob == null ? null : '${_two(dob.day)}${_two(dob.month)}';
  final ddmmyy = dob == null ? null : '$ddmm${_two(dob.year % 100)}';
  final ddmmyyyy = dob == null ? null : '$ddmm${dob.year}';
  final mobile = d.mobile?.replaceAll(RegExp(r'\D'), '');
  final mobile10 = mobile == null || mobile.length < 10
      ? null
      : mobile.substring(mobile.length - 10);
  final id = d.customerId?.trim();
  final account = d.accountNumber?.replaceAll(RegExp(r'\s'), '');
  final card = d.cardLast4?.trim();

  if (name4 != null && ddmm != null) {
    // Axis, Union, Federal, SBI Card, IndusInd: NAME + DDMM.
    add('${name4.toUpperCase()}$ddmm');
    // ICICI card, Bank of Baroda: name + DDMM in lower case.
    add('${name4.toLowerCase()}$ddmm');
    // As typed, for banks that keep the name's case.
    add('$name4$ddmm');
  }
  // Kotak, IDFC First, Airtel: date of birth.
  add(ddmmyyyy);
  add(ddmmyy);
  // HDFC, Canara, AU, Kotak (CRN), IndusInd: customer ID.
  add(id);
  if (id != null && ddmmyyyy != null) add('$id$ddmmyyyy'); // Yes Bank
  if (mobile10 != null && ddmmyy != null) {
    add('${mobile10.substring(5)}$ddmmyy'); // SBI e-statements
  }
  if (name4 != null && card != null) {
    add('${name4.toUpperCase()}$card'); // HDFC card
    add('${name4.toLowerCase()}$card');
  }
  if (name4 != null && ddmmyy != null) {
    add('${name4.toUpperCase()}$ddmmyy'); // IPPB
  }
  if (name4 != null && ddmmyyyy != null) {
    add('${name4.toUpperCase()}$ddmmyyyy');
    add('${name4.toLowerCase()}$ddmmyyyy'); // Paytm
  }
  if (name4 != null && id != null) add('${name4.toUpperCase()}$id'); // Axis
  add(account); // SBI net banking, PNB
  add(mobile10);
  if (ddmmyyyy != null && card != null) add('$ddmmyyyy$card'); // SBI Card
  return out.toList();
}
