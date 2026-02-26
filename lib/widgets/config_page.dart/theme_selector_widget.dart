import 'package:flutter/material.dart';

class ThemeSelector extends StatelessWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) onChanged;

  const ThemeSelector({
    super.key,
    required this.themeMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return PopupMenuButton<ThemeMode>(
      initialValue: themeMode,
      icon: Icon(
        Icons.color_lens,
        size: 32,
        color: colorScheme.tertiary,
      ),
      onSelected: onChanged,
      itemBuilder: (_) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: [
              Icon(Icons.light_mode, color: Colors.amber[400]),
              const SizedBox(width: 8),
              const Text('Claro'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: [
              Icon(Icons.dark_mode, color: Colors.deepPurple[800]),
              const SizedBox(width: 8),
              const Text('Oscuro'),
            ],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: [
              Icon(Icons.settings, color: Colors.grey[400]),
              const SizedBox(width: 8),
              const Text('Sistema'),
            ],
          ),
        ),
      ],
    );
  }
}
