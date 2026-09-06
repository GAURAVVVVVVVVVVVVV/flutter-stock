import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';

class BuySellScreen extends StatefulWidget {
  final String symbol;
  final String name;
  final double currentPrice;
  final bool isBuy;

  const BuySellScreen({
    super.key,
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.isBuy,
  });

  @override
  State<BuySellScreen> createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  int quantity = 10;

  static const cardBg = Color(0xFF1F1F26);
  static const green = Color(0xFF31D98C);
  static const gray = Color(0xFF9E9EAD);

  @override
  Widget build(BuildContext context) {
    final orderValue = widget.currentPrice * quantity;
    final fees = orderValue * 0.0011; // mock brokerage + taxes ~0.11%
    final total = orderValue + fees;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '${widget.isBuy ? 'Buy' : 'Sell'} ${widget.symbol}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Current price card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Price',
                        style: TextStyle(color: gray, fontSize: 11)),
                    const SizedBox(height: 4),
                    Text('\$${widget.currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text('QUANTITY',
                  style: TextStyle(
                      color: gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                    ),
                    Text('$quantity shares',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Order summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _summaryRow('Order Value', '\$${orderValue.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    _summaryRow('Brokerage + Taxes', '\$${fees.toStringAsFixed(2)}'),
                    const Divider(color: Color(0xFF2C2C34), height: 20),
                    _summaryRow('Total ${widget.isBuy ? 'Payable' : 'Receivable'}',
                        '\$${total.toStringAsFixed(2)}',
                        bold: true),
                  ],
                ),
              ),
              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final portfolio = context.read<PortfolioProvider>();
                      if (widget.isBuy) {
                        portfolio.buy(widget.symbol, widget.name,
                            quantity.toDouble(), widget.currentPrice);
                      } else {
                        portfolio.sell(widget.symbol, quantity.toDouble());
                      }
                      Navigator.popUntil(context, (route) => route.isFirst);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${widget.isBuy ? 'Bought' : 'Sold'} $quantity shares of ${widget.symbol}'),
                          backgroundColor: green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isBuy ? green : Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Confirm ${widget.isBuy ? 'Buy' : 'Sell'} Order',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: gray, fontSize: 12)),
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
      ],
    );
  }
}