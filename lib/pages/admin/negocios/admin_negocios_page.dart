import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../catalogos.dart';
import '../../../core/admin_guard.dart';
import '../../../core/descargar_archivo_web.dart';
import '../../../core/widgets/avalado_badge.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/confirmar_eliminar_boton.dart';
import '../../../core/widgets/emprendimiento_verde_badge.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../core/widgets/sello_marca_badge.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/negocio.dart';
import '../../../services/categoria_service.dart';
import '../../../services/negocio_service.dart';
import '../../../theme/nv_colors.dart';

class AdminNegociosPage extends StatefulWidget {
  const AdminNegociosPage({super.key});

  @override
  State<AdminNegociosPage> createState() => _AdminNegociosPageState();
}

class _AdminNegociosPageState extends State<AdminNegociosPage> {
  final _service = NegocioService();
  final _categoriaService = CategoriaService();
  List<Negocio>? _negocios;
  List<CategoriaOficial> _categorias = [];
  String? _error;
  String _busqueda = '';
  String? _filtroMunicipio;
  String? _filtroCategoriaId;
  bool? _filtroActivo;
  /// Estado CDMB (novedad) — independiente de [_filtroActivo] (que es el
  /// flag de publicación). Deja ver los negocios que están RETIRADO /
  /// SUSPENDIDO / INACTIVO, que igual no salen en el sitio público.
  String? _filtroNovedad;

  static const _porPagina = 25;
  int _pagina = 0;

  /// Cualquier cambio de filtro o búsqueda vuelve a la primera página — si
  /// no, se puede quedar "viendo la página 4" de una lista que ahora tiene
  /// 2 páginas y parecería vacía.
  void _cambiarFiltro(VoidCallback cambio) {
    setState(() {
      cambio();
      _pagina = 0;
    });
  }

  static const _novedadOpciones = ['ACTIVO', 'INACTIVO', 'RETIRADO', 'SUSPENDIDO'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final negocios = await _service.listarTodosAdmin();
      final categorias = await _categoriaService.listarTodas();
      if (mounted) {
        setState(() {
          _negocios = negocios;
          _categorias = categorias;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  List<Negocio> get _visibles {
    var lista = _negocios ?? [];
    if (_filtroMunicipio != null) {
      lista = lista.where((n) => n.municipio == _filtroMunicipio).toList();
    }
    if (_filtroCategoriaId != null) {
      lista = lista
          .where((n) =>
              n.categoriasOficiales.any((c) => c.id == _filtroCategoriaId) ||
              n.categoriaOficialId == _filtroCategoriaId)
          .toList();
    }
    if (_filtroActivo != null) {
      lista = lista.where((n) => n.activo == _filtroActivo).toList();
    }
    if (_filtroNovedad != null) {
      lista = lista.where((n) => (n.novedad ?? '') == _filtroNovedad).toList();
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
    try {
      await _service.eliminar(n.id);
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
    final totalPaginas =
        visibles.isEmpty ? 1 : ((visibles.length - 1) ~/ _porPagina) + 1;
    final pagina = _pagina.clamp(0, totalPaginas - 1);
    final desde = pagina * _porPagina;
    final hasta = (desde + _porPagina).clamp(0, visibles.length);
    final pagVisibles = visibles.sublist(desde, hasta);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar por nombre...',
            ),
            onChanged: (v) => _cambiarFiltro(() => _busqueda = v),
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
                onTap: () => _cambiarFiltro(() => _filtroActivo = null),
              ),
              ChipFiltro(
                etiqueta: 'Publicados',
                seleccionado: _filtroActivo == true,
                onTap: () => _cambiarFiltro(() => _filtroActivo = true),
              ),
              ChipFiltro(
                etiqueta: 'No publicados',
                seleccionado: _filtroActivo == false,
                onTap: () => _cambiarFiltro(() => _filtroActivo = false),
              ),
              DropdownButton<String?>(
                value: _filtroNovedad,
                hint: const Text('Estado CDMB'),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Todos los estados')),
                  for (final e in _novedadOpciones)
                    DropdownMenuItem(value: e, child: Text(e)),
                ],
                onChanged: (v) => _cambiarFiltro(() => _filtroNovedad = v),
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
                onChanged: (v) => _cambiarFiltro(() => _filtroMunicipio = v),
              ),
              DropdownButton<String?>(
                value: _filtroCategoriaId,
                hint: const Text('Categoría'),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('Todas las categorías')),
                  for (final c in _categorias)
                    DropdownMenuItem(value: c.id, child: Text(c.nombre)),
                ],
                onChanged: (v) => _cambiarFiltro(() => _filtroCategoriaId = v),
              ),
              // Exporta lo que dejan pasar los filtros de arriba (no toda la
              // base). Incluye negocios en cualquier estado y sin publicar —
              // por eso este CSV nunca se sube tal cual al sitio.
              OutlinedButton.icon(
                onPressed: visibles.isEmpty
                    ? null
                    : () => exportarNegociosComoCsv(visibles),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: Text('Exportar CSV (${visibles.length})'),
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
                  itemCount: pagVisibles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _tarjetaNegocio(pagVisibles[i]),
                ),
        ),
        if (visibles.isNotEmpty)
          _barraPaginacion(
            desde: desde + 1,
            hasta: hasta,
            total: visibles.length,
            pagina: pagina,
            totalPaginas: totalPaginas,
          ),
      ],
    );
  }

  Widget _barraPaginacion({
    required int desde,
    required int hasta,
    required int total,
    required int pagina,
    required int totalPaginas,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: NVColors.borde)),
      ),
      child: Row(
        children: [
          Text('$desde–$hasta de $total',
              style: const TextStyle(
                  color: NVColors.textoSecundario, fontSize: 13)),
          const Spacer(),
          IconButton(
            tooltip: 'Página anterior',
            icon: const Icon(Icons.chevron_left),
            onPressed:
                pagina > 0 ? () => setState(() => _pagina = pagina - 1) : null,
          ),
          Text('${pagina + 1} / $totalPaginas',
              style: const TextStyle(fontSize: 13)),
          IconButton(
            tooltip: 'Página siguiente',
            icon: const Icon(Icons.chevron_right),
            onPressed: pagina < totalPaginas - 1
                ? () => setState(() => _pagina = pagina + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _tarjetaNegocio(Negocio n) {
    // Key estable por id: ListView.separated recicla widgets fuera de
    // pantalla por posición si no se les da identidad propia — al borrar
    // un negocio del medio de la lista eso puede confundir qué tarjeta le
    // corresponde a cuál dato justo en el momento del borrado (mismo
    // problema ya visto y corregido en la lista de banners).
    //
    // Antes toda la tarjeta era tocable (onTap acá mismo) para ir a editar,
    // con el botón de eliminar ANIDADO adentro de esa misma zona — un tap
    // exacto sobre "eliminar" podía disparar también la navegación a
    // editar, cerrando el diálogo de confirmación a medias. Ahora "editar"
    // es un ícono explícito, igual que en categorías/subcategorías/
    // banners, sin superponer zonas tocables con acciones distintas.
    return NVCard(
      key: ValueKey(n.id),
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
                      color: Colors.white,
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        'assets/images/iconografia/logo_negocios_verdes.png',
                        fit: BoxFit.contain,
                      ),
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
                // Aviso puntual: la base de CDMB puede marcar un negocio
                // como "ACTIVO" (novedad) sin que todavía esté publicado
                // acá (necesita foto de portada primero) — este texto es
                // lo que le permite al admin encontrarlos.
                if (!n.activo && n.novedad == 'ACTIVO')
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      'CDMB lo marca ACTIVO — falta foto de portada para publicar',
                      style: TextStyle(color: NVColors.advertencia, fontSize: 11),
                    ),
                  ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (n.emprendimientoVerde)
                      const EmprendimientoVerdeBadge(tamanoFuente: 10),
                    if (n.selloMarca) const SelloMarcaBadge(tamanoFuente: 10),
                    if (n.avalado) const AvaladoBadge(tamanoFuente: 10),
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
                    ? 'Activo — tocar para desactivar'
                    : 'Inactivo — tocar para activar',
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
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go('/admin/negocios/${n.id}/editar'),
          ),
          ConfirmarEliminarBoton(onConfirmado: () => _eliminar(n)),
        ],
      ),
    );
  }
}
