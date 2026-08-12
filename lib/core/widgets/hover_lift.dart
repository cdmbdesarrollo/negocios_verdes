import 'package:flutter/material.dart';

/// Envuelve cualquier tarjeta tocable y la levanta sutilmente al pasar el
/// mouse por encima (escala + traslación hacia arriba) — en touch/mobile
/// no pasa nada porque no hay evento de hover, se queda con el feedback
/// normal del InkWell interno. Es la diferencia entre una tarjeta que se
/// ve estática (como una maqueta) y una que se siente interactiva.
class HoverLift extends StatefulWidget {
  final Widget child;

  const HoverLift({super.key, required this.child});

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: _hover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -4 : 0, 0),
          child: widget.child,
        ),
      ),
    );
  }
}
