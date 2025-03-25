import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:muward_b2b/core/navigation/app_router.dart';
import 'package:muward_b2b/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:muward_b2b/features/home/presentation/pages/home_page.dart';
import 'package:muward_b2b/core/constants/app_routes.dart';
import 'package:muward_b2b/core/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muward_b2b/core/auth/providers/auth_provider.dart';

import 'core/providers/providers.dart';
import 'core/providers/locale_provider.dart';
import 'core/utils/api_key_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiKey = await ApiKeyHelper.getApiKey();
  final providers = await setupAppProviders(apiKey);

  runApp(MyApp(apiKey: apiKey, providers: providers));
}

class MyApp extends StatelessWidget {
  final String apiKey;
  final List<ChangeNotifierProvider<ChangeNotifier?>> providers;

  const MyApp({Key? key, required this.apiKey, required this.providers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (context) {
        // Setup the language listener once after the provider tree is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppProviders().setupLanguageListener(context);
        });

        // First, check if the AuthProvider is available
        final authProvider = Provider.of<AuthProvider>(context, listen: true);
        final localeProvider =
            Provider.of<LocaleProvider>(context, listen: true);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Muward',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return Directionality(
              textDirection: localeProvider.locale.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: child!,
            );
          },
          home: authProvider.isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : authProvider.isLoggedIn
                  ? const HomePage()
                  : const OnboardingPage(),
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      }),
    );
  }
}
