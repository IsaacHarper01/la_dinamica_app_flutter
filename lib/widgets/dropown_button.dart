import 'package:flutter/material.dart';

class OptionDropdown extends StatefulWidget {
  final List<String> options;
  final Future<void> Function(String) onSelected;
  const OptionDropdown({
    super.key, 
    required this.options,
    required this.onSelected
    });

  @override
  _ThreeOptionDropdownState createState() => _ThreeOptionDropdownState();
}

class _ThreeOptionDropdownState extends State<OptionDropdown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    if(widget.options.contains(selectedOption)){
      
    }else{
      setState(() {
        selectedOption = widget.options[0];
      });
    }
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(10),
      hint: Text(widget.options[0]),
      value: selectedOption,
      isExpanded: true, // makes it take full width
      items: widget.options.map((String option) {
        return DropdownMenuItem(
          alignment: Alignment.center,
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) async{
        setState(() {
          selectedOption = value!;
        });
        await widget.onSelected(value!);
      },
    );
  }
}
