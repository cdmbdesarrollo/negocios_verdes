import 'package:flutter/material.dart';

import '../../../core/admin_guard.dart';
import '../../../core/texto_utils.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/icono_etiqueta.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../core/widgets/selector_icono_imagen.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/subcategoria.dart';
import '../../../services/categoria_service.dart';
import '../../../services/storage_service.dart';
import '../../../services/subcategoria_service.dart';
import '../../../theme/nv_colors.dart';

class AdminSubcategoriasPage extends StatefulWidget {
  const AdminSubcategoriasPage({super.key});

  @override
  State<AdminSubcategoriasPage> createState() =>
      _AdminSubcategoriasPageState();
}

class _AdminSubcategoriasPageState extends State<AdminSubcategoriasPage> {
  final _subService = SubcategoriaService();
  final _catService = CategoriaService();
  List<Subcategoria>? _subcategorias;
  List<CategoriaOficial> _categorias = [];
  String? _filtroCategoriaId;
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
        _subService.listarTodas(),
        _catService.listarTodas(),
      ]);
      if (mounted) {
        setState(() {
          _subcategorias = resultados[0] as List<Subcategoria>;
          _categorias = resultados[1] as List<CategoriaOficial>;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _abrirDialogo({Subcategoria? subcategoria}) async {
    if (_categorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Primero crea al menos una categoría oficial.')),
      );
      return;
    }
    final guardado = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoSubcategoria(
        subcategoria: subcategoria,
        categorias: _categorias,
        categoriaInicialId: _filtroCategoriaId,
      ),
    );
    if (guardado == true) _cargar();
  }

  Future<void> _alternarActivo(Subcategoria s) async {
    try {
      await _subService.alternarActivo(s.id, !s.activo);
      _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  Future<void> _eliminar(Subcategoria s) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar subcategoría?'),
        content: Text(
            'Se eliminará "${s.nombre}". Si algún negocio todavía la usa, no se podrá eliminar.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await _subService.eliminar(s.id);
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

  String _nombreCategoria(String id) {
    for (final c in _categorias) {
      if (c.id == id) return c.nombre;
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirDialogo(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva subcategoría'),
      ),
      body: _construirCuerpo(),
    );
  }

  Widget _construirCuerpo() {
    if (_error != null) return Center(child: Text(_error!));
    final subcategorias = _subcategorias;
    if (subcategorias == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final visibles = _filtroCategoriaId == null
        ? subcategorias
        : subcategorias
            .where((s) => s.categoriaOficialId == _filtroCategoriaId)
            .toList();

    return Column(
      children: [
        if (_categorias.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChipFiltro(
                  etiqueta: 'Todas',
                  seleccionado: _filtroCategoriaId == null,
                  onTap: () => setState(() => _filtroCategoriaId = null),
                ),
                for (final c in _categorias)
                  ChipFiltro(
                    etiqueta: c.nombre,
                    icono: c.icono,
                    seleccionado: _filtroCategoriaId == c.id,
                    onTap: () => setState(() => _filtroCategoriaId = c.id),
                  ),
              ],
            ),
          ),
        Expanded(
          child: visibles.isEmpty
              ? const Center(child: Text('No hay subcategorías en este filtro.'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                  itemCount: visibles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final s = visibles[i];
                    return NVCard(
                      key: ValueKey(s.id),
                      child: Row(
                        children: [
                          IconoEtiqueta(
                              iconoUrl: s.iconoUrl,
                              iconoTexto: s.iconoOTexto,
                              tamano: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.nombre,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  _nombreCategoria(s.categoriaOficialId),
                                  style: const TextStyle(
                                      color: NVColors.textoSecundario,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                              value: s.activo,
                              onChanged: (_) => _alternarActivo(s)),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _abrirDialogo(subcategoria: s),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _eliminar(s),
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

class _DialogoSubcategoria extends StatefulWidget {
  final Subcategoria? subcategoria;
  final List<CategoriaOficial> categorias;
  final String? categoriaInicialId;

  const _DialogoSubcategoria({
    this.subcategoria,
    required this.categorias,
    this.categoriaInicialId,
  });

  @override
  State<_DialogoSubcategoria> createState() => _DialogoSubcategoriaState();
}

class _DialogoSubcategoriaState extends State<_DialogoSubcategoria> {
  final _formKey = GlobalKey<FormState>();
  final _service = SubcategoriaService();
  final _storage = StorageService();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _iconoCtrl;
  String? _categoriaId;
  bool _slugEditadoManualmente = false;
  bool _guardando = false;

  String? _iconoUrl;
  String? _iconoPath;

  @override
  void initState() {
    super.initState();
    final s = widget.subcategoria;
    _nombreCtrl = TextEditingController(text: s?.nombre ?? '');
    _slugCtrl = TextEditingController(text: s?.slug ?? '');
    _iconoCtrl = TextEditingController(text: s?.icono ?? '');
    _categoriaId = s?.categoriaOficialId ??
        widget.categoriaInicialId ??
        widget.categorias.first.id;
    _slugEditadoManualmente = s != null;
    _iconoUrl = s?.iconoUrl;
    _iconoPath = s?.iconoPath;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _slugCtrl.dispose();
    _iconoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoriaId == null) return;
    setState(() => _guardando = true);
    try {
      final slug = _slugCtrl.text.trim().isEmpty
          ? generarSlug(_nombreCtrl.text)
          : generarSlug(_slugCtrl.text.trim());
      final icono = _iconoCtrl.text.trim();
      final pathAnterior = widget.subcategoria?.iconoPath;

      if (widget.subcategoria == null) {
        await _service.crear(
          categoriaOficialId: _categoriaId!,
          nombre: _nombreCtrl.text.trim(),
          slug: slug,
          icono: icono.isEmpty ? null : icono,
          iconoUrl: _iconoUrl,
          iconoPath: _iconoPath,
        );
      } else {
        await _service.actualizar(
          id: widget.subcategoria!.id,
          categoriaOficialId: _categoriaId!,
          nombre: _nombreCtrl.text.trim(),
          slug: slug,
          icono: icono.isEmpty ? null : icono,
          iconoUrl: _iconoUrl,
          iconoPath: _iconoPath,
          orden: widget.subcategoria!.orden,
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
      title: Text(widget.subcategoria == null
          ? 'Nueva subcategoría'
          : 'Editar subcategoría'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _categoriaId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Categoría oficial'),
                items: [
                  for (final c in widget.categorias)
                    DropdownMenuItem(
                      value: c.id,
                      child: Text(
                        '${c.iconoOTexto} ${c.nombre}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _categoriaId = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nombreCtrl,
                decoration:
                    const InputDecoration(labelText: 'Nombre (ej. Apicultura)'),
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
                  labelText: 'Ícono (un emoji, ej. 🐝)',
                  helperText: 'Se usa si no subes una imagen abajo.',
                ),
              ),
              const SizedBox(height: 12),
              SelectorIconoImagen(
                carpeta: 'subcategorias-iconos',
                iconoUrlInicial: _iconoUrl,
                onCambio: (subida) => setState(() {
                  _iconoUrl = subida?.url;
                  _iconoPath = subida?.path;
                }),
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
