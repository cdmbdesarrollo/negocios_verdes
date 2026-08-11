import 'package:flutter/material.dart';

import '../../../core/admin_guard.dart';
import '../../../core/texto_utils.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/categoria_oficial.dart';
import '../../../services/categoria_service.dart';
import '../../../theme/nv_colors.dart';

class AdminCategoriasPage extends StatefulWidget {
  const AdminCategoriasPage({super.key});

  @override
  State<AdminCategoriasPage> createState() => _AdminCategoriasPageState();
}

class _AdminCategoriasPageState extends State<AdminCategoriasPage> {
  final _service = CategoriaService();
  List<CategoriaOficial>? _categorias;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final categorias = await _service.listarTodas();
      if (mounted) setState(() => _categorias = categorias);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _abrirDialogo({CategoriaOficial? categoria}) async {
    final guardado = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoCategoria(categoria: categoria),
    );
    if (guardado == true) _cargar();
  }

  Future<void> _alternarActivo(CategoriaOficial categoria) async {
    try {
      await _service.alternarActivo(categoria.id, !categoria.activo);
      _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  Future<void> _eliminar(CategoriaOficial categoria) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar categoría?'),
        content: Text(
            'Se eliminará "${categoria.nombre}". Si algún negocio o subcategoría todavía la usa, no se podrá eliminar.'),
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
      await _service.eliminar(categoria.id);
      _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  void _mostrarError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirDialogo(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva categoría'),
      ),
      body: _construirCuerpo(),
    );
  }

  Widget _construirCuerpo() {
    if (_error != null) return Center(child: Text(_error!));
    final categorias = _categorias;
    if (categorias == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (categorias.isEmpty) {
      return const Center(child: Text('Todavía no hay categorías.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
      itemCount: categorias.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final c = categorias[i];
        return NVCard(
          child: Row(
            children: [
              Text(c.iconoOTexto, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (c.descripcion != null && c.descripcion!.isNotEmpty)
                      Text(
                        c.descripcion!,
                        style: const TextStyle(
                            color: NVColors.textoSecundario, fontSize: 13),
                      ),
                  ],
                ),
              ),
              Switch(value: c.activo, onChanged: (_) => _alternarActivo(c)),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _abrirDialogo(categoria: c),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _eliminar(c),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DialogoCategoria extends StatefulWidget {
  final CategoriaOficial? categoria;

  const _DialogoCategoria({this.categoria});

  @override
  State<_DialogoCategoria> createState() => _DialogoCategoriaState();
}

class _DialogoCategoriaState extends State<_DialogoCategoria> {
  final _formKey = GlobalKey<FormState>();
  final _service = CategoriaService();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _descripcionCtrl;
  late final TextEditingController _iconoCtrl;
  late final TextEditingController _categoriaNacionalCtrl;
  bool _slugEditadoManualmente = false;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final c = widget.categoria;
    _nombreCtrl = TextEditingController(text: c?.nombre ?? '');
    _slugCtrl = TextEditingController(text: c?.slug ?? '');
    _descripcionCtrl = TextEditingController(text: c?.descripcion ?? '');
    _iconoCtrl = TextEditingController(text: c?.icono ?? '');
    _categoriaNacionalCtrl =
        TextEditingController(text: c?.categoriaNacional ?? '');
    _slugEditadoManualmente = c != null;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _slugCtrl.dispose();
    _descripcionCtrl.dispose();
    _iconoCtrl.dispose();
    _categoriaNacionalCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _guardando = true);
    try {
      final slug = _slugCtrl.text.trim().isEmpty
          ? generarSlug(_nombreCtrl.text)
          : generarSlug(_slugCtrl.text.trim());
      final descripcion = _descripcionCtrl.text.trim();
      final icono = _iconoCtrl.text.trim();
      final categoriaNacional = _categoriaNacionalCtrl.text.trim();

      if (widget.categoria == null) {
        await _service.crear(
          nombre: _nombreCtrl.text.trim(),
          slug: slug,
          descripcion: descripcion.isEmpty ? null : descripcion,
          icono: icono.isEmpty ? null : icono,
          categoriaNacional:
              categoriaNacional.isEmpty ? null : categoriaNacional,
        );
      } else {
        await _service.actualizar(
          id: widget.categoria!.id,
          nombre: _nombreCtrl.text.trim(),
          slug: slug,
          descripcion: descripcion.isEmpty ? null : descripcion,
          icono: icono.isEmpty ? null : icono,
          categoriaNacional:
              categoriaNacional.isEmpty ? null : categoriaNacional,
          orden: widget.categoria!.orden,
        );
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
      title:
          Text(widget.categoria == null ? 'Nueva categoría' : 'Editar categoría'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                onChanged: (v) {
                  if (!_slugEditadoManualmente) {
                    _slugCtrl.text = generarSlug(v);
                  }
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
                decoration:
                    const InputDecoration(labelText: 'Ícono (un emoji, ej. 🌱)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoriaNacionalCtrl,
                decoration: const InputDecoration(
                  labelText: 'Categoría nacional (opcional)',
                  helperText:
                      'Solo informativo, ej. "Bioproductos y Servicios Sostenibles"',
                ),
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
