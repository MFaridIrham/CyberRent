import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

// Menampilkan detail satu pesanan: item PC/snack yang dipesan beserta
// jumlah, subtotal, waktu pemesanan lengkap, dan total pembayaran.
class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final items = (order['items'] as List<dynamic>?) ?? [];
    final totalPrice = (order['total_price'] as num?)?.toInt() ?? 0;
    final timestamp = order['timestamp'] as Timestamp?;
    final orderId = order['id'] as String?;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Detail Pesanan", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: ID & waktu pemesanan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Pesanan #${_shortId(orderId)}",
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white70, size: 16),
                      const SizedBox(width: 6),
                      Text(_formatDateTime(timestamp), style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

            const SizedBox(height: 20),
            Text("Item Dipesan", style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text("Tidak ada detail item", style: TextStyle(color: colors.textSecondary))),
              )
            else
              ...items.asMap().entries.map((entry) => _buildItemCard(colors, entry.value as Map<String, dynamic>, entry.key)),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: const Offset(0, 2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Pembayaran", style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Rp ${_formatCurrency(totalPrice)}", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(AppColors colors, Map<String, dynamic> item, int index) {
    final name = item['name']?.toString() ?? '';
    final price = (item['price'] as num?)?.toInt() ?? 0;
    final quantity = (item['quantity'] as num?)?.toInt() ?? 1;
    final subtotal = price * quantity;
    final isPc = name.toUpperCase().contains('PC');
    final accent = isPc ? Colors.purpleAccent : Colors.orangeAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(isPc ? Icons.computer : Icons.fastfood, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("Rp ${_formatCurrency(price)} x $quantity", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text("Rp ${_formatCurrency(subtotal)}", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate(delay: (index * 80).ms).fadeIn(duration: 350.ms).slideX(begin: 0.1, end: 0);
  }

  String _shortId(String? id) {
    if (id == null || id.isEmpty) return "-";
    return id.length <= 8 ? id : id.substring(0, 8).toUpperCase();
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

  String _formatDateTime(Timestamp? timestamp) {
    if (timestamp == null) return "Baru saja";
    final date = timestamp.toDate();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute';
  }
}
