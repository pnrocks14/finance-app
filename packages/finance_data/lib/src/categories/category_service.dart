import 'package:drift/drift.dart';
import 'package:finance_core/finance_core.dart';

import '../db/database.dart';

/// Adds the built-in categories that are missing. Safe to run on every
/// open: existing rows, including ones you renamed, are left alone.
Future<void> seedCategoryRows(FinanceDatabase db, DateTime now) async {
  await db.batch((b) {
    for (var i = 0; i < seedCategories.length; i++) {
      final s = seedCategories[i];
      b.insert(
        db.categories,
        CategoriesCompanion.insert(
          id: s.id,
          createdAt: now,
          updatedAt: now,
          name: s.name,
          spendClass: s.spendClass,
          spendClassSource: SpendClassSource.auto,
          icon: s.icon,
          colorToken: s.colorToken,
          isSystem: const Value(true),
          sortOrder: Value(i),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });
}

/// What the categoriser sees of a stored transaction.
CategorizeInput categorizeInputOf(Transaction t) => CategorizeInput(
  direction: t.direction,
  flow: t.flow,
  flowReason: t.flowReason,
  counterpartyName: t.counterpartyName,
  merchantKey: t.merchantKey,
  vpa: t.vpa,
  description: t.descriptionRaw,
  counterpartyKind: t.counterpartyKind,
);

CategoryRuleSpec _spec(CategoryRule r) => CategoryRuleSpec(
  id: r.id,
  type: r.type,
  match: r.match,
  categoryId: r.categoryId,
  priority: r.priority,
);

/// Categories for screens, and adding, editing and removing them.
class CategoriesRepository {
  CategoriesRepository(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FinanceDatabase _db;
  final DateTime Function() _clock;

  /// Adds a category of your own, after the others.
  Future<Category> create({
    required String name,
    required SpendClass spendClass,
    required String icon,
    required String colorToken,
  }) async {
    final now = _clock().toUtc();
    final last = _db.categories.sortOrder.max();
    final row = await (_db.selectOnly(
      _db.categories,
    )..addColumns([last])).getSingle();
    return _db
        .into(_db.categories)
        .insertReturning(
          CategoriesCompanion.insert(
            id: newId(),
            createdAt: now,
            updatedAt: now,
            name: name.trim(),
            spendClass: spendClass,
            spendClassSource: SpendClassSource.user,
            icon: icon,
            colorToken: colorToken,
            sortOrder: Value((row.read(last) ?? 0) + 1),
          ),
        );
  }

  /// Renames a category or changes its look, or whether spending in it is
  /// fixed or flexible. Built-in ones can be changed too; a fresh install
  /// never puts your changes back.
  Future<void> update(
    String id, {
    String? name,
    String? icon,
    String? colorToken,
    SpendClass? spendClass,
  }) async {
    final c = await (_db.select(
      _db.categories,
    )..where((r) => r.id.equals(id))).getSingle();
    await (_db.update(_db.categories)..where((r) => r.id.equals(id))).write(
      CategoriesCompanion(
        name: name == null || name.trim().isEmpty
            ? const Value.absent()
            : Value(name.trim()),
        icon: icon == null ? const Value.absent() : Value(icon),
        colorToken: colorToken == null
            ? const Value.absent()
            : Value(colorToken),
        spendClass: spendClass == null
            ? const Value.absent()
            : Value(spendClass),
        spendClassSource: spendClass == null
            ? const Value.absent()
            : const Value(SpendClassSource.user),
        version: Value(c.version + 1),
        updatedAt: Value(_clock().toUtc()),
      ),
    );
  }

  /// Removes a category you added. Its transactions go back to needing a
  /// category, and its rules and budget go with it. Built-in categories
  /// can't be removed, because the dictionary files payees under them.
  Future<void> delete(String id) => _db.transaction(() async {
    final c = await (_db.select(
      _db.categories,
    )..where((r) => r.id.equals(id))).getSingle();
    if (c.isSystem) {
      throw StateError("Built-in categories can't be removed");
    }
    final now = _clock().toUtc();
    await (_db.update(
      _db.transactions,
    )..where((t) => t.categoryId.equals(id))).write(
      TransactionsCompanion(
        categoryId: const Value(null),
        categorizedBy: const Value(null),
        categorizationRuleId: const Value(null),
        categorizationConfidence: const Value(null),
        updatedAt: Value(now),
      ),
    );
    await (_db.update(_db.trainingLabels)
          ..where((l) => l.previousCategoryId.equals(id)))
        .write(const TrainingLabelsCompanion(previousCategoryId: Value(null)));
    await (_db.delete(
      _db.trainingLabels,
    )..where((l) => l.categoryId.equals(id))).go();
    await (_db.delete(
      _db.categoryRules,
    )..where((r) => r.categoryId.equals(id))).go();
    await (_db.delete(_db.budgets)..where((b) => b.categoryId.equals(id))).go();
    await (_db.delete(_db.categories)..where((r) => r.id.equals(id))).go();
  });

  Stream<List<Category>> watchAll() =>
      (_db.select(_db.categories)..orderBy([
            (c) => OrderingTerm.asc(c.sortOrder),
            (c) => OrderingTerm.asc(c.name),
          ]))
          .watch();

  /// Your rules, newest first.
  Stream<List<CategoryRule>> watchRules() =>
      (_db.select(_db.categoryRules)
            ..where((r) => r.createdBy.equals(Origin.seed.wire).not())
            ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
          .watch();
}

/// Categorises the ledger on the device and records your corrections.
///
/// Transactions you categorised by hand (`categorized_by = manual`) are
/// never changed by the categoriser.
class CategoryService {
  CategoryService(this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FinanceDatabase _db;
  final DateTime Function() _clock;

  /// Lower runs first; your rules sit ahead of any added later by default.
  static const userRulePriority = 50;

  Future<Categorizer> _categorizer() async {
    final rules = await (_db.select(
      _db.categoryRules,
    )..where((r) => r.enabled.equals(true))).get();
    return Categorizer(rules.map(_spec));
  }

  /// Re-runs the categoriser over transactions that weren't set by hand,
  /// limited to a date range or to those with a payee key, UPI ID or rule.
  /// Returns how many changed.
  Future<int> recategorize({
    LocalDate? from,
    LocalDate? to,
    String? merchantKey,
    String? vpa,
    String? ruleId,
  }) => _db.transaction(() async {
    final now = _clock().toUtc();
    final categorizer = await _categorizer();
    final q = _db.select(_db.transactions)
      ..where(
        (t) =>
            t.deletedAt.isNull() &
            (t.categorizedBy.isNull() |
                t.categorizedBy.equals(CategorizationMethod.manual.wire).not()),
      );
    if (from != null && to != null) {
      q.where((t) => t.localDate.isBetweenValues(from.toIso(), to.toIso()));
    }
    final keys = [
      if (merchantKey != null) _db.transactions.merchantKey.equals(merchantKey),
      if (vpa != null) _db.transactions.vpa.lower().equals(vpa.toLowerCase()),
      if (ruleId != null) _db.transactions.categorizationRuleId.equals(ruleId),
    ];
    if (keys.isNotEmpty) q.where((_) => keys.reduce((a, b) => a | b));

    var changed = 0;
    final hits = <String, int>{};
    for (final t in await q.get()) {
      final d = categorizer.categorize(categorizeInputOf(t));
      if (d?.categoryId == t.categoryId &&
          d?.method == t.categorizedBy &&
          d?.ruleId == t.categorizationRuleId &&
          d?.confidence == t.categorizationConfidence) {
        continue;
      }
      await (_db.update(
        _db.transactions,
      )..where((r) => r.id.equals(t.id))).write(
        TransactionsCompanion(
          categoryId: Value(d?.categoryId),
          categorizedBy: Value(d?.method),
          categorizationRuleId: Value(d?.ruleId),
          categorizationConfidence: Value(d?.confidence),
          version: Value(t.version + 1),
          updatedAt: Value(now),
        ),
      );
      if (d?.ruleId case final id?) hits[id] = (hits[id] ?? 0) + 1;
      changed++;
    }
    for (final MapEntry(:key, :value) in hits.entries) {
      await _db.customUpdate(
        'UPDATE category_rules SET hit_count = hit_count + ? WHERE id = ?',
        variables: [Variable.withInt(value), Variable.withString(key)],
        updates: {_db.categoryRules},
      );
    }
    return changed;
  });

  /// Sets a category by hand. With [always], also makes or updates your
  /// rule for this payee and re-categorises their other transactions that
  /// weren't set by hand. Returns how many others changed.
  Future<int> setCategory(
    String transactionId,
    String categoryId, {
    bool always = true,
  }) => _db.transaction(() async {
    final now = _clock().toUtc();
    final t = await (_db.select(
      _db.transactions,
    )..where((r) => r.id.equals(transactionId))).getSingle();
    final input = categorizeInputOf(t);

    if (t.categorizedBy == CategorizationMethod.rule &&
        t.categorizationRuleId != null &&
        t.categoryId != categoryId) {
      await _db.customUpdate(
        'UPDATE category_rules SET miss_count = miss_count + 1 WHERE id = ?',
        variables: [Variable.withString(t.categorizationRuleId!)],
        updates: {_db.categoryRules},
      );
    }
    await (_db.update(_db.transactions)..where((r) => r.id.equals(t.id))).write(
      TransactionsCompanion(
        categoryId: Value(categoryId),
        categorizedBy: const Value(CategorizationMethod.manual),
        categorizationRuleId: const Value(null),
        categorizationConfidence: const Value(1),
        version: Value(t.version + 1),
        updatedAt: Value(now),
      ),
    );
    // Training data for the on-device model (phase 11). Only what the
    // model reads: no names, amounts or narration.
    await _db
        .into(_db.trainingLabels)
        .insert(
          TrainingLabelsCompanion.insert(
            id: newId(),
            createdAt: now,
            updatedAt: now,
            transactionId: t.id,
            categoryId: categoryId,
            previousCategoryId: Value(t.categoryId),
            origin: t.categoryId == null
                ? LabelOrigin.labeling
                : LabelOrigin.correction,
            features: {
              'merchantKey': t.merchantKey,
              'vpaHandle': t.vpa?.split('@').last,
              'direction': t.direction.wire,
              'channel': t.channel.wire,
              'counterpartyKind': t.counterpartyKind.wire,
              'flow': t.flow.wire,
            },
          ),
        );

    if (!always) return 0;
    final rule = ruleForCorrection(input);
    if (rule == null) return 0;
    await _upsertRule(rule.type, rule.match, categoryId, now);
    return recategorize(merchantKey: t.merchantKey, vpa: t.vpa);
  });

  Future<void> _upsertRule(
    RuleType type,
    Map<String, Object?> match,
    String categoryId,
    DateTime now,
  ) async {
    final existing = await (_db.select(
      _db.categoryRules,
    )..where((r) => r.type.equals(type.wire))).get();
    for (final r in existing) {
      if (_sameMatch(r.match, match)) {
        await (_db.update(
          _db.categoryRules,
        )..where((x) => x.id.equals(r.id))).write(
          CategoryRulesCompanion(
            categoryId: Value(categoryId),
            enabled: const Value(true),
            createdBy: const Value(Origin.user),
            version: Value(r.version + 1),
            updatedAt: Value(now),
          ),
        );
        return;
      }
    }
    await _db
        .into(_db.categoryRules)
        .insert(
          CategoryRulesCompanion.insert(
            id: newId(),
            createdAt: now,
            updatedAt: now,
            type: type,
            match: match,
            categoryId: categoryId,
            priority: const Value(userRulePriority),
            createdBy: Origin.user,
          ),
        );
  }

  /// Deletes one of your rules and re-categorises what it had matched.
  Future<int> deleteRule(String ruleId) => _db.transaction(() async {
    final ids =
        await (_db.selectOnly(_db.transactions)
              ..addColumns([_db.transactions.id])
              ..where(_db.transactions.categorizationRuleId.equals(ruleId)))
            .map((r) => r.read(_db.transactions.id)!)
            .get();
    await (_db.update(_db.transactions)
          ..where((t) => t.categorizationRuleId.equals(ruleId)))
        .write(const TransactionsCompanion(categorizationRuleId: Value(null)));
    await (_db.delete(
      _db.categoryRules,
    )..where((r) => r.id.equals(ruleId))).go();
    if (ids.isEmpty) return 0;
    final categorizer = await _categorizer();
    final now = _clock().toUtc();
    final txs = await (_db.select(
      _db.transactions,
    )..where((t) => t.id.isIn(ids))).get();
    for (final t in txs) {
      final d = categorizer.categorize(categorizeInputOf(t));
      await (_db.update(
        _db.transactions,
      )..where((r) => r.id.equals(t.id))).write(
        TransactionsCompanion(
          categoryId: Value(d?.categoryId),
          categorizedBy: Value(d?.method),
          categorizationRuleId: Value(d?.ruleId),
          categorizationConfidence: Value(d?.confidence),
          version: Value(t.version + 1),
          updatedAt: Value(now),
        ),
      );
    }
    return txs.length;
  });

  /// Transactions in a date range that still need a category: none, or a
  /// guess below [categoryReviewBelow]. Transfers don't count.
  Future<int> countNeedingCategory(LocalDate from, LocalDate to) async {
    final t = _db.transactions;
    final count = t.id.count();
    final row =
        await (_db.selectOnly(t)
              ..addColumns([count])
              ..where(
                t.deletedAt.isNull() &
                    t.localDate.isBetweenValues(from.toIso(), to.toIso()) &
                    t.flow.equals(TransactionFlow.transfer.wire).not() &
                    (t.categoryId.isNull() |
                        t.categorizationConfidence.isSmallerThanValue(
                          categoryReviewBelow,
                        )),
              ))
            .getSingle();
    return row.read(count) ?? 0;
  }
}

bool _sameMatch(Map<String, Object?> a, Map<String, Object?> b) =>
    a.length == b.length &&
    a.entries.every(
      (e) => b.containsKey(e.key) && '${b[e.key]}' == '${e.value}',
    );
