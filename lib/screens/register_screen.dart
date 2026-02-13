import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  
  bool _isNameFocused = false;
  bool _isEmailFocused = false;
  bool _isPhoneFocused = false;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() => setState(() => _isNameFocused = _nameFocus.hasFocus));
    _emailFocus.addListener(() => setState(() => _isEmailFocused = _emailFocus.hasFocus));
    _phoneFocus.addListener(() => setState(() => _isPhoneFocused = _phoneFocus.hasFocus));
    _passwordFocus.addListener(() => setState(() => _isPasswordFocused = _passwordFocus.hasFocus));
    _confirmPasswordFocus.addListener(() => setState(() => _isConfirmPasswordFocused = _confirmPasswordFocus.hasFocus));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
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
                      child: const Icon(Icons.person_add, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'BERGABUNG SEKARANG',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'AKSES PENUH KE SEMUA FITUR',
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
          vertical: isDesktop ? 24 : 40,
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
            SizedBox(height: isDesktop ? 20 : 32),
            Text(
              'Daftar',
              style: TextStyle(
                fontSize: isDesktop ? 32 : 36,
                fontWeight: FontWeight.w800,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat akun untuk mulai berbelanja genteng berkualitas.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isDesktop ? 20 : 32),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                children: [
                  _buildFloatingInput(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    label: 'Nama Lengkap',
                    isFocused: _isNameFocused,
                  ),
                  const SizedBox(height: 16),
                  _buildFloatingInput(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    label: 'Email',
                    isFocused: _isEmailFocused,
                  ),
                  const SizedBox(height: 16),
                  _buildFloatingInput(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    label: 'No. Handphone',
                    isFocused: _isPhoneFocused,
                  ),
                  const SizedBox(height: 16),
                  _buildFloatingInput(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    label: 'Kata Sandi',
                    isFocused: _isPasswordFocused,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFloatingInput(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    label: 'Konfirmasi Kata Sandi',
                    isFocused: _isConfirmPasswordFocused,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: Colors.grey.shade400,
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: Checkbox(
                          value: _agreeToTerms,
                          onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
                          activeColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          children: [
                            Text(
                              'Saya setuju dengan ',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Syarat & Ketentuan',
                                style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              ' dan ',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Kebijakan Privasi',
                                style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _agreeToTerms ? () => Navigator.pop(context) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade100)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'ATAU',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 2),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade100)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
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
                        const Text('Daftar dengan Google', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isDesktop ? 20 : 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah punya akun?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
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
            SizedBox(height: isDesktop ? 24 : 40),
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
