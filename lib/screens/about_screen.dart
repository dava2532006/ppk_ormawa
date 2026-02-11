import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/desktop_navbar.dart';
import '../widgets/footer.dart';

class AboutScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  final int currentIndex;

  const AboutScreen({
    super.key,
    this.onNavigate,
    this.currentIndex = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: isDesktop ? null : AppBar(
        title: const Text('Tentang Kami'),
        centerTitle: true,
        backgroundColor: AppTheme.surface,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Desktop Navbar
            if (isDesktop && onNavigate != null)
              DesktopNavbar(
                currentIndex: currentIndex,
                onNavigate: onNavigate!,
              ),
            // Hero Image
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1000 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://picsum.photos/600/400?grayscale',
                          width: double.infinity,
                          height: isDesktop ? 300 : 200,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: double.infinity,
                          height: isDesktop ? 300 : 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'SEJAK 1998',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Melestarikan Warisan Nusantara',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isDesktop ? 28 : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Story
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1000 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 40 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cerita Kami',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Berawal dari semangat melestarikan warisan pengrajin tanah liat lokal di Jatiwangi, Gentengforyou hadir sebagai jembatan digital antara pembeli modern dan pengrajin genteng terbaik di nusantara.',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSec,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Kami memahami bahwa atap bukan sekadar pelindung rumah, melainkan mahkota yang memberikan karakter. Oleh karena itu, kami berkomitmen untuk menyajikan kualitas genteng tanah liat asli, langsung dari tangan para ahli.',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.textSec,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(height: 8, color: Colors.grey.shade50),
            // Advantages
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1000 : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 40 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified, color: AppTheme.primary),
                          SizedBox(width: 8),
                          Text(
                            'Keunggulan Kami',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildAdvantageCard(
                        Icons.diamond,
                        'Kualitas Premium',
                        'Tanah liat pilihan dengan pembakaran sempurna.',
                      ),
                      const SizedBox(height: 12),
                      _buildAdvantageCard(
                        Icons.local_shipping,
                        'Pengiriman Cepat',
                        'Armada logistik khusus aman dan tepat waktu.',
                      ),
                      const SizedBox(height: 12),
                      _buildAdvantageCard(
                        Icons.sell,
                        'Harga Pengrajin',
                        'Tangan pertama tanpa perantara berlebihan.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvantageCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSec,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
