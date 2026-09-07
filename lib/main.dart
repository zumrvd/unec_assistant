import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unec_assistant/routing/app_router.dart';
import 'package:device_preview/device_preview.dart';
import 'package:unec_assistant/providers/theme_provider.dart';
import 'package:unec_assistant/providers/locale_provider.dart';
import 'package:unec_assistant/presentation/theme/app_colors.dart';

void main() => runApp(
  DevicePreview(
    //enabled: !kReleaseMode, // ON
    enabled: false, // OFF
    builder: (context) => const ProviderScope(child: UnecAssistantApp()),
  ),
);

class UnecAssistantApp extends ConsumerWidget {
  const UnecAssistantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(themeModeProvider);
    final flutterLocale = ref.watch(flutterLocaleProvider);

    final ThemeMode themeMode = switch (appThemeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };

    const lightColors = AppColors.light();
    const darkColors = AppColors.dark();

    return MaterialApp.router(
      scrollBehavior: const AppScrollBehavior(),
      locale: flutterLocale,
      builder: DevicePreview.appBuilder,
      title: 'UNEC Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: lightColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: lightColors.background,
        textTheme: GoogleFonts.redditSansTextTheme(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: lightColors.background,
          elevation: 0,
          titleTextStyle: GoogleFonts.redditSans(
            color: lightColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: darkColors.background,
        textTheme: GoogleFonts.redditSansTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: darkColors.background,
          elevation: 0,
          titleTextStyle: GoogleFonts.redditSans(
            color: darkColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('az', 'AZ'),
        Locale('ru', 'RU'),
      ],
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child;
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}