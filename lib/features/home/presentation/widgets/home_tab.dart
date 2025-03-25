import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/top_bar.dart';
import '../widgets/rfq_banner.dart';
import '../home_viewmodel.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      TopBar(
                        onCityButtonPressed: () {},
                      ),
                      if (viewModel.banners.isNotEmpty)
                        BannerCarousel(
                          banners: viewModel.banners,
                          onBannerTap: (String redirectUrl) {},
                        ),
                      if (viewModel.categories.isNotEmpty)
                        CategoryGrid(categories: viewModel.categories),
                      const SizedBox(height: 10),
                      RfqBanner(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
