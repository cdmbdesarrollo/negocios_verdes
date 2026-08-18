import 'package:flutter/material.dart';

import '../../../core/widgets/hover_lift.dart';
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: NVColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                // Oso de anteojos (iconografía de marca) en vez del ícono
                // genérico -- misma idea del badge, pero con algo de
                // personalidad para un estado que de otro modo es solo
                // texto vacío.
                child: Image.asset(
                  'assets/images/iconografia/oso_anteojos_2.png',
                  width: 42,
                  height: 42,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No encontramos negocios con estos filtros',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              const Text(
                'Prueba con otra búsqueda o quita algún filtro.',
                textAlign: TextAlign.center,
                style: TextStyle(color: NVColors.textoSecundario, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: negocios.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final negocio = negocios[i];
        final clave = clavesPorNegocio.putIfAbsent(negocio.id, () => GlobalKey());
        return KeyedSubtree(
          key: clave,
          child: HoverLift(
            child: NegocioCard(
              negocio: negocio,
              seleccionado: negocio.id == negocioSeleccionadoId,
              onVerEnMapa:
                  onVerEnMapa != null ? () => onVerEnMapa!(negocio) : null,
            ),
          ),
        );
      },
    );
  }
}
