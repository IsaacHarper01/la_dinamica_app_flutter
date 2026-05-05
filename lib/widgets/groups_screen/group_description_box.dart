import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ConsumerWidget version
class GroupDescriptionBox extends ConsumerStatefulWidget {
  final String groupName;
  final String description;

  const GroupDescriptionBox({
    super.key,
    required this.groupName,
    required this.description,
  });

  @override
  ConsumerState<GroupDescriptionBox> createState() => _GroupDescriptionBoxState();
}

class _GroupDescriptionBoxState extends ConsumerState<GroupDescriptionBox> {
  bool isEditing = false;
  late TextEditingController controller;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.description);
  }

  void startEditing() {
    setState(() {
      isEditing = true;
    });

    Future.delayed(Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  void save() {
    setState(() {
      isEditing = false;
    });

    final newText = controller.text;
    
    /// 🔥 TODO: save to backend / provider
    print("New description: $newText");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.95,
      height: size.height * 0.1,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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
              widget.groupName,
              style: GoogleFonts.gochiHand(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 8),

          /// 🔥 Editable area
          Expanded(
          child: SingleChildScrollView(
            child: isEditing
                ? TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: null, // important for multiline
                    onSubmitted: (_) => save(),
                    onEditingComplete: save,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : InkWell(
                    onTap: startEditing,
                    child: Text(
                      controller.text,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
          ),
        ),
        ],
      ),
    );
  }
}