import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Barra de paginación reutilizable para las listas del admin. Va ARRIBA de
/// la lista (no como pie fijo) porque el `FloatingActionButton` flota abajo
/// a la derecha y tapaba los botones de página. Botones con texto
/// ("Anterior" / "Siguiente"), no solo flechas, para que se vean.
class BarraPaginacion extends StatelessWidget {
  final int desde; // 1-indexado
  final int hasta;
  final int total;
  final int pagina; // 0-indexado
  final int totalPaginas;
  final ValueChanged<int> onCambioPagina;

  const BarraPaginacion({
    super.key,
    required this.desde,
    required this.hasta,
    required this.total,
    required this.pagina,
    required this.totalPaginas,
    required this.onCambioPagina,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: NVColors.borde)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            '$desde–$hasta de $total  ·  página ${pagina + 1} de $totalPaginas',
            style: const TextStyle(
                color: NVColors.textoSecundario, fontSize: 13),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.chevron_left, size: 18),
            label: const Text('Anterior'),
            onPressed: pagina > 0 ? () => onCambioPagina(pagina - 1) : null,
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.chevron_right, size: 18),
            label: const Text('Siguiente'),
            onPressed: pagina < totalPaginas - 1
                ? () => onCambioPagina(pagina + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
