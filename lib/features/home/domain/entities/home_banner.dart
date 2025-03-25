class HomeBanner {
  final int id;
  final String imageUrl;
  final String redirectUrl;

  HomeBanner({
    required this.id,
    required this.imageUrl,
    required this.redirectUrl,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id'] as int? ?? 0, // Default to 0 if null
      imageUrl: json['imageUrl'] as String? ?? '', // Default to empty string
      redirectUrl:
          json['redirectUrl'] as String? ?? '', // Default to empty string
    );
  }
}
