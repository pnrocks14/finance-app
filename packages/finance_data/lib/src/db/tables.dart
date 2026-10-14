// Table definitions for the local database. The generated SQL uses
// snake_case names (`amount_paise`) for these camelCase getters.
//
// Conventions (see ARCHITECTURE.md, "Data model"):
// - every row has a UUID v7 `id`, `createdAt`, `updatedAt` and `version`;
// - money is integer paise in columns ending `Paise`;
// - instants are UTC, stored as ISO-8601 text; IST calendar days are
//   `LocalDate` columns stored as "YYYY-MM-DD";
// - enums are stored by their wire name.
// Drift's check constraints read a column's own getter inside its definition
// (`amountPaise.isBiggerThanValue(0)`); that is not real recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import 'converters.dart';

/// Columns every table has.
mixin RowMeta on Table {
  /// UUID v7, created with `newId()`.
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  /// Starts at 1 and goes up by one on every change. AI proposals record the
  /// versions they were based on, so a proposal made against an older version
  /// is marked stale instead of being applied.
  IntColumn get version => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// The single user's profile, used to personalize advice.
class UserProfiles extends Table with RowMeta {
  IntColumn get birthYear => integer().nullable()();
  TextColumn get occupation => text().nullable()();
  TextColumn get incomeBracket => text().nullable()();
  IntColumn get monthlyNetIncomePaise => integer().nullable()();
}

/// Bank accounts, credit cards and wallets that money moves through.
class Accounts extends Table with RowMeta {
  TextColumn get kind =>
      text().map(const WireEnumConverter(AccountKind.values))();
  TextColumn get institution => text()();
  TextColumn get displayName => text()();

  /// Last four digits of the account or card number, if known.
  TextColumn get last4 => text().nullable()();
  TextColumn get upiHandles =>
      text().map(const JsonListConverter()).withDefault(const Constant('[]'))();

  /// SMS sender ids that belong to this account, e.g. `VM-HDFCBK`.
  TextColumn get smsSenderIds =>
      text().map(const JsonListConverter()).withDefault(const Constant('[]'))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

/// One statement import or one SMS backfill run, with its error report.
@DataClassName('ImportBatch')
class ImportBatches extends Table with RowMeta {
  TextColumn get kind =>
      text().map(const WireEnumConverter(ImportKind.values))();
  TextColumn get status =>
      text().map(const WireEnumConverter(ImportStatus.values))();

  /// The bank adapter used, e.g. `hdfc_csv`.
  TextColumn get adapter => text().nullable()();
  TextColumn get accountId => text().nullable().references(Accounts, #id)();
  TextColumn get periodFrom =>
      text().map(const LocalDateConverter()).nullable()();
  TextColumn get periodTo =>
      text().map(const LocalDateConverter()).nullable()();
  IntColumn get parsedCount => integer().withDefault(const Constant(0))();
  IntColumn get failedCount => integer().withDefault(const Constant(0))();
  IntColumn get duplicateCount => integer().withDefault(const Constant(0))();
  IntColumn get matchedCount => integer().withDefault(const Constant(0))();
  IntColumn get createdCount => integer().withDefault(const Constant(0))();

  /// Rows that could not be parsed: row number, reason, redacted excerpt.
  TextColumn get errors =>
      text().map(const JsonListConverter()).withDefault(const Constant('[]'))();
}

/// Immutable evidence: one SMS or one statement row, as received and parsed.
class SourceRecords extends Table with RowMeta {
  TextColumn get kind =>
      text().map(const WireEnumConverter(SourceKind.values))();
  TextColumn get batchId => text().nullable().references(ImportBatches, #id)();

  /// Identifies the same SMS or statement row arriving twice, so importing
  /// again creates nothing new.
  TextColumn get dedupeHash => text().unique()();
  TextColumn get parseStatus =>
      text().map(const WireEnumConverter(ParseStatus.values))();
  TextColumn get parsed => text().map(const JsonMapConverter()).nullable()();

  /// The SMS body or the statement line. Stays on the device, inside the
  /// encrypted database, and is never logged or sent to an AI provider.
  TextColumn get rawText => text().nullable()();
  TextColumn get sender => text().nullable()();
  DateTimeColumn get receivedAt => dateTime()();
}

/// The reconciled ledger: one row per real-world transaction.
@TableIndex(name: 'transactions_local_date', columns: {#localDate})
@TableIndex(name: 'transactions_category', columns: {#categoryId})
@TableIndex(name: 'transactions_upi_ref', columns: {#upiRef})
@TableIndex(
  name: 'transactions_amount_date',
  columns: {#amountPaise, #localDate},
)
@TableIndex(
  name: 'transactions_account_date',
  columns: {#accountId, #localDate},
)
class Transactions extends Table with RowMeta {
  TextColumn get accountId => text().nullable().references(Accounts, #id)();
  TextColumn get direction =>
      text().map(const WireEnumConverter(Direction.values))();

  /// Always positive; [direction] says which way the money moved.
  IntColumn get amountPaise =>
      integer().check(amountPaise.isBiggerThanValue(0))();
  DateTimeColumn get occurredAt => dateTime()();

  /// The IST calendar day of [occurredAt], used for monthly bucketing.
  TextColumn get localDate => text().map(const LocalDateConverter())();
  TextColumn get channel =>
      text().map(const WireEnumConverter(Channel.values))();
  TextColumn get counterpartyName => text().nullable()();

  /// Normalized merchant name used by rules, e.g. `swiggy`.
  TextColumn get merchantKey => text().nullable()();
  TextColumn get vpa => text().nullable()();
  TextColumn get counterpartyKind => text()
      .map(const WireEnumConverter(CounterpartyKind.values))
      .withDefault(const Constant('unknown'))();
  TextColumn get upiRef => text().nullable()();
  TextColumn get bankRef => text().nullable()();
  TextColumn get cardLast4 => text().nullable()();
  TextColumn get descriptionRaw => text().nullable()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get categorizedBy => text()
      .map(const WireEnumConverter(CategorizationMethod.values))
      .nullable()();
  TextColumn get categorizationRuleId =>
      text().nullable().references(CategoryRules, #id)();
  RealColumn get categorizationConfidence => real().nullable()();
  TextColumn get flow =>
      text().map(const WireEnumConverter(TransactionFlow.values))();

  /// Why [flow] has its value, for "see why". Added in schema 2.
  TextColumn get flowReason => text()
      .map(const WireEnumConverter(FlowReason.values))
      .withDefault(const Constant('direction'))();

  /// The other side of a transfer between your own accounts. Added in
  /// schema 2.
  TextColumn get transferPairId => text().nullable()();
  TextColumn get reconciliationStatus =>
      text().map(const WireEnumConverter(ReconciliationStatus.values))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Links a transaction to the evidence it was built from.
class TransactionSources extends Table with RowMeta {
  TextColumn get transactionId => text().references(Transactions, #id)();

  /// A record belongs to at most one transaction.
  TextColumn get sourceRecordId =>
      text().unique().references(SourceRecords, #id)();
  TextColumn get kind =>
      text().map(const WireEnumConverter(SourceKind.values))();

  /// A transaction holds at most one record of each kind, so two genuine
  /// identical payments on the same day stay two transactions.
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {transactionId, kind},
  ];
}

/// Uncertain matches waiting for you to merge or keep separate.
class ReconciliationReviews extends Table with RowMeta {
  TextColumn get transactionId => text().references(Transactions, #id)();
  TextColumn get candidateRecordIds => text().map(const JsonListConverter())();
  RealColumn get score => real()();
  TextColumn get reasons =>
      text().map(const JsonListConverter()).withDefault(const Constant('[]'))();
  TextColumn get status =>
      text().map(const WireEnumConverter(ReviewStatus.values))();
}

/// The category tree.
class Categories extends Table with RowMeta {
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable().references(Categories, #id)();
  TextColumn get spendClass =>
      text().map(const WireEnumConverter(SpendClass.values))();
  TextColumn get spendClassSource =>
      text().map(const WireEnumConverter(SpendClassSource.values))();

  /// The goal simulator never suggests cutting this category below this
  /// monthly amount.
  IntColumn get floorPaise => integer().withDefault(const Constant(0))();
  TextColumn get icon => text()();

  /// A design token name such as `chart3`, never a raw colour.
  TextColumn get colorToken => text()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Merchant, VPA, keyword, regex and pattern rules.
class CategoryRules extends Table with RowMeta {
  TextColumn get type => text().map(const WireEnumConverter(RuleType.values))();

  /// What to match; its shape depends on [type]. See ARCHITECTURE.md.
  TextColumn get match => text().map(const JsonMapConverter())();
  TextColumn get categoryId => text().references(Categories, #id)();

  /// Lower runs first.
  IntColumn get priority => integer().withDefault(const Constant(100))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get createdBy =>
      text().map(const WireEnumConverter(Origin.values))();
  IntColumn get hitCount => integer().withDefault(const Constant(0))();
  IntColumn get missCount => integer().withDefault(const Constant(0))();
}

/// Hand labels and corrections: the training data for the on-device model.
class TrainingLabels extends Table with RowMeta {
  TextColumn get transactionId => text().references(Transactions, #id)();
  @ReferenceName('labels')
  TextColumn get categoryId => text().references(Categories, #id)();
  @ReferenceName('correctedFromLabels')
  TextColumn get previousCategoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn get origin =>
      text().map(const WireEnumConverter(LabelOrigin.values))();

  /// The model features at labeling time, so retraining is reproducible.
  TextColumn get features => text().map(const JsonMapConverter())();
}

/// Per-category monthly limits.
class Budgets extends Table with RowMeta {
  TextColumn get categoryId => text().references(Categories, #id)();
  IntColumn get limitPaise =>
      integer().check(limitPaise.isBiggerThanValue(0))();
  TextColumn get warnAtPercent => text()
      .map(const JsonListConverter())
      .withDefault(const Constant('[80,100]'))();
  TextColumn get effectiveFrom => text().map(const LocalDateConverter())();
}

class Goals extends Table with RowMeta {
  TextColumn get name => text()();
  IntColumn get targetPaise =>
      integer().check(targetPaise.isBiggerThanValue(0))();
  IntColumn get savedPaise => integer().withDefault(const Constant(0))();
  TextColumn get deadline => text().map(const LocalDateConverter())();

  /// How money reaches this goal, e.g. a fixed monthly amount.
  TextColumn get fundingRule =>
      text().map(const JsonMapConverter()).nullable()();
  TextColumn get status =>
      text().map(const WireEnumConverter(GoalStatus.values))();
}

/// Detected subscriptions and other repeating charges.
@DataClassName('RecurringSeriesRow')
class RecurringSeries extends Table with RowMeta {
  TextColumn get merchantKey => text()();
  TextColumn get cadence =>
      text().map(const WireEnumConverter(Cadence.values))();
  IntColumn get typicalAmountPaise => integer()();
  TextColumn get nextExpectedDate =>
      text().map(const LocalDateConverter()).nullable()();
  TextColumn get transactionIds => text().map(const JsonListConverter())();
  TextColumn get userState =>
      text().map(const WireEnumConverter(SeriesUserState.values))();
}

/// Locally detected facts, plus AI text when you asked for it.
class Insights extends Table with RowMeta {
  TextColumn get type =>
      text().map(const WireEnumConverter(InsightType.values))();
  TextColumn get facts => text().map(const JsonMapConverter())();
  TextColumn get guidelineIds =>
      text().map(const JsonListConverter()).withDefault(const Constant('[]'))();
  TextColumn get aiNarrative => text().nullable()();
  TextColumn get aiProvider => text().nullable()();
  TextColumn get status =>
      text().map(const WireEnumConverter(InsightStatus.values))();
}

/// Changes proposed by the AI. Nothing here is applied until you approve it.
class Proposals extends Table with RowMeta {
  /// What the change is for: `{"type": "goal", "id": "..."}`.
  TextColumn get target => text().map(const JsonMapConverter())();

  /// RFC 6902 JSON Patch operations.
  TextColumn get patch => text().map(const JsonListConverter())();
  TextColumn get before => text().map(const JsonMapConverter())();
  TextColumn get after => text().map(const JsonMapConverter())();
  TextColumn get rationale => text()();

  /// Who proposed it, e.g. `anthropic:claude-...` or `openai:...`.
  TextColumn get proposer => text()();

  /// Row id → `version` of every record the AI was shown.
  TextColumn get baseVersions => text().map(const JsonMapConverter())();
  TextColumn get status =>
      text().map(const WireEnumConverter(ProposalStatus.values))();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get decidedAt => dateTime().nullable()();
}

/// Typed plan items the app does not model natively (sinking funds, custom
/// rules, reminders). Created only through approved proposals.
class PlanExtensions extends Table with RowMeta {
  TextColumn get kind => text()();
  IntColumn get schemaVersion => integer()();
  TextColumn get data => text().map(const JsonMapConverter())();
  TextColumn get status =>
      text().map(const WireEnumConverter(ExtensionStatus.values))();
}

/// Append-only, hash-chained record of every proposal event. Database
/// triggers reject UPDATE and DELETE on this table.
@DataClassName('AuditEntry')
class AuditLog extends Table with RowMeta {
  /// 1, 2, 3, ... in the order entries were written.
  IntColumn get sequence => integer().unique()();
  TextColumn get event =>
      text().map(const WireEnumConverter(AuditEvent.values))();
  TextColumn get actor => text()();
  TextColumn get proposalId => text().nullable()();
  TextColumn get diff => text().map(const JsonMapConverter()).nullable()();

  /// Hash of the previous entry (empty for the first), then of this entry.
  TextColumn get prevHash => text()();
  TextColumn get hash => text()();
}

/// What was sent to an AI provider and when. Never stores the content.
class AiRequests extends Table with RowMeta {
  TextColumn get feature => text()();
  TextColumn get provider => text()();
  TextColumn get model => text()();

  /// Names of the fields that left the device, e.g. `["insight.facts"]`.
  TextColumn get fieldsSent => text().map(const JsonListConverter())();
  IntColumn get tokenCount => integer().nullable()();
  TextColumn get outcome => text()();
}
