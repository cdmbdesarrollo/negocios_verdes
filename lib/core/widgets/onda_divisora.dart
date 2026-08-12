import 'package:flutter/material.dart';

/// Transición ondulada entre dos secciones de color sólido — en vez del
/// corte recto de siempre entre bloques de color. Pinta su PROPIO fondo
/// completo primero ([colorFondo], el color de la sección de la que
/// "sale") y encima la curva ([colorOnda], el color de la sección a la
/// que "entra") — así nunca depende de qué haya detrás en el árbol de
/// widgets, autónomo de verdad. Es una franja delgada propia en el flujo
/// (no un ClipPath sobre contenido real), así nunca recorta nada por
/// accidente. Un guiño de marca (montañas, ríos) para un directorio de
/// negocios verdes, sin depender de ningún asset externo.
class OndaDivisora extends StatelessWidget {
  final Color colorFondo;
  final Color colorOnda;
  final double altura;

  const OndaDivisora({
    super.key,
    required this.colorFondo,
    required this.colorOnda,
    this.altura = 34,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: altura,
      child: CustomPaint(
        painter: _OndaPainter(colorFondo: colorFondo, colorOnda: colorOnda),
      ),
    );
  }
}

class _OndaPainter extends CustomPainter {
  final Color colorFondo;
  final Color colorOnda;

  const _OndaPainter({required this.colorFondo, required this.colorOnda});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = colorFondo);
    final paint = Paint()..color = colorOnda;
    final path = Path()
      ..moveTo(0, size.height * 0.55)
      ..quadraticBezierTo(
          size.width * 0.25, 0, size.width * 0.5, size.height * 0.4)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.8, size.width, size.height * 0.2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OndaPainter oldDelegate) =>
      oldDelegate.colorFondo != colorFondo || oldDelegate.colorOnda != colorOnda;
}
