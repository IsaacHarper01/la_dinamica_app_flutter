import 'package:flutter/material.dart';
import 'package:la_dinamica_app/config/menu/menu_items.dart';
import 'package:la_dinamica_app/config/theme/app_theme.dart';
import 'package:la_dinamica_app/screens/config_screen.dart';
import 'package:la_dinamica_app/screens/earn_screen.dart';
import 'package:la_dinamica_app/screens/home_screen.dart';
import 'package:la_dinamica_app/screens/pays_screen.dart';
import 'package:la_dinamica_app/screens/students_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    StudentsScreen(),
    EarnScreen(),
    PaysScreen(),
    ConfigScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortatil = orientation == Orientation.portrait;
    final screenHeight = isPortatil
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height * 2;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: colorList[0],
        height: screenHeight * 0.07,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: appMenuItmes.asMap().entries.map((entry) {
            int idx = entry.key;
            MenuItem item = entry.value;
            return TextButton(
              onPressed: () =>
                  _onItemTapped(idx), // Cambia la pantalla al hacer clic
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: _selectedIndex == idx ? colorList[4] : colorList[5],
                    size: screenHeight * 0.020,
                  ),
                  Text(
                    item.title,
                    style: TextStyle(
                        color:
                            _selectedIndex == idx ? colorList[4] : colorList[5],
                        fontSize: screenHeight * 0.015),
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
