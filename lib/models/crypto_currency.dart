import 'package:intl/intl.dart';

class CryptoCurrency {
  final int id;
  final String name;
  final String symbol;
  final DateTime dateAdded;
  final double priceUsd;
  final double percentChange24h;

  CryptoCurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.dateAdded,
    required this.priceUsd,
    required this.percentChange24h,
  });

  static const double usdToBrlRate = 5.60;

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'];
    final usdQuote = quote?['USD'];

    return CryptoCurrency(
      id: json['id'] as int,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      dateAdded: DateTime.parse(json['date_added'] as String),
      priceUsd: (usdQuote?['price'] as num?)?.toDouble() ?? 0.0,
      percentChange24h:
          (usdQuote?['percent_change_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }

  double get priceBrl => priceUsd * usdToBrlRate;

  String get formattedPriceUsd {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
    ).format(priceUsd);
  }

  String get formattedPriceBrl {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    ).format(priceBrl);
  }

  String get formattedDateAdded {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateAdded);
  }
} 