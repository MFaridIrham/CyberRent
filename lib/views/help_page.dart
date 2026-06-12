import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

// Halaman Bantuan: berisi daftar FAQ (pertanyaan yang sering diajukan)
// dan tombol WhatsApp di pojok kanan bawah (belum berfungsi / placeholder).
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const _faqs = [
    (
      'Bagaimana cara menyewa PC?',
      'Buka menu "Pilih PC" di halaman utama, pilih unit PC yang tersedia, atur durasi sewa, lalu tambahkan ke keranjang dan lakukan checkout.',
    ),
    (
      'Bagaimana cara memesan snack?',
      'Buka menu "Snack" di halaman utama, pilih makanan/minuman yang diinginkan, tentukan jumlahnya, lalu tekan tombol "Pesan" untuk menambahkannya ke keranjang.',
    ),
    (
      'Bagaimana cara top up saldo?',
      'Buka halaman Saldo (ketuk info saldo di pojok kiri atas), lalu tekan "Top Up via QRIS". Pilih atau masukkan nominal, kemudian tekan "Bayar Sekarang". Saldo akan langsung bertambah dan siap digunakan.',
    ),
    (
      'Bagaimana cara melihat riwayat transaksi?',
      'Buka halaman Profil, lalu pilih "Riwayat". Ketuk salah satu riwayat untuk melihat detail PC dan snack yang dipesan beserta tanggal dan waktunya.',
    ),
    (
      'Bagaimana cara mengubah nama, foto, atau password?',
      'Buka halaman Profil, lalu pilih "Edit Profil". Anda dapat mengganti foto dengan menekan ikon kamera, mengubah nama, dan mengganti password pada formulir yang tersedia.',
    ),
    (
      'Bagaimana cara mengganti tampilan menjadi terang/gelap?',
      'Buka halaman Profil, lalu pilih "Pengaturan". Aktifkan atau matikan toggle "Mode Gelap" sesuai preferensi Anda.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Bantuan", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A2A5A), Color(0xFF1A3A52)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pusat Bantuan ❓", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        "Temukan jawaban dari pertanyaan yang sering diajukan di bawah ini.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),

                const SizedBox(height: 20),

                Text("FAQ", style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold))
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 12),

                ..._faqs.asMap().entries.map(
                  (entry) => _buildFaqItem(context, colors, entry.value.$1, entry.value.$2, entry.key),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),

          // Tombol WhatsApp (belum berfungsi)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF25D366),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fitur chat WhatsApp akan datang!"), duration: Duration(seconds: 2)),
                );
              },
              child: Image.asset('assets/whatsapp.png', width: 28, height: 28, fit: BoxFit.contain),
            ).animate(delay: 400.ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.6, 0.6), curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, AppColors colors, String question, String answer, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          iconColor: colors.accent,
          collapsedIconColor: colors.textSecondary,
          title: Text(
            question,
            style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (150 + index * 80).ms).fadeIn(duration: 350.ms).slideX(begin: 0.1, end: 0);
  }
}
