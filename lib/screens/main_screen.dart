import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../data/constants.dart';
import 'home_screen.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';
import 'about_screen.dart';
import 'detail_screen.dart';
import '../widgets/sidebar.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<CartItem> _cartItems = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _cartItems = [
      CartItem(product: mockProducts[0], quantity: 1000, selected: true),
      CartItem(product: mockProducts[5], quantity: 500, selected: true),
    ];
  }

  void _onProductClick(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          product: product,
          onAddToCart: _addToCart,
        ),
      ),
    );
  }

  void _addToCart(Product product) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
      if (existingIndex != -1) {
        _cartItems[existingIndex].quantity += 50;
      } else {
        _cartItems.add(CartItem(product: product, quantity: 50, selected: true));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil ditambahkan ke keranjang')),
    );
  }

  void _updateCartQuantity(int productId, int delta) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        _cartItems[index].quantity = (_cartItems[index].quantity + delta).clamp(0, 999999);
      }
    });
  }

  void _removeCartItem(int productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    
    final screens = [
      HomeScreen(
        onProductClick: _onProductClick,
        onMenuClick: () => _scaffoldKey.currentState?.openDrawer(),
        onNavigate: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
      ),
      CatalogScreen(
        onProductClick: _onProductClick,
        onNavigate: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
      ),
      CartScreen(
        items: _cartItems,
        onUpdateQuantity: _updateCartQuantity,
        onRemove: _removeCartItem,
        onNavigate: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
      ),
      AboutScreen(
        onNavigate: (index) => setState(() => _currentIndex = index),
        currentIndex: _currentIndex,
      ),
    ];

    // Desktop Layout - Full width, hide bottom nav
    if (isDesktop) {
      return Scaffold(
        key: _scaffoldKey,
        body: screens[_currentIndex],
      );
    }

    // Mobile Layout - Show bottom nav
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(
        user: widget.user,
        onNavigate: (index) {
          setState(() => _currentIndex = index);
          Navigator.pop(context);
        },
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFD1603D),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: _cartItems.isNotEmpty,
              label: Text('${_cartItems.length}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: _cartItems.isNotEmpty,
              label: Text('${_cartItems.length}'),
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Tentang',
          ),
        ],
      ),
    );
  }
}
