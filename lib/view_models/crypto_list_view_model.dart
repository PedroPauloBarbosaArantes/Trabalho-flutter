import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto_list/models/crypto_currency.dart';
import 'package:crypto_list/services/crypto_service.dart';

class CryptoListViewModel extends ChangeNotifier {
  final CryptoService _service = CryptoService();

  List<CryptoCurrency> _cryptoCurrencies = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentSearchSymbols = CryptoService.defaultSymbols;

  List<CryptoCurrency> get cryptoCurrencies => _cryptoCurrencies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentSearchSymbols => _currentSearchSymbols;

  void setSearchSymbols(String symbols) {
    _currentSearchSymbols = symbols
        .split(',')
        .map((s) => s.trim().toUpperCase())
        .where((s) => s.isNotEmpty)
        .toSet()
        .join(',');

    if (_currentSearchSymbols.isEmpty) {
      _currentSearchSymbols = CryptoService.defaultSymbols;
    }
    notifyListeners();
  }

  Future<void> fetchCryptoCurrencies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _errorMessage = 'Sem conexão com a internet.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _cryptoCurrencies = await _service.getCryptoCurrencies(
        symbols: _currentSearchSymbols,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Erro ao carregar dados: ${e.toString()}';
      _cryptoCurrencies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 