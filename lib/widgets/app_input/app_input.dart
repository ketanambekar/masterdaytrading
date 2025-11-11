import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String hint;
  final RxString text;
  final bool obscureText;
  final TextInputType keyboardType;

  const AppInput({
    super.key,
    required this.label,
    required this.hint,
    required this.text,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isFocused = ValueNotifier(false);
    final FocusNode focusNode = FocusNode();

    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });

    return ValueListenableBuilder<bool>(
      valueListenable: isFocused,
      builder: (context, hasFocus, _) {
        return Obx(() => TextField(
          focusNode: focusNode,
          onChanged: (val) => text.value = val,
          controller: TextEditingController(text: text.value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: text.value.length),
            ),
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            labelStyle:  TextStyle(fontWeight: FontWeight.w500, color: Colors.orange.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.orange.shade400,
                width: 2,
              ),
            ),
          ),
        ));
      },
    );
  }
}
