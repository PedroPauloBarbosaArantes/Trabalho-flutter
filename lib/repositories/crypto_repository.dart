import '../models/crypto_model.dart';
import '../datasources/crypto_datasource.dart';

class CryptoRepository {
  final CryptoDataSource _dataSource;

  CryptoRepository(this._dataSource);

  Future<List<CryptoModel>> getCryptoQuotes(String symbols) async {
    try {
      final response = await _dataSource.getCryptoQuotes(symbols);
      
      // Verifica se a resposta contém os dados esperados
      if (response.containsKey('data')) {
        final data = response['data'] as Map<String, dynamic>;
        return data.values.map((crypto) => CryptoModel.fromJson(crypto)).toList();
      } else {
        throw Exception('Formato de resposta inválido: dados não encontrados');
      }
    } catch (e) {
      throw Exception('Erro ao buscar criptomoedas: $e');
    }
  }
} 