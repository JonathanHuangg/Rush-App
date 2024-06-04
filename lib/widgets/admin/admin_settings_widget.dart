import 'package:flutter/material.dart';

// widget definition
class TextAndCheckBox extends StatefulWidget {
  const TextAndCheckBox({super.key});

  @override 
  State<TextAndCheckBox> createState() => TextAndCheckBoxState();
}

class TextAndCheckBoxState extends State<TextAndCheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {

    // If the states are in any of the interacted states, change color to blue
    // otherwise, keep as red
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
      };

      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
    
    return Checkbox( 
      checkColor: Colors.white, // color of checkmark
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      }
    );
  }
}