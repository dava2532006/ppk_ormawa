import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Tambahkan intl
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import '../utils/theme.dart';
import 'login_screen.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  // Kita update sedikit: menerima quantity juga agar sesuai input user
  final Function(Product, int) onAddToCart;

  const DetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  int _selectedImageIndex = 0;
  final PageController _pageController = PageController();
  late TextEditingController _quantityController;

  late final List<String> _productImages;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: _quantity.toString());

    // Setup Gambar:
    // Gambar 1: Asli dari Supabase
    // Gambar 2 & 3: Dummy (hanya pemanis visual, bisa dihapus kalau mau)
    _productImages = [
      widget.product.image,
      'https://picsum.photos/800/800?random=1', // Placeholder gallery
      'https://picsum.photos/800/800?random=2', // Placeholder gallery
    ];
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // --- LOGIKA STOK & INPUT ---

  void _incrementQuantity() {
    // Cek Stok Asli dari Database
    if (_quantity < widget.product.realStock) {
      setState(() {
        _quantity++;
        _quantityController.text = _quantity.toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok hanya tersedia ${widget.product.realStock} pcs'),
          backgroundColor: Colors.orange,
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = _quantity.toString();
      });
    }
  }

  // Format Rupiah
  String _formatCurrency(int price) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(price);
  }

  // Logika "Satpam" (Cek Login sebelum masuk Keranjang)
  void _handleAddToCart() {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      // Jika belum login, lempar ke Login Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // Jika sudah login, cek stok lagi
      if (widget.product.realStock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maaf, stok barang ini habis.')),
        );
        return;
      }

      // Jalankan fungsi tambah ke keranjang
      widget.onAddToCart(widget.product, _quantity);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil masuk keranjang!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
        ),
      );
      Navigator.pop(context); // Tutup Detail Screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    // Tampilan Mobile (Fokus Utama Kita)
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header & Gambar (Expanded agar scrollable area luas)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Navigasi (Tombol Back)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text("Detail Produk",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    // Gallery Gambar
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) =>
                            setState(() => _selectedImageIndex = index),
                        itemCount: _productImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: _productImages[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.grey.shade200),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Indikator Gambar (Titik-titik)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _productImages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedImageIndex == index
                                ? AppTheme.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info Produk
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kategori & Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  widget.product.category,
                                  style: const TextStyle(
                                      color: AppTheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${widget.product.rating} (${widget.product.sold} terjual)",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Nama Produk
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.2),
                          ),
                          const SizedBox(height: 8),

                          // Harga
                          Text(
                            _formatCurrency(widget.product.price),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary),
                          ),

                          // Stok Tersedia
                          const SizedBox(height: 4),
                          Text(
                            "Stok Tersedia: ${widget.product.realStock} pcs",
                            style: TextStyle(
                                color: widget.product.realStock > 0
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),

                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Deskripsi
                          const Text("Deskripsi",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            widget.product.description,
                            style: TextStyle(
                                color: Colors.grey.shade700, height: 1.5),
                          ),

                          const SizedBox(height: 24),

                          // Spesifikasi
                          const Text("Spesifikasi",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _buildMobileSpecItem(
                              "Berat", widget.product.specs.weight),
                          _buildMobileSpecItem(
                              "Kebutuhan", widget.product.specs.coverage),
                          _buildMobileSpecItem(
                              "Jarak Reng", widget.product.specs.spacing),
                          _buildMobileSpecItem(
                              "Garansi", widget.product.specs.warranty),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Bottom Action Bar (Fixed di Bawah)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  // Tombol Kurang (-)
                  InkWell(
                    onTap: _decrementQuantity,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.remove, size: 20),
                    ),
                  ),

                  // Angka Quantity
                  SizedBox(
                    width: 50,
                    child: Center(
                      child: Text(
                        "$_quantity",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // Tombol Tambah (+)
                  InkWell(
                    onTap: _incrementQuantity,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: _quantity >= widget.product.realStock
                            ? Colors.grey.shade100
                            : null,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: _quantity >= widget.product.realStock
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Tombol "Tambah ke Keranjang"
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.product.realStock > 0
                          ? _handleAddToCart
                          : null, // Disable jika stok 0
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.product.realStock > 0
                            ? AppTheme.primary
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        widget.product.realStock > 0
                            ? 'Tambah Keranjang'
                            : 'Stok Habis',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileSpecItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
