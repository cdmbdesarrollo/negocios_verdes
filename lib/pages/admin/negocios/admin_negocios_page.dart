import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../catalogos.dart';
import '../../../core/admin_guard.dart';
import '../../../core/widgets/badge_nivel.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/negocio.dart';
import '../../../services/negocio_service.dart';
import '../../../theme/nv_colors.dart';

class AdminNegociosPage extends StatefulWidget {
  const AdminNegociosPage({super.key});

  @override
  State<AdminNegociosPage> createState() => _AdminNegociosPageState();
}

class _AdminNegociosPageState extends State<AdminNegociosPage> {
  final _service = NegocioService();
  List<Negocio>? _negocios;
  String? _error;
  String _busqueda = '';
  String? _filtroMunicipio;
  bool? _filtroActivo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final negocios = await _service.listarTodosAdmin();
      if (mounted) setState(() => _negocios = negocios);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  List<Negocio> get _visibles {
    var lista = _negocios ?? [];
    if (_filtroMunicipio != null) {
      lista = lista.where((n) => n.municipio == _filtroMunicipio).toList();
    }
    if (_filtroActivo != null) {
      lista = lista.where((n) => n.activo == _filtroActivo).toList();
    }
    if (_busqueda.trim().isNotEmpty) {
      final termino = _busqueda.trim().toLowerCase();
      lista =
          lista.where((n) => n.nombre.toLowerCase().contains(termino)).toList();
    }
    return lista;
  }

  Future<void> _alternarActivo(Negocio n) async {
    try {
      await _service.alternarActivo(n.id, !n.activo);
      _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  Future<void> _alternarDestacado(Negocio n) async {
    try {
      await _service.alternarDestacado(n.id, !n.destacado);
      _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  Future<void> _eliminar(Negocio n) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar negocio?'),
        content: Text(
            'Se eliminará "${n.nombre}" junto con su galería de fotos. Esta acción no se puede deshacer.'),
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
      await _service.eliminar(n.id);
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
        onPressed: () => context.go('/admin/negocios/nuevo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo negocio'),
      ),
      body: _construirCuerpo(),
    );
  }

  Widget _construirCuerpo() {
    if (_error != null) return Center(child: Text(_error!));
    if (_negocios == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final visibles = _visibles;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar por nombre...',
            ),
            onChanged: (v) => setState(() => _busqueda = v),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ChipFiltro(
                etiqueta: 'Todos',
                seleccionado: _filtroActivo == null,
                onTap: () => setState(() => _filtroActivo = null),
              ),
              ChipFiltro(
                etiqueta: 'Publicados',
                seleccionado: _filtroActivo == true,
                onTap: () => setState(() => _filtroActivo = true),
              ),
              ChipFiltro(
                etiqueta: 'Ocultos',
                seleccionado: _filtroActivo == false,
                onTap: () => setState(() => _filtroActivo = false),
              ),
              DropdownButton<String?>(
                value: _filtroMunicipio,
                hint: const Text('Municipio'),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Todos los municipios')),
                  for (final m in kMunicipios)
                    DropdownMenuItem(value: m, child: Text(m)),
                ],
                onChanged: (v) => setState(() => _filtroMunicipio = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: visibles.isEmpty
              ? const Center(child: Text('No hay negocios con estos filtros.'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                  itemCount: visibles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _tarjetaNegocio(visibles[i]),
                ),
        ),
      ],
    );
  }

  Widget _tarjetaNegocio(Negocio n) {
    // Key estable por id: ListView.separated recicla widgets fuera de
    // pantalla por posición si no se les da identidad propia — al borrar
    // un negocio del medio de la lista eso puede confundir qué tarjeta le
    // corresponde a cuál dato justo en el momento del borrado (mismo
    // problema ya visto y corregido en la lista de banners).
    return NVCard(
      key: ValueKey(n.id),
      onTap: () => context.go('/admin/negocios/${n.id}/editar'),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: n.fotoPortadaUrl != null && n.fotoPortadaUrl!.isNotEmpty
                  ? Image.network(n.fotoPortadaUrl!, fit: BoxFit.cover)
                  : Container(
                      color: NVColors.primaryLight,
                      child:
                          const Icon(Icons.storefront, color: NVColors.primary),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${n.categoriaOficial?.nombre ?? 'Sin categoría'} · ${n.municipio}',
                  style: const TextStyle(
                      color: NVColors.textoSecundario, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    BadgeNivel(nivel: n.nivelDesarrollo, tamanoFuente: 11),
                    if (n.destacado)
                      const Icon(Icons.star, color: NVColors.accent, size: 18),
                  ],
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: n.activo
                    ? 'Publicado — tocar para ocultar'
                    : 'Oculto — tocar para publicar',
                child:
                    Switch(value: n.activo, onChanged: (_) => _alternarActivo(n)),
              ),
              IconButton(
                tooltip:
                    n.destacado ? 'Quitar de destacados' : 'Marcar como destacado',
                icon: Icon(n.destacado ? Icons.star : Icons.star_border,
                    color: NVColors.accent),
                onPressed: () => _alternarDestacado(n),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _eliminar(n),
          ),
        ],
      ),
    );
  }
}
