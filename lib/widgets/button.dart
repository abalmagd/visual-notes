import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const Button({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 46.0,
      minWidth: double.infinity,
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
