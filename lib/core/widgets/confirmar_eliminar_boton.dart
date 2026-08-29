import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Botón de eliminar con confirmación EN LÍNEA — sin showDialog, sin
/// Navigator, sin overlay de ningún tipo. Un primer toque cambia el ícono
/// de basura por un check (confirmar) y una X (cancelar), pura
/// reconstrucción de este widget vía setState; el segundo toque (el check)
/// dispara [onConfirmado]. Existe porque los 4 flujos de borrado del panel
/// admin usaban AlertDialog + showDialog para confirmar y reportaban
/// pantalla en blanco de forma consistente al usarlos (incluso en
/// incógnito, sin caché ni sesión vieja de por medio) — este widget quita
/// esa pieza compartida de la ecuación por completo.
class ConfirmarEliminarBoton extends StatefulWidget {
  final VoidCallback onConfirmado;

  /// Corre ANTES de pasar a modo confirmación — si devuelve un texto no
  /// nulo, se muestra ese texto en vez de dejar confirmar (p. ej. "esta
  /// categoría todavía tiene 3 subcategorías"). Si devuelve null, se
  /// procede a pedir confirmación normalmente.
  final Future<String?> Function()? validarAntes;
  final String tooltip;

  /// Texto de advertencia que se muestra al pasar a modo confirmación
  /// (p. ej. "se borra el negocio con TODAS sus fotos, puntajes e
  /// historial"). Si es null, solo aparecen los botones de confirmar.
  final String? advertencia;

  const ConfirmarEliminarBoton({
    super.key,
    required this.onConfirmado,
    this.validarAntes,
    this.tooltip = 'Eliminar',
    this.advertencia,
  });

  @override
  State<ConfirmarEliminarBoton> createState() => _ConfirmarEliminarBotonState();
}

class _ConfirmarEliminarBotonState extends State<ConfirmarEliminarBoton> {
  bool _confirmando = false;
  bool _validando = false;

  Future<void> _alTocarEliminar() async {
    if (widget.validarAntes == null) {
      setState(() => _confirmando = true);
      return;
    }
    setState(() => _validando = true);
    final bloqueo = await widget.validarAntes!();
    if (!mounted) return;
    if (bloqueo != null) {
      setState(() => _validando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(bloqueo), duration: const Duration(seconds: 6)),
      );
      return;
    }
    setState(() {
      _validando = false;
      _confirmando = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_validando) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
            width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (_confirmando) {
      final botones = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: NVColors.error),
            tooltip: 'Sí, eliminar definitivamente',
            onPressed: () {
              setState(() => _confirmando = false);
              widget.onConfirmado();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined,
                color: NVColors.textoSecundario),
            tooltip: 'Cancelar',
            onPressed: () => setState(() => _confirmando = false),
          ),
        ],
      );
      if (widget.advertencia == null) return botones;
      return Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
        decoration: BoxDecoration(
          color: NVColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NVColors.error),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(widget.advertencia!,
                  style: const TextStyle(
                      fontSize: 12, color: NVColors.error)),
            ),
            botones,
          ],
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.delete_outline),
      tooltip: widget.tooltip,
      onPressed: _alTocarEliminar,
    );
  }
}
