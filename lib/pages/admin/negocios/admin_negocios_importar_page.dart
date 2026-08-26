import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/admin_guard.dart';
import '../../../core/descargar_archivo_web.dart';
import '../../../core/negocios_csv.dart';
import '../../../models/actividad_productiva.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/negocio.dart';
import '../../../models/subcategoria.dart';
import '../../../services/actividad_productiva_service.dart';
import '../../../services/categoria_service.dart';
import '../../../services/negocio_service.dart';
import '../../../services/subcategoria_service.dart';
import '../../../theme/nv_colors.dart';

/// Carga masiva de negocios desde CSV — pensada para arrancar el
/// directorio con ~180 negocios de golpe (nombre, ubicación, contacto,
/// categorización, reconocimientos) sin tener que pasar uno por uno por el
/// formulario. Nunca toca fotos/logo/galería: todo negocio importado nace
/// oculto (activo=false) porque negocios_publicado_necesita_foto lo exige
/// — se publica a mano desde /admin/negocios/:id/editar en cuanto alguien
/// le suba la portada.
class AdminNegociosImportarPage extends StatefulWidget {
  const AdminNegociosImportarPage({super.key});

  @override
  State<AdminNegociosImportarPage> createState() =>
      _AdminNegociosImportarPageState();
}

class _AdminNegociosImportarPageState
    extends State<AdminNegociosImportarPage> {
  final _categoriaService = CategoriaService();
  final _subcategoriaService = SubcategoriaService();
  final _actividadService = ActividadProductivaService();
  final _negocioService = NegocioService();

  bool _cargandoCatalogos = true;
  String? _errorCatalogos;
  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<ActividadProductiva> _actividades = [];
  List<Negocio> _negociosExistentes = [];

  String? _nombreArchivo;
  List<FilaImportada>? _filas;
  bool _leyendoArchivo = false;
  String? _errorArchivo;

  bool _importando = false;
  int _progresoActual = 0;
  int _progresoTotal = 0;
  List<String> _erroresImportacion = const [];
  int? _creados;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargarCatalogos();
  }

  Future<void> _cargarCatalogos() async {
    try {
      final resultados = await Future.wait([
        _categoriaService.listarTodas(),
        _subcategoriaService.listarTodas(),
        _actividadService.listarTodas(),
        _negocioService.listarTodosAdmin(),
      ]);
      if (!mounted) return;
      setState(() {
        _categorias = resultados[0] as List<CategoriaOficial>;
        _subcategorias = resultados[1] as List<Subcategoria>;
        _actividades = resultados[2] as List<ActividadProductiva>;
        _negociosExistentes = resultados[3] as List<Negocio>;
        _cargandoCatalogos = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorCatalogos = e.toString().replaceFirst('Exception: ', '');
          _cargandoCatalogos = false;
        });
      }
    }
  }

  void _exportarPlantilla() => exportarNegociosComoCsv(_negociosExistentes);

  Future<void> _elegirArchivo() async {
    setState(() {
      _errorArchivo = null;
      _filas = null;
      _creados = null;
      _erroresImportacion = const [];
    });

    final PlatformFile? archivo;
    try {
      archivo = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
    } catch (e) {
      setState(() =>
          _errorArchivo = 'No se pudo abrir el selector de archivos: $e');
      return;
    }
    if (archivo == null) return;

    setState(() => _leyendoArchivo = true);
    try {
      final bytes = await archivo.readAsBytes();
      final contenido = utf8.decode(bytes, allowMalformed: true);
      final filas = interpretarCsvNegocios(
        contenido,
        categorias: _categorias,
        subcategorias: _subcategorias,
        actividades: _actividades,
        negociosExistentes: _negociosExistentes,
      );
      if (!mounted) return;
      setState(() {
        _nombreArchivo = archivo!.name;
        _filas = filas;
        _leyendoArchivo = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorArchivo = 'No se pudo leer el archivo: $e';
          _leyendoArchivo = false;
        });
      }
    }
  }

  Future<void> _importarSeleccionadas() async {
    final filas = _filas;
    if (filas == null) return;
    final seleccionadas =
        filas.where((f) => f.esValida && f.seleccionada).toList();
    if (seleccionadas.isEmpty) return;

    setState(() {
      _importando = true;
      _progresoActual = 0;
      _progresoTotal = seleccionadas.length;
    });

    var creados = 0;
    final errores = <String>[];
    for (final fila in seleccionadas) {
      final datos = fila.datos!;
      try {
        await _negocioService.guardar(
          id: const Uuid().v4(),
          nombre: datos.nombre,
          categoriaOficialIds: datos.categoriaIds,
          municipio: datos.municipio,
          direccion: datos.direccion,
          latitud: datos.latitud,
          longitud: datos.longitud,
          descripcionCorta: datos.descripcionCorta,
          descripcion: datos.descripcion,
          telefono: datos.telefono,
          whatsapp: datos.whatsapp,
          email: datos.email,
          sitioWeb: datos.sitioWeb,
          facebookUrl: datos.facebookUrl,
          instagramUrl: datos.instagramUrl,
          destacado: datos.destacado,
          // Siempre oculto: nunca hay foto de portada en un CSV.
          activo: false,
          subcategoriaIds: datos.subcategoriaIds,
          actividadIds: datos.actividadIds,
          selloMarca: datos.selloMarca,
          avalConfianza: datos.avalConfianza,
          avalado: datos.avalado,
          emprendimientoVerde: datos.emprendimientoVerde,
        );
        creados++;
      } catch (e) {
        errores.add('Fila ${fila.numeroFila} (${fila.nombreMostrado}): '
            '${e.toString().replaceFirst("Exception: ", "")}');
      }
      if (!mounted) return;
      setState(() => _progresoActual++);
    }

    if (!mounted) return;
    setState(() {
      _importando = false;
      _creados = creados;
      _erroresImportacion = errores;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_errorCatalogos != null) {
      return Center(child: Text(_errorCatalogos!));
    }
    if (_cargandoCatalogos) {
      return const Center(child: CircularProgressIndicator());
    }

    final filas = _filas;
    final validas = filas?.where((f) => f.esValida).length ?? 0;
    final conErrores = filas?.where((f) => !f.esValida).length ?? 0;
    final seleccionadas =
        filas?.where((f) => f.esValida && f.seleccionada).length ?? 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => context.go('/admin/negocios'),
              icon: const Icon(Icons.arrow_back),
            ),
            Text('Importar negocios desde CSV',
                style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        const SizedBox(height: 8),
        _cajaInstrucciones(),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: _exportarPlantilla,
              icon: const Icon(Icons.download_outlined),
              label: const Text('Exportar plantilla / datos actuales'),
            ),
            ElevatedButton.icon(
              onPressed: _leyendoArchivo ? null : _elegirArchivo,
              icon: const Icon(Icons.upload_file_outlined),
              label: Text(
                  _leyendoArchivo ? 'Leyendo...' : 'Elegir archivo CSV'),
            ),
          ],
        ),
        if (_errorArchivo != null) ...[
          const SizedBox(height: 12),
          Text(_errorArchivo!, style: const TextStyle(color: NVColors.error)),
        ],
        if (filas != null) ...[
          const SizedBox(height: 24),
          Text(
            '$_nombreArchivo — ${filas.length} filas leídas: '
            '$validas listas para importar, $conErrores con errores.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (_creados != null)
            _cajaResultado()
          else ...[
            if (_importando) ...[
              LinearProgressIndicator(
                value: _progresoTotal == 0
                    ? null
                    : _progresoActual / _progresoTotal,
              ),
              const SizedBox(height: 6),
              Text('Importando $_progresoActual / $_progresoTotal...'),
              const SizedBox(height: 16),
            ] else ...[
              ElevatedButton.icon(
                onPressed: seleccionadas == 0 ? null : _importarSeleccionadas,
                icon: const Icon(Icons.cloud_upload_outlined),
                label: Text('Importar $seleccionadas negocio(s) seleccionado(s)'),
              ),
              const SizedBox(height: 16),
            ],
            for (final fila in filas) _tarjetaFila(fila),
          ],
        ],
      ],
    );
  }

  Widget _cajaInstrucciones() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cómo funciona',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 8),
          Text(
            '1. Exporta la plantilla (ya trae las columnas correctas y los '
            'negocios que ya existen, si quieres usarlos de ejemplo).\n'
            '2. Complétala en Excel: una fila por negocio. El campo más '
            'importante es "nombre"; también hacen falta municipio, '
            'categorías, descripción corta, descripción y whatsapp.\n'
            '3. Si un negocio tiene varias categorías, subcategorías o '
            'actividades, sepáralas con "|" en la misma celda (ej. '
            '"Bucaramanga|Girón" no aplica a municipio, que es uno solo, '
            'pero sí a categorías/subcategorías/actividades).\n'
            '4. Las columnas avalado / sello_marca / aval_confianza / '
            'emprendimiento_verde / destacado se llenan con SI o NO.\n'
            '5. No incluye fotos, logo ni galería — los negocios importados '
            'quedan ocultos (sin publicar) hasta que alguien les suba la '
            'foto de portada desde el formulario admin y los publique a '
            'mano.',
            style: TextStyle(height: 1.4, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _cajaResultado() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: NVColors.exito.withValues(alpha: 0.1),
        border: Border.all(color: NVColors.exito.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Se crearon $_creados negocios (ocultos, sin foto de '
              'portada) — publícalos desde /admin/negocios cuando tengan '
              'foto.'),
          if (_erroresImportacion.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text('${_erroresImportacion.length} fallaron:',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            for (final error in _erroresImportacion)
              Text('• $error',
                  style: const TextStyle(
                      fontSize: 12.5, color: NVColors.textoSecundario)),
          ],
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.go('/admin/negocios'),
            child: const Text('Ver negocios'),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaFila(FilaImportada fila) {
    final color = !fila.esValida
        ? NVColors.error
        : fila.advertencias.isNotEmpty
            ? NVColors.advertencia
            : NVColors.exito;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: NVColors.superficie,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: fila.seleccionada,
            onChanged: !fila.esValida
                ? null
                : (v) => setState(() => fila.seleccionada = v ?? false),
          ),
          Icon(
            !fila.esValida
                ? Icons.error_outline
                : fila.advertencias.isNotEmpty
                    ? Icons.warning_amber_outlined
                    : Icons.check_circle_outline,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fila ${fila.numeroFila}: ${fila.nombreMostrado}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                for (final e in fila.errores)
                  Text('• $e',
                      style:
                          const TextStyle(fontSize: 12.5, color: NVColors.error)),
                for (final a in fila.advertencias)
                  Text('• $a',
                      style: const TextStyle(
                          fontSize: 12.5, color: NVColors.advertencia)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
