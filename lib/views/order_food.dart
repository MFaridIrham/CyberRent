import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/food_model.dart';
import '../theme/app_colors.dart';
import '../viewmodels/rental_viewmodel.dart';

class OrderFoodPage extends StatefulWidget {
  const OrderFoodPage({super.key});

  @override
  State<OrderFoodPage> createState() => _OrderFoodPageState();
}

class _OrderFoodPageState extends State<OrderFoodPage> {
  // Map untuk jumlah per item
  final Map<String, int> _quantities = {};

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final menuItems = context.watch<RentalViewModel>().foodMenu;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Snack Order", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Snack
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.redAccent]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Icon(Icons.fastfood, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Menu Snack", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Pilih snack favorit Anda", style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),

            // Grid Menu Makanan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildFoodItem(colors, item)
                      .animate(delay: (100 + index * 80).ms)
                      .fadeIn(duration: 400.ms)
                      .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(AppColors colors, FoodModel item) {
    final quantity = _quantities[item.name] ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: colors.surfaceAlt,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(item.name, style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
          Text("Rp ${item.price}", style: TextStyle(color: colors.textSecondary, fontSize: 14)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: colors.accent),
                onPressed: () => setState(() => _quantities[item.name] = (quantity > 0) ? quantity - 1 : 0),
              ),
              Text("$quantity", style: TextStyle(color: colors.textPrimary, fontSize: 18)),
              IconButton(
                icon: Icon(Icons.add, color: colors.accent),
                onPressed: () => setState(() => _quantities[item.name] = quantity + 1),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: quantity > 0 ? () {
              context.read<RentalViewModel>().addItem(item.name, item.price, quantity);
              setState(() => _quantities[item.name] = 0); // Reset setelah pesan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Ditambahkan ke keranjang: $quantity ${item.name}"),
                  duration: Duration(seconds: 2),
                ),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Pesan", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
