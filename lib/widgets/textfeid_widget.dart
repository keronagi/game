import 'package:flutter/material.dart';

Widget buildInputField({
  required String label,
  required TextEditingController controller,
  required bool isEnabled,
}) {
  return TextField(
    controller: controller,
    enabled: isEnabled,
    textAlign: TextAlign.right,
    textDirection: TextDirection.rtl,
    decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
  );
}
