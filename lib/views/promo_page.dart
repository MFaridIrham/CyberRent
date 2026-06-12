import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import 'widgets/animated_tap.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  static const _promos = [
    {
      'emoji': '🎉',
      'title': 'DISKON 50% JAM KE-5',
      'desc': 'Sewa PC 5 jam berturut-turut, jam ke-5 cukup bayar separuh harga.',
      'code': 'GAMER2024',
      'colors': [Colors.deepOrange, Color(0xFFC62828)],
    },
    {
      'emoji': '🍔',
      'title': 'COMBO SNACK HEMAT',
      'desc': 'Beli 2 snack favorit, gratis 1 minuman pilihan.',
      'code': 'SNACKHEMAT',
      'colors': [Colors.purpleAccent, Color(0xFF512DA8)],
    },
    {
      'emoji': '✨',
      'title': 'BONUS MEMBER BARU',
      'desc': 'Diskon 10% untuk transaksi pertamamu setelah daftar akun.',
      'code': 'WELCOME10',
      'colors': [Colors.cyanAccent, Color(0xFF1565C0)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Promo Hari Ini", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A2A5A), Color(0xFF1A3A52)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Penawaran Spesial 🔥", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "Tap kartu promo untuk menyalin kode dan gunakan saat checkout.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),

            // Promo Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: _promos
                    .asMap()
                    .entries
                    .map((entry) => _buildPromoCard(context, entry.value, entry.key))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, Map<String, dynamic> promo, int index) {
    final colors = promo['colors'] as List<Color>;
    final code = promo['code'] as String;

    return AnimatedTap(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kode '$code' disalin!"), duration: const Duration(seconds: 2)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: colors[1].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(promo['emoji'] as String, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(promo['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(promo['desc'] as String, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Kode: $code", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(width: 6),
                  const Icon(Icons.copy, color: Colors.white, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (150 + index * 120).ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
