import '../entities/home_category.dart';
import '../repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<HomeCategory>> call() async {
    return await repository.getCategories();
  }
}
