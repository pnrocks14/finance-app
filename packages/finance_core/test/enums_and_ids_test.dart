import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

final _snakeCase = RegExp(r'^[a-z][a-z0-9]*(_[a-z0-9]+)*$');

void main() {
  final allEnums = <List<WireEnum>>[
    Direction.values,
    TransactionFlow.values,
    Channel.values,
    CounterpartyKind.values,
    AccountKind.values,
    SpendClass.values,
    SpendClassSource.values,
    SourceKind.values,
    ParseStatus.values,
    ImportKind.values,
    ImportStatus.values,
    ReconciliationStatus.values,
    ReviewStatus.values,
    CategorizationMethod.values,
    RuleType.values,
    Origin.values,
    LabelOrigin.values,
    GoalStatus.values,
    Cadence.values,
    SeriesUserState.values,
    InsightType.values,
    InsightStatus.values,
    ProposalStatus.values,
    ExtensionStatus.values,
    AuditEvent.values,
  ];

  test('every wire name is unique snake_case and round-trips', () {
    for (final values in allEnums) {
      final wires = values.map((v) => v.wire).toList();
      expect(wires.toSet().length, wires.length, reason: '$wires');
      for (final value in values) {
        expect(value.wire, matches(_snakeCase));
        expect(enumFromWire(values, value.wire), same(value));
      }
    }
  });

  test('unknown wire names fail loudly', () {
    expect(
      () => enumFromWire(Direction.values, 'sideways'),
      throwsArgumentError,
    );
  });

  test('ids are time-ordered UUID v7 strings', () {
    final a = newId();
    final b = newId();
    expect(
      a,
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
    expect(a.compareTo(b), lessThanOrEqualTo(0));
  });
}
