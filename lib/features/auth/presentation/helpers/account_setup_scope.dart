import 'package:daily_tarot_focus/features/auth/presentation/helpers/account_setup_mixin.dart';
import 'package:flutter/widgets.dart';

class AccountSetupScope extends InheritedWidget {
  const AccountSetupScope({required this.state, required super.child, super.key});
  final AccountSetupMixin state;

  static AccountSetupScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AccountSetupScope>();
    assert(result != null, 'No AccountSetupScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AccountSetupScope oldWidget) => false;
}
