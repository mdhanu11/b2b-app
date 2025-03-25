import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muward_b2b/core/constants/app_colors.dart';
import 'package:muward_b2b/core/constants/app_constants.dart';
import 'package:muward_b2b/core/utils/shared_prefs_helper.dart';
import '../widgets/home_tab.dart';
import '../widgets/pending_approval_bottom_sheet.dart';
import '../widgets/success_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeTab(),
      const Center(child: Text("Buy Again Page")),
      const Center(child: Text("Deals Page")),
      const Center(child: Text("Cart Page")),
      const Center(child: Text("Account Page")),
    ];
    _checkForSuccessPopup();
  }

  Future<void> _checkForSuccessPopup() async {
    final shouldShowPopup =
        await SharedPrefsHelper.getBool(AppConstants.successPopupKey);
    if (shouldShowPopup) {
      await SharedPrefsHelper.setBool(AppConstants.successPopupKey, false);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _showSuccessPopup();
      });
    }
  }

  void _showSuccessPopup() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PendingApprovalBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.tabCadetBlue,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: localizations.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.repeat),
              label: localizations.buyAgain,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.diamond),
              label: localizations.deals,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart),
              label: localizations.cart,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: localizations.account,
            ),
          ],
        ),
      ),
    );
  }
}
