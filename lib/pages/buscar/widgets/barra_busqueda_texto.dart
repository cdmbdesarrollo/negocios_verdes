import 'package:flutter/material.dart';

import '../../../theme/nv_colors.dart';

/// Caja de texto de búsqueda de /buscar — separada de FiltrosBar (que antes
/// la tenía adentro) para poder ubicarla aparte en el layout de escritorio:
/// ocupa todo el ancho arriba de la barra lateral de filtros + resultados,
/// en vez de angostarse junto con los chips dentro de una columna lateral.
/// Mismo controller/lifecycle que tenía dentro de FiltrosBar, solo que
/// ahora en su propio widget — sin esto, cada letra tecleada perdería el
/// cursor al reconstruirse desde un TextEditingController nuevo.
class BarraBusquedaTexto extends StatefulWidget {
  final String query;
  final ValueChanged<String> onCambio;

  const BarraBusquedaTexto({
    super.key,
    required this.query,
    required this.onCambio,
  });

  @override
  State<BarraBusquedaTexto> createState() => _BarraBusquedaTextoState();
}

class _BarraBusquedaTextoState extends State<BarraBusquedaTexto> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant BarraBusquedaTexto oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Solo sincroniza si el cambio vino de afuera (ej. se limpió desde otro
    // lado) — si viniera de este mismo TextField perdería el cursor.
    if (widget.query != _ctrl.text && widget.query != oldWidget.query) {
      _ctrl.text = widget.query;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText:
            'Buscar negocios verdes (ej. agricultura orgánica, turismo sostenible...)',
        hintStyle: const TextStyle(fontSize: 13.5),
        prefixIcon: const Icon(Icons.search, color: NVColors.primary),
        suffixIcon: widget.query.isNotEmpty
            ? IconButton(
                tooltip: 'Borrar búsqueda',
                icon: const Icon(Icons.close),
                onPressed: () {
                  _ctrl.clear();
                  widget.onCambio('');
                },
              )
            : null,
        filled: true,
        fillColor: NVColors.superficie,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: NVColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: NVColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(26),
          borderSide: const BorderSide(color: NVColors.primary, width: 1.5),
        ),
      ),
      onChanged: widget.onCambio,
    );
  }
}
