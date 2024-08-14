import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String link;
  final IconData icon;

  const MenuItem({required this.title, required this.link, required this.icon});
}

const appMenuItmes = <MenuItem>[
  MenuItem(title: 'Inicio', link: '/home', icon: Icons.home_max_rounded),
  MenuItem(
      title: 'Alumnos',
      link: '/students',
      icon: Icons.supervisor_account_rounded),
  MenuItem(title: 'Ganancias', link: '/earn', icon: Icons.shopify_rounded),
  MenuItem(title: 'Pagos', link: 'pay', icon: Icons.payments_rounded),
  MenuItem(
      title: 'Perfil', link: 'profile', icon: Icons.manage_accounts_rounded),
];
