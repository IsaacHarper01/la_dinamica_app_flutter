import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String link;
  final IconData icon;

  const MenuItem({required this.title, required this.link, required this.icon});
}

const appMenuItmes = <MenuItem>[
  MenuItem(title: 'Inicio', link: '/home', icon: Icons.home_rounded),
  MenuItem(title: 'Alumnos',link: '/students',icon: Icons.supervisor_account_rounded),
  MenuItem(title: 'Ingresos', link: '/earn', icon: Icons.shopify_rounded),
  MenuItem(title: 'Evaluar', link: 'evaluation', icon: Icons.edit_rounded),
  MenuItem(title: 'Productos', link: 'products', icon: Icons.store),
  MenuItem(title: 'Ajustes', link: 'profile', icon: Icons.manage_accounts_rounded),
];
