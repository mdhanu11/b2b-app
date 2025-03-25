import '../repositories/location_repository.dart';
import '../entities/place_prediction.dart';

class FetchPlacePredictionsUseCase {
  final LocationRepository repository;

  FetchPlacePredictionsUseCase(this.repository);

  Future<List<PlacePrediction>> call(String query) async {
    return await repository.fetchPlacePredictions(query);
  }
}
