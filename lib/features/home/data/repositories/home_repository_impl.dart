import 'package:muward_b2b/features/home/domain/entities/home_category.dart';

import '../../domain/entities/home_banner.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/categories_remote_data_source.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final CategoriesRemoteDataSource categoriesRemoteDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.categoriesRemoteDataSource,
  });

  @override
  Future<List<HomeBanner>> getBanners() async {
    final bannersData = await remoteDataSource.fetchBanners();
    return bannersData.map((data) => HomeBanner.fromJson(data)).toList();
  }

  @override
  Future<List<HomeCategory>> getCategories() async {
    final categoriesData = await categoriesRemoteDataSource.fetchCategories();
    final categories =
        categoriesData.map((data) => HomeCategory.fromJson(data)).toList();
    categories.sort((a, b) => a.position.compareTo(b.position));

    return categories;
  }

  @override
  Future<List<Product>> getTrendingItems() async {
    return await remoteDataSource.fetchTrendingItems();
  }
}
