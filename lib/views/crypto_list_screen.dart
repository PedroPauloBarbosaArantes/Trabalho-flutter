import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crypto_list/view_models/crypto_list_view_model.dart';
import 'package:crypto_list/models/crypto_currency.dart';

class CryptoDetailBottomSheet extends StatelessWidget {
  final CryptoCurrency crypto;

  const CryptoDetailBottomSheet({Key? key, required this.crypto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF16213E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFE94560),
                child: Text(
                  crypto.symbol,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Adicionado em ${crypto.formattedDateAdded}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildPriceCard(
            context,
            'Preço em USD',
            crypto.formattedPriceUsd,
            Icons.attach_money,
          ),
          SizedBox(height: 8),
          _buildPriceCard(
            context,
            'Preço em BRL',
            crypto.formattedPriceBrl,
            Icons.currency_exchange,
          ),
          SizedBox(height: 8),
          _buildPriceCard(
            context,
            'Variação 24h',
            '${crypto.percentChange24h.toStringAsFixed(2)}%',
            Icons.trending_up,
            isPositive: crypto.percentChange24h >= 0,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(
    BuildContext context,
    String title,
    String value,
    IconData icon, {
    bool? isPositive,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPositive != null
              ? (isPositive ? Colors.green : Colors.red)
              : Color(0xFFE94560),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isPositive != null
                ? (isPositive ? Colors.green : Colors.red)
                : Color(0xFFE94560),
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isPositive != null
                        ? (isPositive ? Colors.green : Colors.red)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text =
        Provider.of<CryptoListViewModel>(
          context,
          listen: false,
        ).currentSearchSymbols;

    Future.microtask(
      () =>
          Provider.of<CryptoListViewModel>(
            context,
            listen: false,
          ).fetchCryptoCurrencies(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CryptoListViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Crypto Tracker',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Buscar criptomoedas (BTC,ETH,SOL)',
                              prefixIcon: Icon(Icons.search, color: Color(0xFFE94560)),
                            ),
                            onSubmitted: (value) {
                              viewModel.setSearchSymbols(value);
                              viewModel.fetchCryptoCurrencies();
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            viewModel.setSearchSymbols(_searchController.text);
                            viewModel.fetchCryptoCurrencies();
                          },
                          child: Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (viewModel.isLoading)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xFF16213E),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE94560)),
                  ),
                ),
              if (viewModel.errorMessage != null)
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Column(
                    children: [
                      Text(
                        viewModel.errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          viewModel.setSearchSymbols(_searchController.text);
                          viewModel.fetchCryptoCurrencies();
                        },
                        child: Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    viewModel.setSearchSymbols(_searchController.text);
                    await viewModel.fetchCryptoCurrencies();
                  },
                  color: Color(0xFFE94560),
                  child: viewModel.cryptoCurrencies.isEmpty &&
                          !viewModel.isLoading &&
                          viewModel.errorMessage == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.white38,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhuma criptomoeda encontrada',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(12),
                          itemCount: viewModel.cryptoCurrencies.length,
                          itemBuilder: (context, index) {
                            final crypto = viewModel.cryptoCurrencies[index];
                            final percentChangeColor =
                                crypto.percentChange24h >= 0
                                    ? Colors.green
                                    : Colors.red;

                            return Card(
                              margin: EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return CryptoDetailBottomSheet(
                                        crypto: crypto,
                                      );
                                    },
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Color(0xFFE94560),
                                        child: Text(
                                          crypto.symbol,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              crypto.name,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              'USD: ${crypto.formattedPriceUsd}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            Text(
                                              'BRL: ${crypto.formattedPriceBrl}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: percentChangeColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: percentChangeColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${crypto.percentChange24h.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                color: percentChangeColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '24h',
                                              style: TextStyle(
                                                color: percentChangeColor
                                                    .withOpacity(0.7),
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}