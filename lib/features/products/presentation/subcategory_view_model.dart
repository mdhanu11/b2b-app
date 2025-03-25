import 'package:flutter/cupertino.dart';
import 'package:muward_b2b/features/products/domain/entities/subcategory.dart';
import 'package:muward_b2b/features/products/domain/usecases/get_subcategories_usecase.dart';

class SubcategoryViewModel extends ChangeNotifier {
  final GetSubcategoriesUsecase getSubcategoriesUsecase;

  SubcategoryViewModel(this.getSubcategoriesUsecase);

  List<Subcategory> _subcategories = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentParentId;
  Subcategory? _selectedSubcategory;

  // Category information
  String? _categoryId;
  String? _categoryName;

  List<Subcategory> get subcategories => _subcategories;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  Subcategory? get selectedSubcategory => _selectedSubcategory;
  String? get categoryId => _categoryId;
  String? get categoryName => _categoryName;

  // Set the category information
  void setCategory(String id, String name) {
    _categoryId = id;
    _categoryName = name;
    notifyListeners();

    // Automatically fetch subcategories when category is set
    fetchSubcategories(id);
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Select a subcategory
  void selectSubcategory(Subcategory subcategory) {
    _selectedSubcategory = subcategory;
    notifyListeners();
  }

  Future<void> fetchSubcategories(String parentId) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    _currentParentId = parentId;
    notifyListeners();

    try {
      final result = await getSubcategoriesUsecase(parentId);
      _subcategories = result;

      // Auto-select the first subcategory if available
      if (_subcategories.isNotEmpty && _selectedSubcategory == null) {
        _selectedSubcategory = _subcategories.first;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void refresh() {
    if (_currentParentId != null) {
      fetchSubcategories(_currentParentId!);
    }
  }

  void clearSelection() {
    _selectedSubcategory = null;
    notifyListeners();
  }

  void clearSubcategories() {
    _subcategories = [];
    _selectedSubcategory = null;
    notifyListeners();
  }
}
