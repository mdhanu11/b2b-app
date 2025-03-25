import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muward_b2b/features/home/domain/entities/home_banner.dart';
import 'package:muward_b2b/features/home/domain/entities/home_category.dart';

import '../domain/entities/product.dart';
import '../domain/usecases/get_banners_usecase.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_trending_items_usecase.dart';

class HomeViewModel extends ChangeNotifier {
  final GetBannersUseCase getBannersUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetTrendingItemsUseCase getTrendingItemsUseCase;

  bool isLoading = true;
  List<HomeBanner> banners = [];
  List<HomeCategory> categories = [];
  List<Product> trendingItems = [];

  HomeViewModel({
    required this.getBannersUseCase,
    required this.getCategoriesUseCase,
    required this.getTrendingItemsUseCase,
  }) {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      banners = await getBannersUseCase();
      categories = await getCategoriesUseCase();
      trendingItems = await getTrendingItemsUseCase();
    } catch (e) {
      print('Error loading home data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
