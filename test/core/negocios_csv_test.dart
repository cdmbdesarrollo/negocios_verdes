import 'package:flutter_test/flutter_test.dart';
import 'package:negocios_verdes_cdmb/core/negocios_csv.dart';
import 'package:negocios_verdes_cdmb/models/actividad_productiva.dart';
import 'package:negocios_verdes_cdmb/models/categoria_oficial.dart';
import 'package:negocios_verdes_cdmb/models/negocio.dart';
import 'package:negocios_verdes_cdmb/models/subcategoria.dart';

// Lógica pura de alto riesgo real (carga masiva de ~180 negocios reales de
// producción): un desajuste silencioso entre construirCsvNegocios y
// interpretarCsvNegocios, o una columna mal mapeada, se traduciría en datos
// corruptos o negocios fantasma en la base — mismo criterio que
// filtro_busqueda_test.dart.
void main() {
  const categoriaBio = CategoriaOficial(
    id: 'cat-1',
    nombre: 'Bioproductos y Servicios Sostenibles',
    slug: 'bioproductos-servicios-sostenibles',
  );
  const categoriaEco = CategoriaOficial(
    id: 'cat-2',
    nombre: 'Ecoproductos Industriales',
    slug: 'ecoproductos-industriales',
  );
  const subAgro = Subcategoria(
    id: 'sub-1',
    categoriaOficialId: 'cat-1',
    nombre: 'Agrosistemas Sostenibles',
    slug: 'agrosistemas-sostenibles',
  );
  const actividadOrganica = ActividadProductiva(
    id: 'act-1',
    subcategoriaId: 'sub-1',
    nombre: 'Agricultura orgánica',
    slug: 'agricultura-organica',
  );

  final categorias = [categoriaBio, categoriaEco];
  final subcategorias = [subAgro];
  final actividades = [actividadOrganica];

  group('round-trip exportar -> importar', () {
    test('un negocio completo sobrevive el viaje de ida y vuelta', () {
      const negocio = Negocio(
        id: 'neg-1',
        nombre: 'Finca La Esperanza',
        slug: 'finca-la-esperanza',
        categoriaOficialId: 'cat-1',
        categoriasOficiales: [categoriaBio, categoriaEco],
        subcategorias: [subAgro],
        actividadesProductivas: [actividadOrganica],
        municipio: 'Girón',
        direccion: 'Vereda El Palmar',
        latitud: 7.05,
        longitud: -73.17,
        descripcionCorta: 'Finca agroecológica',
        descripcion: 'Producción, con comas, y "comillas" en el texto.',
        telefono: '6076543210',
        whatsapp: '573001234567',
        email: 'contacto@finca.co',
        sitioWeb: 'https://finca.co',
        facebookUrl: 'https://facebook.com/finca',
        instagramUrl: 'https://instagram.com/finca',
        avalado: true,
        selloMarca: true,
        emprendimientoVerde: false,
        destacado: true,
        activo: true,
      );

      final csv = construirCsvNegocios([negocio]);
      final filas = interpretarCsvNegocios(
        csv,
        categorias: categorias,
        subcategorias: subcategorias,
        actividades: actividades,
        negociosExistentes: const [],
      );

      expect(filas, hasLength(1));
      final fila = filas.single;
      expect(fila.errores, isEmpty);
      final datos = fila.datos!;
      expect(datos.nombre, 'Finca La Esperanza');
      expect(datos.municipio, 'Girón');
      expect(datos.categoriaIds, unorderedEquals(['cat-1', 'cat-2']));
      expect(datos.subcategoriaIds, ['sub-1']);
      expect(datos.actividadIds, ['act-1']);
      expect(datos.direccion, 'Vereda El Palmar');
      expect(datos.latitud, 7.05);
      expect(datos.longitud, -73.17);
      expect(datos.descripcionCorta, 'Finca agroecológica');
      expect(datos.descripcion,
          'Producción, con comas, y "comillas" en el texto.');
      expect(datos.whatsapp, '573001234567');
      expect(datos.email, 'contacto@finca.co');
      expect(datos.avalado, isTrue);
      expect(datos.selloMarca, isTrue);
      expect(datos.destacado, isTrue);
    });

    test('campos opcionales vacíos vuelven como null, no como cadena vacía',
        () {
      const negocio = Negocio(
        id: 'neg-2',
        nombre: 'Emprendimiento Sin Datos Extra',
        slug: 'emprendimiento-sin-datos-extra',
        categoriaOficialId: 'cat-1',
        categoriasOficiales: [categoriaBio],
        municipio: 'Lebrija',
        descripcionCorta: 'Corta',
        descripcion: 'Larga',
        whatsapp: '573000000000',
      );

      final csv = construirCsvNegocios([negocio]);
      final datos = interpretarCsvNegocios(
        csv,
        categorias: categorias,
        subcategorias: subcategorias,
        actividades: actividades,
        negociosExistentes: const [],
      ).single.datos!;

      expect(datos.direccion, isNull);
      expect(datos.latitud, isNull);
      expect(datos.email, isNull);
      expect(datos.subcategoriaIds, isEmpty);
      expect(datos.actividadIds, isEmpty);
    });
  });

  group('validación de filas', () {
    List<FilaImportada> interpretar(String csv) => interpretarCsvNegocios(
          csv,
          categorias: categorias,
          subcategorias: subcategorias,
          actividades: actividades,
          negociosExistentes: const [],
        );

    test('fila sin nombre queda con error y sin datos', () {
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion\n'
          ';Girón;Bioproductos y Servicios Sostenibles;573000000000;corta;larga';
      final fila = interpretar(csv).single;
      expect(fila.esValida, isFalse);
      expect(fila.datos, isNull);
      expect(fila.errores, contains(contains('nombre')));
    });

    test('municipio desconocido queda como error', () {
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion\n'
          'Negocio X;Bogotá;Bioproductos y Servicios Sostenibles;573000000000;c;d';
      final fila = interpretar(csv).single;
      expect(fila.esValida, isFalse);
      expect(fila.errores.any((e) => e.contains('Municipio desconocido')),
          isTrue);
    });

    test('categoría desconocida queda como error, no crea el negocio', () {
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion\n'
          'Negocio Y;Girón;Categoría Inventada;573000000000;c;d';
      final fila = interpretar(csv).single;
      expect(fila.esValida, isFalse);
      expect(
          fila.errores.any((e) => e.contains('Categoría')), isTrue);
    });

    test('varias categorías separadas por "|" se resuelven todas', () {
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion\n'
          'Negocio Z;Girón;Bioproductos y Servicios Sostenibles|Ecoproductos '
          'Industriales;573000000000;c;d';
      final datos = interpretar(csv).single.datos!;
      expect(datos.categoriaIds, unorderedEquals(['cat-1', 'cat-2']));
    });

    test('sin WhatsApp queda como error (obligatorio en la base)', () {
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion\n'
          'Negocio W;Girón;Bioproductos y Servicios Sostenibles;;c;d';
      final fila = interpretar(csv).single;
      expect(fila.esValida, isFalse);
      expect(fila.errores.any((e) => e.contains('WhatsApp')), isTrue);
    });

    test('latitud no numérica queda como error', () {
      const csv =
          'nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion;latitud\n'
          'Negocio V;Girón;Bioproductos y Servicios Sostenibles;573000000000;c;d;no-es-un-numero';
      final fila = interpretar(csv).single;
      expect(fila.esValida, isFalse);
      expect(fila.errores.any((e) => e.contains('Latitud')), isTrue);
    });

    test('nombre repetido de un negocio existente es advertencia, no error',
        () {
      const existente = Negocio(
        id: 'existe-1',
        nombre: 'Negocio Repetido',
        slug: 'negocio-repetido',
        categoriaOficialId: 'cat-1',
        municipio: 'Girón',
        descripcionCorta: 'x',
        descripcion: 'x',
        whatsapp: '573000000000',
      );
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion\n'
          'Negocio Repetido;Girón;Bioproductos y Servicios Sostenibles;573000000000;c;d';
      final fila = interpretarCsvNegocios(
        csv,
        categorias: categorias,
        subcategorias: subcategorias,
        actividades: actividades,
        negociosExistentes: const [existente],
      ).single;

      expect(fila.esValida, isTrue);
      expect(fila.advertencias, isNotEmpty);
      // Válida + advertencia = sigue seleccionada por defecto (el admin
      // decide si la destilda), no bloqueada como un error.
      expect(fila.seleccionada, isTrue);
    });

    test('valores booleanos aceptan SI/NO, true/false, 1/0 y x', () {
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;'
          'descripcion;avalado;sello_marca;emprendimiento_verde;destacado\n'
          'Negocio B;Girón;Bioproductos y Servicios Sostenibles;573000000000;c;d;'
          'SI;true;1;x';
      final datos = interpretar(csv).single.datos!;
      expect(datos.avalado, isTrue);
      expect(datos.selloMarca, isTrue);
      expect(datos.emprendimientoVerde, isTrue);
      expect(datos.destacado, isTrue);
    });

    test('columna booleana vacía se interpreta como false, no como error',
        () {
      const csv = 'nombre;municipio;categorias;whatsapp;descripcion_corta;'
          'descripcion;avalado\n'
          'Negocio C;Girón;Bioproductos y Servicios Sostenibles;573000000000;c;d;';
      final fila = interpretar(csv).single;
      expect(fila.esValida, isTrue);
      expect(fila.datos!.avalado, isFalse);
    });
  });

  test('un BOM inicial (típico de Excel) no rompe el encabezado', () {
    const csv = '﻿nombre;municipio;categorias;whatsapp;descripcion_corta;descripcion\n'
        'Negocio BOM;Girón;Bioproductos y Servicios Sostenibles;573000000000;c;d';
    final fila = interpretarCsvNegocios(
      csv,
      categorias: categorias,
      subcategorias: subcategorias,
      actividades: actividades,
      negociosExistentes: const [],
    ).single;
    expect(fila.esValida, isTrue);
    expect(fila.datos!.nombre, 'Negocio BOM');
  });

  test('csv con delimitador "," también se interpreta (autoDetect)', () {
    const csv = 'nombre,municipio,categorias,whatsapp,descripcion_corta,descripcion\n'
        'Negocio Coma,Girón,Bioproductos y Servicios Sostenibles,573000000000,c,d';
    final fila = interpretarCsvNegocios(
      csv,
      categorias: categorias,
      subcategorias: subcategorias,
      actividades: actividades,
      negociosExistentes: const [],
    ).single;
    expect(fila.esValida, isTrue);
    expect(fila.datos!.nombre, 'Negocio Coma');
  });
}
