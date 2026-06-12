import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../viewmodels/payment_viewmodel.dart';
import 'order_detail_page.dart';
import 'top_up_page.dart';
import 'widgets/animated_tap.dart';
import 'widgets/page_transition.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final Set<String> _hiddenIds = {};

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final payment = context.watch<PaymentViewModel>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Saldo", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Saldo Card
            StreamBuilder<int>(
              stream: payment.balanceStream,
              builder: (context, snapshot) {
                final balance = snapshot.data ?? 0;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      const Text("Total Saldo", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 10),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: balance.toDouble()),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Text("Rp ${_formatCurrency(value.round())}", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold));
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0);
              },
            ),

            // Top Up Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, fadeSlideRoute((context) => const TopUpPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Top Up via QRIS", style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ).animate(delay: 150.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 30),

            // Riwayat Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Riwayat Transaksi", style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

            // Riwayat List
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: payment.transactionHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(child: CircularProgressIndicator(color: colors.accent)),
                  );
                }

                final transactions = (snapshot.data ?? [])
                    .where((data) => !_hiddenIds.contains(data['id']))
                    .toList();
                if (transactions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text("Belum ada transaksi", style: TextStyle(color: colors.textSecondary)),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: transactions
                        .asMap()
                        .entries
                        .map((entry) => _buildHistoryItem(context, colors, payment, entry.value, entry.key))
                        .toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, AppColors colors, PaymentViewModel payment, Map<String, dynamic> data, int index) {
    final items = (data['items'] as List<dynamic>?) ?? [];
    final title = items.map((item) => item['name'].toString()).join(', ');
    final totalPrice = (data['total_price'] as num?)?.toInt() ?? 0;
    final timestamp = data['timestamp'] as Timestamp?;
    final orderId = data['id'] as String?;

    final card = AnimatedTap(
      onTap: () => Navigator.push(context, fadeSlideRoute((context) => OrderDetailPage(order: data))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.isEmpty ? "Pesanan" : title,
                    style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(_formatDate(timestamp), style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "-Rp ${_formatCurrency(totalPrice)}",
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: colors.textMuted, size: 20),
              onPressed: orderId == null ? null : () => _confirmDeleteTransaction(context, colors, payment, orderId),
            ),
          ],
        ),
      ),
    );

    final animatedCard = card.animate(delay: (index * 80).ms).fadeIn(duration: 350.ms).slideX(begin: 0.1, end: 0);

    if (orderId == null) return animatedCard;

    return Dismissible(
      key: ValueKey(orderId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() => _hiddenIds.add(orderId));
        payment.deleteTransaction(orderId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: animatedCard,
    );
  }

  void _confirmDeleteTransaction(BuildContext context, AppColors colors, PaymentViewModel payment, String orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text("Hapus Riwayat", style: TextStyle(color: colors.textPrimary)),
        content: Text("Hapus catatan transaksi ini secara permanen?", style: TextStyle(color: colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("Batal", style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              payment.deleteTransaction(orderId);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final digits = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Baru saja";
    final date = timestamp.toDate();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute';
  }
}
