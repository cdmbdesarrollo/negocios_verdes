import 'package:flutter/widgets.dart';

/// Punto de quiebre único para todo el sitio. Por debajo: una columna, menús
/// colapsados, toggle lista/mapa. Desde acá: navbar completa y, en
/// BuscarPage, lista+mapa lado a lado sin pestañas.
const double kAnchoPantallaAncha = 900;

bool esPantallaAncha(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= kAnchoPantallaAncha;
