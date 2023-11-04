import 'package:flutter/material.dart';
import 'package:flutter_manifest_creator/core/resources.dart';

class CustomElevatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  const CustomElevatedButton({
    Key? key,
    required this.label,
    this.onPressed,
  }) : super(key: key);
  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  Resources.buttonImage), // Replace with your image asset
              fit: BoxFit.fill,
            ),
            border: _isHovered
                ? Border.all(color: Colors.white, width: 2)
                : Border.all(color: Colors.transparent, width: 2),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
