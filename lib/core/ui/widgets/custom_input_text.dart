import 'package:flutter/material.dart';

class CustomInputText extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const CustomInputText({
    Key? key,
    required this.label,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        label,
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      const SizedBox(height: 10.0),
      TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black.withOpacity(0.5),
          border: const OutlineInputBorder(),
        ),
      ),
    ]);
  }
}
