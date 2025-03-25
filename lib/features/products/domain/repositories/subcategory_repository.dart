import 'package:muward_b2b/features/products/domain/entities/subcategory.dart';

abstract class SubcategoryRepository {
  Future<List<Subcategory>> getCategories(String parentId);
}
