class Subcategory {
  final String id;
  final String parentId;
  final String name;
  final String description;
  final String code;
  final Map<String, String> localizedName;
  final Map<String, String> localizedDescription;
  final Map<String, String> localizedSlug;
  final Validity validity;
  final int position;
  final bool published;
  final Metadata metadata;

  Subcategory({
    required this.id,
    required this.parentId,
    required this.name,
    required this.description,
    required this.code,
    required this.localizedName,
    required this.localizedDescription,
    required this.localizedSlug,
    required this.validity,
    required this.position,
    required this.published,
    required this.metadata,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] ?? '',
      parentId: json['parentId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      localizedName: json['localizedName'] != null
          ? Map<String, String>.from(json['localizedName'])
          : {},
      localizedDescription: json['localizedDescription'] != null
          ? Map<String, String>.from(json['localizedDescription'])
          : {},
      localizedSlug: json['localizedSlug'] != null
          ? Map<String, String>.from(json['localizedSlug'])
          : {},
      validity: json['validity'] != null
          ? Validity.fromJson(json['validity'])
          : Validity(from: '', to: ''),
      position: json['position'] ?? 0,
      published: json['published'] ?? false,
      metadata: json['metadata'] != null
          ? Metadata.fromJson(json['metadata'])
          : Metadata(version: 0, createdAt: '', modifiedAt: ''),
    );
  }

  // Helper method to get localized name based on locale
  String getLocalizedName(String locale) {
    if (localizedName.containsKey(locale)) {
      return localizedName[locale]!;
    }
    return name;
  }

  // Helper method to get localized description based on locale
  String getLocalizedDescription(String locale) {
    if (localizedDescription.containsKey(locale)) {
      return localizedDescription[locale]!;
    }
    return description;
  }
}

class Validity {
  final String from;
  final String to;

  Validity({
    required this.from,
    required this.to,
  });

  factory Validity.fromJson(Map<String, dynamic> json) {
    return Validity(
      from: json['from'] ?? '',
      to: json['to'] ?? '',
    );
  }
}

class Metadata {
  final int version;
  final String createdAt;
  final String modifiedAt;

  Metadata({
    required this.version,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      version: json['version'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      modifiedAt: json['modifiedAt'] ?? '',
    );
  }
}
