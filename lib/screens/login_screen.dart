import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme.dart';
import '../models/user.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'main_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController =
      TextEditingController(text: 'customer@jatiwangi.com');
  final _passwordController = TextEditingController();
  final _identifierFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isIdentifierFocused = false;
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    if (isDesktop) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            Expanded(flex: 60, child: _buildHeroSection()),
            Expanded(flex: 40, child: _buildFormSection()),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildFormSection(),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCFvuCD29hA4jNUrQZJj4CsxND6mgHb8Q5hmXrhkMPDAJyUNmilPzm6HqSrdYEITe2V9rVGtYP7xI2jgE2obE1xVdVtep_tMJ8yb5FEGF8pejHWZRtnimINVRYLkieN76gD7N8-ywMq9z1YGpgOeHzXYFRxskQ4afAaWnF08ASGOrgYfmW7LZtmi5DGT4W4PY6tBWVhoMJ8GqLTDdaacseEEkzatsmTTk3yxYZ7H8catF_NuEnnLSD69NbZamvnSKDImjgiHSaFnSU',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 32,
          left: 32,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () => Navigator.pop(context),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 48,
          left: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 384),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.verified,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'JAMINAN KEASLIAN',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '100% PRODUK JATIWANGI ASLI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 48 : 32,
          vertical: isDesktop ? 32 : 48,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Icon(Icons.roofing, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            const Text(
              'Gentengforyou',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: isDesktop ? 28 : 40),
            Text(
              'Masuk',
              style: TextStyle(
                fontSize: isDesktop ? 32 : 36,
                fontWeight: FontWeight.w800,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kelola kebutuhan atap rumah Anda dengan mudah.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isDesktop ? 28 : 40),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                children: [
                  _buildFloatingInput(
                    controller: _identifierController,
                    focusNode: _identifierFocus,
                    label: 'Email atau No. Handphone',
                    isFocused: _isIdentifierFocused,
                  ),
                  const SizedBox(height: 20),
                  _buildFloatingInput(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    label: 'Kata Sandi',
                    isFocused: _isPasswordFocused,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v ?? false),
                              activeColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ingat Saya',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        // 1. Validasi Input Kosong
                        if (_identifierController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Email dan Password harus diisi!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // 2. Tampilkan Loading (Spinner)
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(
                                color: AppTheme.primary),
                          ),
                        );

                        try {
                          // 3. Panggil Backend Supabase
                          await AuthService().signIn(
                            _identifierController.text.trim(),
                            _passwordController.text,
                          );

                          // 4. Tutup Loading jika sukses
                          if (mounted) Navigator.pop(context);

                          // 5. Ambil Data User Asli & Pindah Halaman
                          if (mounted) {
                            final user = AuthService().getCurrentUser();

                            // Jika user null (aneh tapi mungkin terjadi), lempar error
                            if (user == null)
                              throw 'Gagal mengambil data user.';

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(user: user),
                              ),
                            );
                          }
                        } catch (e) {
                          // 6. Jika Error (Password salah / User tidak ada)
                          if (mounted)
                            Navigator.pop(context); // Tutup loading dulu

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Login Gagal: ${e.toString().replaceAll("Exception:", "")}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Masuk Ke Akun',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade100)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'ATAU',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              letterSpacing: 2),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade100)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.grey.shade200),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/google_icon.svg',
                                width: 18,
                                height: 18,
                              ),
                              const SizedBox(width: 8),
                              const Text('Google',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textMain)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Create guest user
                            final guestUser = User(
                              name: 'Guest',
                              email: 'guest@gentengforyou.com',
                              role: UserRole.guest,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MainScreen(user: guestUser),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.grey.shade200),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.account_circle_outlined,
                                  color: Colors.grey.shade400, size: 18),
                              const SizedBox(width: 8),
                              const Text('Tamu',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textMain)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: isDesktop ? 28 : 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun?',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500)),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? 32 : 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFooterLink('TERMS'),
                const SizedBox(width: 20),
                _buildFooterLink('PRIVACY'),
                const SizedBox(width: 20),
                _buildFooterLink('HELP'),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '© 2024 GENTENGFORYOU INDONESIA',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade300,
                  letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool isFocused,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final hasValue = controller.text.isNotEmpty;
    final shouldFloat = isFocused || hasValue;

    return Container(
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 20,
                right: suffixIcon != null ? 48 : 20,
                top: shouldFloat ? 20 : 16,
                bottom: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primary),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: suffixIcon,
            ),
          ),
          Positioned(
            left: shouldFloat ? 16 : 20,
            top: shouldFloat ? -8 : 18,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: Colors.white,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: shouldFloat ? 12 : 15,
                    color: shouldFloat && isFocused
                        ? AppTheme.primary
                        : Colors.grey.shade400,
                    fontWeight:
                        shouldFloat ? FontWeight.w500 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
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
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade400,
            letterSpacing: 2),
      ),
    );
  }
}
