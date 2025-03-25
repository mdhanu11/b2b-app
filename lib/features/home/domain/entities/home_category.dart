class HomeCategory {
  final String id;
  final Map<String, String> localizedName;
  final Map<String, String> localizedDescription;
  final String name;
  final String description;
  final String code;
  final int position;
  final bool published;
  final Map<String, dynamic> mixins;

  HomeCategory({
    required this.id,
    required this.localizedName,
    required this.localizedDescription,
    required this.name,
    required this.description,
    required this.code,
    required this.position,
    required this.published,
    required this.mixins,
  });

  String getImageUrl(String languageCode) {
    if (mixins.containsKey('images')) {
      return mixins['images']['img_$languageCode'] ?? '';
    }
    return '';
  }

  String getLocalizedName(String languageCode) {
    return localizedName[languageCode] ?? name;
  }

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    return HomeCategory(
      id: json['id'] as String? ?? '',
      localizedName: Map<String, String>.from(json['localizedName'] ?? {}),
      localizedDescription:
          Map<String, String>.from(json['localizedDescription'] ?? {}),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      code: json['code'] as String? ?? '',
      position: json['position'] as int? ?? 0,
      published: json['published'] as bool? ?? false,
      mixins: json['mixins'] as Map<String, dynamic>? ?? {},
    );
  }
}
