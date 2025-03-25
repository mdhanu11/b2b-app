class Product {
  final String id;
  final String code;
  final String name;
  final Map<String, String>? localizedName;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;
  final bool available;
  final String? description;
  final Map<String, String>? localizedDescription;
  final List<String> categories;
  final Map<String, dynamic>? mixins;
  final bool isExpress;
  final bool isPromoted;
  final bool isBestSeller;

  const Product({
    required this.id,
    required this.code,
    required this.name,
    this.localizedName,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    required this.available,
    this.description,
    this.localizedDescription,
    required this.categories,
    this.mixins,
    this.isExpress = false,
    this.isPromoted = false,
    this.isBestSeller = false,
  });

  // Factory constructor to create a Product from standard JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    // Extract the ID and code
    final String id =
        json['id'] as String? ?? json['objectID'] as String? ?? '';
    final String code = json['code'] as String? ?? '';

    // Extract name, trying different possible formats
    String name = '';
    if (json['name'] != null) {
      if (json['name'] is List && (json['name'] as List).isNotEmpty) {
        name = (json['name'] as List).first.toString();
      } else if (json['name'] is String) {
        name = json['name'] as String;
      }
    } else if (json['localizedName'] != null &&
        json['localizedName'] is Map &&
        (json['localizedName'] as Map).containsKey('en')) {
      name = json['localizedName']['en'];
    }

    // Extract localized name
    Map<String, String>? localizedName;
    if (json['localizedName'] != null && json['localizedName'] is Map) {
      localizedName = Map<String, String>.from((json['localizedName'] as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString())));
    }

    // Extract image URL
    final String imageUrl =
        json['imageUrl'] as String? ?? json['image'] as String? ?? '';

    // Extract price and original price
    double price = 0.0;
    double? originalPrice;

    // Try to extract price from various formats
    if (json['price'] != null) {
      price = double.tryParse(json['price'].toString()) ?? 0.0;
    } else if (json['mixins'] != null &&
        json['mixins'] is Map &&
        json['mixins']['productCustomAttributes'] != null) {
      final attrs = json['mixins']['productCustomAttributes'];
      if (attrs['pricingMeasurePrice'] != null) {
        price = double.tryParse(attrs['pricingMeasurePrice'].toString()) ?? 0.0;
      }
    }

    // Try to extract original price
    if (json['originalPrice'] != null) {
      originalPrice = double.tryParse(json['originalPrice'].toString());
    }

    // Extract discount percentage
    int? discountPercentage;
    if (json['discountPercentage'] != null) {
      discountPercentage = int.tryParse(json['discountPercentage'].toString());
    }

    // Extract availability
    final bool available = json['available'] as bool? ?? false;

    // Extract description
    String? description;
    if (json['description'] != null) {
      if (json['description'] is List &&
          (json['description'] as List).isNotEmpty) {
        description = (json['description'] as List).first.toString();
      } else if (json['description'] is String) {
        description = json['description'] as String;
      }
    }

    // Extract localized description
    Map<String, String>? localizedDescription;
    if (json['localizedDescription'] != null &&
        json['localizedDescription'] is Map) {
      localizedDescription = Map<String, String>.from(
          (json['localizedDescription'] as Map)
              .map((key, value) => MapEntry(key.toString(), value.toString())));
    }

    // Extract categories
    List<String> categories = [];
    if (json['categories'] != null) {
      if (json['categories'] is List) {
        categories =
            (json['categories'] as List).map((e) => e.toString()).toList();
      } else if (json['categories'] is String) {
        // Handle case where categories might be a comma-separated string
        categories = [(json['categories'] as String)];
      }
    }

    // Extract flags for special product types
    final bool isExpress = json['isExpress'] as bool? ?? false;
    final bool isPromoted = json['isPromoted'] as bool? ?? false;
    final bool isBestSeller = json['isBestSeller'] as bool? ?? false;

    return Product(
      id: id,
      code: code,
      name: name,
      localizedName: localizedName,
      imageUrl: imageUrl,
      price: price,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      available: available,
      description: description,
      localizedDescription: localizedDescription,
      categories: categories,
      mixins: json['mixins'],
      isExpress: isExpress,
      isPromoted: isPromoted,
      isBestSeller: isBestSeller,
    );
  }

  // Factory constructor to create a Product from Algolia JSON
  factory Product.fromAlgolia(Map<String, dynamic> json) {
    // Extract the product code from objectID if available, otherwise from code field
    final String objectId = json['objectID'] as String? ?? '';
    final String code = json['code'] as String? ?? '';
    final String id = objectId.isNotEmpty ? objectId : code;

    // Get name from the first element of the name list or from localizedName
    String name = '';
    if (json['name'] != null &&
        json['name'] is List &&
        (json['name'] as List).isNotEmpty) {
      name = (json['name'] as List).first.toString();
    } else if (json['localizedName'] != null &&
        json['localizedName'] is Map &&
        (json['localizedName'] as Map).containsKey('en')) {
      name = json['localizedName']['en'];
    }

    // Get image URL
    final String imageUrl = json['image'] as String? ?? '';

    // Get price - for now defaulting to 0 since it's required by the UI
    // In a real app, you might want to handle this differently
    double price = 0.0;
    double? originalPrice;
    int? discountPercentage;

    // Check for price in mixins if available
    if (json['mixins'] != null &&
        json['mixins'] is Map &&
        json['mixins']['productCustomAttributes'] != null) {
      final attrs = json['mixins']['productCustomAttributes'];
      if (attrs['pricingMeasurePrice'] != null) {
        price = double.tryParse(attrs['pricingMeasurePrice'].toString()) ?? 0.0;
      }
    }

    // Get product availability
    final bool available = json['available'] as bool? ?? false;

    // Get description
    String? description;
    if (json['description'] != null &&
        json['description'] is List &&
        (json['description'] as List).isNotEmpty) {
      description = (json['description'] as List).first.toString();
    }

    // Get categories
    List<String> categories = [];
    if (json['categories'] != null && json['categories'] is List) {
      categories =
          (json['categories'] as List).map((e) => e.toString()).toList();
    }

    // Convert localizedName to proper type
    Map<String, String>? localizedName;
    if (json['localizedName'] != null && json['localizedName'] is Map) {
      localizedName = Map<String, String>.from((json['localizedName'] as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString())));
    }

    // Convert localizedDescription to proper type
    Map<String, String>? localizedDescription;
    if (json['localizedDescription'] != null &&
        json['localizedDescription'] is Map) {
      localizedDescription = Map<String, String>.from(
          (json['localizedDescription'] as Map)
              .map((key, value) => MapEntry(key.toString(), value.toString())));
    }

    return Product(
      id: id,
      code: code,
      name: name,
      localizedName: localizedName,
      imageUrl: imageUrl,
      price: price,
      originalPrice: originalPrice,
      discountPercentage: discountPercentage,
      available: available,
      description: description,
      localizedDescription: localizedDescription,
      categories: categories,
      mixins: json['mixins'],
      // These fields would need to be determined based on your business rules
      isExpress: false,
      isPromoted: false,
      isBestSeller: false,
    );
  }

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'localizedName': localizedName,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'available': available,
      'description': description,
      'localizedDescription': localizedDescription,
      'categories': categories,
      'mixins': mixins,
      'isExpress': isExpress,
      'isPromoted': isPromoted,
      'isBestSeller': isBestSeller,
    };
  }

  // Get product weight from mixins if available
  String get weight {
    if (mixins != null &&
        mixins!['productCustomAttributes'] != null &&
        mixins!['productCustomAttributes']['unitPricingMeasure'] != null) {
      final unitMeasure =
          mixins!['productCustomAttributes']['unitPricingMeasure'];
      if (unitMeasure['value'] != null && unitMeasure['unitCode'] != null) {
        final value = unitMeasure['value'];
        final unit = unitMeasure['unitCode'];
        return '$value $unit';
      }
    }

    // Extract weight from name if not in mixins (common pattern like "Product Name 375g")
    final RegExp weightRegex = RegExp(
        r'(\d+(?:\.\d+)?)\s*(g|kg|ml|l|gm|oz|lb)(?:\b|$)',
        caseSensitive: false);
    final match = weightRegex.firstMatch(name);
    if (match != null) {
      return match.group(0)!;
    }
    return '';
  }

  // Get carton info if available (from mixins or custom logic)
  String? get cartonInfo {
    return null; // Implement based on your data structure
  }

  // Calculate savings amount
  double? get savingsAmount {
    if (originalPrice != null) {
      return originalPrice! - price;
    }
    return null;
  }

  // Calculate discount percentage if not provided
  int? get calculatedDiscountPercentage {
    if (discountPercentage != null) {
      return discountPercentage;
    } else if (originalPrice != null) {
      return ((originalPrice! - price) / originalPrice! * 100).round();
    }
    return null;
  }

  // Override equality for comparing products
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
