import 'package:muward_b2b/features/home/domain/entities/home_banner.dart';
import '../entities/home_category.dart';
import '../entities/product.dart';

abstract class HomeRepository {
  Future<List<HomeBanner>> getBanners();
  Future<List<HomeCategory>> getCategories();
  Future<List<Product>> getTrendingItems();
}
