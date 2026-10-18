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
};

IconData categoryIcon(Category c) => _icons[c.icon] ?? Icons.label_rounded;

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
