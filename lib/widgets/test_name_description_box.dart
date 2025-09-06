import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:la_dinamica_app/providers/exam_provider.dart';

// ConsumerWidget version
class TestInfoBox extends ConsumerWidget {

  const TestInfoBox({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final actualTest = ref.watch(examProvider).actualState;
    final description = ref.watch(examProvider).descriptions[actualTest];

    return Container(
      width: size.width * 0.9,
      height: size.height * 0.15,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              actualTest,
              style: GoogleFonts.gochiHand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              description ?? "",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
