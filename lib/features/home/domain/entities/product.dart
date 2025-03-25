class Product {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final bool isTrending;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.isTrending,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0, // Default to 0 if null
      name: json['name'] as String? ?? '', // Default to empty string
      imageUrl: json['imageUrl'] as String? ?? '', // Default to empty string
      price: (json['price'] as num?)?.toDouble() ??
          0.0, // Convert to double, default to 0.0
      description:
          json['description'] as String? ?? '', // Default to empty string
      isTrending: json['isTrending'] as bool? ?? false, // Default to false
    );
  }
}
