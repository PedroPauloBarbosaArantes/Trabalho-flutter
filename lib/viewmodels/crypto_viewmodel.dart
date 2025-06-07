import 'package:flutter/foundation.dart';
import '../models/crypto_model.dart';
import '../repositories/crypto_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CryptoViewModel extends ChangeNotifier {
  final CryptoRepository _repository;
  List<CryptoModel> _cryptos = [];
  bool _isLoading = false;
  String _error = '';
  final String _defaultSymbols =
      'BTC,ETH,SOL,BNB,BCH,MKR,AAVE,DOT,SUI,ADA,XRP,TIA,NEO,NEAR,PENDLE,RENDER,LINK,TON,XAI,SEI,IMX,ETHFI,UMA,SUPER,FET,USUAL,GALA,PAAL,AERO';

  CryptoViewModel(this._repository);

  List<CryptoModel> get cryptos => _cryptos;
  bool get isLoading => _isLoading;
  String get error => _error;

  String _formatSymbols(String symbols) {
    return symbols.replaceAll(' ', '').toUpperCase();
  }

  Future<void> fetchCryptos([String? symbols]) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _error =
          'Sem conexão com a internet. Verifique sua conexão e tente novamente.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final formattedSymbols =
          symbols != null ? _formatSymbols(symbols) : _defaultSymbols;
      _cryptos = await _repository.getCryptoQuotes(formattedSymbols);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
