/// One bank's usual rule for its statement PDF password.
final class PasswordHint {
  const PasswordHint(this.source, this.rule, {this.example});

  /// The bank or app, and which statement: "HDFC Bank account".
  final String source;
  final String rule;

  /// A made-up example of the rule.
  final String? example;
}

/// Filled from the banks' published rules.
const statementPasswordHints = <PasswordHint>[];
