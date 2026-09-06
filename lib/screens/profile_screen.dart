import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const cardBg = Color(0xFF1F1F26);
  static const gray = Color(0xFF9E9EAD);
  static const red = Color(0xFFFF5960);
  static const accent = Color(0xFF4D8CFF);

  @override
  Widget build(BuildContext context) {
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
                'Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Avatar + name card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'G',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gaurav Mehta',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 3),
                        Text('gaurav@example.com',
                            style: TextStyle(color: gray, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('ACCOUNT',
                  style: TextStyle(
                      color: gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5)),
              const SizedBox(height: 10),

              _settingsTile(Icons.account_balance_wallet_outlined,
                  'Linked Bank Account', 'HDFC •••• 4521'),
              const SizedBox(height: 10),
              _settingsTile(Icons.badge_outlined, 'KYC Status', 'Verified'),
              const SizedBox(height: 10),
              _settingsTile(
                  Icons.notifications_outlined, 'Notifications', 'Enabled'),

              const SizedBox(height: 20),
              const Text('PREFERENCES',
                  style: TextStyle(
                      color: gray,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5)),
              const SizedBox(height: 10),

              _settingsTile(Icons.dark_mode_outlined, 'Theme', 'Dark'),
              const SizedBox(height: 10),
              _settingsTile(
                  Icons.currency_rupee, 'Currency', 'USD (demo data)'),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('This is a demo — no real account to log out of.'),
                          backgroundColor: cardBg,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Log Out',
                        style: TextStyle(
                            color: red, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: gray, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
          Text(value,
              style: const TextStyle(
                  color: gray, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}