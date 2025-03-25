class TrendingItem {
  final String id;
  final String name;
  final double price;
  final double discountedPrice;
  final String imageUrl;
  final bool isFavorite;

  TrendingItem({
    required this.id,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory TrendingItem.fromJson(Map<String, dynamic> json) {
    return TrendingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}
