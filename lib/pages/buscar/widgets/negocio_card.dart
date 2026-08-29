import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/avalado_badge.dart';
import '../../../core/widgets/emprendimiento_verde_badge.dart';
import '../../../core/widgets/sello_marca_badge.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/negocio.dart';
import '../../../models/subcategoria.dart';
import '../../../theme/nv_colors.dart';

/// Tarjeta de negocio reusada en BuscarPage (lista de resultados) y en el
/// carrusel de destacados de InicioPage.
class NegocioCard extends StatelessWidget {
  final Negocio negocio;
  final bool seleccionado;
  final VoidCallback? onVerEnMapa;

  const NegocioCard({
    super.key,
    required this.negocio,
    this.seleccionado = false,
    this.onVerEnMapa,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return Material(
      color: NVColors.superficie,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/negocio/${negocio.slug}'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            border: Border.all(
              color: seleccionado ? NVColors.accent : NVColors.borde,
              width: seleccionado ? 2 : 1,
            ),
          ),
          child: Row(
            // Nota: NO usar IntrinsicHeight aquí para igualar la altura de
            // la imagen con el texto — IntrinsicHeight + stretch rompe el
            // hit-testing en desktop quando envuelve algo con InkWell (bug
            // real ya documentado en el CLAUDE.md de HuellaQR). Se usa una
            // altura fija en su lugar.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // 128 de ancho (antes 100): la mayoría de los logos reales
                // son cuadrados o más anchos que altos, y con BoxFit.contain
                // en una casilla angosta ese sobrante de ancho se traduce
                // en aire vacío arriba/abajo — el logo se veía chico dentro
                // de su propia casilla aunque el contenedor no lo fuera
                // (reportado con captura real). Ancho = alto (casilla
                // cuadrada) le da más margen a un logo panorámico antes de
                // toparse con esa restricción. El alto se queda en 128 a
                // propósito — subirlo también rompería el mainAxisExtent
                // fijo de la grilla de destacados en InicioPage.
                width: 128,
                height: 128,
                // Blanco, no verde: la mayoría de los negocios suben su
                // logo tal cual, que casi siempre ya trae fondo blanco
                // propio — sobre un tinte verde se veía como un recuadro
                // desencajado en vez de integrarse. Padding mínimo (antes
                // 8) para que el logo ocupe casi toda la casilla.
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                alignment: Alignment.center,
                child: negocio.fotoPortadaUrl != null &&
                        negocio.fotoPortadaUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: negocio.fotoPortadaUrl!, fit: BoxFit.contain)
                    // Sin foto todavía (la foto ya no es obligatoria para
                    // publicar, ver 0024_foto_portada_opcional.sql) — el
                    // logo de Negocios Verdes en vez de un ícono genérico
                    // de "falta imagen".
                    : Image.asset(
                        'assets/images/iconografia/logo_negocios_verdes.png',
                        fit: BoxFit.contain,
                      ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                negocio.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            if (onVerEnMapa != null && negocio.tieneUbicacion)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.place_outlined,
                                    size: 20, color: NVColors.verdeVivo),
                                tooltip: 'Ver en el mapa',
                                onPressed: onVerEnMapa,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        if (negocio.categoriaOficial != null)
                          _tocable(
                            onTap: () => _irABuscar(
                                context, {'categoria': negocio.categoriaOficial!.slug}),
                            child: Text(
                              '${negocio.categoriaOficial!.iconoOTexto} '
                              '${negocio.categoriaOficial!.nombre}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: NVColors.textoSecundario, fontSize: 12),
                            ),
                          ),
                        if (negocio.descripcionCorta != null &&
                            negocio.descripcionCorta!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            negocio.descripcionCorta!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (negocio.emprendimientoVerde)
                              _tocable(
                                onTap: () => _irABuscar(
                                    context, const {'emprendimiento': '1'}),
                                child: const EmprendimientoVerdeBadge(
                                    tamanoFuente: 10),
                              ),
                            if (negocio.selloMarca)
                              _tocable(
                                onTap: () => _irABuscar(
                                    context, const {'sello': '1'}),
                                child: const SelloMarcaBadge(tamanoFuente: 10),
                              ),
                            if (negocio.avalado)
                              _tocable(
                                onTap: () => _irABuscar(
                                    context, const {'avalado': '1'}),
                                child: const AvaladoBadge(tamanoFuente: 10),
                              ),
                            // Municipio y subcategoría como tags aparte del
                            // nombre de categoría de arriba — de un vistazo,
                            // sin tener que abrir la ficha del negocio.
                            // Todas navegan a /buscar con ese filtro puesto
                            // (pedido explícito) en vez de solo decorar.
                            _tag(
                              negocio.municipio,
                              icono: Icons.place_outlined,
                              onTap: () => _irABuscar(
                                  context, {'municipio': negocio.municipio}),
                            ),
                            for (final sub in negocio.subcategorias.take(2))
                              _tag(
                                sub.nombre,
                                onTap: () => _irABuscar(context, {
                                  if (_categoriaDeSubcategoria(sub) != null)
                                    'categoria':
                                        _categoriaDeSubcategoria(sub)!.slug,
                                  'subcategoria': sub.slug,
                                }),
                              ),
                            if (!negocio.tieneUbicacion)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: NVColors.borde,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Sin ubicación en el mapa',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: NVColors.textoSecundario),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _tag(String texto, {IconData? icono, VoidCallback? onTap}) {
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: NVColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null) ...[
            Icon(icono, size: 10, color: NVColors.primaryDark),
            const SizedBox(width: 3),
          ],
          Text(
            texto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 10,
                color: NVColors.primaryDark,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
    return onTap == null ? chip : _tocable(onTap: onTap, child: chip);
  }

  /// InkWell propio, ANIDADO adentro del InkWell grande de toda la
  /// tarjeta (que navega a la ficha) — Flutter resuelve el gesto al más
  /// específico sin necesitar nada especial, mismo criterio ya probado acá
  /// con el botón "ver en mapa". BorderRadius genérico para el ripple, no
  /// necesita calzar exacto con la forma de cada insignia.
  Widget _tocable({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: child,
      ),
    );
  }

  /// Pedido explícito: cada insignia/tag de la tarjeta debe llevar a
  /// /buscar ya filtrado por ese criterio, no solo decorar. Usa el mismo
  /// negocio (sin pedir nada al servidor) — la categoría/subcategoría que
  /// trae embebida son justamente las de ESTE negocio.
  void _irABuscar(BuildContext context, Map<String, String> parametros) {
    final uri = Uri(path: '/buscar', queryParameters: parametros);
    context.go(uri.toString());
  }

  CategoriaOficial? _categoriaDeSubcategoria(Subcategoria sub) {
    for (final c in negocio.categoriasOficiales) {
      if (c.id == sub.categoriaOficialId) return c;
    }
    return null;
  }
}

