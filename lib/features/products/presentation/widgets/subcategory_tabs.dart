import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/subcategory.dart';
import '../subcategory_view_model.dart';
import 'subcategory_skeleton.dart';

class SubcategoryTabsWidget extends StatefulWidget {
  final String parentCategoryId;
  final Function(Subcategory) onSubcategorySelected;
  final Function(List<Subcategory>)? onSubcategoriesLoaded;

  const SubcategoryTabsWidget({
    super.key,
    required this.parentCategoryId,
    required this.onSubcategorySelected,
    this.onSubcategoriesLoaded,
  });

  @override
  State<SubcategoryTabsWidget> createState() => _SubcategoryTabsWidgetState();
}

class _SubcategoryTabsWidgetState extends State<SubcategoryTabsWidget>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  bool _initialSelectionDone = false;
  String? _lastCategoryId;

  @override
  bool get wantKeepAlive => false; // Don't keep state when navigating away

  @override
  void initState() {
    super.initState();
    _lastCategoryId = widget.parentCategoryId;
    // Schedule the fetch for after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSubcategories();
    });
  }

  @override
  void didUpdateWidget(SubcategoryTabsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the category ID changed or we've returned to the page, refresh data
    if (oldWidget.parentCategoryId != widget.parentCategoryId ||
        _lastCategoryId != widget.parentCategoryId) {
      _lastCategoryId = widget.parentCategoryId;
      // Schedule the update for after the current build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchSubcategories();
      });
    }
  }

  void _fetchSubcategories() {
    // Reset state when fetching new subcategories
    setState(() {
      _initialSelectionDone = false;
    });

    // Access the view model
    final viewModel = context.read<SubcategoryViewModel>();

    // Clear existing subcategories, show loading state, and reset selected subcategory
    viewModel.clearSubcategories();
    viewModel.setLoading(true);

    // Then fetch new data
    viewModel.fetchSubcategories(widget.parentCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final localizations = AppLocalizations.of(context)!;

    return Consumer<SubcategoryViewModel>(
      builder: (context, viewModel, child) {
        // Check if subcategories have loaded and we haven't done the initial selection yet
        if (!viewModel.isLoading &&
            !_initialSelectionDone &&
            viewModel.subcategories.isNotEmpty &&
            widget.onSubcategoriesLoaded != null) {
          // Set flag to avoid calling this multiple times
          _initialSelectionDone = true;

          // Notify parent about loaded subcategories
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onSubcategoriesLoaded!(viewModel.subcategories);
          });
        }

        if (viewModel.isLoading && viewModel.subcategories.isEmpty) {
          return const SubcategorySkeleton();
        }

        if (viewModel.hasError) {
          return SizedBox(
            height: 70,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      color: Theme.of(context).colorScheme.error, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    localizations.failedToLoad,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () => _fetchSubcategories(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                    ),
                    child: Text(localizations.retry,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          );
        }

        // Handle empty subcategories case
        if (viewModel.subcategories.isEmpty) {
          return SizedBox(
            height: 70,
            child: Center(
              child: Text(localizations.noSubcategoriesAvailable),
            ),
          );
        }

        // Create a non-selected index by default
        if (_selectedIndex >= viewModel.subcategories.length) {
          _selectedIndex = 0;
        }

        return Container(
          height: 70,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.subcategories.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            itemBuilder: (context, index) {
              final subcategory = viewModel.subcategories[index];
              final isSelected = index == _selectedIndex;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onSubcategorySelected(subcategory);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.lightGrey : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subcategory.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
