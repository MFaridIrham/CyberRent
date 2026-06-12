import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme/app_colors.dart';
import '../viewmodels/payment_viewmodel.dart';
import 'widgets/animated_tap.dart';

// Halaman simulasi Top Up via QRIS: menampilkan kode QR dummy, lalu pengguna
// memasukkan nominal yang diinginkan. Setelah dikonfirmasi, saldo di Firestore
// (`users/{uid}.balance`) langsung bertambah dan dapat dipakai secara real-time.
class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _amountController = TextEditingController();
  bool _isProcessing = false;

  static const _quickAmounts = [20000, 50000, 100000, 200000, 500000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _amount => int.tryParse(_amountController.text) ?? 0;

  void _selectQuickAmount(int amount) {
    setState(() => _amountController.text = amount.toString());
  }

  Future<void> _confirmTopUp() async {
    final amount = _amount;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan nominal top up terlebih dahulu")),
      );
      return;
    }

    setState(() => _isProcessing = true);
    final payment = context.read<PaymentViewModel>();

    // Simulasi proses pembayaran QRIS
    await Future.delayed(const Duration(milliseconds: 1200));

    final success = await payment.topUp(amount);

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (success) {
      _showSuccessDialog(amount);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(payment.errorMessage ?? "Top up gagal, silakan coba lagi")),
      );
    }
  }

  void _showSuccessDialog(int amount) {
    final colors = context.colors;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 64)
                .animate()
                .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),
            const SizedBox(height: 16),
            Text(
              "Top Up Berhasil",
              style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Saldo sebesar Rp ${_formatCurrency(amount)} telah ditambahkan dan siap digunakan.",
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // tutup dialog
                Navigator.pop(context); // kembali ke halaman saldo
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Selesai", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final qrData = "CYBERRENT|QRIS|TOPUP|${_amount > 0 ? _amount : '------'}";

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Top Up via QRIS", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Kartu Kode QR (dummy)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Text(
                    "Scan untuk Bayar (Simulasi)",
                    style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text("QRIS - CyberRent", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pilih Nominal",
                style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 12),

            // Pilihan nominal cepat
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _quickAmounts.map((amount) {
                final selected = _amount == amount;
                return AnimatedTap(
                  onTap: () => _selectQuickAmount(amount),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? colors.accent : colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selected ? colors.accent : colors.divider),
                    ),
                    child: Text(
                      "Rp ${_formatCurrency(amount)}",
                      style: TextStyle(
                        color: selected ? Colors.black : colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate(delay: 150.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Atau Masukkan Nominal Lain",
                style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 12),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: "Rp ",
                prefixStyle: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                hintText: "0",
                hintStyle: TextStyle(color: colors.textMuted),
                filled: true,
                fillColor: colors.inputFill,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ).animate(delay: 250.ms).fadeIn(duration: 400.ms),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _confirmTopUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text("Bayar Sekarang", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
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
}
