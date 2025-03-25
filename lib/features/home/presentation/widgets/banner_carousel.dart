import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../domain/entities/home_banner.dart';

class BannerCarousel extends StatefulWidget {
  final List<HomeBanner> banners;
  final Function(String redirectUrl) onBannerTap;

  const BannerCarousel({
    super.key,
    required this.banners,
    required this.onBannerTap,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0; // To track the active banner
  final Map<int, bool> _isLoading = {}; // Track loading state for each image

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Carousel Slider
        CarouselSlider(
          options: CarouselOptions(
            height: 130.0,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.banners.asMap().entries.map((entry) {
            final int index = entry.key;
            final HomeBanner banner = entry.value;

            return Stack(
              children: [
                // Image
                GestureDetector(
                  onTap: () {
                    widget.onBannerTap(banner.redirectUrl);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      banner.imageUrl,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          _isLoading[index] = false; // Image loaded
                          return child;
                        } else {
                          _isLoading[index] = true; // Still loading
                          return Container(
                            color:
                                Colors.grey.shade300, // Placeholder background
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        _isLoading[index] = false; // Error occurred
                        return Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),

                if (_isLoading[index] ?? true)
                  Positioned.fill(
                    child: Container(
                      color: Colors.green.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),

        // Bar Indicators Below the Banner
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? 40.0 : 40.0,
              height: 4.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                color: _currentIndex == entry.key
                    ? Colors.black
                    : Colors.grey.shade400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
