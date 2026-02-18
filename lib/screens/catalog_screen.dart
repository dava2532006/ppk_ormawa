import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Pastikan package ini ada
import '../models/product.dart';
import '../utils/theme.dart';

class CatalogScreen extends StatefulWidget {
  final Function(Product) onProductClick;
  final Function(int)? onNavigate; // Tidak dipakai sementara
  final int currentIndex;

  const CatalogScreen({
    super.key,
    required this.onProductClick,
    this.onNavigate,
    this.currentIndex = 1,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedCategory = "Semua";
  String _sortBy = "Ketersediaan";

  // Stream dari Supabase
  final _productsStream = Supabase.instance.client
      .from('products')
      .stream(primaryKey: ['id']).order('created_at', ascending: false);

  String _formatCurrency(int price) {
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(price);
  }

  // Logika Filter & Sorting
  List<Product> _processProducts(List<Product> allProducts) {
    // 1. Filter Kategori
    List<Product> filtered = _selectedCategory == "Semua"
        ? allProducts
        : allProducts.where((p) => p.category == _selectedCategory).toList();

    // 2. Sorting
    if (_sortBy == "Ketersediaan") {
      filtered.sort((a, b) {
        if (a.inStock && !b.inStock) return -1;
        if (!a.inStock && b.inStock) return 1;
        return a.name.compareTo(b.name);
      });
    } else if (_sortBy == "Harga Terendah") {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == "Harga Tertinggi") {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: Column(
        children: [
          // BAGIAN NAVIGASI DESKTOP DIHAPUS BIAR TIDAK ERROR

          // Header & Filter Area
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Katalog Produk",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const Spacer(),

                    // Dropdown Sorting
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          icon: const Icon(Icons.sort, size: 16),
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textMain),
                          items: [
                            "Ketersediaan",
                            "Harga Terendah",
                            "Harga Tertinggi"
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _sortBy = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filter Kategori (Chips)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        ["Semua", "Genteng", "Bata", "Aksesoris", "Lainnya"]
                            .map((category) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(category),
                                    selected: _selectedCategory == category,
                                    onSelected: (selected) {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    },
                                    selectedColor:
                                        AppTheme.primary.withOpacity(0.1),
                                    checkmarkColor: AppTheme.primary,
                                    labelStyle: TextStyle(
                                      color: _selectedCategory == category
                                          ? AppTheme.primary
                                          : Colors.grey.shade600,
                                      fontWeight: _selectedCategory == category
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: _selectedCategory == category
                                            ? AppTheme.primary
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    showCheckmark: false,
                                  ),
                                ))
                            .toList(),
                  ),
                ),
              ],
            ),
          ),

          // LIST PRODUK (STREAM BUILDER)
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _productsStream,
              builder: (context, snapshot) {
                // 1. Loading State
                if (!snapshot.hasData) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: AppTheme.primary));
                }

                // 2. Data Processing
                final rawData = snapshot.data!;

                // Ubah JSON Supabase -> Object Product -> Lalu Filter
                final allProducts =
                    rawData.map((e) => Product.fromJson(e)).toList();
                final displayProducts = _processProducts(allProducts);

                // 3. Empty State
                if (displayProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          "Produk tidak ditemukan",
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                // 4. Grid View
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70, // Rasio kartu
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: displayProducts.length,
                  itemBuilder: (context, index) {
                    final product = displayProducts[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Produk
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => widget.onProductClick(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: product.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      // Placeholder saat loading
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                            child: Icon(Icons.image, color: Colors.grey)),
                      ),
                      // Widget error jika gambar gagal
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                            child:
                                Icon(Icons.broken_image, color: Colors.grey)),
                      ),
                    ),
                  ),
                  // Badge Stok Habis
                  if (!product.inStock)
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      child: const Center(
                        child: Text(
                          "STOK HABIS",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info Produk
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori kecil
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.primary.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Nama Produk
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMain,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Harga
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          _formatCurrency(product.price),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: product.inStock
                                ? AppTheme.primary
                                : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Icon Keranjang Kecil
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: product.inStock
                              ? AppTheme.primary.withOpacity(0.1)
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 14,
                          color:
                              product.inStock ? AppTheme.primary : Colors.grey,
                        ),
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
}
