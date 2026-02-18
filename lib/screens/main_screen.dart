import 'dart:async'; // Untuk StreamSubscription
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/product.dart';
import '../utils/theme.dart';
import 'catalog_screen.dart';
import 'detail_screen.dart';
import 'cart_screen.dart'; // Pastikan ada atau buat dummy jika belum
import 'login_screen.dart';
import 'profile_screen.dart'; // Jika ada

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  User? _currentUser;
  late final StreamSubscription<AuthState> _authSubscription;

  // Keranjang Belanja (Lokal State)
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();

    // 1. Cek User saat ini
    _currentUser = Supabase.instance.client.auth.currentUser;

    // 2. PASANG PENDENGAR (LISTENER) STATUS LOGIN
    // Ini solusi agar saat login/logout, tampilan langsung berubah otomatis
    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _currentUser = data.session?.user;
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel(); // Wajib dimatikan biar gak memori leak
    super.dispose();
  }

  // --- LOGIKA KERANJANG ---
  void _addToCart(Product product, int quantity) {
    setState(() {
      final index =
          _cartItems.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(product: product, quantity: quantity));
      }
    });
  }

  // --- LOGIKA NAVIGASI ---
  void _onNavigate(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _goToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          product: product,
          onAddToCart: (p, q) => _addToCart(p, q),
        ),
      ),
    );
  }

  // Format Rupiah Helper
  String _formatCurrency(int price) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(price);
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan Body berdasarkan Tab yang dipilih
    Widget bodyContent;
    switch (_currentIndex) {
      case 0:
        bodyContent = _buildHomePage(); // Home pakai Data Supabase
        break;
      case 1:
        bodyContent = CatalogScreen(
          onProductClick: _goToDetail,
          currentIndex: 1,
        );
        break;
      case 2:
        // Cek Login dulu kalau mau buka Cart
        if (_currentUser == null) {
          bodyContent = const LoginScreen(); // Atau widget info "Harap Login"
        } else {
          // Ganti dengan CartScreen aslimu jika ada
          bodyContent = Center(
              child: Text("Halaman Keranjang (${_cartItems.length} items)"));
        }
        break;
      case 3:
        bodyContent = _currentUser == null
            ? const LoginScreen()
            : const Center(
                child: Text("Halaman Profil")); // Ganti ProfileScreen
        break;
      default:
        bodyContent = _buildHomePage();
    }

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      // Hapus AppBar di MainScreen agar tiap tab punya AppBar sendiri (opsional)
      // atau gunakan AppBar conditional. Di sini saya hilangkan agar clean.

      body: bodyContent,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigate,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Beranda'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Katalog'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: _cartItems.isNotEmpty,
              label: Text('${_cartItems.length}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(_currentUser == null ? Icons.login : Icons.person),
            label: _currentUser == null ? 'Masuk' : 'Akun',
          ),
        ],
      ),
    );
  }

  // --- HALAMAN HOME (BERANDA) ---
  Widget _buildHomePage() {
    // Stream untuk mengambil 5 produk terbaru (Bukan Dummy Lagi!)
    final recentProductsStream = Supabase.instance.client
        .from('products')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(5);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Banner Sederhana
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: const BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, ${_currentUser?.email?.split('@')[0] ?? 'Tamu'}",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Cari Kebutuhan\nBangunanmu?",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section Judul
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Produk Terbaru",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => _onNavigate(1), // Pindah ke Katalog
                  child: const Text("Lihat Semua"),
                )
              ],
            ),
          ),

          // Horizontal List Produk (Dari Supabase)
          SizedBox(
            height: 240,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: recentProductsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final products =
                    snapshot.data!.map((e) => Product.fromJson(e)).toList();

                if (products.isEmpty)
                  return const Center(child: Text("Belum ada produk."));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () => _goToDetail(product),
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200, blurRadius: 5)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: CachedNetworkImage(
                                imageUrl: product.image,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey.shade100),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                            // Teks
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatCurrency(product.price),
                                    style: const TextStyle(
                                        color: AppTheme.primary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Banner Promo Statis (Pemanis)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_shipping,
                    size: 40, color: Colors.orange),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Gratis Ongkir se-Jawa Barat\nMin. Pembelian 1000 pcs",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
