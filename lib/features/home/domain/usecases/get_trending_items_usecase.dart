import '../entities/product.dart';
import '../repositories/home_repository.dart';

class GetTrendingItemsUseCase {
  final HomeRepository homeRepository;

  GetTrendingItemsUseCase(this.homeRepository);

  Future<List<Product>> call() async {
    return await homeRepository.getTrendingItems();
  }
}
