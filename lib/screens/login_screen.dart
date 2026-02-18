import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/theme.dart';
import 'admin/admin_dashboard_screen.dart'; // Import Admin Dashboard

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController(); // Hapus dummy text
  final _passwordController = TextEditingController();

  final _identifierFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isIdentifierFocused = false;
  bool _isPasswordFocused = false;

  // State Loading Baru
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Listener Focus Node (Sesuai UI aslimu)
    _identifierFocus.addListener(() {
      setState(() => _isIdentifierFocused = _identifierFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _isPasswordFocused = _passwordFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _identifierFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // --- LOGIKA SUPABASE (BARU) ---
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final email = _identifierController.text.trim();
      final password = _passwordController.text.trim();

      // 1. Login ke Supabase
      final AuthResponse res =
          await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) throw const AuthException("Login Gagal");

      if (mounted) {
        // 2. Cek Role Admin (Sederhana)
        if (email.contains('admin')) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const AdminDashboardScreen()),
            (route) => false,
          );
        } else {
          // 3. User Biasa -> Tutup Login Screen (Balik ke Main/Detail)
          // Jika bisa di-pop (dibuka dari detail), pop. Jika tidak, diam saja (MainScreen auto update)
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Berhasil Masuk!"),
                backgroundColor: Colors.green),
          );
        }
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Login Gagal: ${e.message}"),
              backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Terjadi kesalahan koneksi"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // Background (Bisa dikembalikan kalau ada gambar aset)
          Container(color: Colors.white),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Header (Sesuai aslimu)
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.home_work,
                              size: 48, color: AppTheme.primary),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Selamat Datang",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMain),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Masuk untuk melanjutkan belanja",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Input Fields (Menggunakan Widget Custom Kamu di bawah)
                  _buildInputContainer(
                    label: "Email",
                    controller: _identifierController,
                    focusNode: _identifierFocus,
                    isFocused: _isIdentifierFocused,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  _buildInputContainer(
                    label: "Password",
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    isFocused: _isPasswordFocused,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  // Remember Me & Forgot Pass
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: AppTheme.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) =>
                                    setState(() => _rememberMe = val!),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text("Ingat Saya",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13)),
                          ],
                        ),
                        _buildFooterLink("Lupa Password?"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Masuk (Updated dengan Loading)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        shadowColor: AppTheme.primary.withOpacity(0.4),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Masuk Sekarang",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum punya akun? ",
                          style: TextStyle(color: Colors.grey.shade500)),
                      GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Fitur Register belum aktif")));
                          },
                          child: const Text("Daftar",
                              style: TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CUSTOM ORIGINAL KAMU ---
  Widget _buildInputContainer({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isFocused,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    bool shouldFloat = isFocused || controller.text.isNotEmpty;

    // UI Input Kerenmu Tetap Ada
    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isFocused ? AppTheme.primary : Colors.grey.shade200,
                width: isFocused ? 2 : 1,
              ),
              boxShadow: [
                if (isFocused)
                  BoxShadow(
                      color: AppTheme.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(prefixIcon,
                    color: isFocused ? AppTheme.primary : Colors.grey.shade400),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    obscureText: isPassword && _obscurePassword,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: AppTheme.textMain),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 8),
                    ),
                  ),
                ),
                if (isPassword)
                  IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
              ],
            ),
          ),
          Positioned(
            left: shouldFloat ? 48 : 48, // Adjusted position slightly
            top: shouldFloat ? 8 : 20,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: shouldFloat ? 10 : 14,
                color: isFocused ? AppTheme.primary : Colors.grey.shade400,
                fontWeight: shouldFloat ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero, minimumSize: Size.zero),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
            letterSpacing: 0.5),
      ),
    );
  }
}
