import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screen/_screen.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Assets
  late final GoRouter _router;

  void _createGorouter() {
    _router = GoRouter(
      routes: [
        GoRoute(
          name: PresentationScreen.name,
          path: PresentationScreen.path,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: PresentationScreen(),
            );
          },
        ),
        GoRoute(
          name: HomeScreen.name,
          path: HomeScreen.path,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: HomeScreen(),
            );
          },
          redirect: (context, state) {
            if (DatabaseService.instance.value) return null;
            return PresentationScreen.path;
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    /// Assets
    _createGorouter();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocalizationService.instance,
      builder: (context, locale, child) {
        return MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: Themes.theme,
          locale: locale,
        );
      },
    );
  }
}
