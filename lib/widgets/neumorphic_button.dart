import 'package:flutter/material.dart';

class NeumorphicButton extends StatefulWidget {
  double? size = 30;
  double? width;
  double? height;
  final VoidCallback onPressed;
  final Widget child;
  double? radius;
  Color? backgroundColor;
  Gradient? gradient;
  Color? borderColor;

  NeumorphicButton(
      {super.key,
      this.size,
      required this.onPressed,
      required this.child,
      this.radius,
      this.backgroundColor,
      this.gradient,
      this.borderColor,
      this.width,
      this.height});

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _pressed = false;

  void _onTap() {
    setState(() {
      _pressed = true;
    });
    widget.onPressed.call();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _pressed = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: widget.width ?? widget.size,
        height: widget.height ?? widget.size,
        decoration: BoxDecoration(
          color: (widget.gradient == null && widget.backgroundColor != null)
              ? widget.backgroundColor
              : const Color(0xFFEFF0F3),
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(widget.radius ?? 20),
          border: Border.all(
              color: _pressed
                  ? (widget.borderColor ?? Colors.amber)
                  : Colors.transparent,
              width: 3),
          boxShadow: _pressed
              ? []
              : [
                  const BoxShadow(
                    color: Colors.white,
                    blurRadius: 30,
                    offset: Offset(-20, -20),
                  ),
                  const BoxShadow(
                    color: Color(0xFFA3B1C6),
                    blurRadius: 30,
                    offset: Offset(20, 20),
                  ),
                ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}
