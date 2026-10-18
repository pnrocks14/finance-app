import 'package:finance_data/finance_data.dart';
import 'package:finance_ui_kit/finance_ui_kit.dart';
import 'package:flutter/material.dart';

/// Icons for the names stored in `categories.icon`. Unknown names fall back
/// to a plain tag, so a renamed or added icon never breaks a screen.
const _icons = <String, IconData>{
  'delivery_dining': Icons.delivery_dining_rounded,
  'restaurant': Icons.restaurant_rounded,
  'local_grocery_store': Icons.local_grocery_store_rounded,
  'shopping_bag': Icons.shopping_bag_rounded,
  'local_gas_station': Icons.local_gas_station_rounded,
  'directions_car': Icons.directions_car_rounded,
  'movie': Icons.movie_rounded,
  'subscriptions': Icons.subscriptions_rounded,
  'bolt': Icons.bolt_rounded,
  'wifi': Icons.wifi_rounded,
  'home': Icons.home_rounded,
  'account_balance': Icons.account_balance_rounded,
  'shield': Icons.shield_rounded,
  'medical_services': Icons.medical_services_rounded,
  'school': Icons.school_rounded,
  'spa': Icons.spa_rounded,
  'redeem': Icons.redeem_rounded,
  'local_atm': Icons.local_atm_rounded,
  'receipt_long': Icons.receipt_long_rounded,
  'person': Icons.person_rounded,
  'category': Icons.category_rounded,
  'trending_up': Icons.trending_up_rounded,
  'payments': Icons.payments_rounded,
  'savings': Icons.savings_rounded,
  'undo': Icons.undo_rounded,
  'add_card': Icons.add_card_rounded,
  'swap_horiz': Icons.swap_horiz_rounded,
  'credit_card': Icons.credit_card_rounded,
  'pets': Icons.pets_rounded,
  'fitness_center': Icons.fitness_center_rounded,
  'child_care': Icons.child_care_rounded,
  'flight': Icons.flight_rounded,
  'train': Icons.train_rounded,
  'local_cafe': Icons.local_cafe_rounded,
  'local_bar': Icons.local_bar_rounded,
  'sports_esports': Icons.sports_esports_rounded,
  'card_giftcard': Icons.card_giftcard_rounded,
  'laptop': Icons.laptop_rounded,
  'phone_android': Icons.phone_android_rounded,
  'checkroom': Icons.checkroom_rounded,
  'local_laundry_service': Icons.local_laundry_service_rounded,
  'build': Icons.build_rounded,
  'volunteer_activism': Icons.volunteer_activism_rounded,
  'work': Icons.work_rounded,
  'account_balance_wallet': Icons.account_balance_wallet_rounded,
  'directions_bike': Icons.directions_bike_rounded,
  'music_note': Icons.music_note_rounded,
  'menu_book': Icons.menu_book_rounded,
  'celebration': Icons.celebration_rounded,
  'local_pharmacy': Icons.local_pharmacy_rounded,
  'family_restroom': Icons.family_restroom_rounded,
  'attach_money': Icons.attach_money_rounded,
};

/// Icon names offered when you add or edit a category.
final categoryIconNames = List<String>.unmodifiable(_icons.keys);

/// The chart colours a category can take.
const categoryColorTokens = [
  'chart1', 'chart2', 'chart3', 'chart4', //
  'chart5', 'chart6', 'chart7', 'chart8',
];

IconData iconNamed(String name) => _icons[name] ?? Icons.label_rounded;

IconData categoryIcon(Category c) => iconNamed(c.icon);

/// A round category badge in the category's chart colour.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge(this.category, {super.key, this.radius = 20});

  final Category category;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.chartToken(category.colorToken);
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: 0.16),
      child: Icon(categoryIcon(category), color: color, size: radius),
    );
  }
}
