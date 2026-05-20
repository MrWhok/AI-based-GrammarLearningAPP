import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'data/database/isar_service.dart';
import 'features/home/home_screen.dart';
import 'shared/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isarService = IsarService();
  await isarService.init();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        isarServiceProvider.overrideWithValue(isarService),
        themeNotifierProvider.overrideWith((ref) => ThemeNotifier(prefs)),
      ],
      child: const GrammarApp(),
    ),
  );
}

class GrammarApp extends ConsumerWidget {
  const GrammarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      title: 'Grammar Master',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
