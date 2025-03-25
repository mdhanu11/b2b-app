import 'package:muward_b2b/features/products/domain/repositories/product_repository.dart';

class GetFavoriteProductIdsUseCase {
  final ProductRepository _repository;

  GetFavoriteProductIdsUseCase(this._repository);

  Future<Set<String>> execute() async {
    return await _repository.getFavoriteProductIds();
  }
}
