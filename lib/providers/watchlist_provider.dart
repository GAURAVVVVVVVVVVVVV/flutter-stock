import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/api_service.dart';

class WatchlistProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final List<String> _symbols = ['AAPL', 'TSLA', 'MSFT', 'GOOGL', 'AMZN'];
  List<Stock> stocks = [];
  bool isLoading = false;

  static const Map<String, String> companyNames = {
    'AAPL': 'Apple Inc.',
    'TSLA': 'Tesla Inc.',
    'MSFT': 'Microsoft Corp.',
    'GOOGL': 'Alphabet Inc.',
    'AMZN': 'Amazon.com Inc.',
  };

  Future<void> loadStocks() async {
    isLoading = true;
    notifyListeners();
    try {
      final fetched = await Future.wait(_symbols.map((s) => _api.getQuote(s)));
      stocks = fetched.map((stock) {
        return Stock(
          symbol: stock.symbol,
          name: companyNames[stock.symbol] ?? stock.symbol,
          currentPrice: stock.currentPrice,
          changePercent: stock.changePercent,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error loading stocks: $e');
    }
    isLoading = false;
    notifyListeners();
  }
}