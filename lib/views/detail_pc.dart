import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../models/pc_model.dart';
import '../theme/app_colors.dart';
import '../viewmodels/rental_viewmodel.dart';
import 'widgets/animated_tap.dart';

class DetailPCPage extends StatefulWidget {
  const DetailPCPage({super.key});

  @override
  State<DetailPCPage> createState() => _DetailPCPageState();
}

class _DetailPCPageState extends State<DetailPCPage> {
  String? selectedPC;
  int hours = 1;
  String promoCode = "";
  final TextEditingController promoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pcOptions = context.watch<RentalViewModel>().pcOptions;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text("Pilih PC", style: TextStyle(color: colors.accent, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header PC
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purpleAccent, Colors.blueAccent]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Icon(Icons.computer, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text("Pilih PC Gaming", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text("Sewa PC impian Anda", style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),

            // List PC Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: pcOptions.asMap().entries.map((entry) => _buildPCOption(colors, entry.value, entry.key)).toList(),
              ),
            ),

            // Durasi
            if (selectedPC != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Durasi (Jam): $hours", style: TextStyle(color: colors.textPrimary, fontSize: 18)),
                    Slider(
                      value: hours.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: hours.toString(),
                      onChanged: (value) => setState(() => hours = value.toInt()),
                      activeColor: colors.accent,
                    ),
                    SizedBox(height: 16),
                    Text("Kode Promo", style: TextStyle(color: colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                    SizedBox(height: 8),
                    TextField(
                      controller: promoController,
                      onChanged: (value) => setState(() => promoCode = value),
                      style: TextStyle(color: colors.textPrimary),
                      decoration: InputDecoration(
                        hintText: "Masukkan kode promo (opsional)",
                        hintStyle: TextStyle(color: colors.textMuted),
                        prefixIcon: Icon(Icons.local_offer, color: colors.accent),
                        filled: true,
                        fillColor: colors.surfaceAlt,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: colors.accent, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: colors.accent.withValues(alpha: 0.3), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: colors.accent, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final pc = pcOptions.firstWhere((p) => p.name == selectedPC);
                        final itemName = promoCode.isNotEmpty
                            ? "${selectedPC!} ($hours jam) - Kode: $promoCode"
                            : "${selectedPC!} ($hours jam)";
                        context.read<RentalViewModel>().addItem(itemName, pc.price * hours, 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Ditambahkan ke keranjang: ${selectedPC!}"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        promoController.clear();
                        setState(() => promoCode = "");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.accent,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text("Tambah ke Keranjang", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  Widget _buildPCOption(AppColors colors, PcModel pc, int index) {
    final isSelected = selectedPC == pc.name;
    return AnimatedTap(
      onTap: () => setState(() => selectedPC = pc.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent.withValues(alpha: 0.2) : colors.surface,
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: colors.accent, width: 2) : null,
          boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 5, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colors.surfaceAlt,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  pc.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pc.name, style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(pc.specs, style: TextStyle(color: colors.textSecondary, fontSize: 14)),
                  Text("Rp ${pc.price}/jam", style: TextStyle(color: colors.accent, fontSize: 16)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: colors.accent),
          ],
        ),
      ),
    ).animate(delay: (150 + index * 100).ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}
