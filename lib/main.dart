import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDark);
    return MaterialApp(
      title: 'La Dinamica del Movimiento',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Color.fromRGBO(204, 208, 207, 1.0),
          appBarTheme: const AppBarTheme(centerTitle: false),
          brightness: isDarkMode ? Brightness.dark : Brightness.light),
      home: const MainScreen(),
    );
  }
}
