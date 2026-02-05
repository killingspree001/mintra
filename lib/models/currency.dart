/// Represents a currency with its symbol and formatting.
enum Currency {
  usd('USD', '\$', 'US Dollar'),
  eur('EUR', '€', 'Euro'),
  gbp('GBP', '£', 'British Pound'),
  ngn('NGN', '₦', 'Nigerian Naira'),
  jpy('JPY', '¥', 'Japanese Yen'),
  cny('CNY', '¥', 'Chinese Yuan'),
  inr('INR', '₹', 'Indian Rupee'),
  cad('CAD', 'C\$', 'Canadian Dollar'),
  aud('AUD', 'A\$', 'Australian Dollar'),
  chf('CHF', 'Fr', 'Swiss Franc'),
  zar('ZAR', 'R', 'South African Rand'),
  aed('AED', 'د.إ', 'UAE Dirham'),
  sgd('SGD', 'S\$', 'Singapore Dollar'),
  hkd('HKD', 'HK\$', 'Hong Kong Dollar'),
  krw('KRW', '₩', 'South Korean Won');

  final String code;
  final String symbol;
  final String name;

  const Currency(this.code, this.symbol, this.name);

  /// Format an amount in this currency.
  String format(double amount) {
    final formatted = amount.toStringAsFixed(2);
    return '$symbol$formatted';
  }

  /// Get display label for dropdown.
  String get displayLabel => '$symbol $code';
}
