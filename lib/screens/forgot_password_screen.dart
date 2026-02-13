import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  bool _isEmailFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      setState(() => _isEmailFocused = _emailFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
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
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
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
                      child: const Icon(Icons.lock_reset, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'RESET PASSWORD',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'KAMI AKAN KIRIM LINK RESET',
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
              'Lupa Kata Sandi',
              style: TextStyle(
                fontSize: isDesktop ? 32 : 36,
                fontWeight: FontWeight.w800,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masukkan email Anda dan kami akan mengirimkan link untuk reset kata sandi.',
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
                    controller: _emailController,
                    focusNode: _emailFocus,
                    label: 'Email',
                    isFocused: _isEmailFocused,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Link reset password telah dikirim ke email Anda'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Kirim Link Reset',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isDesktop ? 28 : 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah ingat kata sandi?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primary),
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
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.grey.shade300, letterSpacing: 2),
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
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 20,
                right: 20,
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
                    color: shouldFloat && isFocused ? AppTheme.primary : Colors.grey.shade400,
                    fontWeight: shouldFloat ? FontWeight.w500 : FontWeight.normal,
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
      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade400, letterSpacing: 2),
      ),
    );
  }
}
