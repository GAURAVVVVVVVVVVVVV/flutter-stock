import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import 'search_screen.dart';
import 'stock_detail_screen.dart';
import 'portfolio_screen.dart';
import 'profile_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const cardBg = Color(0xFF1F1F26);
  static const green = Color(0xFF31D98C);
  static const red = Color(0xFFFF5960);
  static const gray = Color(0xFF9E9EAD);

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistProvider>().loadStocks());
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = context.watch<WatchlistProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Good evening',
                style: TextStyle(color: gray, fontSize: 13),
              ),
              const SizedBox(height: 2),
              const Text(
                'My Watchlist',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Search bar - tappable, navigates to Search screen
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: gray, size: 18),
                      SizedBox(width: 8),
                      Text('Search stocks...',
                          style: TextStyle(color: gray, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'WATCHLIST',
                style: TextStyle(
                    color: gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),

              // Stock list
              Expanded(
                child: watchlist.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: green))
                    : ListView.separated(
                        itemCount: watchlist.stocks.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final stock = watchlist.stocks[index];
                          final isUp = stock.changePercent >= 0;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StockDetailScreen(
                                    symbol: stock.symbol,
                                    name: stock.name,
                                  ),
                                ),
                              );
                            },
                            child: Container(
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
                                      Text(
                                        stock.symbol,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        stock.name,
                                        style: const TextStyle(
                                            color: gray, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${stock.currentPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${isUp ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                            color: isUp ? green : red,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),

              // Bottom nav
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Home',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PortfolioScreen()),
                        );
                      },
                      child: const Text('Portfolio',
                          style: TextStyle(color: gray, fontSize: 11)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen()),
                        );
                      },
                      child: const Text('Search',
                          style: TextStyle(color: gray, fontSize: 11)),
                    ),
                    GestureDetector(
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        );
                      },
                      child: const Text('Profile',
                          style: TextStyle(color: gray, fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}