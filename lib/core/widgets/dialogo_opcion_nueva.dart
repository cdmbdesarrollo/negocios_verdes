import 'package:flutter/material.dart';

import '../texto_utils.dart';

/// Resultado de [pedirOpcionNueva]: el valor a usar y si hay que crearlo en
/// el catálogo (false = ya existía y se reusa tal cual).
typedef OpcionElegida = ({String valor, bool esNueva});

/// Pide un valor nuevo para un catálogo parametrizado (opciones_campo) y
/// evita que entren variantes del mismo valor — pedido explícito con el
/// cargo de responsables/delegados: que no pase que uno escriba
/// "Responsable" y otro "Responsabe" o "responsable ".
///
/// * Igual a uno existente sin contar mayúsculas, tildes ni espacios
///   → se usa el existente, sin preguntar.
/// * Muy parecido a uno existente (1-2 letras de diferencia, típico error
///   de tipeo) → se pregunta si quiso decir ese.
/// * Si no, es nuevo.
///
/// Devuelve null si se canceló.
Future<OpcionElegida?> pedirOpcionNueva(
  BuildContext context, {
  required List<String> existentes,
  String etiqueta = 'Valor',
}) async {
  final controller = TextEditingController();
  final escrito = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Agregar opción nueva'),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: etiqueta),
        onSubmitted: (v) => Navigator.pop(dialogContext, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(dialogContext, controller.text),
          child: const Text('Agregar'),
        ),
      ],
    ),
  );
  controller.dispose();
  final valor = _limpiar(escrito ?? '');
  if (valor.isEmpty) return null;

  final clave = _clave(valor);
  for (final e in existentes) {
    if (_clave(e) == clave) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('"$e" ya existía en la lista — se usa esa.')));
      }
      return (valor: e, esNueva: false);
    }
  }

  final parecida = _masParecida(clave, existentes);
  if (parecida != null && context.mounted) {
    final usarExistente = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Quisiste decir…?'),
        content: Text(
            'Escribiste "$valor", que se parece mucho a "$parecida", que ya '
            'está en la lista. Para no tener dos versiones del mismo valor, '
            'usa la existente salvo que de verdad sea otra cosa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Agregar "$valor" igual'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Usar "$parecida"'),
          ),
        ],
      ),
    );
    if (usarExistente == null) return null;
    if (usarExistente) return (valor: parecida, esNueva: false);
  }
  return (valor: valor, esNueva: true);
}

/// Espacios de más fuera y adentro, primera letra en mayúscula — así todas
/// las opciones nuevas quedan con la misma forma ("Profesional
/// especializado", no "  profesional  especializado").
String _limpiar(String texto) {
  final t = texto.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (t.isEmpty) return t;
  return t[0].toUpperCase() + t.substring(1);
}

String _clave(String texto) =>
    quitarTildes(texto.trim().toLowerCase()).replaceAll(RegExp(r'\s+'), ' ');

/// La opción existente más cercana si está a 1 letra (textos cortos) o 2
/// (textos de 6+ letras) de distancia; null si ninguna se parece tanto.
String? _masParecida(String clave, List<String> existentes) {
  String? mejor;
  var mejorDistancia = 1 << 30;
  final tope = clave.length >= 6 ? 2 : 1;
  for (final e in existentes) {
    final d = _distancia(clave, _clave(e));
    if (d <= tope && d < mejorDistancia) {
      mejor = e;
      mejorDistancia = d;
    }
  }
  return mejor;
}

/// Distancia de Levenshtein (inserciones, borrados y cambios de letra).
int _distancia(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var anterior = List<int>.generate(b.length + 1, (j) => j);
  for (var i = 1; i <= a.length; i++) {
    final actual = List<int>.filled(b.length + 1, 0)..[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final costo = a[i - 1] == b[j - 1] ? 0 : 1;
      actual[j] = [
        anterior[j] + 1,
        actual[j - 1] + 1,
        anterior[j - 1] + costo,
      ].reduce((x, y) => x < y ? x : y);
    }
    anterior = actual;
  }
  return anterior[b.length];
}
