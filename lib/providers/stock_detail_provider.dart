import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/api_service.dart';

class StockDetailProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  Stock? stock;
  List<double> history = [];
  bool isLoading = false;

  Future<void> load(String symbol, String name) async {
    isLoading = true;
    notifyListeners();
    try {
      final quote = await _api.getQuote(symbol);
      stock = Stock(
        symbol: symbol,
        name: name,
        currentPrice: quote.currentPrice,
        changePercent: quote.changePercent,
      );
      history = await _api.getCandles(symbol, quote.currentPrice);
    } catch (e) {
      debugPrint('Stock detail load error: $e');
    }
    isLoading = false;
    notifyListeners();
  }
}