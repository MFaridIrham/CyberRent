import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../viewmodels/payment_viewmodel.dart';
import '../viewmodels/rental_viewmodel.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final rental = context.watch<RentalViewModel>();
    final payment = context.watch<PaymentViewModel>();
    final items = rental.cartItems;
    final total = rental.totalPrice;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Keranjang", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: items.isEmpty
          ? Center(
              child: Text("Keranjang kosong", style: TextStyle(color: colors.textPrimary)).animate().fadeIn(duration: 400.ms),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: ValueKey(item.name),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => rental.removeItem(item.name),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(item.name, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () => rental.removeItem(item.name),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Harga Unit: Rp ${item.price}", style: TextStyle(color: colors.textSecondary)),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline, color: colors.accent),
                                        onPressed: () => rental.updateQuantity(item.name, item.quantity - 1),
                                      ),
                                      Text("${item.quantity}", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline, color: colors.accent),
                                        onPressed: () => rental.updateQuantity(item.name, item.quantity + 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Subtotal:", style: TextStyle(color: colors.textSecondary)),
                                  Text("Rp ${item.subtotal}", style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: (index * 80).ms).fadeIn(duration: 350.ms).slideX(begin: 0.15, end: 0);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Harga:", style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: total.toDouble()),
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Text("Rp ${value.round()}", style: TextStyle(color: colors.accent, fontSize: 20, fontWeight: FontWeight.bold));
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: payment.isProcessing
                            ? null
                            : () async {
                                final success = await payment.checkout(items, total);
                                if (!context.mounted) return;

                                if (success) {
                                  rental.clearCart();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Checkout berhasil! Saldo telah dipotong."),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(payment.errorMessage ?? "Checkout gagal, silakan coba lagi."),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.accent,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: payment.isProcessing
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                              )
                            : Text("Checkout", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
              ],
            ),
    );
  }
}
