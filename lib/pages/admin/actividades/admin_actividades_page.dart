import 'package:flutter/material.dart';

import '../../../core/admin_guard.dart';
import '../../../core/texto_utils.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/confirmar_eliminar_boton.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/icono_etiqueta.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../core/widgets/selector_icono_imagen.dart';
import '../../../models/actividad_productiva.dart';
import '../../../models/subcategoria.dart';
import '../../../services/actividad_productiva_service.dart';
import '../../../services/storage_service.dart';
import '../../../services/subcategoria_service.dart';
import '../../../theme/nv_colors.dart';

/// Un nivel más abajo que /admin/subcategorias, calcada de esa página —
/// mismo patrón de filtro + tarjeta + diálogo, un escalón más profundo en
/// la taxonomía (categoría → subcategoría → actividad productiva).
class AdminActividadesPage extends StatefulWidget {
  const AdminActividadesPage({super.key});

  @override
  State<AdminActividadesPage> createState() => _AdminActividadesPageState();
}

class _AdminActividadesPageState extends State<AdminActividadesPage> {
  final _actividadService = ActividadProductivaService();
  final _subService = SubcategoriaService();
  List<ActividadProductiva>? _actividades;
  List<Subcategoria> _subcategorias = [];
  String? _filtroSubcategoriaId;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final resultados = await Future.wait([
        _actividadService.listarTodas(),
        _subService.listarTodas(),
      ]);
      if (mounted) {
        setState(() {
          _actividades = resultados[0] as List<ActividadProductiva>;
          _subcategorias = resultados[1] as List<Subcategoria>;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _abrirDialogo({ActividadProductiva? actividad}) async {
    if (_subcategorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Primero crea al menos una subcategoría.')),
      );
      return;
    }
    final guardado = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoActividad(
        actividad: actividad,
        subcategorias: _subcategorias,
        subcategoriaInicialId: _filtroSubcategoriaId,
      ),
    );
    if (guardado == true) _cargar();
  }

  Future<void> _alternarActivo(ActividadProductiva a) async {
    try {
      await _actividadService.alternarActivo(a.id, !a.activo);
      _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  Future<String?> _validarBorrado(ActividadProductiva a) async {
    try {
      final negocios = await _actividadService.contarNegocios(a.id);
      if (negocios == 0) return null;
      final verbo = negocios == 1 ? 'usa' : 'usan';
      return '"${a.nombre}" todavía la $verbo $negocios negocio${negocios == 1 ? '' : 's'}. '
          'Quítala de ahí primero, o desactívala en la lista para '
          'ocultarla sin perder esos datos.';
    } catch (e) {
      return 'No se pudo verificar: ${e.toString().replaceFirst('Exception: ', '')}';
    }
  }

  Future<void> _eliminar(ActividadProductiva a) async {
    try {
      await _actividadService.eliminar(a.id);
      _cargar();
    } catch (e) {
      if (mounted) mostrarErrorEliminar(context, e);
    }
  }

  void _mostrarError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
    );
  }

  String _nombreSubcategoria(String id) {
    for (final s in _subcategorias) {
      if (s.id == id) return s.nombre;
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirDialogo(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva actividad'),
      ),
      body: _construirCuerpo(),
    );
  }

  Widget _construirCuerpo() {
    if (_error != null) return Center(child: Text(_error!));
    final actividades = _actividades;
    if (actividades == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final visibles = _filtroSubcategoriaId == null
        ? actividades
        : actividades
            .where((a) => a.subcategoriaId == _filtroSubcategoriaId)
            .toList();

    return Column(
      children: [
        if (_subcategorias.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChipFiltro(
                  etiqueta: 'Todas',
                  seleccionado: _filtroSubcategoriaId == null,
                  onTap: () => setState(() => _filtroSubcategoriaId = null),
                ),
                for (final s in _subcategorias)
                  ChipFiltro(
                    etiqueta: s.nombre,
                    icono: s.icono,
                    seleccionado: _filtroSubcategoriaId == s.id,
                    onTap: () => setState(() => _filtroSubcategoriaId = s.id),
                  ),
              ],
            ),
          ),
        Expanded(
          child: visibles.isEmpty
              ? const Center(child: Text('No hay actividades en este filtro.'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                  itemCount: visibles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final a = visibles[i];
                    return NVCard(
                      key: ValueKey(a.id),
                      child: Row(
                        children: [
                          IconoEtiqueta(
                              iconoUrl: a.iconoUrl,
                              iconoTexto: a.iconoOTexto,
                              tamano: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.nombre,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  _nombreSubcategoria(a.subcategoriaId),
                                  style: const TextStyle(
                                      color: NVColors.textoSecundario,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                              value: a.activo,
                              onChanged: (_) => _alternarActivo(a)),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _abrirDialogo(actividad: a),
                          ),
                          ConfirmarEliminarBoton(
                            validarAntes: () => _validarBorrado(a),
                            onConfirmado: () => _eliminar(a),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _DialogoActividad extends StatefulWidget {
  final ActividadProductiva? actividad;
  final List<Subcategoria> subcategorias;
  final String? subcategoriaInicialId;

  const _DialogoActividad({
    this.actividad,
    required this.subcategorias,
    this.subcategoriaInicialId,
  });

  @override
  State<_DialogoActividad> createState() => _DialogoActividadState();
}

class _DialogoActividadState extends State<_DialogoActividad> {
  final _formKey = GlobalKey<FormState>();
  final _service = ActividadProductivaService();
  final _storage = StorageService();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _iconoCtrl;
  late final TextEditingController _descripcionCtrl;
  String? _subcategoriaId;
  bool _slugEditadoManualmente = false;
  bool _guardando = false;

  String? _iconoUrl;
  String? _iconoPath;

  @override
  void initState() {
    super.initState();
    final a = widget.actividad;
    _nombreCtrl = TextEditingController(text: a?.nombre ?? '');
    _slugCtrl = TextEditingController(text: a?.slug ?? '');
    _iconoCtrl = TextEditingController(text: a?.icono ?? '');
    _descripcionCtrl = TextEditingController(text: a?.descripcion ?? '');
    _subcategoriaId = a?.subcategoriaId ??
        widget.subcategoriaInicialId ??
        widget.subcategorias.first.id;
    _slugEditadoManualmente = a != null;
    _iconoUrl = a?.iconoUrl;
    _iconoPath = a?.iconoPath;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _slugCtrl.dispose();
    _iconoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_subcategoriaId == null) return;
    setState(() => _guardando = true);
    try {
      final slug = _slugCtrl.text.trim().isEmpty
          ? generarSlug(_nombreCtrl.text)
          : generarSlug(_slugCtrl.text.trim());
      final icono = _iconoCtrl.text.trim();
      final descripcion = _descripcionCtrl.text.trim();
      final pathAnterior = widget.actividad?.iconoPath;

      if (widget.actividad == null) {
        await _service.crear(
          subcategoriaId: _subcategoriaId!,
          nombre: _nombreCtrl.text.trim(),
          slug: slug,
          descripcion: descripcion.isEmpty ? null : descripcion,
          icono: icono.isEmpty ? null : icono,
          iconoUrl: _iconoUrl,
          iconoPath: _iconoPath,
        );
      } else {
        await _service.actualizar(
          id: widget.actividad!.id,
          subcategoriaId: _subcategoriaId!,
          nombre: _nombreCtrl.text.trim(),
          slug: slug,
          descripcion: descripcion.isEmpty ? null : descripcion,
          icono: icono.isEmpty ? null : icono,
          iconoUrl: _iconoUrl,
          iconoPath: _iconoPath,
          orden: widget.actividad!.orden,
        );
      }
      if (pathAnterior != null &&
          pathAnterior.isNotEmpty &&
          pathAnterior != _iconoPath) {
        _storage
            .eliminarImagen(bucket: kBucketSitioAssets, path: pathAnterior)
            .catchError((_) {});
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.actividad == null
          ? 'Nueva actividad productiva'
          : 'Editar actividad productiva'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _subcategoriaId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Subcategoría'),
                items: [
                  for (final s in widget.subcategorias)
                    DropdownMenuItem(
                      value: s.id,
                      child: Text(
                        '${s.iconoOTexto} ${s.nombre}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _subcategoriaId = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                    labelText: 'Nombre (ej. Agricultura orgánica)'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                onChanged: (v) {
                  if (!_slugEditadoManualmente) _slugCtrl.text = generarSlug(v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _slugCtrl,
                decoration: const InputDecoration(labelText: 'Slug (URL)'),
                onChanged: (_) => _slugEditadoManualmente = true,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _iconoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ícono (un emoji, ej. 🌾)',
                  helperText: 'Se usa si no subes una imagen abajo.',
                ),
              ),
              const SizedBox(height: 12),
              SelectorIconoImagen(
                carpeta: 'actividades-iconos',
                iconoUrlInicial: _iconoUrl,
                onCambio: (subida) => setState(() {
                  _iconoUrl = subida?.url;
                  _iconoPath = subida?.path;
                }),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
