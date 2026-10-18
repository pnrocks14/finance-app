import 'package:finance_core/finance_core.dart';
import 'package:flutter/material.dart';

IconData accountIcon(AccountKind kind) => switch (kind) {
  AccountKind.bankAccount => Icons.account_balance_rounded,
  AccountKind.creditCard => Icons.credit_card_rounded,
  AccountKind.wallet => Icons.account_balance_wallet_rounded,
  AccountKind.cash => Icons.payments_rounded,
  AccountKind.investment => Icons.trending_up_rounded,
};

String accountKindLabel(AccountKind kind) => switch (kind) {
  AccountKind.bankAccount => 'Bank account',
  AccountKind.creditCard => 'Credit card',
  AccountKind.wallet => 'Wallet',
  AccountKind.cash => 'Cash',
  AccountKind.investment => 'Investment',
};
