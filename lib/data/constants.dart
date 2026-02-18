import '../models/product.dart';

final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Genteng Morando Glazur',
    category: 'Genteng',
    price: 3500,
    originalPrice: 4000,
    rating: 4.8,
    sold: 1250,
    realStock: 500, // <--- TAMBAHAN BARU
    image: 'assets/images/genteng1.png', // Pastikan aset ada atau ganti URL
    store: 'Jatiwangi Official',
    location: 'Majalengka',
    description:
        'Genteng Morando Glazur asli Jatiwangi dengan kualitas pembakaran sempurna. Tahan lumut dan cuaca ekstrem.',
    specs: ProductSpecs(
      weight: '2.5 kg',
      coverage: '12 pcs/m²',
      spacing: '26 cm',
      warranty: '15 Tahun',
    ),
    isPromo: true,
  ),
  Product(
    id: '2',
    name: 'Bata Merah Ekspos',
    category: 'Bata',
    price: 1200,
    rating: 4.7,
    sold: 5000,
    realStock: 10000, // <--- TAMBAHAN BARU
    image: 'assets/images/bata1.png',
    store: 'TB. Sumber Rejeki',
    location: 'Cirebon',
    description:
        'Bata merah presisi untuk dinding ekspos tanpa plester. Memberikan kesan natural dan sejuk pada hunian.',
    specs: ProductSpecs(
      weight: '1.8 kg',
      coverage: '60 pcs/m²',
      spacing: '-',
      warranty: '-',
    ),
  ),
  Product(
    id: '3',
    name: 'Genteng Keramik Kia',
    category: 'Genteng',
    price: 9500,
    rating: 4.9,
    sold: 850,
    realStock: 200, // <--- TAMBAHAN BARU
    image: 'assets/images/genteng2.png',
    store: 'Jatiwangi Official',
    location: 'Majalengka',
    description:
        'Genteng keramik dengan lapisan glazur premium. Mewah, mengkilap, dan anti bocor.',
    specs: ProductSpecs(
      weight: '3.1 kg',
      coverage: '14 pcs/m²',
      spacing: '27 cm',
      warranty: '20 Tahun',
    ),
  ),
  Product(
    id: '4',
    name: 'Nok/Wuwung Bulat',
    category: 'Aksesoris',
    price: 15000,
    rating: 4.6,
    sold: 300,
    realStock: 50, // <--- TAMBAHAN BARU
    image: 'assets/images/nok.png',
    store: 'TB. Maju Jaya',
    location: 'Bandung',
    description: 'Aksesoris atap untuk bagian bubungan. Bentuk bulat estetis.',
    specs: ProductSpecs(
      weight: '3.0 kg',
      coverage: '3 pcs/m',
      spacing: '-',
      warranty: '10 Tahun',
    ),
    inStock: false, // Contoh stok habis
  ),
  Product(
    id: '5',
    name: 'Genteng Palentong',
    category: 'Genteng',
    price: 2500,
    originalPrice: 2800,
    rating: 4.5,
    sold: 2100,
    realStock: 1000, // <--- TAMBAHAN BARU
    image: 'assets/images/genteng3.png',
    store: 'Ud. Berkah',
    location: 'Majalengka',
    description:
        'Genteng tradisional harga ekonomis. Cocok untuk rumah sederhana.',
    specs: ProductSpecs(
      weight: '1.8 kg',
      coverage: '22 pcs/m²',
      spacing: '22 cm',
      warranty: '5 Tahun',
    ),
    isPromo: true,
  ),
];
