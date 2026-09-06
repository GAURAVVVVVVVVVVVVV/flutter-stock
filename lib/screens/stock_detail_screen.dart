import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_detail_provider.dart';
import 'buy_sell_screen.dart';
class StockDetailScreen extends StatelessWidget {
  final String symbol;
  final String name;

  const StockDetailScreen({super.key, required this.symbol, required this.name});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockDetailProvider()..load(symbol, name),
      child: _StockDetailBody(symbol: symbol),
    );
  }
}

class _StockDetailBody extends StatelessWidget {
  final String symbol;
  const _StockDetailBody({required this.symbol});

  static const cardBg = Color(0xFF1F1F26);
  static const green = Color(0xFF31D98C);
  static const red = Color(0xFFFF5960);
  static const gray = Color(0xFF9E9EAD);

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<StockDetailProvider>();

    if (detail.isLoading || detail.stock == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0F14),
        body: Center(child: CircularProgressIndicator(color: green)),
      );
    }

    final stock = detail.stock!;
    final isUp = stock.changePercent >= 0;
    final history = detail.history;

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
                    stock.symbol,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.name,
                        style: const TextStyle(color: gray, fontSize: 12)),
                    const SizedBox(height: 6),
                    Text('\$${stock.currentPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      '${isUp ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}% today',
                      style: TextStyle(
                          color: isUp ? green : red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Chart card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SizedBox(
                  height: 140,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _LineChartPainter(
                      points: history,
                      lineColor: isUp ? green : red,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statColumn('Day High',
                        '\$${(stock.currentPrice * 1.012).toStringAsFixed(2)}'),
                    _statColumn('Day Low',
                        '\$${(stock.currentPrice * 0.988).toStringAsFixed(2)}'),
                    _statColumn('30D Range',
                        '\$${history.reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}-${history.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}'),
                  ],
                ),
              ),
              const Spacer(),

              // Buy / Sell buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BuySellScreen(
                                symbol: stock.symbol,
                                name: stock.name,
                                currentPrice: stock.currentPrice,
                                isBuy: false,
                              ),
                            ),
                          );  
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Sell',
                            style: TextStyle(
                                color: red, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BuySellScreen(
                                symbol: stock.symbol,
                                name: stock.name,
                                currentPrice: stock.currentPrice,
                                isBuy: true,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Buy',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
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
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: gray, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;
  final Color lineColor;

  _LineChartPainter({required this.points, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxVal = points.reduce((a, b) => a > b ? a : b);
    final minVal = points.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);

    final path = Path();
    final stepX = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = size.height - ((points[i] - minVal) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => true;
}