import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/desktop_navbar.dart';
import '../widgets/footer.dart';
import '../models/user.dart';

class AboutScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  final int currentIndex;
  final User? user;
  final VoidCallback? onLogin;

  const AboutScreen({
    super.key,
    this.onNavigate,
    this.currentIndex = 3,
    this.user,
    this.onLogin,
  });

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showHero = false;
  bool _showSpotlight = false;
  bool _showTestimonials = false;
  bool _showCommitment = false;
  bool _showCTA = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showHero = true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    
    if (scrollPosition > 100 && !_showSpotlight) {
      setState(() => _showSpotlight = true);
    }
    if (scrollPosition > 400 && !_showTestimonials) {
      setState(() => _showTestimonials = true);
    }
    if (scrollPosition > 800 && !_showCommitment) {
      setState(() => _showCommitment = true);
    }
    if (scrollPosition > 1200 && !_showCTA) {
      setState(() => _showCTA = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: !isDesktop ? AppBar(
        title: const Text('Our Story'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textMain,
        elevation: 0,
      ) : null,
      body: Stack(
        children: [
          // Main Content with Scroll
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Add spacing for navbar on desktop
                if (isDesktop) const SizedBox(height: 80),
                _buildHeroSection(isDesktop),
                _buildSpotlightSection(isDesktop),
                _buildTestimonialsSection(isDesktop),
                _buildCommitmentSection(isDesktop),
                _buildCTASection(isDesktop),
                const Footer(),
              ],
            ),
          ),
          // Navbar on top for desktop only
          if (isDesktop && widget.onNavigate != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: DesktopNavbar(
                currentIndex: widget.currentIndex,
                onNavigate: widget.onNavigate!,
                user: widget.user,
                onLogin: widget.onLogin,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(bool isDesktop) {
    return AnimatedOpacity(
      opacity: _showHero ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: AnimatedSlide(
        offset: _showHero ? Offset.zero : const Offset(0, 0.2),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        child: SizedBox(
          height: isDesktop ? 650 : 500,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  'https://picsum.photos/1400/700?random=1',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primary.withOpacity(0.1),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: isDesktop ? 0 : 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'YOUR VISION, OUR MISSION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Protecting What',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 56 : 36,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Matters Most.',
                        style: TextStyle(
                          color: const Color(0xFFFFEDD5),
                          fontSize: isDesktop ? 56 : 36,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'At GentengForYou, we don\'t just sell tiles; we provide the peace of mind that comes with a beautiful, durable roof over your head.',
                        style: TextStyle(
                          color: const Color(0xFFFFF7ED).withOpacity(0.9),
                          fontSize: isDesktop ? 18 : 16,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite),
                            label: const Text('View Success Stories'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withOpacity(0.3)),
                              backgroundColor: Colors.white.withOpacity(0.1),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Meet Our Artisans'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpotlightSection(bool isDesktop) {
    return AnimatedOpacity(
      opacity: _showSpotlight ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: AnimatedSlide(
        offset: _showSpotlight ? Offset.zero : const Offset(0, 0.2),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 80 : 24,
            vertical: isDesktop ? 96 : 48,
          ),
          color: Colors.white,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildSpotlightImage()),
                        const SizedBox(width: 64),
                        Expanded(child: _buildSpotlightContent()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildSpotlightImage(),
                        const SizedBox(height: 32),
                        _buildSpotlightContent(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpotlightImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.network(
            'https://picsum.photos/600/500?random=2',
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -24,
          right: -24,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFEDD5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(Icons.star, color: AppTheme.primary, size: 16),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '"GentengForYou turned our renovation nightmare into a dream. The personalized advice made all the difference!"',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF475569),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '— BUDI SANTOSO, HOMEOWNER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpotlightContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 1,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 12),
            const Text(
              'PROJECT SPOTLIGHT',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Personalized Care for Every Square Meter',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'When we met the Santoso family, they needed more than just materials. They needed a solution that would preserve their 50-year-old heritage home while providing modern insulation.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF475569),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Our specialists worked hand-in-hand with them, selecting our signature Terracotta range that matched the original aesthetic but offered 3x the weather resistance.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF475569),
            height: 1.8,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'CUSTOM TAILORED',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '24/7',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'EXPERT SUPPORT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTestimonialsSection(bool isDesktop) {
    return AnimatedOpacity(
      opacity: _showTestimonials ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: AnimatedSlide(
        offset: _showTestimonials ? Offset.zero : const Offset(0, 0.2),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 80 : 24,
            vertical: isDesktop ? 96 : 48,
          ),
          color: Colors.grey.shade50,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  const Text(
                    'Voices of Satisfaction',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '"Real stories from real homeowners who found their perfect \'crown\' with GentengForYou."',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF475569),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isDesktop ? 3 : 1,
                    childAspectRatio: isDesktop ? 0.85 : 1.1,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    children: [
                      _buildTestimonialCard(
                        'RD',
                        'Rina Dwi',
                        'Architect',
                        'The delivery was incredibly fast, and the staff helped me calculate exactly how many tiles I needed. Saved me thousands!',
                        0,
                      ),
                      _buildTestimonialCard(
                        'AW',
                        'Agus Wijaya',
                        'Villa Owner',
                        'I was worried about the weather resistance in our coastal area. The team recommended the Slate series and it has been flawless for two seasons now.',
                        200,
                        isHighlighted: true,
                      ),
                      _buildTestimonialCard(
                        'ST',
                        'Sari T.',
                        'Interior Designer',
                        'Modern, professional, and very helpful. The digital gallery really helped me visualize the final result before buying.',
                        400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(
    String initials,
    String name,
    String role,
    String testimonial,
    int delay, {
    bool isHighlighted = false,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: _showTestimonials ? 1 : 0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: isHighlighted ? 1.0 : 0.9 + (0.1 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFFEDD5)),
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              size: 48,
              color: AppTheme.primary.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Text(
                testimonial,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentSection(bool isDesktop) {
    return AnimatedOpacity(
      opacity: _showCommitment ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: AnimatedSlide(
        offset: _showCommitment ? Offset.zero : const Offset(0, 0.2),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 80 : 24,
            vertical: isDesktop ? 96 : 48,
          ),
          color: const Color(0xFF0F172A),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildCommitmentContent()),
                        const SizedBox(width: 80),
                        Expanded(child: _buildCommitmentImage()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildCommitmentContent(),
                        const SizedBox(height: 40),
                        _buildCommitmentImage(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommitmentContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Our Customer-Centric Commitment',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'We built our business around your needs, not just our products. These are the three pillars that ensure your success.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 40),
        _buildCommitmentItem(
          Icons.handshake,
          'Lifetime Partnership',
          'We\'re with you from the initial consultation to long after the last tile is laid. Our warranties mean something.',
        ),
        const SizedBox(height: 32),
        _buildCommitmentItem(
          Icons.psychology,
          'Personalized Design Advice',
          'Not sure what fits? Our experts analyze your architecture to provide recommendations that enhance both value and beauty.',
        ),
        const SizedBox(height: 32),
        _buildCommitmentItem(
          Icons.verified_user,
          'Transparent Quality',
          'No hidden fees or subpar batches. Every tile that leaves our warehouse is inspected for your family\'s safety.',
        ),
      ],
    );
  }

  Widget _buildCommitmentItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommitmentImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Image.network(
            'https://picsum.photos/600/500?random=3',
            width: double.infinity,
            height: 500,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: 500,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primary.withOpacity(0.2),
                  AppTheme.primary.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(bool isDesktop) {
    return AnimatedOpacity(
      opacity: _showCTA ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: AnimatedSlide(
        offset: _showCTA ? Offset.zero : const Offset(0, 0.3),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: _showCTA ? 1 : 0),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: child,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: isDesktop ? 96 : 48,
            ),
            color: Colors.white,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.all(isDesktop ? 64 : 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary,
                      Color(0xFFEA580C),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Start Your Story Today',
                      style: TextStyle(
                        fontSize: isDesktop ? 40 : 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Join thousands of happy homeowners. Whether it\'s a small repair or a full renovation, we\'re here to help you build a legacy.',
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 16,
                        color: const Color(0xFFFFF7ED).withOpacity(0.9),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: _showCTA ? 1 : 0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, double value, child) {
                            return Transform.translate(
                              offset: Offset(-50 * (1 - value), 0),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppTheme.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 8,
                            ),
                            child: const Text(
                              'Free Consultation',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: _showCTA ? 1 : 0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, double value, child) {
                            return Transform.translate(
                              offset: Offset(50 * (1 - value), 0),
                              child: Opacity(
                                opacity: value,
                                child: child,
                              ),
                            );
                          },
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white, width: 2),
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Browse Tiles',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
