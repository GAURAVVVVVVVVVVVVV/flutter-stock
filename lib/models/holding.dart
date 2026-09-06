class Holding {
  final String symbol;
  final String name;
  double quantity;
  double avgBuyPrice;

  Holding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.avgBuyPrice,
  });

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'name': name,
        'quantity': quantity,
        'avgBuyPrice': avgBuyPrice,
      };

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'],
      name: json['name'],
      quantity: json['quantity'],
      avgBuyPrice: json['avgBuyPrice'],
    );
  }
}