import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  Timer? _debounce;
  List<Map<String, String>> results = [];
  bool isLoading = false;

  void onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      results = [];
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isLoading = true;
      notifyListeners();
      try {
        results = await _api.searchSymbols(query);
      } catch (e) {
        debugPrint('Search error: $e');
        results = [];
      }
      isLoading = false;
      notifyListeners();
    });
  }
}