import 'package:muward_b2b/features/home/domain/entities/home_banner.dart';
import '../repositories/home_repository.dart';

class GetBannersUseCase {
  final HomeRepository repository;

  GetBannersUseCase(this.repository);

  Future<List<HomeBanner>> call() async {
    print('banners');
    return await repository.getBanners();
  }
}
