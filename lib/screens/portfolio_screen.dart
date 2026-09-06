import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  static const cardBg = Color(0xFF1F1F26);
  static const green = Color(0xFF31D98C);
  static const red = Color(0xFFFF5960);
  static const gray = Color(0xFF9E9EAD);

  static const List<Color> allocColors = [
    Color(0xFF4D8CFF),
    Color(0xFF31D98C),
    Color(0xFFFFB84D),
    Color(0xFF8C66FF),
    Color(0xFFFF5960),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PortfolioProvider>().refreshLivePrices());
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();
    final holdings = portfolio.holdings;
    final prices = portfolio.currentPrices;

    double totalValue = 0;
    double totalInvested = 0;
    for (final h in holdings) {
      final live = prices[h.symbol] ?? h.avgBuyPrice;
      totalValue += live * h.quantity;
      totalInvested += h.avgBuyPrice * h.quantity;
    }
    final totalPnl = totalValue - totalInvested;
    final totalPnlPercent =
        totalInvested == 0 ? 0.0 : (totalPnl / totalInvested) * 100;
    final isUpOverall = totalPnl >= 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => portfolio.refreshLivePrices(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text('Portfolio',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Portfolio Value',
                          style: TextStyle(color: gray, fontSize: 11)),
                      const SizedBox(height: 6),
                      Text('\$${totalValue.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      if (holdings.isNotEmpty)
                        Row(
                          children: [
                            Text(
                              '${isUpOverall ? '+' : ''}\$${totalPnl.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: isUpOverall ? green : red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${isUpOverall ? '+' : ''}${totalPnlPercent.toStringAsFixed(2)}%) overall',
                              style: const TextStyle(color: gray, fontSize: 12),
                            ),
                          ],
                        )
                      else
                        const Text('No holdings yet',
                            style: TextStyle(color: gray, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (holdings.isNotEmpty) ...[
                  const Text('ALLOCATION',
                      style: TextStyle(
                          color: gray,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 10,
                      child: Row(
                        children: holdings.asMap().entries.map((entry) {
                          final index = entry.key;
                          final h = entry.value;
                          final live = prices[h.symbol] ?? h.avgBuyPrice;
                          final value = live * h.quantity;
                          final flexValue =
                              (value * 1000).toInt().clamp(1, 999999);
                          return Expanded(
                            flex: flexValue,
                            child: Container(
                              color: allocColors[index % allocColors.length],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                const Text('HOLDINGS',
                    style: TextStyle(
                        color: gray,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5)),
                const SizedBox(height: 10),
                Expanded(
                  child: holdings.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(
                              child: Text(
                                'Buy your first stock to see it here',
                                style: TextStyle(color: gray, fontSize: 13),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          itemCount: holdings.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final h = holdings[index];
                            final live = prices[h.symbol] ?? h.avgBuyPrice;
                            final value = live * h.quantity;
                            final pnl =
                                (live - h.avgBuyPrice) * h.quantity;
                            final isUp = pnl >= 0;
                            return Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(h.symbol,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 3),
                                      Text(
                                          '${h.quantity.toStringAsFixed(0)} shares',
                                          style: const TextStyle(
                                              color: gray, fontSize: 11)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text('\$${value.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${isUp ? '+' : ''}\$${pnl.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            color: isUp ? green : red,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}