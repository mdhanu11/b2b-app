import 'package:muward_b2b/features/products/domain/entities/subcategory.dart';
import 'package:muward_b2b/features/products/domain/repositories/subcategory_repository.dart';

import '../datasources/subcategory_remote_data_source.dart';

class SubcategoryRepositoryImpl implements SubcategoryRepository {
  final SubcategoryRemoteDataSource remoteDataSource;

  SubcategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Subcategory>> getCategories(String parentId) async {
    final categoriesData = await remoteDataSource.getSubcategories(parentId);
    final categories =
        categoriesData.map((data) => Subcategory.fromJson(data)).toList();
    categories.sort((a, b) => a.position.compareTo(b.position));

    return categories;
  }
}
