import 'package:flutter_test/flutter_test.dart';
import 'package:negocios_verdes_cdmb/models/filtro_busqueda.dart';

// Primera prueba real del proyecto — arranca por FiltroBusqueda porque es
// lógica pura (sin Supabase, sin widgets) y de alto riesgo real: es el
// puente entre la URL compartible de /buscar y los filtros que de verdad
// se aplican contra la base de datos. Un campo nuevo que se agregue a la
// clase pero se olvide en toQueryParameters/fromQueryParameters se
// rompería en silencio — exactamente el tipo de bug que un test barato
// como este detecta antes que un usuario.
void main() {
  group('FiltroBusqueda.toQueryParameters', () {
    test('filtro vacío no genera ningún parámetro', () {
      const filtro = FiltroBusqueda();
      expect(filtro.toQueryParameters(), isEmpty);
    });

    test('cada campo se serializa con su propia clave', () {
      const filtro = FiltroBusqueda(
        query: 'apicultura',
        municipio: 'Girón',
        categoriaSlug: 'bioproductos-servicios-sostenibles',
        subcategoriaSlug: 'agrosistemas-sostenibles',
        actividadSlug: 'agricultura-organica',
        vista: VistaResultados.mapa,
      );
      expect(filtro.toQueryParameters(), {
        'q': 'apicultura',
        'municipio': 'Girón',
        'categoria': 'bioproductos-servicios-sostenibles',
        'subcategoria': 'agrosistemas-sostenibles',
        'actividad': 'agricultura-organica',
        'vista': 'mapa',
      });
    });

    test('vista lista (default) no aparece en la URL — solo mapa la necesita', () {
      const filtro = FiltroBusqueda(municipio: 'Tona');
      expect(filtro.toQueryParameters().containsKey('vista'), isFalse);
    });

    test('nivel/sello/aval — nivel es texto plano, sello/aval son "1" solo si son true', () {
      const filtro = FiltroBusqueda(
        nivelDesarrollo: 'verificado',
        selloMarca: true,
        avalConfianza: true,
      );
      expect(filtro.toQueryParameters(), {
        'nivel': 'verificado',
        'sello': '1',
        'aval': '1',
      });
      // false no es "lo contrario de true" para estos dos — es lo mismo
      // que no filtrar, así que no debe aparecer en la URL en absoluto
      // (nadie comparte un link pidiendo "sin Sello Marca").
      const filtroFalse = FiltroBusqueda(selloMarca: false, avalConfianza: false);
      expect(filtroFalse.toQueryParameters(), isEmpty);
    });
  });

  group('FiltroBusqueda.fromQueryParameters', () {
    test('parámetros vacíos producen el filtro por defecto', () {
      final filtro = FiltroBusqueda.fromQueryParameters(const {});
      expect(filtro.query, isEmpty);
      expect(filtro.municipio, isNull);
      expect(filtro.categoriaSlug, isNull);
      expect(filtro.subcategoriaSlug, isNull);
      expect(filtro.actividadSlug, isNull);
      expect(filtro.vista, VistaResultados.lista);
    });

    test('"vista=mapa" activa VistaResultados.mapa, cualquier otro valor cae a lista', () {
      expect(
        FiltroBusqueda.fromQueryParameters(const {'vista': 'mapa'}).vista,
        VistaResultados.mapa,
      );
      expect(
        FiltroBusqueda.fromQueryParameters(const {'vista': 'lo-que-sea'}).vista,
        VistaResultados.lista,
      );
    });

    test('"sello=1"/"aval=1" activan el filtro, cualquier otro valor (incluido ausente) no', () {
      final filtro =
          FiltroBusqueda.fromQueryParameters(const {'sello': '1', 'aval': '1'});
      expect(filtro.selloMarca, isTrue);
      expect(filtro.avalConfianza, isTrue);

      final sinInsignias = FiltroBusqueda.fromQueryParameters(const {});
      expect(sinInsignias.selloMarca, isNull);
      expect(sinInsignias.avalConfianza, isNull);
    });
  });

  group('round-trip (URL compartible)', () {
    test('toQueryParameters -> Uri -> fromQueryParameters reproduce el filtro original', () {
      const original = FiltroBusqueda(
        query: 'café orgánico',
        municipio: 'Floridablanca',
        categoriaSlug: 'ecoproductos-industriales',
        subcategoriaSlug: 'moda-sostenible',
        actividadSlug: 'textiles-sostenibles',
        vista: VistaResultados.mapa,
      );

      final uri = Uri(path: '/buscar', queryParameters: original.toQueryParameters());
      final reconstruido = FiltroBusqueda.fromQueryParameters(uri.queryParameters);

      expect(reconstruido.query, original.query);
      expect(reconstruido.municipio, original.municipio);
      expect(reconstruido.categoriaSlug, original.categoriaSlug);
      expect(reconstruido.subcategoriaSlug, original.subcategoriaSlug);
      expect(reconstruido.actividadSlug, original.actividadSlug);
      expect(reconstruido.vista, original.vista);
    });
  });

  group('FiltroBusqueda.copyWith', () {
    test('limpiarX en null explícito el campo, no solo lo deja igual', () {
      const conTodo = FiltroBusqueda(
        categoriaSlug: 'bioproductos-servicios-sostenibles',
        subcategoriaSlug: 'agrosistemas-sostenibles',
        actividadSlug: 'agricultura-organica',
      );

      final sinSubcategoria = conTodo.copyWith(limpiarSubcategoria: true);
      expect(sinSubcategoria.categoriaSlug, conTodo.categoriaSlug);
      expect(sinSubcategoria.subcategoriaSlug, isNull);
      // Este test documenta el comportamiento actual: copyWith no poda en
      // cascada por sí solo (eso lo hacen los callers, ej. FiltrosBar,
      // pasando limpiarActividad explícito junto con limpiarSubcategoria).
      expect(sinSubcategoria.actividadSlug, conTodo.actividadSlug);
    });

    test('tieneFiltrosActivos es false solo cuando absolutamente todo está vacío', () {
      expect(const FiltroBusqueda().tieneFiltrosActivos, isFalse);
      expect(const FiltroBusqueda(municipio: 'Vetas').tieneFiltrosActivos, isTrue);
      expect(const FiltroBusqueda(query: 'x').tieneFiltrosActivos, isTrue);
    });
  });
}
