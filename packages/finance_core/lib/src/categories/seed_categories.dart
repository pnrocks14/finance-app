import '../models/enums.dart';

/// A built-in category. Ids are fixed strings so the merchant dictionary
/// and stored rules can name them; categories you add get UUIDs.
final class SeedCategory {
  const SeedCategory(
    this.id,
    this.name,
    this.spendClass,
    this.icon,
    this.colorToken,
  );

  final String id;
  final String name;
  final SpendClass spendClass;

  /// A Material icon name; the app maps it to an icon.
  final String icon;

  /// `chart1` … `chart8`, never a raw colour.
  final String colorToken;
}

/// Ids of the built-in categories.
abstract final class Cat {
  static const foodDelivery = 'cat.food_delivery';
  static const eatingOut = 'cat.eating_out';
  static const groceries = 'cat.groceries';
  static const shopping = 'cat.shopping';
  static const fuel = 'cat.fuel';
  static const travel = 'cat.travel';
  static const entertainment = 'cat.entertainment';
  static const subscriptions = 'cat.subscriptions';
  static const bills = 'cat.bills';
  static const phoneInternet = 'cat.phone_internet';
  static const rent = 'cat.rent';
  static const loans = 'cat.loans';
  static const insurance = 'cat.insurance';
  static const health = 'cat.health';
  static const education = 'cat.education';
  static const personalCare = 'cat.personal_care';
  static const giftsDonations = 'cat.gifts_donations';
  static const cash = 'cat.cash';
  static const bankCharges = 'cat.bank_charges';
  static const sentToPeople = 'cat.sent_to_people';
  static const otherSpend = 'cat.other_spend';
  static const investments = 'cat.investments';
  static const salary = 'cat.salary';
  static const interest = 'cat.interest';
  static const refunds = 'cat.refunds';
  static const receivedFromPeople = 'cat.received_from_people';
  static const otherIncome = 'cat.other_income';
  static const ownTransfers = 'cat.own_transfers';
  static const cardBill = 'cat.card_bill';
}

/// The categories a new install starts with, in display order.
const seedCategories = <SeedCategory>[
  SeedCategory(
    Cat.foodDelivery,
    'Food delivery',
    SpendClass.flexible,
    'delivery_dining',
    'chart1',
  ),
  SeedCategory(
    Cat.eatingOut,
    'Eating out',
    SpendClass.flexible,
    'restaurant',
    'chart1',
  ),
  SeedCategory(
    Cat.groceries,
    'Groceries',
    SpendClass.flexible,
    'local_grocery_store',
    'chart2',
  ),
  SeedCategory(
    Cat.shopping,
    'Shopping',
    SpendClass.flexible,
    'shopping_bag',
    'chart3',
  ),
  SeedCategory(
    Cat.fuel,
    'Fuel',
    SpendClass.flexible,
    'local_gas_station',
    'chart4',
  ),
  SeedCategory(
    Cat.travel,
    'Travel and commute',
    SpendClass.flexible,
    'directions_car',
    'chart4',
  ),
  SeedCategory(
    Cat.entertainment,
    'Entertainment',
    SpendClass.flexible,
    'movie',
    'chart5',
  ),
  SeedCategory(
    Cat.subscriptions,
    'Subscriptions',
    SpendClass.flexible,
    'subscriptions',
    'chart5',
  ),
  SeedCategory(
    Cat.bills,
    'Bills and utilities',
    SpendClass.fixed,
    'bolt',
    'chart6',
  ),
  SeedCategory(
    Cat.phoneInternet,
    'Phone and internet',
    SpendClass.fixed,
    'wifi',
    'chart6',
  ),
  SeedCategory(Cat.rent, 'Rent', SpendClass.fixed, 'home', 'chart7'),
  SeedCategory(
    Cat.loans,
    'Loans and EMIs',
    SpendClass.fixed,
    'account_balance',
    'chart7',
  ),
  SeedCategory(
    Cat.insurance,
    'Insurance',
    SpendClass.fixed,
    'shield',
    'chart7',
  ),
  SeedCategory(
    Cat.health,
    'Health',
    SpendClass.fixed,
    'medical_services',
    'chart8',
  ),
  SeedCategory(
    Cat.education,
    'Education',
    SpendClass.fixed,
    'school',
    'chart8',
  ),
  SeedCategory(
    Cat.personalCare,
    'Personal care',
    SpendClass.flexible,
    'spa',
    'chart3',
  ),
  SeedCategory(
    Cat.giftsDonations,
    'Gifts and donations',
    SpendClass.flexible,
    'redeem',
    'chart3',
  ),
  SeedCategory(Cat.cash, 'Cash', SpendClass.flexible, 'local_atm', 'chart2'),
  SeedCategory(
    Cat.bankCharges,
    'Bank charges',
    SpendClass.fixed,
    'receipt_long',
    'chart6',
  ),
  SeedCategory(
    Cat.sentToPeople,
    'Sent to people',
    SpendClass.flexible,
    'person',
    'chart5',
  ),
  SeedCategory(
    Cat.otherSpend,
    'Other spending',
    SpendClass.flexible,
    'category',
    'chart8',
  ),
  SeedCategory(
    Cat.investments,
    'Investments',
    SpendClass.transfer,
    'trending_up',
    'chart2',
  ),
  SeedCategory(Cat.salary, 'Salary', SpendClass.income, 'payments', 'chart2'),
  SeedCategory(
    Cat.interest,
    'Interest',
    SpendClass.income,
    'savings',
    'chart2',
  ),
  SeedCategory(
    Cat.refunds,
    'Refunds and cashback',
    SpendClass.income,
    'undo',
    'chart2',
  ),
  SeedCategory(
    Cat.receivedFromPeople,
    'Received from people',
    SpendClass.income,
    'person',
    'chart2',
  ),
  SeedCategory(
    Cat.otherIncome,
    'Other income',
    SpendClass.income,
    'add_card',
    'chart2',
  ),
  SeedCategory(
    Cat.ownTransfers,
    'Between your accounts',
    SpendClass.transfer,
    'swap_horiz',
    'chart4',
  ),
  SeedCategory(
    Cat.cardBill,
    'Credit card bill',
    SpendClass.transfer,
    'credit_card',
    'chart4',
  ),
];
