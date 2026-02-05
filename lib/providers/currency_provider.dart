import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/currency.dart';

class CurrencyNotifier extends Notifier<Currency> {
  static const _key = 'selected_currency';

  @override
  Currency build() {
    _loadCurrency();
    return Currency.usd;
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      try {
        state = Currency.values.firstWhere((c) => c.code == code);
      } catch (_) {
        // Keep default if not found
      }
    }
  }

  Future<void> setCurrency(Currency currency) async {
    state = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, currency.code);
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, Currency>(
  CurrencyNotifier.new,
);
