import 'package:http/http.dart' as http;
import 'dart:convert';

class CryptoDataSource {
  final String baseUrl = 'https://api.coingecko.com/api/v3';

  Future<Map<String, dynamic>> getCryptoQuotes(String symbols) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/simple/price?ids=$symbols&vs_currencies=usd&include_24hr_change=true'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Falha ao carregar dados');
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }
} 