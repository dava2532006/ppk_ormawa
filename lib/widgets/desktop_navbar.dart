import 'package:flutter/material.dart';
import '../utils/theme.dart';

class DesktopNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const DesktopNavbar({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.3),
          ],
        ),
      ),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.roofing, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Gentengforyou',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Navigation Menu
          _buildNavItem('Beranda', 0),
          const SizedBox(width: 32),
          _buildNavItem('Katalog Produk', 1),
          const SizedBox(width: 32),
          _buildNavItem('Keranjang Belanja', 2),
          const SizedBox(width: 32),
          _buildNavItem('Tentang Kami', 3),
          const SizedBox(width: 40),
          // User Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, int index) {
    final isActive = currentIndex == index;
    return TextButton(
      onPressed: () => onNavigate(index),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          decoration: isActive ? TextDecoration.underline : null,
          decorationColor: Colors.white,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
