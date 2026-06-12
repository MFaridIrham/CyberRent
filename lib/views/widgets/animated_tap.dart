import 'package:flutter/material.dart';

// Membungkus widget dengan efek mengecil saat ditekan agar terasa interaktif
class AnimatedTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AnimatedTap({super.key, required this.child, this.onTap});

  @override
  State<AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<AnimatedTap> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
