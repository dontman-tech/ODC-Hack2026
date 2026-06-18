import 'package:flutter/material.dart';

class EcoBackground extends StatelessWidget {
  const EcoBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF064E3B), Color(0xFF1E293B), Color(0xFF10B981)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -90,
            child: _Glow(size: 260, color: const Color(0xFF4ADE80).withOpacity(0.32)),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _Glow(size: 280, color: const Color(0xFF2ECC71).withOpacity(0.26)),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
