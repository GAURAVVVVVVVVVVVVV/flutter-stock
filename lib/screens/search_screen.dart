import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const cardBg = Color(0xFF1F1F26);
  static const gray = Color(0xFF9E9EAD);
  static const accent = Color(0xFF4D8CFF);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: const _SearchScreenBody(),
    );
  }
}

class _SearchScreenBody extends StatelessWidget {
  const _SearchScreenBody();

  static const cardBg = Color(0xFF1F1F26);
  static const gray = Color(0xFF9E9EAD);
  static const accent = Color(0xFF4D8CFF);

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

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
                  const Text(
                    'Search',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'TCS, AAPL, TSLA...',
                    hintStyle: TextStyle(color: gray),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) =>
                      context.read<SearchProvider>().onQueryChanged(value),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'RESULTS',
                style: TextStyle(
                    color: gray,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: search.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: search.results.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = search.results[index];
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['symbol'] ?? '',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 3),
                                      Text(item['description'] ?? '',
                                          style: const TextStyle(
                                              color: gray, fontSize: 11),
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
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
    );
  }
}