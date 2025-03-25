import 'package:muward_b2b/features/products/domain/repositories/product_repository.dart';

class ToggleFavoriteProductUseCase {
  final ProductRepository _repository;

  ToggleFavoriteProductUseCase(this._repository);

  Future<void> execute(String productId) async {
    await _repository.toggleFavoriteProduct(productId);
  }
}
