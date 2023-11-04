// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;
  const CustomProgressBar({
    Key? key,
    required this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: Colors.green,
      backgroundColor: Colors.black.withOpacity(0.5),
      minHeight: 30,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      value: value,
    );
  }
}
