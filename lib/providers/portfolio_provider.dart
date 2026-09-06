import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/holding.dart';
import '../services/api_service.dart';

class PortfolioProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final List<Holding> holdings = [];
  Map<String, double> currentPrices = {};
  bool isLoadingPrices = false;
  static const _storageKey = 'portfolio_holdings';

  PortfolioProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      holdings.clear();
      holdings.addAll(decoded.map((e) => Holding.fromJson(e)));
      notifyListeners();
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(holdings.map((h) => h.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void buy(String symbol, String name, double quantity, double price) {
    final existing = holdings.where((h) => h.symbol == symbol).firstOrNull;
    if (existing != null) {
      final totalCost =
          (existing.avgBuyPrice * existing.quantity) + (price * quantity);
      existing.quantity += quantity;
      existing.avgBuyPrice = totalCost / existing.quantity;
    } else {
      holdings.add(Holding(
        symbol: symbol,
        name: name,
        quantity: quantity,
        avgBuyPrice: price,
      ));
    }
    _saveToStorage();
    notifyListeners();
  }

  void sell(String symbol, double quantity) {
    final existing = holdings.where((h) => h.symbol == symbol).firstOrNull;
    if (existing == null) return;
    existing.quantity -= quantity;
    if (existing.quantity <= 0) {
      holdings.removeWhere((h) => h.symbol == symbol);
    }
    _saveToStorage();
    notifyListeners();
  }

  Future<void> refreshLivePrices() async {
    if (holdings.isEmpty) return;
    isLoadingPrices = true;
    notifyListeners();
    try {
      final quotes = await Future.wait(
        holdings.map((h) => _api.getQuote(h.symbol)),
      );
      currentPrices = {
        for (var q in quotes) q.symbol: q.currentPrice,
      };
    } catch (e) {
      debugPrint('Live price refresh failed: $e');
    }
    isLoadingPrices = false;
    notifyListeners();
  }
}