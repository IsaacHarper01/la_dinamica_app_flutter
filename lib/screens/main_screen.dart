import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/config/menu/menu_items.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/config_screen.dart';
import 'package:la_dinamica_app/screens/earn_screen.dart';
import 'package:la_dinamica_app/screens/home_screen.dart';
import 'package:la_dinamica_app/screens/pays_screen.dart';
import 'package:la_dinamica_app/screens/students_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    StudentsScreen(),
    EarnScreen(),
    PaysScreen(),
    ConfigScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).initializeUser(ref);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final screenHeight =
        MediaQuery.of(context).size.height * (isPortrait ? 1 : 2);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: colorList[0],
        height: screenHeight * 0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              appMenuItmes.asMap().entries.map((entry) {
                int idx = entry.key;
                MenuItem item = entry.value;
                final isSelected = _selectedIndex == idx;
                return TextButton(
                  onPressed:
                      () => _onItemTapped(
                        idx,
                      ), // Cambia la pantalla al hacer clic
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected ? colorList[4] : colorList[5],
                        size: screenHeight * 0.020,
                      ),
                      Text(
                        item.title,
                        style: TextStyle(
                          color: isSelected ? colorList[4] : colorList[5],
                          fontSize: screenHeight * 0.015,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
