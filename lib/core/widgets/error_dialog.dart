import 'package:flutter/material.dart';

/// Error de borrado — SnackBar (Overlay vía ScaffoldMessenger), no
/// showDialog/AlertDialog (Navigator). Los flujos de borrado del panel
/// admin reportaban pantalla en blanco de forma consistente al usar
/// showDialog para confirmar o para mostrar el error, incluso en
/// incógnito — este archivo evita esa ruta por completo. Detecta el error
/// de "on delete restrict" de Postgres y lo traduce a un mensaje
/// entendible en vez de mostrar el texto crudo de la excepción.
void mostrarErrorEliminar(BuildContext context, Object error) {
  final texto = error.toString().replaceFirst('Exception: ', '');
  final esRestriccion =
      texto.contains('foreign key constraint') || texto.contains('violates');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        esRestriccion
            ? 'No se puede eliminar: otro registro todavía lo usa.'
            : texto,
      ),
      duration: const Duration(seconds: 6),
    ),
  );
}
