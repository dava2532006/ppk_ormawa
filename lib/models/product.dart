class Product {
  final int id;
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
  });
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
