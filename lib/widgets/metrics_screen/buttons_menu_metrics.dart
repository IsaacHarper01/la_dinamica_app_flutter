import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/select_date_range_metrics.dart';


class ButtonsMenu extends ConsumerWidget {
  final List<String> options;
  final double screenWidth;

  const ButtonsMenu({
    super.key, 
    required this.options,
    required this.screenWidth
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProviderMetrics);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(4, (index) {
        final value = index + 1;
        final isSelected = selected == value;
        return GestureDetector(
          onTap: () {
            ref.read(selectedDateProviderMetrics.notifier).state = value;
            // you can also call a callback here if you want to "return" the value
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blueAccent : Colors.grey,
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              options[value-1],
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
