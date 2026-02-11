import 'package:flutter/material.dart';
import '../utils/theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF2C2420),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.roofing, color: Colors.white, size: 20),
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
          const SizedBox(height: 16),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: AppTheme.primary, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jl. Raya Jatiwangi No. 88, Majalengka,\nJawa Barat, Indonesia 45454',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat, color: Colors.white, size: 20),
                  label: const Text('WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.mail, size: 20),
                  label: const Text('Email Kami'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.facebook),
              const SizedBox(width: 12),
              _buildSocialButton(Icons.camera_alt),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          const Text(
            '© 2023 Gentengforyou. All rights reserved.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  static Widget _buildSocialButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: () {},
      ),
    );
  }
}
