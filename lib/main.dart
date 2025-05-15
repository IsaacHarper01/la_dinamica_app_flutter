import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/config/theme/util.dart';
import 'package:la_dinamica_app/screens/main_screen.dart';

import 'config/provider/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    TextTheme textTheme = createTextTheme(context, "Mulish", "Work Sans");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'La Dinamica del Movimiento',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: themeMode,
      home: const MainScreen(),
    );
  }
}
