import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/crypto_viewmodel.dart';
import '../models/crypto_model.dart';

class CryptoListView extends StatefulWidget {
  const CryptoListView({super.key});

  @override
  State<CryptoListView> createState() => _CryptoListViewState();
}

class _CryptoListViewState extends State<CryptoListView> {
  final TextEditingController _searchController = TextEditingController();
  final _formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoViewModel>().fetchCryptos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criptomoedas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar criptomoedas (separadas por vírgula)',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      context.read<CryptoViewModel>().fetchCryptos(_searchController.text);
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<CryptoViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.error.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.error,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.fetchCryptos(),
                            child: const Text('Tentar Novamente'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => viewModel.fetchCryptos(),
                  child: ListView.builder(
                    itemCount: viewModel.cryptos.length,
                    itemBuilder: (context, index) {
                      final crypto = viewModel.cryptos[index];
                      return CryptoListItem(crypto: crypto, formatter: _formatter);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CryptoListItem extends StatelessWidget {
  final CryptoModel crypto;
  final NumberFormat formatter;

  const CryptoListItem({
    super.key, 
    required this.crypto,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text('${crypto.symbol} - ${crypto.name}'),
        subtitle: Text('USD: \$${crypto.priceUsd.toStringAsFixed(2)}'),
        trailing: Text(
          formatter.format(crypto.priceBrl),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => _showCryptoDetails(context),
      ),
    );
  }

  void _showCryptoDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${crypto.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Símbolo: ${crypto.symbol}'),
            const SizedBox(height: 8),
            Text('Data de Adição: ${crypto.dateAdded}'),
            const SizedBox(height: 8),
            Text('Preço USD: \$${crypto.priceUsd.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Preço BRL: ${formatter.format(crypto.priceBrl)}'),
          ],
        ),
      ),
    );
  }
} 