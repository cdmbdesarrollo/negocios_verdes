import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Diálogo de borrado con DOBLE confirmación: además de los botones
/// Cancelar / Eliminar, hay que marcar una casilla ("Entiendo que no se
/// puede deshacer") para habilitar el botón. Para acciones destructivas del
/// panel admin (borrar un negocio, borrar una persona de sus bases).
/// Devuelve `true` solo si se confirmó de las dos formas.
class DialogoConfirmarBorrado extends StatefulWidget {
  final String titulo;
  final String advertencia;
  final String etiquetaConfirmar;

  const DialogoConfirmarBorrado({
    super.key,
    required this.titulo,
    required this.advertencia,
    this.etiquetaConfirmar = 'Eliminar',
  });

  @override
  State<DialogoConfirmarBorrado> createState() =>
      _DialogoConfirmarBorradoState();
}

class _DialogoConfirmarBorradoState extends State<DialogoConfirmarBorrado> {
  bool _entendido = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded, color: NVColors.error),
      title: Text(widget.titulo),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.advertencia),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
              value: _entendido,
              onChanged: (v) => setState(() => _entendido = v ?? false),
              title: const Text('Entiendo que esta acción no se puede deshacer.',
                  style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: NVColors.error),
          onPressed:
              _entendido ? () => Navigator.pop(context, true) : null,
          child: Text(widget.etiquetaConfirmar),
        ),
      ],
    );
  }
}
