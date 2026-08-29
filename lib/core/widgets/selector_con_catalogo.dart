import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Dropdown respaldado por un catálogo en la base de datos (ver
/// opciones_campo / OpcionCampoService) en vez de texto libre — para que
/// un campo categórico (Sí/No/Pendiente/No aplica y similares) siempre
/// tenga el mismo valor exacto sin importar quién lo edite, algo
/// imposible de garantizar con un TextFormField. La última opción de la
/// lista es siempre "+ Agregar opción nueva…": si CDMB necesita un valor
/// que todavía no existe, lo agrega ahí mismo sin salir del formulario ni
/// depender de que alguien lo escriba a mano en otro lado.
class SelectorConCatalogo extends StatelessWidget {
  final String etiqueta;
  final String? valor;
  final List<String> opciones;
  final ValueChanged<String?> onCambio;
  final Future<void> Function(BuildContext context) onAgregarOpcion;

  /// Ícono a la izquierda del campo — para que la ficha se lea "de un
  /// vistazo por el dato" (pedido explícito: que se sienta un sistema de
  /// información real, no una lista de desplegables iguales).
  final IconData? icono;

  const SelectorConCatalogo({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.opciones,
    required this.onCambio,
    required this.onAgregarOpcion,
    this.icono,
  });

  static const _agregarNueva = '__agregar_nueva__';

  @override
  Widget build(BuildContext context) {
    // El valor actual puede no estar todavía en el catálogo (ej. viene de
    // una carga de datos vieja con un texto distinto) — se agrega igual a
    // la lista para no perderlo silenciosamente ni romper el dropdown con
    // un value que no matchea ningún item.
    final items = [
      if (valor != null && valor!.isNotEmpty && !opciones.contains(valor))
        valor!,
      ...opciones,
    ];
    return DropdownButtonFormField<String>(
      initialValue: valor != null && items.contains(valor) ? valor : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: icono == null
            ? null
            : Icon(icono, size: 20, color: NVColors.primary),
      ),
      items: [
        for (final o in items) DropdownMenuItem(value: o, child: Text(o)),
        const DropdownMenuItem(
          value: _agregarNueva,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16, color: NVColors.primary),
              SizedBox(width: 6),
              Text('Agregar opción nueva…',
                  style: TextStyle(color: NVColors.primary)),
            ],
          ),
        ),
      ],
      onChanged: (v) async {
        if (v == _agregarNueva) {
          await onAgregarOpcion(context);
          return;
        }
        onCambio(v);
      },
    );
  }
}
