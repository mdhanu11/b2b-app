import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/product.dart';

class HomeRemoteDataSource {
  final http.Client client;

  HomeRemoteDataSource(this.client);

  /// Mock Banners Data
  Future<List<Map<String, dynamic>>> fetchBanners() async {
    final sampleBanners = [
      {
        "id": 1,
        "imageUrl":
            "https://muward-b2b.s3.me-south-1.amazonaws.com/banners/banner1.png",
        "title": "Get 25% Off On Your First Order",
        "description": "Order today and enjoy a huge discount!"
      },
      {
        "id": 2,
        "imageUrl":
            "https://muward-b2b.s3.me-south-1.amazonaws.com/banners/banner2.png",
        "title": "Unlock Exclusive Prices",
        "description": "Sign up now for special deals."
      },
      {
        "id": 3,
        "imageUrl":
            "https://muward-b2b.s3.me-south-1.amazonaws.com/banners/banner3.png",
        "title": "Best Deals of the Week",
        "description": "Don't miss out on these amazing offers!"
      },
    ];
    return Future.value(sampleBanners);
  }

  /// Mock Categories Data
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final sampleCategories = [
      {
        "id": 1,
        "name": "Frozen",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_frozen.png",
      },
      {
        "id": 2,
        "name": "Bakery",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/home_parent/bakerey.png",
      },
      {
        "id": 3,
        "name": "Beverages",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_beverages.png",
      },
      {
        "id": 4,
        "name": "Snacks",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/home/categoryicons/v4_snacks.png",
      },
      {
        "id": 5,
        "name": "Food Basics",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_food_basics.png",
      },
      {
        "id": 6,
        "name": "Cooking Essentials",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_cooking_essentials.png",
      },
      {
        "id": 7,
        "name": "Beauty Care",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v5_beauty_care.png",
      },
      {
        "id": 8,
        "name": "Electronics",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_electronics.png",
      },
      {
        "id": 2,
        "name": "Bakery",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/home_parent/bakerey.png",
      },
      {
        "id": 6,
        "name": "Cooking Essentials",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_cooking_essentials.png",
      },
      {
        "id": 1,
        "name": "Frozen",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_frozen.png",
      },
      {
        "id": 3,
        "name": "Beverages",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_beverages.png",
      },
      {
        "id": 1,
        "name": "Frozen",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/v4_frozen.png",
      },
      {
        "id": 2,
        "name": "Bakery",
        "imageUrl":
            "https://images.todoorstep.com/app-assets/categoryicons/home_parent/bakerey.png",
      },
    ];
    return Future.value(sampleCategories);
  }

  /// Mock Trending Items Data
  Future<List<Product>> fetchTrendingItems() async {
    final sampleTrendingItems = [
      Product(
        id: 1,
        name: "Nescafe Instant Coffee 95g",
        imageUrl: "https://dummyimage.com/150x150/000/fff&text=Nescafe",
        price: 19.45,
        description: "Rich instant coffee with great taste",
        isTrending: true,
      ),
      Product(
        id: 2,
        name: "Ahmad Tea Green Tea (20 Bags)",
        imageUrl: "https://dummyimage.com/150x150/007bff/ffffff&text=Green+Tea",
        price: 15.99,
        description: "Refreshing and natural green tea bags",
        isTrending: true,
      ),
      Product(
        id: 3,
        name: "Lipton Black Tea (100 Bags)",
        imageUrl: "https://dummyimage.com/150x150/28a745/ffffff&text=Lipton",
        price: 29.99,
        description: "Classic black tea with a robust flavor",
        isTrending: true,
      ),
      Product(
        id: 4,
        name: "Amul Butter 500g",
        imageUrl: "https://dummyimage.com/150x150/ffc107/000000&text=Butter",
        price: 4.99,
        description: "Delicious and smooth butter for all occasions",
        isTrending: true,
      ),
    ];
    return Future.value(sampleTrendingItems);
  }

  Future<List<Map<String, dynamic>>> fetchSubcategories() async {
    final sampleSubcategories = [
      {
        "id": 1,
        "name": "Coffee",
        "imageUrl": "https://dummyimage.com/150x150/000/fff&text=Coffee",
      },
      {
        "id": 2,
        "name": "Tea",
        "imageUrl": "https://dummyimage.com/150x150/007bff/ffffff&text=Tea",
      },
      {
        "id": 3,
        "name": "Creamers",
        "imageUrl":
            "https://dummyimage.com/150x150/ffc107/000000&text=Creamers",
      },
      {
        "id": 4,
        "name": "Brews",
        "imageUrl": "https://dummyimage.com/150x150/a52a2a/ffffff&text=Brews",
      },
    ];
    return Future.value(sampleSubcategories);
  }

  Future<List<Product>> fetchProductsBySubcategory(int subcategoryId) async {
    final Map<int, List<Product>> subcategoryProducts = {
      1: [
        // Coffee Products
        Product(
          id: 101,
          name: "Al Ain Original Turkish Coffee",
          imageUrl:
              "https://dummyimage.com/150x150/000/fff&text=Turkish+Coffee",
          price: 19.95,
          description: "Traditional Turkish-style ground coffee.",
          isTrending: false,
        ),
        Product(
          id: 102,
          name: "Nescafe 2in1 Classic",
          imageUrl: "https://dummyimage.com/150x150/000/fff&text=Nescafe+2in1",
          price: 22.95,
          description: "Convenient instant coffee mix.",
          isTrending: true,
        ),
        Product(
          id: 103,
          name: "Nescafe Instant Coffee",
          imageUrl:
              "https://dummyimage.com/150x150/000/fff&text=Instant+Coffee",
          price: 19.45,
          description: "Rich instant coffee with great taste.",
          isTrending: true,
        ),
      ],
      2: [
        // Tea Products
        Product(
          id: 201,
          name: "Lipton Yellow Label Black Tea Bags",
          imageUrl:
              "https://dummyimage.com/150x150/007bff/ffffff&text=Lipton+Tea",
          price: 6.71,
          description: "Classic black tea with strong flavor.",
          isTrending: true,
        ),
        Product(
          id: 202,
          name: "Ahmad Tea Green Tea",
          imageUrl:
              "https://dummyimage.com/150x150/007bff/ffffff&text=Green+Tea",
          price: 15.90,
          description: "Refreshing green tea bags.",
          isTrending: false,
        ),
      ],
      3: [
        // Creamers Products
        Product(
          id: 301,
          name: "Nestle Coffee Mate",
          imageUrl:
              "https://dummyimage.com/150x150/ffc107/000000&text=Coffee+Mate",
          price: 8.05,
          description: "Rich and creamy coffee enhancer.",
          isTrending: false,
        ),
        Product(
          id: 302,
          name: "Coffeemate French Vanilla",
          imageUrl:
              "https://dummyimage.com/150x150/ffc107/000000&text=French+Vanilla",
          price: 33.50,
          description: "Vanilla flavored coffee creamer.",
          isTrending: true,
        ),
      ],
      4: [
        // Brews Products
        Product(
          id: 401,
          name: "Starbucks Pike Place Roast",
          imageUrl:
              "https://dummyimage.com/150x150/a52a2a/ffffff&text=Starbucks",
          price: 42.50,
          description: "Smooth and well-balanced coffee blend.",
          isTrending: true,
        ),
        Product(
          id: 402,
          name: "Lavazza Espresso Italiano",
          imageUrl: "https://dummyimage.com/150x150/a52a2a/ffffff&text=Lavazza",
          price: 38.99,
          description: "Authentic Italian espresso with bold flavor.",
          isTrending: false,
        ),
      ],
    };

    return Future.value(subcategoryProducts[subcategoryId] ?? []);
  }
}
