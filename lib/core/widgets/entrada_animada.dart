import 'package:flutter/material.dart';

/// Fade + deslizamiento hacia arriba al montar el widget, con [retraso]
/// opcional — usado para escalonar la entrada de varias secciones en fila
/// (retraso creciente en cada una) en vez de que toda la página aparezca
/// de golpe. Cada instancia maneja su propio AnimationController (más
/// simple que coordinar Intervals sobre uno solo compartido), y como
/// arranca al montar (no al entrar en el viewport), solo se nota de
/// verdad en lo que ya está visible en la carga inicial — el resto ya
/// habrá terminado de animar para cuando el usuario llegue ahí con
/// scroll, lo cual está bien: no hace falta detección de visibilidad.
class EntradaAnimada extends StatefulWidget {
  final Widget child;
  final Duration retraso;

  const EntradaAnimada({super.key, required this.child, this.retraso = Duration.zero});

  @override
  State<EntradaAnimada> createState() => _EntradaAnimadaState();
}

class _EntradaAnimadaState extends State<EntradaAnimada>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador;
  late final Animation<double> _opacidad;
  late final Animation<Offset> _desplazamiento;

  @override
  void initState() {
    super.initState();
    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacidad = CurvedAnimation(parent: _controlador, curve: Curves.easeOut);
    _desplazamiento = Tween(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controlador, curve: Curves.easeOut));
    Future.delayed(widget.retraso, () {
      if (mounted) _controlador.forward();
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacidad,
      child: SlideTransition(position: _desplazamiento, child: widget.child),
    );
  }
}
