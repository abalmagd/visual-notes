import 'package:flutter/material.dart';

class InputFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String label;
  final String validate;

  const InputFormField({
    Key? key,
    required this.controller,
    required this.type,
    required this.label,
    required this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (value) {
        if (value!.isEmpty) return validate;

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
