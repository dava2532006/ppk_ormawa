import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../utils/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/desktop_navbar.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> items;
  final Function(int, int) onUpdateQuantity;
  final Function(int) onRemove;
  final Function(int)? onNavigate;
  final int currentIndex;

  const CartScreen({
    super.key,
    required this.items,
    required this.onUpdateQuantity,
    required this.onRemove,
    this.onNavigate,
    this.currentIndex = 2,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _items;
  final Map<int, TextEditingController> _quantityControllers = {};

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    for (var item in _items) {
      _quantityControllers[item.product.id] = TextEditingController(
        text: item.quantity.toString(),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleSelection(int productId) {
    setState(() {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        _items[index] = CartItem(
          product: _items[index].product,
          quantity: _items[index].quantity,
          selected: !_items[index].selected,
        );
      }
    });
  }

  void _updateQuantity(int productId, int delta) {
    setState(() {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        final newQuantity = (_items[index].quantity + delta).clamp(1, 999999);
        _items[index] = CartItem(
          product: _items[index].product,
          quantity: newQuantity,
          selected: _items[index].selected,
        );
        _quantityControllers[productId]?.text = newQuantity.toString();
        widget.onUpdateQuantity(productId, delta);
      }
    });
  }

  void _setQuantityFromText(int productId, String text) {
    final newQuantity = int.tryParse(text) ?? 1;
    if (newQuantity < 1) return;
    
    setState(() {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        final delta = newQuantity - _items[index].quantity;
        _items[index] = CartItem(
          product: _items[index].product,
          quantity: newQuantity,
          selected: _items[index].selected,
        );
        widget.onUpdateQuantity(productId, delta);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    final selectedItems = _items.where((item) => item.selected).toList();
    final subtotal = selectedItems.fold<int>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    final totalItems = selectedItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    if (isDesktop) {
      return _buildDesktopLayout(selectedItems, subtotal, totalItems);
    }

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('Keranjang'),
        centerTitle: true,
        backgroundColor: AppTheme.bgLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'Keranjang belanja Anda kosong',
                    style: TextStyle(color: AppTheme.textSec),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return _buildMobileCartItem(item);
                          },
                        ),
                        if (selectedItems.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildSummary(subtotal, totalItems),
                        ],
                      ],
                    ),
                  ),
                ),
                if (selectedItems.isNotEmpty) _buildBottomAction(subtotal),
              ],
            ),
    );
  }

  Widget _buildDesktopLayout(List<CartItem> selectedItems, int subtotal, int totalItems) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: Column(
        children: [
          if (widget.onNavigate != null)
            DesktopNavbar(
              currentIndex: widget.currentIndex,
              onNavigate: widget.onNavigate!,
            ),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(40),
                child: _items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text(
                              'Keranjang belanja Anda kosong',
                              style: TextStyle(color: AppTheme.textSec),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left - Cart Items
                          Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Keranjang Belanja',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_items.length} Barang Terpilih',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          final allSelected = _items.every((item) => item.selected);
                                          for (var i = 0; i < _items.length; i++) {
                                            _items[i] = CartItem(
                                              product: _items[i].product,
                                              quantity: _items[i].quantity,
                                              selected: !allSelected,
                                            );
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        _items.every((item) => item.selected)
                                            ? Icons.check_circle
                                            : Icons.check_circle_outline,
                                        color: AppTheme.primary,
                                      ),
                                      label: Text(
                                        _items.every((item) => item.selected) ? 'Hapus Semua' : 'Pilih Semua',
                                        style: const TextStyle(
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _items.length,
                                    itemBuilder: (context, index) {
                                      final item = _items[index];
                                      return _buildCartItem(item, true);
                                    },
                                  ),
                                ),
                                if (_items.isEmpty)
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 120,
                                            color: Colors.grey.shade300,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Lanjutkan belanja untuk melihat lebih banyak produk',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 32),
                          // Right - Summary
                          SizedBox(
                            width: 380,
                            child: Column(
                              children: [
                                _buildDesktopSummary(subtotal, totalItems, selectedItems),
                              ],
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

  Widget _buildMobileCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.selected ? AppTheme.primary.withOpacity(0.3) : Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: item.selected,
                onChanged: (value) => _toggleSelection(item.product.id),
                activeColor: AppTheme.primary,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.product.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey.shade100),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.product.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => widget.onRemove(item.product.id),
                          color: AppTheme.textSec,
                        ),
                      ],
                    ),
                    Text(
                      'Rp ${item.product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} / pcs',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Subtotal: Rp ${(item.product.price * item.quantity).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.bgLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    _buildMobileQuantityButton(
                      Icons.remove,
                      () => _updateQuantity(item.product.id, -1),
                      item.quantity <= 1,
                    ),
                    Container(
                      width: 70,
                      height: 32,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _quantityControllers[item.product.id],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onSubmitted: (value) => _setQuantityFromText(item.product.id, value),
                      ),
                    ),
                    _buildMobileQuantityButton(
                      Icons.add,
                      () => _updateQuantity(item.product.id, 1),
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileQuantityButton(IconData icon, VoidCallback onPressed, bool disabled) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: disabled ? Colors.grey.shade100 : (icon == Icons.add ? AppTheme.primary : Colors.white),
        borderRadius: BorderRadius.circular(8),
        boxShadow: disabled
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                ),
              ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: disabled ? null : onPressed,
        color: icon == Icons.add ? Colors.white : AppTheme.textMain,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCartItem(CartItem item, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.selected ? AppTheme.primary.withOpacity(0.3) : Colors.grey.shade200,
          width: item.selected ? 2 : 1,
        ),
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
          Checkbox(
            value: item.selected,
            onChanged: (value) => _toggleSelection(item.product.id),
            activeColor: AppTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: item.product.image,
              width: isDesktop ? 100 : 80,
              height: isDesktop ? 100 : 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey.shade100),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${item.product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} / pcs',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'SUBTOTAL ITEM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${(item.product.price * item.quantity).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => widget.onRemove(item.product.id),
                color: Colors.grey.shade400,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildQuantityButton(
                      Icons.remove,
                      () => _updateQuantity(item.product.id, -1),
                      item.quantity <= 1,
                    ),
                    Container(
                      width: 60,
                      height: 36,
                      alignment: Alignment.center,
                      child: TextField(
                        controller: _quantityControllers[item.product.id],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        onSubmitted: (value) => _setQuantityFromText(item.product.id, value),
                      ),
                    ),
                    _buildQuantityButton(
                      Icons.add,
                      () => _updateQuantity(item.product.id, 1),
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed, bool disabled) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: disabled
            ? Colors.grey.shade100
            : (icon == Icons.add ? AppTheme.primary : Colors.white),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: disabled ? null : onPressed,
        color: icon == Icons.add ? Colors.white : (disabled ? Colors.grey.shade400 : AppTheme.textMain),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDesktopSummary(int subtotal, int totalItems, List<CartItem> selectedItems) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Belanja',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 24),
          _buildSummaryRow('Total Barang', '$totalItems pcs'),
          const SizedBox(height: 12),
          _buildSummaryRow('Estimasi Berat', '~${(totalItems * 2.5).toStringAsFixed(0)} kg'),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              Text(
                'Rp ${subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Belum termasuk ongkir. Ongkir akan dihitung oleh\nkami melalui WhatsApp berdasarkan lokasi pengiriman.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: selectedItems.isEmpty ? null : () {},
              icon: const Icon(Icons.chat, color: Colors.white),
              label: const Text(
                'Pesan via WhatsApp',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedItems.isEmpty ? Colors.grey.shade300 : AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Info Pengiriman',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pengiriman genteng menggunakan armada khusus untuk menjamin keamanan produk sampai lokasi.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textMain,
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(int subtotal, int totalItems) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Belanja',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Barang', style: TextStyle(color: AppTheme.textSec)),
              Text(
                '$totalItems pcs',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimasi Berat', style: TextStyle(color: AppTheme.textSec)),
              Text(
                '~${(totalItems * 2.5).toStringAsFixed(0)} kg',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              Text(
                'Rp ${subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(int subtotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pembayaran',
                      style: TextStyle(fontSize: 11, color: AppTheme.textSec),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text('Lihat Detail', style: TextStyle(fontSize: 11)),
                      Icon(Icons.keyboard_arrow_up, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Rp ${subtotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat),
                label: const Text(
                  'Pesan Semua via WhatsApp',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
