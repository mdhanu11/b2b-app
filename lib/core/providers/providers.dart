// lib/core/providers/setup_app_providers.dart
import 'package:flutter/material.dart';
import 'package:muward_b2b/features/products/data/datasources/product_local_data_source.dart';
import 'package:muward_b2b/features/products/data/datasources/product_remote_data_source.dart';
import 'package:muward_b2b/features/products/data/datasources/subcategory_remote_data_source.dart';
import 'package:muward_b2b/features/products/data/repositories/products_repository_impl.dart';
import 'package:muward_b2b/features/products/data/repositories/subcategory_repository_impl.dart';
import 'package:muward_b2b/features/products/domain/usecases/get_favorite_products_usecase.dart';
import 'package:muward_b2b/features/products/domain/usecases/get_products_by_subcategory_usecase.dart';
import 'package:muward_b2b/features/products/domain/usecases/get_subcategories_usecase.dart';
import 'package:muward_b2b/features/products/domain/usecases/toggle_favorite_product_usecase.dart';
import 'package:muward_b2b/features/products/presentation/product_view_model.dart';
import 'package:muward_b2b/features/products/presentation/subcategory_view_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// Location Imports
import 'package:muward_b2b/features/location/data/datasources/location_service.dart';
import 'package:muward_b2b/features/location/data/datasources/place_service.dart';
import 'package:muward_b2b/features/location/data/repositories/location_repository_impl.dart';
import 'package:muward_b2b/features/location/domain/usecases/fetch_address_from_latlng_usecase.dart';
import 'package:muward_b2b/features/location/domain/usecases/fetch_current_location_usecase.dart';
import 'package:muward_b2b/features/location/domain/usecases/fetch_latlng_usecase.dart';
import 'package:muward_b2b/features/location/domain/usecases/fetch_place_predictions_usecase.dart';
import 'package:muward_b2b/features/location/presentation/pages/location_viewmodel.dart';

// Home Imports
import 'package:muward_b2b/features/home/data/datasources/home_remote_data_source.dart';
import 'package:muward_b2b/features/home/data/repositories/home_repository_impl.dart';
import 'package:muward_b2b/features/home/domain/usecases/get_banners_usecase.dart';
import 'package:muward_b2b/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:muward_b2b/features/home/domain/usecases/get_trending_items_usecase.dart';
import 'package:muward_b2b/features/home/presentation/home_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/home/data/datasources/categories_remote_data_source.dart';
import '../../features/registration/data/datasources/registration_api_datasource.dart';
import '../../features/registration/data/datasources/registration_local_datasource.dart';
import '../../features/registration/data/repositories/registration_repository_impl.dart';
import '../../features/registration/presentation/provider/registration_provider.dart';
import '../auth/providers/auth_provider.dart';
import '../network/api_client.dart';
import 'locale_provider.dart';

class AppProviders {
  // Singleton instance
  static final AppProviders _instance = AppProviders._internal();
  factory AppProviders() => _instance;
  AppProviders._internal();

  // Shared API client instance
  APIClient? apiClient;
  AuthRepository? _authRepository;

  APIClient getApiClient(AuthRepository authRepository) {
    if (apiClient == null) {
      _authRepository = authRepository;
      apiClient = APIClient(authRepository);
    }
    return apiClient!;
  }

  // Setup language change listener
  void setupLanguageListener(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    // Set initial language
    if (apiClient != null) {
      apiClient!.setLanguage(localeProvider.locale.languageCode);

      // Setup listener for future changes
      localeProvider.addListener(() {
        apiClient!.setLanguage(localeProvider.locale.languageCode);
      });
    }
  }
}

Future<List<ChangeNotifierProvider<ChangeNotifier?>>> setupAppProviders(
    String apiKey) async {
  // **HTTP Client**
  final httpClient = http.Client();

  final authLocalDataSource = AuthLocalDatasourceImpl();

  // Initialize Auth repository
  final authRepository = AuthRepositoryImpl(
    localDatasource: authLocalDataSource,
  );

  // **API Client**
  final apiClient = AppProviders().getApiClient(authRepository);

  final sharedPreferences = await SharedPreferences.getInstance();

  // **Location Feature**
  // Initialize shared services for Location
  final placesService = PlacesService(apiKey: apiKey);
  final locationService = LocationService();

  // Initialize Location repository
  final locationRepository = LocationRepositoryImpl(
    locationService: locationService,
    placesService: placesService,
  );

  // Initialize Location use cases
  final fetchCurrentLocationUseCase =
      FetchCurrentLocationUseCase(locationRepository);
  final fetchPlacePredictionsUseCase =
      FetchPlacePredictionsUseCase(locationRepository);
  final fetchLatLngForPlaceUseCase = FetchLatLngUseCase(locationRepository);
  final fetchAddressFromLatLngUseCase =
      FetchAddressFromLatLngUseCase(locationRepository);

  // **Home Feature**
  // Initialize shared services for Home
  final homeRemoteDataSource = HomeRemoteDataSource(httpClient);
  final categoriesRemoteDataSource = CategoriesRemoteDataSource(apiClient);

  // Initialize Home repository
  final homeRepository = HomeRepositoryImpl(
      remoteDataSource: homeRemoteDataSource,
      categoriesRemoteDataSource: categoriesRemoteDataSource);

  // Initialize Home use cases
  final getBannersUseCase = GetBannersUseCase(homeRepository);
  final getCategoriesUseCase = GetCategoriesUseCase(homeRepository);
  final getTrendingItemsUseCase = GetTrendingItemsUseCase(homeRepository);

  // Initialize Auth provider
  final authProvider = AuthProvider(authRepository);

  // **Registration Feature**
  // Initialize Registration data sources
  final registrationLocalDataSource =
      RegistrationLocalDatasource(sharedPreferences);
  final registrationApiDataSource = RegistrationApiDatasource(apiClient);

  // Initialize Registration repository
  final registrationRepository = RegistrationRepositoryImpl(
    registrationLocalDataSource,
    registrationApiDataSource,
  );

  //Products Feature
  final subcategoryRemoteDataSource = SubcategoryRemoteDataSource(apiClient);
  final subCategoryRepository =
      SubcategoryRepositoryImpl(subcategoryRemoteDataSource);
  final getSubcategoryUsecase = GetSubcategoriesUsecase(subCategoryRepository);

  final productLocalDataSource = ProductLocalDataSource();
  final productRemoteDataSource =
      ProductRemoteDataSource(apiClient, productLocalDataSource);

  final productRepository = ProductRepositoryImpl(
    productRemoteDataSource,
    productLocalDataSource,
  );
  final getProductUsecase = GetProductsBySubcategoryUsecase(productRepository);
  final getFavoriteUsecase = GetFavoriteProductIdsUseCase(productRepository);
  final toggleFavoriteUsecase = ToggleFavoriteProductUseCase(productRepository);

  // Return providers
  return [
    ChangeNotifierProvider<LocaleProvider>(
      create: (_) => LocaleProvider(),
    ),

    ChangeNotifierProvider<AuthProvider>(
      create: (_) => authProvider,
    ),

    // Location ViewModel
    ChangeNotifierProvider<LocationViewModel>(
      create: (_) => LocationViewModel(
        fetchCurrentLocationUseCase: fetchCurrentLocationUseCase,
        fetchPlacePredictionsUseCase: fetchPlacePredictionsUseCase,
        fetchLatLngForPlaceUseCase: fetchLatLngForPlaceUseCase,
        fetchAddressFromLatLngUseCase: fetchAddressFromLatLngUseCase,
      ),
    ),
    // Home ViewModel
    ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(
        getBannersUseCase: getBannersUseCase,
        getCategoriesUseCase: getCategoriesUseCase,
        getTrendingItemsUseCase: getTrendingItemsUseCase,
      ),
    ),

    // New Registration provider
    ChangeNotifierProvider<RegistrationProvider>(
      create: (_) => RegistrationProvider(registrationRepository, authProvider),
    ),

    ChangeNotifierProvider<SubcategoryViewModel>(
      create: (_) => SubcategoryViewModel(
        getSubcategoryUsecase,
      ),
    ),
    ChangeNotifierProvider<ProductViewModel>(
      create: (_) => ProductViewModel(
          getProductsUseCase: getProductUsecase,
          getFavoriteProductIdsUseCase: getFavoriteUsecase,
          toggleFavoriteProductUseCase: toggleFavoriteUsecase),
    ),
  ];
}
