import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'detail_pc.dart'; // Pastikan nama file sesuai
import 'order_food.dart';
import 'promo_page.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import 'balance_page.dart';
import 'help_page.dart';
import 'widgets/animated_tap.dart';
import 'widgets/page_transition.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/payment_viewmodel.dart';
import '../viewmodels/rental_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final user = context.watch<AuthViewModel>().userModel;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("CyberRent", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        leading: AnimatedTap(
          onTap: () => Navigator.push(context, fadeSlideRoute((context) => BalancePage())),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: StreamBuilder<int>(
                stream: context.read<PaymentViewModel>().balanceStream,
                builder: (context, snapshot) {
                  final balance = snapshot.data ?? 0;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Saldo", style: TextStyle(color: colors.accent, fontSize: 10)),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: balance.toDouble()),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Text("Rp ${_formatBalanceShort(value.round())}", style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold));
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        leadingWidth: 80,
        actions: [
          AnimatedTap(
            onTap: () {
              Navigator.push(context, fadeSlideRoute((context) => CartPage()));
            },
            child: Consumer<RentalViewModel>(
              builder: (context, rental, child) {
                return Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Keranjang", style: TextStyle(color: colors.accent, fontSize: 10)),
                        Text("Rp ${rental.totalPrice}", style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Section (menampilkan nama & foto user yang sedang aktif)
            AnimatedTap(
              onTap: () => Navigator.push(context, fadeSlideRoute((context) => ProfilePage())),
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A2A5A), Color(0xFF1A3A52)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Row(
                  children: [
                    _buildAvatar(user?.photoBase64, radius: 28),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Halo, ${user?.name ?? 'Pengguna'} 👋",
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6),
                          Text("Nikmati pengalaman gaming terbaik dengan peralatan premium", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),

            // Promo Banner
            AnimatedTap(
              onTap: () => Navigator.push(context, fadeSlideRoute((context) => PromoPage())),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.red.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.3), blurRadius: 10, offset: Offset(0, 5))],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(Icons.local_offer, size: 120, color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("🎉 PENAWARAN SPESIAL", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          SizedBox(height: 8),
                          Text("DISKON 50% JAM KE-5", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("Kode: GAMER2024", style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(delay: 150.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

            // Menu Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Layanan Kami", style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

            // Grid Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuButton(context, Icons.computer, "Pilih PC", Colors.purpleAccent, () => Navigator.push(context, fadeSlideRoute((context) => DetailPCPage())), 300.ms),
                  _buildMenuButton(context, Icons.fastfood, "Snack", Colors.orangeAccent, () => Navigator.push(context, fadeSlideRoute((context) => OrderFoodPage())), 380.ms),
                  _buildMenuButton(context, Icons.person, "Profil", colors.accent, () => Navigator.push(context, fadeSlideRoute((context) => ProfilePage())), 460.ms),
                  _buildMenuButton(context, Icons.info, "Bantuan", Colors.greenAccent, () {
                    Navigator.push(context, fadeSlideRoute((context) => const HelpPage()));
                  }, 540.ms),
                ],
              ),
            ),

            // Info Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mengapa Memilih CyberRent?", style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  _buildInfoItem(colors, "⚡", "Performa Terbaik", "PC gaming dengan spesifikasi terkini"),
                  SizedBox(height: 12),
                  _buildInfoItem(colors, "🍔", "Snack Lengkap", "Berbagai pilihan makanan dan minuman"),
                  SizedBox(height: 12),
                  _buildInfoItem(colors, "💳", "Pembayaran Fleksibel", "Berbagai metode pembayaran tersedia"),
                ],
              ),
            ).animate(delay: 700.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? photoBase64, {required double radius}) {
    if (photoBase64 != null && photoBase64.isNotEmpty) {
      try {
        return CircleAvatar(
          radius: radius,
          backgroundImage: MemoryImage(base64Decode(photoBase64)),
        );
      } catch (_) {
        // Abaikan data foto yang tidak valid, tampilkan ikon default
      }
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      child: Icon(Icons.person, color: Colors.white, size: radius),
    );
  }

  Widget _buildMenuButton(BuildContext context, IconData icon, String title, Color accentColor, VoidCallback onTap, Duration delay) {
    final colors = context.colors;
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.surface, colors.surfaceAlt],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
          boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.2), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 36),
            ),
            SizedBox(height: 12),
            Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    ).animate(delay: delay).fadeIn(duration: 400.ms).scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
  }

  String _formatBalanceShort(int balance) {
    if (balance < 1000) return balance.toString();
    final k = balance / 1000;
    return k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1)}K';
  }

  Widget _buildInfoItem(AppColors colors, String emoji, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: TextStyle(fontSize: 24)),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(description, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
