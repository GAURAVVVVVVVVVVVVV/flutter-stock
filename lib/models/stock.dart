class Stock {
  final String symbol;
  final String name;
  final double currentPrice;
  final double changePercent;

  Stock({
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.changePercent,
  });

  factory Stock.fromJson(String symbol, Map<String, dynamic> json) {
    return Stock(
      symbol: symbol,
      name: symbol,
      currentPrice: (json['c'] ?? 0).toDouble(),
      changePercent: (json['dp'] ?? 0).toDouble(),
    );
  }
}