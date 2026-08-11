import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Ícono de una categoría o subcategoría: la imagen subida desde el admin
/// si existe, si no el emoji de texto (ver iconoOTexto en los modelos).
/// Un solo lugar para esta decisión — se usa en tarjetas de categoría y en
/// las listas de /admin/categorias y /admin/subcategorias.
class IconoEtiqueta extends StatelessWidget {
  final String? iconoUrl;
  final String iconoTexto;
  final double tamano;

  const IconoEtiqueta({
    super.key,
    required this.iconoUrl,
    required this.iconoTexto,
    this.tamano = 20,
  });

  @override
  Widget build(BuildContext context) {
    if (iconoUrl != null && iconoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: iconoUrl!,
        width: tamano,
        height: tamano,
        fit: BoxFit.contain,
      );
    }
    return Text(iconoTexto, style: TextStyle(fontSize: tamano));
  }
}
