import 'package:flutter/material.dart';
import '../utils/theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 80 : 40,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildBrandSection()),
                        const SizedBox(width: 60),
                        Expanded(child: _buildCollectionsSection()),
                        const SizedBox(width: 60),
                        Expanded(child: _buildExploreSection()),
                        const SizedBox(width: 60),
                        Expanded(child: _buildContactSection()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrandSection(),
                        const SizedBox(height: 32),
                        _buildCollectionsSection(),
                        const SizedBox(height: 32),
                        _buildExploreSection(),
                        const SizedBox(height: 32),
                        _buildContactSection(),
                      ],
                    ),
              const SizedBox(height: 48),
              const Divider(color: Color(0xFF1E293B), thickness: 1),
              const SizedBox(height: 24),
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '© 2024 GentengForYou. Handcrafted with care for your home.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Privacy First',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Terms of Care',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Text(
                          '© 2024 GentengForYou. Handcrafted with care for your home.',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Privacy First',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Terms of Care',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.home_work, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Text(
              'GENTENGFORYOU',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Dedicated to protecting homes and enhancing lives through superior roofing and unmatched customer care since 1994.',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _buildSocialIcon(Icons.facebook, () {}),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.camera_alt, () {}),
            const SizedBox(width: 12),
            _buildSocialIcon(Icons.alternate_email, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF64748B),
          size: 18,
        ),
      ),
    );
  }

  Widget _buildCollectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Collections',
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildFooterLink('Classic Clay'),
        const SizedBox(height: 12),
        _buildFooterLink('Modern Slate'),
        const SizedBox(height: 12),
        _buildFooterLink('Eco-Friendly Roofs'),
        const SizedBox(height: 12),
        _buildFooterLink('Accessories'),
      ],
    );
  }

  Widget _buildExploreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Explore',
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildFooterLink('Success Stories'),
        const SizedBox(height: 12),
        _buildFooterLink('Installation Guides'),
        const SizedBox(height: 12),
        _buildFooterLink('Career Opportunities'),
        const SizedBox(height: 12),
        _buildFooterLink('Our Philosophy'),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Get In Touch',
          style: TextStyle(
            color: AppTheme.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.phone,
              color: AppTheme.primary,
              size: 16,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '+62 812 3456 7890',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.email,
              color: AppTheme.primary,
              size: 16,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'hello@gentengforyou.com',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.place,
              color: AppTheme.primary,
              size: 16,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Customer Center, Suite 45\nJakarta, Indonesia',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}
