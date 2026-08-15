import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

class ChipFiltro extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;
  final String? icono;

  /// Estilo de contorno (sin relleno) en vez del relleno sólido de
  /// siempre — para filtros que dependen/anidan bajo otro (p. ej.
  /// subcategoría bajo categoría), así se distinguen a simple vista en
  /// vez de leerse como "más chips del mismo nivel".
  final bool variante;

  /// Ancho mínimo opcional — sin esto, cada chip mide justo lo que su
  /// etiqueta necesita, así que una lista con nombres muy dispares (p. ej.
  /// "Biocomercio" junto a "Aprovechamiento y valorización de residuos")
  /// se ve despareja. Es mínimo, no fijo: una etiqueta más larga que
  /// [anchoMinimo] igual crece lo que necesite, nunca se trunca. A
  /// propósito NO se envuelve el label en Center/Align sin widthFactor —
  /// eso rompió esto una vez ya (Align sin widthFactor se expande a
  /// llenar el ancho disponible en vez de solo centrar en cuanto las
  /// constraints entrantes dejan de ser infinitas, que es siempre el caso
  /// dentro de un Wrap). El label se queda como Text plano; es FilterChip
  /// el que centra su contenido dentro del ancho que termine midiendo.
  final double? anchoMinimo;

  const ChipFiltro({
    super.key,
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
    this.icono,
    this.variante = false,
    this.anchoMinimo,
  });

  @override
  Widget build(BuildContext context) {
    final texto = icono != null ? '$icono $etiqueta' : etiqueta;
    Widget chip;
    if (variante) {
      chip = FilterChip(
        label: Text(texto),
        selected: seleccionado,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.transparent,
        // Relleno completo de verdeMenu al seleccionar (antes era un lavado
        // pálido de primaryLight con solo el contorno marcando el estado)
        // -- estos chips son "los botones del buscador", así que llevan el
        // mismo verde que los demás botones/menús, no verdeVivo. Texto y
        // contorno en verdeVivo (no primaryDark/primary) -- pedido
        // explícito de no dejar nada del verde institucional viejo.
        selectedColor: NVColors.verdeMenu,
        labelStyle: TextStyle(
          color: NVColors.verdeVivo,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: seleccionado ? NVColors.verdeMenu : NVColors.verdeVivo,
        ),
        checkmarkColor: NVColors.verdeVivo,
      );
    } else {
      chip = FilterChip(
        label: Text(texto),
        selected: seleccionado,
        onSelected: (_) => onTap(),
        backgroundColor: NVColors.primaryLight,
        // Relleno completo de verdeMenu (no primary) al seleccionar -- estos
        // chips son "los botones del buscador", pedido explícito de que
        // lleven el mismo verde que menús/botones. El texto pasa de blanco
        // a textoPrincipal: blanco encima de este verde es casi ilegible,
        // textoPrincipal da ~7:1.
        selectedColor: NVColors.verdeMenu,
        labelStyle: TextStyle(
          color: NVColors.textoPrincipal,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide.none,
        checkmarkColor: NVColors.textoPrincipal,
      );
    }
    // Alto MÍNIMO siempre (no solo cuando hay anchoMinimo), nunca fijo —
    // sin esto cada chip mide lo que su CONTENIDO necesite, y el contenido
    // varía de formas que no tienen que ver con el criterio real de
    // "seleccionado o no": un emoji tiene una altura de línea distinta a
    // la del texto latino de Work Sans (Skia calcula el alto de línea por
    // el glifo más alto de la línea), así que los chips con ícono salían
    // más altos que "Todas"/"Todos los municipios" (sin ícono). Primer
    // intento usó SizedBox(height: fijo) — se veía parejo en el caso
    // común, pero un chip con el emoji ♻️ (trae selector de variación,
    // más alto que el resto) necesitaba más que ese fijo y su contenido
    // terminaba amontonado/cortado. minHeight en vez de un alto fijo: es
    // un piso, nunca fuerza a nada a encogerse por debajo de lo que
    // necesita — un chip más exigente simplemente mide un poco más que
    // sus vecinos en vez de recortarse.
    Widget resultado = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 40),
      child: chip,
    );
    if (anchoMinimo != null) {
      resultado = ConstrainedBox(
        constraints: BoxConstraints(minWidth: anchoMinimo!),
        child: resultado,
      );
    }
    return resultado;
  }
}
