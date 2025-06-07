class CryptoModel {
  final String symbol;
  final String name;
  final String dateAdded;
  final double priceUsd;
  final double priceBrl;

  CryptoModel({
    required this.symbol,
    required this.name,
    required this.dateAdded,
    required this.priceUsd,
    required this.priceBrl,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    try {
      final quote = json['quote'] as Map<String, dynamic>;
      final usd = quote['USD'] as Map<String, dynamic>;
      final dateAdded = DateTime.parse(json['date_added'] as String).toIso8601String();
      
      return CryptoModel(
        symbol: json['symbol'] as String,
        name: json['name'] as String,
        dateAdded: dateAdded,
        priceUsd: (usd['price'] as num).toDouble(),
        priceBrl: (usd['price'] as num).toDouble() * 5.0,
      );
    } catch (e) {
      print('Erro ao converter dados: $e');
      print('JSON recebido: $json');
      throw Exception('Erro ao converter dados da criptomoeda: $e');
    }
  }
}
