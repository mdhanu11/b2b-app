import 'package:muward_b2b/features/products/domain/entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsBySubcategoryUsecase {
  final ProductRepository repository;

  GetProductsBySubcategoryUsecase(this.repository);

  Future<List<Product>> call(String subcategoryId,
      {int page = 1, int pageSize = 20}) {
    print('subcategoryId $subcategoryId');
    return repository.getProductsBySubcategory(subcategoryId);
  }
}
