class Product {
  // --- FIELD UTAMA (Sesuai Database Supabase) ---
  final String id; // Tipe String (UUID)
  final String name; // Kolom: name
  final int price; // Kolom: price
  final String description; // Kolom: description
  final String category; // Kolom: category
  final String image; // Kolom: image_url (Di UI kita sebut 'image')
  final int realStock; // Kolom: stock (Di UI kita sebut 'realStock')

  // --- FIELD TAMBAHAN (Untuk Keperluan UI Temanmu) ---
  // Kita beri nilai default nanti karena belum ada di database
  final int? originalPrice;
  final double rating;
  final int sold;
  final String store;
  final String location;
  final ProductSpecs specs;
  final bool isPromo;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.sold,
    required this.image,
    required this.store,
    required this.location,
    required this.description,
    required this.specs,
    this.isPromo = false,
    this.inStock = true,
    required this.realStock,
  });

  // --- LOGIKA PENERJEMAH (Supabase JSON -> Object Product) ---
  factory Product.fromJson(Map<String, dynamic> json) {
    // Ambil stok untuk logika inStock
    final int stockFromDb = json['stock'] ?? 0;

    return Product(
      // 1. DATA DARI DATABASE (Wajib Ada)
      id: json['id'].toString(),
      name: json['name'] ?? 'Tanpa Nama',
      price: (json['price'] as num?)?.toInt() ?? 0, // Pastikan jadi int
      description: json['description'] ?? 'Tidak ada deskripsi.',
      category: json['category'] ?? 'Umum',
      image: json['image_url'] ??
          'https://via.placeholder.com/300', // Gambar default jika kosong
      realStock: stockFromDb,

      // 2. DATA UI (Diisi Default agar Error Hilang)
      originalPrice: null, // Bisa diisi logika diskon nanti
      rating: 4.8, // Rating palsu biar terlihat bagus
      sold: 0, // Belum ada data penjualan
      store: 'Jatiwangi Official',
      location: 'Majalengka, Jawa Barat',
      isPromo: false,
      inStock: stockFromDb > 0, // Jika stok > 0 maka true

      // Spesifikasi Dummy (Nanti bisa ditambah kolom JSON di DB jika mau)
      specs: ProductSpecs(
        weight: '2 kg',
        coverage: '12 pcs/m²',
        spacing: '30 cm',
        warranty: 'Garansi 10 Tahun',
      ),
    );
  }

  // --- LOGIKA UPLOAD (Object Product -> Supabase JSON) ---
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'stock': realStock,
      'description': description,
      'category': category,
      'image_url': image,
      // 'id' tidak dikirim karena dibuat otomatis oleh Database
    };
  }
}

// --- CLASS PENDUKUNG ---

class ProductSpecs {
  final String weight;
  final String coverage;
  final String spacing;
  final String warranty;

  ProductSpecs({
    required this.weight,
    required this.coverage,
    required this.spacing,
    required this.warranty,
  });
}

class CartItem {
  final Product product;
  int quantity;
  bool selected;

  CartItem({
    required this.product,
    required this.quantity,
    this.selected = true,
  });
}
