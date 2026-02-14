import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  final User user;
  final VoidCallback? onLogout;

  const SettingsScreen({
    super.key,
    required this.user,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kelola preferensi akun Anda',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                _buildSection(
                  'Akun',
                  [
                    _buildSettingItem(Icons.person, 'Edit Profile', 'Ubah informasi profil Anda'),
                    _buildSettingItem(Icons.lock, 'Ubah Password', 'Perbarui password akun Anda'),
                    _buildSettingItem(Icons.email, 'Email Preferences', 'Kelola notifikasi email'),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  'Notifikasi',
                  [
                    _buildSwitchItem(Icons.notifications, 'Push Notifications', 'Terima notifikasi push', true),
                    _buildSwitchItem(Icons.email, 'Email Notifications', 'Terima notifikasi email', true),
                    _buildSwitchItem(Icons.sms, 'SMS Notifications', 'Terima notifikasi SMS', false),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  'Preferensi',
                  [
                    _buildSettingItem(Icons.language, 'Bahasa', 'Indonesia'),
                    _buildSettingItem(Icons.palette, 'Tema', 'Light Mode'),
                    _buildSettingItem(Icons.currency_exchange, 'Mata Uang', 'IDR (Rp)'),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  'Lainnya',
                  [
                    _buildSettingItem(Icons.help, 'Bantuan & Dukungan', 'Dapatkan bantuan'),
                    _buildSettingItem(Icons.privacy_tip, 'Kebijakan Privasi', 'Baca kebijakan privasi'),
                    _buildSettingItem(Icons.description, 'Syarat & Ketentuan', 'Baca syarat layanan'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.textMain,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildSwitchItem(IconData icon, String title, String subtitle, bool value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.textMain,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing: Switch(
        value: value,
        onChanged: (val) {},
        activeColor: AppTheme.primary,
      ),
    );
  }
}
