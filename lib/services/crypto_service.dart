import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto_list/models/crypto_currency.dart';

class CryptoService {
  final String _apiKey = '01c759ae-e821-4871-84fb-aedea93bba07';
  final String _baseUrl =
      'https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest';

  static const String defaultSymbols =
      'BTC,ETH,SOL,BNB,BCH,MKR,AAVE,DOT,SUI,ADA,XRP,TIA,NEO,NEAR,PENDLE,RENDER,LINK,TON,XAI,SEI,'
      'IMX,ETHFI,UMA,SUPER,FET,USUAL,GALA,PAAL,AERO';

  Future<List<CryptoCurrency>> getCryptoCurrencies({
    String symbols = defaultSymbols,
  }) async {
    final uri = Uri.parse('$_baseUrl?symbol=$symbols&convert=USD');

    final response = await http.get(
      uri,
      headers: {'X-CMC_PRO_API_KEY': _apiKey, 'Accepts': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> data = jsonResponse['data'];

      List<CryptoCurrency> cryptos = [];
      data.forEach((symbol, cryptoData) {
        if (cryptoData is List && cryptoData.isNotEmpty) {
          cryptos.add(CryptoCurrency.fromJson(cryptoData[0]));
        }
      });
      return cryptos;
    } else {
      print('Erro na API: ${response.statusCode} - ${response.body}');
      throw Exception(
        'Falha ao carregar criptomoedas: ${response.statusCode} - ${response.body}',
      );
    }
  }
} 