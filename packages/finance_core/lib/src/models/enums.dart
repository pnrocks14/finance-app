/// Every enum that is stored or sent anywhere implements [WireEnum].
///
/// [wire] is the stable lowercase snake_case name used in the database, in
/// JSON and in AI requests. Dart names may change in a refactor; wire names
/// may not, because stored rows depend on them.
abstract interface class WireEnum {
  String get wire;
}

/// Looks up the value of [values] whose [WireEnum.wire] equals [wire].
T enumFromWire<T extends WireEnum>(List<T> values, String wire) {
  for (final value in values) {
    if (value.wire == wire) return value;
  }
  throw ArgumentError.value(wire, 'wire', 'Unknown value for $T');
}

/// Money in or out of one of your accounts.
enum Direction implements WireEnum {
  debit('debit'),
  credit('credit');

  const Direction(this.wire);
  @override
  final String wire;
}

/// What a transaction means for your finances, after transfer detection.
enum TransactionFlow implements WireEnum {
  /// Counts toward spending.
  spend('spend'),

  /// Counts toward income.
  income('income'),

  /// Money coming back for an earlier spend.
  refund('refund'),

  /// Money moving between your own accounts, wallet top-ups and credit card
  /// bill payments. Never counted as spend or income.
  transfer('transfer');

  const TransactionFlow(this.wire);
  @override
  final String wire;
}

enum Channel implements WireEnum {
  upi('upi'),
  card('card'),
  neft('neft'),
  imps('imps'),
  rtgs('rtgs'),
  atm('atm'),
  netBanking('net_banking'),
  wallet('wallet'),
  cheque('cheque'),
  other('other');

  const Channel(this.wire);
  @override
  final String wire;
}

enum CounterpartyKind implements WireEnum {
  merchant('merchant'),
  person('person'),
  self('self'),
  unknown('unknown');

  const CounterpartyKind(this.wire);
  @override
  final String wire;
}

enum AccountKind implements WireEnum {
  bankAccount('bank_account'),
  creditCard('credit_card'),
  wallet('wallet');

  const AccountKind(this.wire);
  @override
  final String wire;
}

/// How a category behaves in budgets and the goal simulator.
enum SpendClass implements WireEnum {
  /// Non-negotiable: rent, loan EMIs, insurance. Never suggested for cuts.
  fixed('fixed'),

  /// Discretionary: food delivery, entertainment, shopping, subscriptions.
  /// The only class the goal simulator may suggest cutting.
  flexible('flexible'),
  income('income'),
  transfer('transfer');

  const SpendClass(this.wire);
  @override
  final String wire;
}

enum SpendClassSource implements WireEnum {
  auto('auto'),
  user('user');

  const SpendClassSource(this.wire);
  @override
  final String wire;
}

enum SourceKind implements WireEnum {
  sms('sms'),
  statementRow('statement_row');

  const SourceKind(this.wire);
  @override
  final String wire;
}

enum ParseStatus implements WireEnum {
  parsed('parsed'),
  parseFailed('parse_failed'),
  ignored('ignored');

  const ParseStatus(this.wire);
  @override
  final String wire;
}

enum ImportKind implements WireEnum {
  statementCsv('statement_csv'),
  statementPdf('statement_pdf'),
  smsBackfill('sms_backfill'),
  smsLive('sms_live');

  const ImportKind(this.wire);
  @override
  final String wire;
}

enum ImportStatus implements WireEnum {
  running('running'),
  completed('completed'),
  failed('failed');

  const ImportStatus(this.wire);
  @override
  final String wire;
}

enum ReconciliationStatus implements WireEnum {
  /// Seen in one source only so far.
  single('single'),

  /// Linked to records from more than one source.
  matched('matched'),

  /// Waiting for you in the review queue.
  needsReview('needs_review');

  const ReconciliationStatus(this.wire);
  @override
  final String wire;
}

enum ReviewStatus implements WireEnum {
  open('open'),
  merged('merged'),
  keptSeparate('kept_separate');

  const ReviewStatus(this.wire);
  @override
  final String wire;
}

/// Which layer of the categorization ladder decided a category.
enum CategorizationMethod implements WireEnum {
  manual('manual'),
  rule('rule'),
  pattern('pattern'),
  model('model');

  const CategorizationMethod(this.wire);
  @override
  final String wire;
}

enum RuleType implements WireEnum {
  merchantKey('merchant_key'),
  vpa('vpa'),
  keyword('keyword'),
  regex('regex'),
  pattern('pattern');

  const RuleType(this.wire);
  @override
  final String wire;
}

/// Who created something: the seed data, you, or an approved AI proposal.
enum Origin implements WireEnum {
  seed('seed'),
  user('user'),
  aiProposal('ai_proposal');

  const Origin(this.wire);
  @override
  final String wire;
}

enum LabelOrigin implements WireEnum {
  labeling('labeling'),
  correction('correction');

  const LabelOrigin(this.wire);
  @override
  final String wire;
}

enum GoalStatus implements WireEnum {
  active('active'),
  achieved('achieved'),
  paused('paused'),
  archived('archived');

  const GoalStatus(this.wire);
  @override
  final String wire;
}

enum Cadence implements WireEnum {
  weekly('weekly'),
  monthly('monthly'),
  quarterly('quarterly'),
  yearly('yearly');

  const Cadence(this.wire);
  @override
  final String wire;
}

enum SeriesUserState implements WireEnum {
  unknown('unknown'),
  keep('keep'),
  cancel('cancel');

  const SeriesUserState(this.wire);
  @override
  final String wire;
}

enum InsightType implements WireEnum {
  forgottenSubscription('forgotten_subscription'),
  categoryCreep('category_creep'),
  savingsTarget('savings_target'),
  unusualSpike('unusual_spike'),
  burnRate('burn_rate');

  const InsightType(this.wire);
  @override
  final String wire;
}

enum InsightStatus implements WireEnum {
  fresh('new'),
  seen('seen'),
  dismissed('dismissed');

  const InsightStatus(this.wire);
  @override
  final String wire;
}

enum ProposalStatus implements WireEnum {
  proposed('proposed'),
  approved('approved'),
  rejected('rejected'),
  expired('expired'),
  stale('stale'),
  applied('applied'),
  failed('failed');

  const ProposalStatus(this.wire);
  @override
  final String wire;
}

enum ExtensionStatus implements WireEnum {
  active('active'),
  archived('archived');

  const ExtensionStatus(this.wire);
  @override
  final String wire;
}

enum AuditEvent implements WireEnum {
  proposalCreated('proposal_created'),
  proposalApproved('proposal_approved'),
  proposalRejected('proposal_rejected'),
  proposalExpired('proposal_expired'),
  proposalStale('proposal_stale'),
  proposalApplied('proposal_applied'),
  proposalFailed('proposal_failed');

  const AuditEvent(this.wire);
  @override
  final String wire;
}
