import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/constants.dart';
import '../utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/desktop_navbar.dart';

class CatalogScreen extends StatefulWidget {
  final Function(Product) onProductClick;
  final Function(int)? onNavigate;
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
  String _sortBy = "Ketersediaan"; // Default sorting

  List<Product> get _filteredProducts {
    List<Product> products = _selectedCategory == "Semua"
        ? mockProducts
        : mockProducts.where((p) => p.category == _selectedCategory).toList();

    // Apply sorting
    if (_sortBy == "Ketersediaan") {
      products.sort((a, b) {
        // In stock items first
        if (a.inStock && !b.inStock) return -1;
        if (!a.inStock && b.inStock) return 1;
        // Then sort by name A-Z
        return a.name.compareTo(b.name);
      });
    } else if (_sortBy == "Nama A-Z") {
      products.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == "Nama Z-A") {
      products.sort((a, b) => b.name.compareTo(a.name));
    } else if (_sortBy == "Harga Terendah") {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == "Harga Tertinggi") {
      products.sort((a, b) => b.price.compareTo(a.price));
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: isDesktop ? null : AppBar(
        title: const Text('Katalog Produk'),
        centerTitle: true,
        backgroundColor: AppTheme.bgLight,
      ),
      body: Column(
        children: [
          // Desktop Navbar
          if (isDesktop && widget.onNavigate != null)
            DesktopNavbar(
              currentIndex: widget.currentIndex,
              onNavigate: widget.onNavigate!,
            ),
          // Content
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1200 : double.infinity,
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: EdgeInsets.all(isDesktop ? 24 : 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari genteng, atap...',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.grey.shade100),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(color: Colors.grey.shade100),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Sort Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            child: PopupMenuButton<String>(
                              initialValue: _sortBy,
                              onSelected: (value) {
                                setState(() => _sortBy = value);
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(12),
                                child: const Icon(Icons.tune, color: AppTheme.primary),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: "Ketersediaan",
                                  child: Row(
                                    children: [
                                      Icon(Icons.inventory_2, size: 18, color: AppTheme.primary),
                                      SizedBox(width: 12),
                                      Text("Ketersediaan"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: "Nama A-Z",
                                  child: Row(
                                    children: [
                                      Icon(Icons.sort_by_alpha, size: 18, color: AppTheme.primary),
                                      SizedBox(width: 12),
                                      Text("Nama A-Z"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: "Nama Z-A",
                                  child: Row(
                                    children: [
                                      Icon(Icons.sort_by_alpha, size: 18, color: AppTheme.primary),
                                      SizedBox(width: 12),
                                      Text("Nama Z-A"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: "Harga Terendah",
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_downward, size: 18, color: AppTheme.primary),
                                      SizedBox(width: 12),
                                      Text("Harga Terendah"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: "Harga Tertinggi",
                                  child: Row(
                                    children: [
                                      Icon(Icons.arrow_upward, size: 18, color: AppTheme.primary),
                                      SizedBox(width: 12),
                                      Text("Harga Tertinggi"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Category Filter
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24 : 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() => _selectedCategory = category);
                              },
                              backgroundColor: Colors.white,
                              selectedColor: AppTheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppTheme.textSec,
                                fontWeight: FontWeight.w600,
                              ),
                              side: BorderSide(
                                color: isSelected ? Colors.transparent : Colors.grey.shade200,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Product Grid
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.all(isDesktop ? 24 : 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return _buildProductCard(product);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => widget.onProductClick(product),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                      color: product.inStock ? null : Colors.grey,
                      colorBlendMode: product.inStock ? null : BlendMode.saturation,
                    ),
                  ),
                  if (!product.inStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'HABIS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (product.isPromo && product.inStock)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PROMO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 12),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: product.inStock ? AppTheme.textMain : Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.originalPrice != null)
                              Text(
                                'Rp ${product.originalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              'Rp ${product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: product.inStock ? AppTheme.textMain : Colors.grey,
                              ),
                            ),
                            const Text('/pcs', style: TextStyle(fontSize: 9, color: AppTheme.textSec)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 16,
                          color: product.inStock ? AppTheme.primary : Colors.grey,
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
