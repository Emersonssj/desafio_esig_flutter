import 'package:flutter/material.dart';

Widget buildCheckItemWidget(String title, bool isValid) {
  return Row(
    children: [
      Icon(
        isValid ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isValid ? Colors.green : Colors.grey,
        size: 20,
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(
          color: isValid ? Colors.green : Colors.grey,
          decoration: isValid ? TextDecoration.lineThrough : null,
        ),
      ),
    ],
  );
}
