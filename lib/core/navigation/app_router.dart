import 'package:flutter/material.dart';
import 'package:muward_b2b/features/home/presentation/pages/home_page.dart';
import 'package:muward_b2b/features/location/presentation/pages/location_page.dart';
import 'package:muward_b2b/features/products/presentation/pages/product_list.dart';
import 'package:muward_b2b/features/registration/presentation/pages/business_details_page.dart';
import 'package:muward_b2b/features/registration/presentation/pages/registraion_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../constants/app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return _buildPageRoute(const OnboardingPage(), settings);
      case AppRoutes.registration:
        return _buildPageRoute(const RegistrationPage(), settings);
      case AppRoutes.location:
        return _buildPageRoute(const LocationPage(), settings);
      case AppRoutes.home:
        return _buildPageRoute(const HomePage(), settings);
      case AppRoutes.businessDetails:
        return _buildPageRoute(const BusinessDetailsPage(), settings);
      case AppRoutes.products:
        return _buildPageRoute(const ProductListPage(), settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
