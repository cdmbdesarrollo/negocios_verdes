import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../catalogos.dart';
import '../../../core/admin_guard.dart';
import '../../../models/actividad_productiva.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/negocio_foto.dart';
import '../../../models/subcategoria.dart';
import '../../../services/actividad_productiva_service.dart';
import '../../../services/categoria_service.dart';
import '../../../services/negocio_foto_service.dart';
import '../../../services/negocio_service.dart';
import '../../../services/subcategoria_service.dart';
import '../../../theme/nv_colors.dart';
import 'widgets/galeria_editor.dart';
import 'widgets/selector_taxonomia_negocio.dart';
import 'widgets/selector_ubicacion_mapa.dart';

/// Un solo formulario para crear y editar (negocioId nulo = crear). El id
/// del negocio se genera en el cliente ANTES de guardar (ver initState) —
/// lo necesita GaleriaEditor para las rutas de Storage de portada/galería
/// desde el primer momento, no solo después de guardar.
class AdminNegocioFormPage extends StatefulWidget {
  final String? negocioId;

  const AdminNegocioFormPage({super.key, this.negocioId});

  @override
  State<AdminNegocioFormPage> createState() => _AdminNegocioFormPageState();
}

class _AdminNegocioFormPageState extends State<AdminNegocioFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoriaService = CategoriaService();
  final _subcategoriaService = SubcategoriaService();
  final _actividadService = ActividadProductivaService();
  final _negocioService = NegocioService();
  final _negocioFotoService = NegocioFotoService();

  late final String _negocioId;
  bool get _esEdicion => widget.negocioId != null;

  bool _cargando = true;
  bool _guardando = false;
  String? _error;

  final _nombreCtrl = TextEditingController();
  final _descripcionCortaCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _sitioWebCtrl = TextEditingController();
  final _facebookCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<ActividadProductiva> _actividades = [];
  /// Hasta 3 — orden de selección, la primera es la "principal" (la que
  /// queda en negocios.categoria_oficial_id para todo lo que ya filtra o
  /// muestra por una sola categoría). Lista, no Set, para que ese orden sea
  /// predecible.
  List<String> _categoriaOficialIds = [];
  Set<String> _subcategoriaIds = {};
  Set<String> _actividadIds = {};
  String? _municipio;
  double? _latitud;
  double? _longitud;
  String _nivelDesarrollo = 'en_verificacion';
  bool _destacado = false;
  bool _activo = false;
  String? _fotoPortadaUrl;
  String? _fotoPortadaPath;
  List<NegocioFoto> _galeriaInicial = [];
  List<FotoLocal> _galeriaActual = [];

  @override
  void initState() {
    super.initState();
    _negocioId = widget.negocioId ?? const Uuid().v4();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCortaCtrl.dispose();
    _descripcionCtrl.dispose();
    _telefonoCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _sitioWebCtrl.dispose();
    _facebookCtrl.dispose();
    _instagramCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      final categorias = await _categoriaService.listarTodas();
      final subcategorias = await _subcategoriaService.listarTodas();
      final actividades = await _actividadService.listarTodas();

      if (_esEdicion) {
        final existente = await _negocioService.obtenerPorId(_negocioId);
        if (existente == null) {
          throw Exception('No se encontró el negocio.');
        }
        _nombreCtrl.text = existente.nombre;
        _categoriaOficialIds = existente.categoriasOficiales.isNotEmpty
            ? existente.categoriasOficiales.map((c) => c.id).toList()
            : [existente.categoriaOficialId];
        _municipio = existente.municipio;
        _direccionCtrl.text = existente.direccion ?? '';
        _latitud = existente.latitud;
        _longitud = existente.longitud;
        _descripcionCortaCtrl.text = existente.descripcionCorta;
        _descripcionCtrl.text = existente.descripcion;
        _telefonoCtrl.text = existente.telefono ?? '';
        _whatsappCtrl.text = existente.whatsapp;
        _emailCtrl.text = existente.email ?? '';
        _sitioWebCtrl.text = existente.sitioWeb ?? '';
        _facebookCtrl.text = existente.facebookUrl ?? '';
        _instagramCtrl.text = existente.instagramUrl ?? '';
        _fotoPortadaUrl = existente.fotoPortadaUrl;
        _fotoPortadaPath = existente.fotoPortadaPath;
        _nivelDesarrollo = existente.nivelDesarrollo;
        _destacado = existente.destacado;
        _activo = existente.activo;
        _subcategoriaIds = existente.subcategorias.map((s) => s.id).toSet();
        _actividadIds =
            existente.actividadesProductivas.map((a) => a.id).toSet();
        _galeriaInicial = existente.fotos;
        // Crítico: _galeriaActual es lo que _sincronizarGaleria() vuelve a
        // insertar al guardar (borra todo _galeriaInicial primero). Si el
        // admin guarda SIN tocar la galería, GaleriaEditor nunca dispara
        // onGaleriaCambiada (solo lo hace al agregar/quitar/reordenar), así
        // que sin esta línea _galeriaActual se quedaba en su valor por
        // defecto (lista vacía) y el guardado borraba las fotos existentes
        // sin volver a insertar ninguna — las fotos "desaparecían solas"
        // en una edición posterior que no tocaba la galería para nada.
        _galeriaActual = existente.fotos
            .map((f) => FotoLocal(url: f.url, storagePath: f.storagePath))
            .toList();
      }

      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _subcategorias = subcategorias;
        _actividades = actividades;
        _cargando = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _cargando = false;
        });
      }
    }
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoriaOficialIds.isEmpty) {
      _avisar('Selecciona al menos una categoría oficial.');
      return;
    }
    if (_municipio == null) {
      _avisar('Selecciona un municipio.');
      return;
    }
    if (_activo && (_fotoPortadaUrl == null || _fotoPortadaUrl!.isEmpty)) {
      _avisar('Sube una foto de portada antes de publicar el negocio.');
      return;
    }

    setState(() => _guardando = true);
    try {
      // Solo dígitos — un número guardado con espacios/guiones/+ produce un
      // link wa.me roto (ver comentario en negocios.whatsapp / BotonWhatsapp).
      final whatsappLimpio = _whatsappCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');

      await _negocioService.guardar(
        id: _negocioId,
        nombre: _nombreCtrl.text.trim(),
        categoriaOficialIds: _categoriaOficialIds,
        municipio: _municipio!,
        direccion: _vacioANulo(_direccionCtrl.text),
        latitud: _latitud,
        longitud: _longitud,
        descripcionCorta: _descripcionCortaCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
        telefono: _vacioANulo(_telefonoCtrl.text),
        whatsapp: whatsappLimpio,
        email: _vacioANulo(_emailCtrl.text),
        sitioWeb: _vacioANulo(_sitioWebCtrl.text),
        facebookUrl: _vacioANulo(_facebookCtrl.text),
        instagramUrl: _vacioANulo(_instagramCtrl.text),
        fotoPortadaUrl: _fotoPortadaUrl,
        fotoPortadaPath: _fotoPortadaPath,
        nivelDesarrollo: _nivelDesarrollo,
        destacado: _destacado,
        activo: _activo,
        subcategoriaIds: _subcategoriaIds.toList(),
        actividadIds: _actividadIds.toList(),
      );

      await _sincronizarGaleria();

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Negocio guardado.')));
        context.go('/admin/negocios');
      }
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  /// Borrar+reinsertar, igual que negocios_subcategorias en la RPC — a esta
  /// escala (hasta 5 fotos) es más simple y confiable que diffear altas,
  /// bajas y reordenamientos por separado. Corre DESPUÉS de que el negocio
  /// ya existe en la base de datos (si no, negocio_fotos.negocio_id no
  /// tendría a qué apuntar).
  Future<void> _sincronizarGaleria() async {
    if (_esEdicion) {
      for (final foto in _galeriaInicial) {
        await _negocioFotoService.eliminar(foto.id);
      }
    }
    for (var i = 0; i < _galeriaActual.length; i++) {
      final foto = _galeriaActual[i];
      await _negocioFotoService.agregar(
        negocioId: _negocioId,
        url: foto.url,
        storagePath: foto.storagePath,
        orden: i,
      );
    }
  }

  String? _vacioANulo(String texto) =>
      texto.trim().isEmpty ? null : texto.trim();

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
        children: [
          Text(
            _esEdicion ? 'Editar negocio' : 'Nuevo negocio',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _seccion('Datos básicos'),
          TextFormField(
            controller: _nombreCtrl,
            decoration: const InputDecoration(labelText: 'Nombre del negocio'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descripcionCortaCtrl,
            decoration: const InputDecoration(
              labelText: 'Descripción corta',
              helperText: 'Para la tarjeta de resultados, máximo ~160 caracteres.',
            ),
            maxLength: 160,
            maxLines: 2,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          TextFormField(
            controller: _descripcionCtrl,
            decoration: const InputDecoration(labelText: 'Descripción completa'),
            maxLines: 5,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 20),
          _seccion('Municipio y categorización'),
          DropdownButtonFormField<String>(
            initialValue: _municipio,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Municipio'),
            items: [
              for (final m in kMunicipios) DropdownMenuItem(value: m, child: Text(m)),
            ],
            onChanged: (v) => setState(() => _municipio = v),
            validator: (v) => v == null ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          // Categoría → subcategoría → actividad vive en su propio widget
          // con estado local, no acá: si estos chips dispararan el
          // setState de esta página, cada toque reconstruiría TODO el
          // formulario (mapa de ubicación incluido) — ver el comentario en
          // SelectorTaxonomiaNegocio para el porqué eso importa de verdad.
          SelectorTaxonomiaNegocio(
            categorias: _categorias,
            subcategorias: _subcategorias,
            actividades: _actividades,
            categoriaIdsIniciales: _categoriaOficialIds,
            subcategoriaIdsIniciales: _subcategoriaIds,
            actividadIdsIniciales: _actividadIds,
            onCambio: (categoriaIds, subcategoriaIds, actividadIds) {
              _categoriaOficialIds = categoriaIds;
              _subcategoriaIds = subcategoriaIds;
              _actividadIds = actividadIds;
            },
          ),
          const SizedBox(height: 20),
          _seccion('Ubicación'),
          TextFormField(
            controller: _direccionCtrl,
            decoration: const InputDecoration(labelText: 'Dirección (opcional)'),
          ),
          const SizedBox(height: 12),
          if (_municipio != null)
            SelectorUbicacionMapa(
              municipio: _municipio!,
              direccionController: _direccionCtrl,
              latitudInicial: _latitud,
              longitudInicial: _longitud,
              onCambio: (lat, lng) {
                _latitud = lat;
                _longitud = lng;
              },
            )
          else
            const Text(
              'Selecciona un municipio para poder marcar la ubicación en el mapa.',
              style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
            ),
          const SizedBox(height: 20),
          _seccion('Contacto y redes sociales'),
          TextFormField(
            controller: _whatsappCtrl,
            decoration: const InputDecoration(
              labelText: 'WhatsApp',
              helperText: 'Con indicativo de país, ej. 573001234567',
            ),
            keyboardType: TextInputType.phone,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _telefonoCtrl,
            decoration: const InputDecoration(labelText: 'Teléfono fijo (opcional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Correo (opcional)'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sitioWebCtrl,
            decoration: const InputDecoration(labelText: 'Sitio web (opcional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _facebookCtrl,
            decoration: const InputDecoration(labelText: 'Facebook (opcional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _instagramCtrl,
            decoration: const InputDecoration(labelText: 'Instagram (opcional)'),
          ),
          const SizedBox(height: 20),
          _seccion('Fotos'),
          GaleriaEditor(
            negocioId: _negocioId,
            portadaUrlInicial: _fotoPortadaUrl,
            portadaPathInicial: _fotoPortadaPath,
            galeriaInicial: _galeriaInicial,
            onPortadaCambiada: (url, path) {
              _fotoPortadaUrl = url;
              _fotoPortadaPath = path;
            },
            onGaleriaCambiada: (fotos) => _galeriaActual = fotos,
          ),
          const SizedBox(height: 20),
          _seccion('Publicación'),
          DropdownButtonFormField<String>(
            initialValue: _nivelDesarrollo,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Nivel de desarrollo'),
            items: [
              for (final entrada in kNivelesDesarrolloEtiqueta.entries)
                DropdownMenuItem(
                  value: entrada.key,
                  child: Text(entrada.value),
                ),
            ],
            onChanged: (v) => setState(() => _nivelDesarrollo = v!),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              kNivelesDesarrolloAyuda[_nivelDesarrollo] ?? '',
              style:
                  const TextStyle(color: NVColors.textoSecundario, fontSize: 12),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Destacado'),
            subtitle: const Text('Aparece en la portada del sitio público.'),
            value: _destacado,
            onChanged: (v) => setState(() => _destacado = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Publicado'),
            subtitle: const Text('Visible en el buscador público. Necesita foto de portada.'),
            value: _activo,
            onChanged: (v) => setState(() => _activo = v),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/admin/negocios'),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardar,
                  child: _guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: NVColors.primaryDark,
        ),
      ),
    );
  }
}
