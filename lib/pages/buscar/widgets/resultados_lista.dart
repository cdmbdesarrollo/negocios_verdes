import 'package:flutter/material.dart';

import '../../../models/negocio.dart';
import '../../../theme/nv_colors.dart';
import 'negocio_card.dart';

class ResultadosLista extends StatelessWidget {
  final List<Negocio> negocios;
  final Map<String, GlobalKey> clavesPorNegocio;
  final String? negocioSeleccionadoId;
  final void Function(Negocio negocio)? onVerEnMapa;

  const ResultadosLista({
    super.key,
    required this.negocios,
    required this.clavesPorNegocio,
    this.negocioSeleccionadoId,
    this.onVerEnMapa,
  });

  @override
  Widget build(BuildContext context) {
    if (negocios.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No encontramos negocios con estos filtros. Prueba con otra '
            'búsqueda o quita algún filtro.',
            textAlign: TextAlign.center,
            style: TextStyle(color: NVColors.textoSecundario),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: negocios.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final negocio = negocios[i];
        final clave = clavesPorNegocio.putIfAbsent(negocio.id, () => GlobalKey());
        return KeyedSubtree(
          key: clave,
          child: NegocioCard(
            negocio: negocio,
            seleccionado: negocio.id == negocioSeleccionadoId,
            onVerEnMapa:
                onVerEnMapa != null ? () => onVerEnMapa!(negocio) : null,
          ),
        );
      },
    );
  }
}
