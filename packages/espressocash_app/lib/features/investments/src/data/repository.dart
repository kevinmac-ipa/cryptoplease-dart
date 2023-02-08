import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class InvestmentSettingsRepository extends ChangeNotifier {
  InvestmentSettingsRepository(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  bool get displayEmptyBalances =>
      _sharedPreferences.getBool(_hideZeroBalanceKey) ?? false;

  Future<void> toggleDisplayEmptyBalances(bool value) async {
    await _sharedPreferences.setBool(_hideZeroBalanceKey, value);
    notifyListeners();
  }

  Future<void> clear() => _sharedPreferences.remove(_hideZeroBalanceKey);
}

const _hideZeroBalanceKey = 'displayEmptyBalancesKey';
