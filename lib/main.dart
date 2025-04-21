import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/provider/theme_provider.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/main_screen.dart';
// import the Amplify API plugin
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicializar Amplify antes de que la app se cargue
    _configureAmplify();

    final isDarkMode = ref.watch(isDark);
    return MaterialApp(
      title: 'La Dinamica del Movimiento',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: colorList[0],
        appBarTheme: const AppBarTheme(centerTitle: false),
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: const MainScreen(),
    );
  }

  Future<void> _configureAmplify() async {
    final datastorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    final apiPlugin = AmplifyAPI();

    if (!Amplify.isConfigured) {
      try {
        await Amplify.addPlugins([datastorePlugin, apiPlugin]);
        await Amplify.configure(amplifyconfig);
        safePrint('✅ Amplify configurado correctamente');
      } on AmplifyAlreadyConfiguredException {
        safePrint('⚠️ Amplify ya estaba configurado');
      } catch (e) {
        safePrint('❌ Error al configurar Amplify: $e');
      }
    }
  }
}
