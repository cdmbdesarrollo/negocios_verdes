import 'package:flutter/material.dart';

/// Diálogo de error para acciones de borrado — un SnackBar es fácil de no
/// ver (aparece abajo, se autodescarta); esto obliga a leerlo y cerrarlo a
/// propósito. Detecta el error de "on delete restrict" de Postgres (algún
/// negocio o subcategoría todavía usa el registro) y lo traduce a un
/// mensaje entendible en vez de mostrar el texto crudo de la excepción.
Future<void> mostrarErrorEliminar(BuildContext context, Object error) {
  final texto = error.toString().replaceFirst('Exception: ', '');
  final esRestriccion =
      texto.contains('foreign key constraint') || texto.contains('violates');
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(esRestriccion ? 'No se puede eliminar todavía' : 'Ocurrió un error'),
      content: Text(
        esRestriccion
            ? 'Uno o más negocios (o subcategorías) todavía usan este '
                'elemento. Quítalo de ahí primero, o desactívalo en vez de '
                'eliminarlo si quieres dejar de mostrarlo sin borrarlo.'
            : texto,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
}
