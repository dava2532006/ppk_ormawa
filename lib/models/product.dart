class Product {
  // PERUBAHAN 1: ID harus String karena Supabase pakai UUID
  final String id;
  final String name;
  final String category;
  final int price;
  final int? originalPrice;
  final double rating;
  final int sold;
  final String image;
  final String store;
  final String location;
  final String description;
  final ProductSpecs specs;
  final bool isPromo;
  final bool inStock;

  // Tambahan: Kita butuh data stok asli (angka) untuk logika admin
  final int realStock;

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
    this.realStock = 0, // Default 0
  });

  // --- JEMBATAN DARI SUPABASE KE UI (PENTING) ---
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // Konversi ID ke String
      id: json['id'].toString(),

      name: json['name'] ?? 'Tanpa Nama',
      category: json['category'] ?? 'Umum',

      // Pastikan harga jadi Integer
      price: (json['price'] as num?)?.toInt() ?? 0,

      // --- DATA DUMMY (Karena belum ada di Database) ---
      // Kita isi nilai default supaya UI temanmu tidak error
      originalPrice: null,
      rating: 4.8, // Nilai default biar terlihat bagus
      sold: 100, // Nilai default
      store: 'Jatiwangi Official',
      location: 'Majalengka',
      isPromo: false,

      // Ambil stok dari DB
      realStock: json['stock'] ?? 0,
      inStock: (json['stock'] ?? 0) > 0, // Jika stok > 0 berarti In Stock

      image: json['image_url'] ?? 'https://via.placeholder.com/300',
      description: json['description'] ?? 'Belum ada deskripsi.',

      // Default Specs (Nanti bisa kita tambah kolom JSON di DB)
      specs: ProductSpecs(
        weight: '2 kg',
        coverage: '12 pcs/m2',
        spacing: '30 cm',
        warranty: '10 Tahun',
      ),
    );
  }

  // --- JEMBATAN DARI UI KE SUPABASE (Untuk Upload) ---
  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // ID dibuat otomatis oleh Supabase
      'name': name,
      'description': description,
      'price': price,
      'stock': realStock, // Simpan stok asli
      'category': category,
      'image_url': image,
    };
  }
}

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
