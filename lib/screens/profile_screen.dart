import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../data/constants.dart';
import '../utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final VoidCallback? onLogout;
  final Function(Product)? onProductClick;
  final Function(int)? onNavigate;

  const ProfileScreen({
    super.key,
    required this.user,
    this.onLogout,
    this.onProductClick,
    this.onNavigate,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedSection = 0; // 0: Profile, 1: Order History, 2: Addresses, 3: Wishlist, 4: Settings

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    if (isDesktop) {
      return _buildDesktopLayout(context);
    }

    return _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: Stack(
        children: [
          // Main content
          Row(
            children: [
              // Sidebar
              _buildSidebar(context),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 100, left: 48, right: 48, bottom: 48),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: _buildSelectedSection(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Desktop Navbar on top with blur effect
          if (widget.onNavigate != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.primary.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Logo
                        InkWell(
                          onTap: () {
                            if (widget.onNavigate != null) {
                              widget.onNavigate!(0); // Navigate to home
                            } else {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Row(
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
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(text: 'Genteng', style: TextStyle(color: AppTheme.primary)),
                                    TextSpan(text: 'ForYou', style: TextStyle(color: AppTheme.textMain)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Navigation Menu
                        _buildNavbarItem('Beranda', 0),
                        const SizedBox(width: 32),
                        _buildNavbarItem('Katalog Produk', 1),
                        const SizedBox(width: 32),
                        _buildNavbarItem('Keranjang Belanja', 2),
                        const SizedBox(width: 32),
                        _buildNavbarItem('Tentang Kami', 3),
                        const SizedBox(width: 40),
                        // Profile icon
                        InkWell(
                          onTap: () {}, // Already in profile
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.primary.withOpacity(0.3), width: 2),
                            ),
                            child: const Icon(Icons.person, color: AppTheme.primary, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavbarItem(String label, int index) {
    return TextButton(
      onPressed: () {
        if (widget.onNavigate != null) {
          // Pop profile screen first, then navigate
          widget.onNavigate!(index);
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textMain,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(_getSectionTitle()),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (widget.onNavigate != null) {
                widget.onNavigate!(0); // Back to home
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: _buildSidebar(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildSelectedSection(),
      ),
    );
  }

  String _getSectionTitle() {
    switch (_selectedSection) {
      case 0:
        return 'Profile';
      case 1:
        return 'Order History';
      case 2:
        return 'Addresses';
      case 3:
        return 'Wishlist';
      case 4:
        return 'Settings';
      default:
        return 'Profile';
    }
  }

  Widget _buildSelectedSection() {
    switch (_selectedSection) {
      case 0:
        return _buildProfileSection();
      case 1:
        return _buildOrderHistorySection();
      case 2:
        return _buildAddressesSection();
      case 3:
        return _buildWishlistSection();
      case 4:
        return _buildSettingsSection();
      default:
        return _buildProfileSection();
    }
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 288,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          right: BorderSide(color: AppTheme.primary.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.all(32),
            child: InkWell(
              onTap: () {
                if (widget.onNavigate != null) {
                  widget.onNavigate!(0); // Navigate to home
                } else {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              child: Row(
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
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Genteng', style: TextStyle(color: AppTheme.primary)),
                        TextSpan(text: 'ForYou', style: TextStyle(color: AppTheme.textMain)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigation
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildNavItem(context, Icons.person, 'Profile', 0),
                _buildNavItem(context, Icons.history, 'Order History', 1),
                _buildNavItem(context, Icons.location_on, 'Addresses', 2),
                _buildNavItem(context, Icons.favorite_border, 'Wishlist', 3),
                _buildNavItem(context, Icons.settings, 'Settings', 4),
              ],
            ),
          ),
          // Logout
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.primary.withOpacity(0.1)),
              ),
            ),
            child: TextButton.icon(
              onPressed: widget.onLogout,
              icon: const Icon(Icons.logout, color: Colors.grey),
              label: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isActive = _selectedSection == index;
    final isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive ? AppTheme.primary : null,
        hoverColor: AppTheme.primary.withOpacity(0.1),
        onTap: () {
          setState(() {
            _selectedSection = index;
          });
          // Close drawer on mobile after selection
          if (!isDesktop) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.all(32),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            const SizedBox(width: 24),
            Expanded(
              child: _buildUserInfo(),
            ),
            const SizedBox(width: 24),
            _buildEditButton(),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
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
        children: [
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 16),
              Expanded(child: _buildUserInfo()),
            ],
          ),
          const SizedBox(height: 16),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.primary.withOpacity(0.2), width: 4),
            image: const DecorationImage(
              image: NetworkImage('https://picsum.photos/200/200?random=user'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.edit, color: Colors.white, size: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.user.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.email, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                widget.user.email,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.phone, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            const Text(
              '+62 812-3456-7890',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return Builder(
      builder: (context) => ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur edit profile akan segera hadir'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.settings, size: 18),
        label: const Text('Edit Profile'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.grey.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildRecentlyViewed(BuildContext context, bool isDesktop) {
    final products = mockProducts.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recently Viewed & Saved',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('History cleared successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Clear History',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 3 : 1,
            childAspectRatio: isDesktop ? 0.85 : 1.2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(products[index]);
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        if (widget.onProductClick != null) {
          widget.onProductClick!(product);
        }
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey.shade100),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.favorite, color: AppTheme.primary, size: 18),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < product.rating.floor() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    })
                      ..add(const SizedBox(width: 4))
                      ..add(
                        Text(
                          '(${product.sold} reviews)',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                        ),
                      ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                          children: [
                            TextSpan(
                              text: 'Rp ${product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            ),
                            TextSpan(
                              text: ' /pcs',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shopping_cart, color: AppTheme.primary, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.05),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isDesktop
          ? Row(
              children: [
                _buildHelpInfo(),
                const Spacer(),
                _buildScheduleButton(),
              ],
            )
          : Column(
              children: [
                _buildHelpInfo(),
                const SizedBox(height: 16),
                _buildScheduleButton(),
              ],
            ),
    );
  }

  Widget _buildHelpInfo() {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.support_agent, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Need installation help?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our roofing experts are available for virtual consultations.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        'Schedule a Call',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  // Section implementations
  Widget _buildProfileSection() {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    return Column(
      children: [
        _buildProfileHeader(context, isDesktop),
        const SizedBox(height: 32),
        _buildRecentlyViewed(context, isDesktop),
        const SizedBox(height: 32),
        _buildHelpSection(context, isDesktop),
      ],
    );
  }

  Widget _buildOrderHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Riwayat Pesanan',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Lihat semua pesanan Anda',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 32),
        _buildOrderCard(
          'GT-88291',
          '1,200 Terracotta Clay Tiles',
          'Delivered',
          'October 15, 2023',
          Colors.green,
          Icons.check_circle,
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          'GT-88290',
          '800 Premium Spanish S-Tile',
          'In Transit',
          'October 10, 2023',
          AppTheme.primary,
          Icons.local_shipping,
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          'GT-88289',
          '500 Architectural Slate Gray',
          'Processing',
          'October 5, 2023',
          Colors.blue,
          Icons.hourglass_empty,
        ),
      ],
    );
  }

  Widget _buildOrderCard(String orderId, String items, String status, String date, Color statusColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ORDER #$orderId',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alamat Pengiriman',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kelola alamat pengiriman Anda',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
              color: AppTheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildAddressCard(
          'Rumah',
          'Jl. Raya Jatiwangi No. 123',
          'Jatiwangi, Majalengka',
          'Jawa Barat 45454',
          '+62 812-3456-7890',
          true,
        ),
        const SizedBox(height: 16),
        _buildAddressCard(
          'Kantor',
          'Jl. Sudirman No. 456',
          'Jakarta Pusat',
          'DKI Jakarta 10220',
          '+62 812-3456-7890',
          false,
        ),
      ],
    );
  }

  Widget _buildAddressCard(String label, String street, String city, String postal, String phone, bool isDefault) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? AppTheme.primary : AppTheme.primary.withOpacity(0.1),
          width: isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                  ),
                  if (isDefault) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Default',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {},
                    color: Colors.grey.shade600,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {},
                    color: Colors.red.shade400,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  street,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
                Text(
                  postal,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.phone, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                phone,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistSection() {
    final products = mockProducts.take(4).toList();
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wishlist Saya',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${products.length} produk tersimpan',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Hapus Semua'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 4 : 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildWishlistProductCard(products[index]);
          },
        ),
      ],
    );
  }

  Widget _buildWishlistProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        if (widget.onProductClick != null) {
          widget.onProductClick!(product);
        }
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey.shade100),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.favorite, color: Colors.red, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rp ${product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shopping_cart, color: AppTheme.primary, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
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
        _buildSettingsSection2(
          'Akun',
          [
            _buildSettingItem(Icons.person, 'Edit Profile', 'Ubah informasi profil Anda'),
            _buildSettingItem(Icons.lock, 'Ubah Password', 'Perbarui password akun Anda'),
            _buildSettingItem(Icons.email, 'Email Preferences', 'Kelola notifikasi email'),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsSection2(
          'Notifikasi',
          [
            _buildSwitchItem(Icons.notifications, 'Push Notifications', 'Terima notifikasi push', true),
            _buildSwitchItem(Icons.email, 'Email Notifications', 'Terima notifikasi email', true),
            _buildSwitchItem(Icons.sms, 'SMS Notifications', 'Terima notifikasi SMS', false),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsSection2(
          'Preferensi',
          [
            _buildSettingItem(Icons.language, 'Bahasa', 'Indonesia'),
            _buildSettingItem(Icons.palette, 'Tema', 'Light Mode'),
            _buildSettingItem(Icons.currency_exchange, 'Mata Uang', 'IDR (Rp)'),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsSection2(
          'Lainnya',
          [
            _buildSettingItem(Icons.help, 'Bantuan & Dukungan', 'Dapatkan bantuan'),
            _buildSettingItem(Icons.privacy_tip, 'Kebijakan Privasi', 'Baca kebijakan privasi'),
            _buildSettingItem(Icons.description, 'Syarat & Ketentuan', 'Baca syarat layanan'),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection2(String title, List<Widget> items) {
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
