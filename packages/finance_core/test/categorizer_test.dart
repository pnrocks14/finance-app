import 'package:finance_core/finance_core.dart';
import 'package:test/test.dart';

CategorizeInput spend(
  String? payee, {
  String? vpa,
  String? description,
  CounterpartyKind kind = CounterpartyKind.unknown,
}) {
  final parsed = description == null ? null : parseDescription(description);
  return CategorizeInput(
    direction: Direction.debit,
    flow: TransactionFlow.spend,
    counterpartyName: payee ?? parsed?.counterpartyName,
    merchantKey:
        parsed?.merchantKey ?? payee?.toLowerCase().replaceAll(' ', '_'),
    vpa: vpa ?? parsed?.vpa,
    description: description,
    counterpartyKind: kind,
  );
}

void main() {
  final c = Categorizer(const []);

  test('seed categories have unique ids and valid colour tokens', () {
    final ids = seedCategories.map((s) => s.id).toSet();
    expect(ids, hasLength(seedCategories.length));
    for (final s in seedCategories) {
      expect(s.colorToken, matches(RegExp(r'^chart[1-8]$')));
    }
    for (final p in merchantPatterns) {
      expect(ids, contains(p.categoryId));
    }
  });

  group('merchant dictionary', () {
    for (final (payee, cat) in [
      ('SWIGGY', Cat.foodDelivery),
      ('Swiggy Instamart', Cat.groceries),
      ('Blinkit', Cat.groceries),
      ('ZOMATO LTD', Cat.foodDelivery),
      ('Udupi Flavours', Cat.eatingOut),
      ('TEA STALL OWN', Cat.eatingOut),
      ('SHARMA DAIRY', Cat.groceries),
      ('SOME PETROL DEPOT', Cat.fuel),
      ('Uber India', Cat.travel),
      ('IRCTC', Cat.travel),
      ('Netflix', Cat.subscriptions),
      ('BOOKMYSHOW', Cat.entertainment),
      ('Reliance Jio', Cat.phoneInternet),
      ('BESCOM', Cat.bills),
      ('Apollo Pharmacy', Cat.health),
      ('Zerodha Broking', Cat.investments),
      ('AMAZON PAY INDIA', Cat.shopping),
    ]) {
      test(payee, () {
        final d = c.categorize(spend(payee))!;
        expect(d.categoryId, cat);
        expect(d.basis, CategoryBasis.merchant);
        expect(d.confidence, greaterThanOrEqualTo(categoryReviewBelow));
      });
    }

    test('words match whole, not inside other words', () {
      // "ola" is inside "Kolar"; "rent" inside "Parents".
      expect(c.categorize(spend('KOLAR TRADING')), isNull);
      expect(c.categorize(spend('PARENTS HOME')), isNull);
    });

    test('a UPI ID alone is enough', () {
      final d = c.categorize(spend(null, vpa: 'swiggy@icici'))!;
      expect(d.categoryId, Cat.foodDelivery);
    });

    test('the narration is a weaker second look', () {
      final d = c.categorize(
        const CategorizeInput(
          direction: Direction.debit,
          flow: TransactionFlow.spend,
          counterpartyName: 'R K ENTERPRISE',
          description: 'POS 4321XXXXXXXX1234 BHARAT PETROLEUM CORP',
        ),
      )!;
      expect(d.categoryId, Cat.fuel);
      expect(d.basis, CategoryBasis.narration);
      expect(d.explain(), contains('bharat petroleum'));
    });
  });

  group('heuristics', () {
    test('transfers and card bills are never spending', () {
      for (final (reason, cat) in [
        (FlowReason.transferPair, Cat.ownTransfers),
        (FlowReason.cardBill, Cat.cardBill),
      ]) {
        final d = c.categorize(
          CategorizeInput(
            direction: Direction.debit,
            flow: TransactionFlow.transfer,
            flowReason: reason,
            counterpartyName: 'SWIGGY',
          ),
        )!;
        expect(d.categoryId, cat);
      }
    });

    test('bank interest, charges and ATM cash', () {
      final interest = c.categorize(
        const CategorizeInput(
          direction: Direction.credit,
          flow: TransactionFlow.income,
          merchantKey: 'bank_interest',
        ),
      )!;
      expect(interest.categoryId, Cat.interest);
      final fee = c.categorize(
        const CategorizeInput(
          direction: Direction.debit,
          flow: TransactionFlow.spend,
          merchantKey: 'bank_charges',
        ),
      )!;
      expect(fee.categoryId, Cat.bankCharges);
      expect(fee.explain(), contains('fee'));
    });

    test('salary, refunds and people', () {
      final salary = c.categorize(
        const CategorizeInput(
          direction: Direction.credit,
          flow: TransactionFlow.income,
          counterpartyName: 'ACME TECHNOLOGIES PVT LTD',
          description: 'NEFT CR-ICIC0000104-ACME TECHNOLOGIES-SALARY OCT',
        ),
      )!;
      expect(salary.categoryId, Cat.salary);
      final refund = c.categorize(
        const CategorizeInput(
          direction: Direction.credit,
          flow: TransactionFlow.refund,
          counterpartyName: 'SWIGGY',
        ),
      )!;
      expect(refund.categoryId, Cat.refunds);
      final person = c.categorize(
        spend('RAVI KUMAR', kind: CounterpartyKind.person),
      )!;
      expect(person.categoryId, Cat.sentToPeople);
      expect(person.confidence, lessThan(categoryReviewBelow));
    });

    test('an unknown shop stays uncategorised', () {
      expect(c.categorize(spend('XYZ123')), isNull);
    });
  });

  group('your rules', () {
    test('win over the dictionary, lowest priority first, by direction', () {
      final rules = Categorizer(const [
        CategoryRuleSpec(
          id: 'r2',
          type: RuleType.keyword,
          match: {'contains': 'swiggy'},
          categoryId: Cat.otherSpend,
          priority: 200,
        ),
        CategoryRuleSpec(
          id: 'r1',
          type: RuleType.merchantKey,
          match: {'key': 'swiggy', 'direction': 'debit'},
          categoryId: Cat.eatingOut,
        ),
        CategoryRuleSpec(
          id: 'r3',
          type: RuleType.vpa,
          match: {'vpa': 'ravi@ybl'},
          categoryId: Cat.rent,
        ),
      ]);
      final d = rules.categorize(spend('swiggy'))!;
      expect(d.ruleId, 'r1');
      expect(d.categoryId, Cat.eatingOut);
      expect(d.method, CategorizationMethod.rule);
      expect(d.explain(), contains('"swiggy"'));
      expect(
        rules.categorize(spend('RAVI', vpa: 'Ravi@YBL'))!.categoryId,
        Cat.rent,
      );
      // The merchant rule is for money out; a credit falls to the keyword.
      final credit = rules.categorize(
        const CategorizeInput(
          direction: Direction.credit,
          flow: TransactionFlow.income,
          counterpartyName: 'SWIGGY',
          merchantKey: 'swiggy',
        ),
      )!;
      expect(credit.ruleId, 'r2');
    });

    test('a broken regex is ignored, not thrown', () {
      final rules = Categorizer(const [
        CategoryRuleSpec(
          id: 'bad',
          type: RuleType.regex,
          match: {'pattern': '(unclosed'},
          categoryId: Cat.rent,
        ),
      ]);
      expect(rules.categorize(spend('SWIGGY'))!.categoryId, Cat.foodDelivery);
    });

    test('corrections become merchant or UPI ID rules', () {
      expect(ruleForCorrection(spend('swiggy'))!.type, RuleType.merchantKey);
      final byVpa = ruleForCorrection(
        const CategorizeInput(
          direction: Direction.debit,
          flow: TransactionFlow.spend,
          vpa: 'Q12345@ybl',
        ),
      )!;
      expect(byVpa.type, RuleType.vpa);
      expect(byVpa.match, {'vpa': 'q12345@ybl', 'direction': 'debit'});
      expect(
        ruleForCorrection(
          const CategorizeInput(
            direction: Direction.debit,
            flow: TransactionFlow.spend,
            merchantKey: 'bank_charges',
          ),
        ),
        isNull,
      );
    });
  });
}
