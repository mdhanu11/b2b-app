import 'package:muward_b2b/features/products/domain/entities/subcategory.dart';
import 'package:muward_b2b/features/products/domain/repositories/subcategory_repository.dart';

class GetSubcategoriesUsecase {
  final SubcategoryRepository repository;

  GetSubcategoriesUsecase(this.repository);

  Future<List<Subcategory>> call(String parentId) async {
    return await repository.getCategories(parentId);
  }
}
