import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/admin_guard.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/negocio.dart';
import '../../../services/negocio_service.dart';
import '../../../theme/nv_colors.dart';

/// Cada "vista" filtra el conjunto de negocios ANTES de calcular KPIs y el
/// desglose por municipio — pedido explícito: "ver negocios por municipio
/// sean cualquiera de estas categorías... una vista por cada categoría,
/// activo, etc. y otro global. Con KPI por cada caso y global". Global no
/// filtra nada; el resto son mutuamente excluyentes entre sí como chips
/// (una a la vez, no combinables) porque cada una responde una pregunta
/// distinta del admin ("¿cómo van los Avalados?", no "Avalados Y Activos").
enum _Vista { global, activos, emprendimientoVerde, selloMarca, avalado }

extension on _Vista {
  String get etiqueta => switch (this) {
        _Vista.global => 'Global',
        _Vista.activos => 'Activos',
        _Vista.emprendimientoVerde => 'Emprendimiento Verde',
        _Vista.selloMarca => 'Sello Marca',
        _Vista.avalado => 'Avalado',
      };

  bool aplica(Negocio n) => switch (this) {
        _Vista.global => true,
        _Vista.activos => n.activo,
        _Vista.emprendimientoVerde => n.emprendimientoVerde,
        _Vista.selloMarca => n.selloMarca,
        _Vista.avalado => n.avalado,
      };
}

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _service = NegocioService();
  List<Negocio>? _negocios;
  List<({String nombre, String slug, int anio, double puntaje})>? _topPuntajes;
  String? _error;
  _Vista _vista = _Vista.global;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final negocios = await _service.listarTodosAdmin();
      // Best-effort: si no hay puntajes cargados todavía, el dashboard
      // sigue funcionando sin la tarjeta de "top puntajes".
      List<({String nombre, String slug, int anio, double puntaje})> top = [];
      try {
        top = await _service.obtenerTopPuntajes();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _negocios = negocios;
          _topPuntajes = top;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    final todos = _negocios;
    if (todos == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final negocios = todos.where(_vista.aplica).toList();

    final activos = negocios.where((n) => n.activo).length;
    // CDMB marca "ACTIVO" en su base (novedad) pero acá sigue inactivo casi
    // siempre por falta de foto de portada (constraint de la base) — cifra
    // priorizable para el admin, más útil que un genérico "en verificación"
    // que ya no existe como concepto (ver 0022_ficha_ampliada_negocios.sql).
    final pendientesDePublicar =
        negocios.where((n) => !n.activo && n.novedad == 'ACTIVO').length;
    final sinFoto = negocios
        .where((n) => n.fotoPortadaUrl == null || n.fotoPortadaUrl!.isEmpty)
        .length;
    final sinClasificar = negocios
        .where((n) => n.categoriaOficial?.slug == 'pendiente-clasificar')
        .length;
    final porMunicipio = <String, int>{};
    for (final n in negocios) {
      porMunicipio[n.municipio] = (porMunicipio[n.municipio] ?? 0) + 1;
    }
    final municipiosOrdenados = porMunicipio.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxMunicipio =
        municipiosOrdenados.isEmpty ? 1 : municipiosOrdenados.first.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola de nuevo',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${todos.length} negocios registrados en total',
                        style: const TextStyle(color: NVColors.textoSecundario),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => context.go('/admin/negocios/nuevo'),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo negocio'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final v in _Vista.values)
                  ChipFiltro(
                    etiqueta: v.etiqueta,
                    seleccionado: _vista == v,
                    onTap: () => setState(() => _vista = v),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Vista: ${_vista.etiqueta} (${negocios.length} negocios)',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: NVColors.primaryDark)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _tarjetaEstadistica(
                  context,
                  etiqueta: 'Activos (publicados)',
                  valor: activos,
                  icono: Icons.check_circle_outline,
                  color: NVColors.exito,
                ),
                _tarjetaEstadistica(
                  context,
                  etiqueta: 'CDMB los marca ACTIVO, faltan por publicar',
                  valor: pendientesDePublicar,
                  icono: Icons.hourglass_top,
                  color: NVColors.advertencia,
                ),
                _tarjetaEstadistica(
                  context,
                  etiqueta: 'Sin foto de portada',
                  valor: sinFoto,
                  icono: Icons.image_not_supported_outlined,
                  color: NVColors.error,
                ),
                _tarjetaEstadistica(
                  context,
                  etiqueta: 'Sin categoría clasificada',
                  valor: sinClasificar,
                  icono: Icons.category_outlined,
                  color: NVColors.error,
                ),
                _tarjetaEstadistica(
                  context,
                  etiqueta: 'Municipios con negocios',
                  valor: porMunicipio.length,
                  icono: Icons.map_outlined,
                  color: NVColors.verdeVivo,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Negocios por municipio — ${_vista.etiqueta}',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            NVCard(
              child: municipiosOrdenados.isEmpty
                  ? const Text('No hay negocios con esta vista.')
                  : Column(
                      children: [
                        for (final entrada in municipiosOrdenados)
                          _filaMunicipio(entrada.key, entrada.value, maxMunicipio),
                      ],
                    ),
            ),
            if (_vista == _Vista.global) ...[
              const SizedBox(height: 28),
              Text('Por reconocimiento',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              NVCard(
                child: Column(
                  children: [
                    _filaMunicipio(
                      'Emprendimiento Verde',
                      todos.where((n) => n.emprendimientoVerde).length,
                      todos.isEmpty ? 1 : todos.length,
                    ),
                    _filaMunicipio(
                      'Sello Marca',
                      todos.where((n) => n.selloMarca).length,
                      todos.isEmpty ? 1 : todos.length,
                    ),
                    _filaMunicipio(
                      'Avalado',
                      todos.where((n) => n.avalado).length,
                      todos.isEmpty ? 1 : todos.length,
                    ),
                  ],
                ),
              ),
            ],
            if (_topPuntajes != null && _topPuntajes!.isNotEmpty) ...[
              const SizedBox(height: 28),
              Text(
                  'Top ${_topPuntajes!.length} mejores puntajes '
                  '(${_topPuntajes!.first.anio})',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              NVCard(
                child: Column(
                  children: [
                    for (final (i, fila) in _topPuntajes!.indexed)
                      _filaTopPuntaje(i + 1, fila),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _filaTopPuntaje(
      int puesto, ({String nombre, String slug, int anio, double puntaje}) fila) {
    final medalla = switch (puesto) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => '$puesto',
    };
    return InkWell(
      onTap: () => context.go('/admin/negocios'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(medalla,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(fila.nombre,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            Text(fila.puntaje.toStringAsFixed(1),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: NVColors.verdeVivo)),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaEstadistica(
    BuildContext context, {
    required String etiqueta,
    required int valor,
    required IconData icono,
    required Color color,
  }) {
    return SizedBox(
      width: 226,
      child: NVCard(
        onTap: () => context.go('/admin/negocios'),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icono, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$valor',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(etiqueta,
                      style: const TextStyle(
                          color: NVColors.textoSecundario, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaMunicipio(String municipio, int valor, int maximo) {
    final proporcion = maximo == 0 ? 0.0 : valor / maximo;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(municipio,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: proporcion,
                minHeight: 10,
                backgroundColor: NVColors.fondo,
                valueColor: const AlwaysStoppedAnimation(NVColors.verdeVivo),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 24,
            child: Text('$valor',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
