import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/admin_guard.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/negocio.dart';
import '../../../services/negocio_service.dart';
import '../../../theme/nv_colors.dart';

/// Cada "vista" filtra el conjunto de negocios ANTES de calcular KPIs y las
/// gráficas — pedido explícito: "una vista por cada categoría, activo, etc. y
/// otro global. Con KPI por cada caso y global".
enum _Vista { global, activos, emprendimientoVerde, selloMarca, avalado }

extension on _Vista {
  String get etiqueta => switch (this) {
        _Vista.global => 'Global',
        _Vista.activos => 'Publicados',
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

/// Paleta para las tortas — verdes/ámbar de marca + neutros, en ese orden.
const _paleta = <Color>[
  Color(0xFF038F67),
  Color(0xFF01BD32),
  Color(0xFF85C800),
  Color(0xFFFF8623),
  Color(0xFF3366CC),
  Color(0xFF8E7CC3),
  Color(0xFF5B6B60),
  Color(0xFFC0392B),
  Color(0xFF2E8B57),
  Color(0xFFD98B2B),
];

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _service = NegocioService();
  List<Negocio>? _negocios;
  List<({String nombre, String slug, int anio, double puntaje})>? _topPuntajes;
  Map<int, double> _promedioPorAnio = {};
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
      var top = <({String nombre, String slug, int anio, double puntaje})>[];
      var promedio = <int, double>{};
      try {
        top = await _service.obtenerTopPuntajes();
        promedio = await _service.promedioPuntajePorAnio();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _negocios = negocios;
          _topPuntajes = top;
          _promedioPorAnio = promedio;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Center(child: Text(_error!));
    final todos = _negocios;
    if (todos == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final negocios = todos.where(_vista.aplica).toList();

    final activos = negocios.where((n) => n.activo).length;
    final pendientesDePublicar =
        negocios.where((n) => !n.activo && n.novedad == 'ACTIVO').length;
    final sinFoto = negocios
        .where((n) => n.fotoPortadaUrl == null || n.fotoPortadaUrl!.isEmpty)
        .length;
    final sinClasificar = negocios
        .where((n) => n.categoriaOficial?.slug == 'pendiente-clasificar')
        .length;

    final porMunicipio = _conteo(negocios, (n) => n.municipio);
    final porCategoria = _conteo(
        negocios, (n) => n.categoriaOficial?.nombre ?? 'Sin categoría');
    final porEstado =
        _conteo(negocios, (n) => (n.novedad ?? 'Sin estado'));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1040),
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
                      Text('Hola de nuevo',
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 4),
                      Text('${todos.length} negocios registrados en total',
                          style: const TextStyle(
                              color: NVColors.textoSecundario)),
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
            const SizedBox(height: 16),
            Text('Vista: ${_vista.etiqueta} · ${negocios.length} negocios',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: NVColors.primaryDark)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _kpi('Publicados', activos, Icons.check_circle_outline,
                    NVColors.exito),
                _kpi('CDMB los marca ACTIVO, faltan publicar',
                    pendientesDePublicar, Icons.hourglass_top,
                    NVColors.advertencia),
                _kpi('Sin foto de portada', sinFoto,
                    Icons.image_not_supported_outlined, NVColors.error),
                _kpi('Sin categoría clasificada', sinClasificar,
                    Icons.category_outlined, NVColors.error),
                _kpi('Municipios con negocios', porMunicipio.length,
                    Icons.map_outlined, NVColors.verdeVivo),
              ],
            ),
            const SizedBox(height: 28),

            _tituloGrafica('Negocios por municipio'),
            NVCard(
              child: SizedBox(
                height: 260,
                child: porMunicipio.isEmpty
                    ? const _SinDatos()
                    : _BarrasHorizontales(datos: porMunicipio),
              ),
            ),
            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tituloGrafica('Por categoría oficial'),
                      NVCard(
                        child: SizedBox(
                          height: 240,
                          child: porCategoria.isEmpty
                              ? const _SinDatos()
                              : _Torta(datos: porCategoria),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _tituloGrafica('Por estado CDMB'),
                      NVCard(
                        child: SizedBox(
                          height: 240,
                          child: porEstado.isEmpty
                              ? const _SinDatos()
                              : _Torta(datos: porEstado),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (_promedioPorAnio.isNotEmpty) ...[
              _tituloGrafica('Puntaje de seguimiento promedio por año'),
              NVCard(
                child: SizedBox(
                  height: 240,
                  child: _LineaPromedio(promedio: _promedioPorAnio),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (_vista == _Vista.global) ...[
              _tituloGrafica('Combinaciones de reconocimientos'),
              const Text(
                'Los 3 reconocimientos son independientes: un negocio puede '
                'tener 1, 2 o los 3.',
                style: TextStyle(fontSize: 12, color: NVColors.textoSecundario),
              ),
              const SizedBox(height: 8),
              NVCard(
                child: Column(
                  children: [
                    for (final c in _combosReconocimiento(todos))
                      _filaBarra(c.$1, c.$2, todos.isEmpty ? 1 : todos.length,
                          esCero: c.$2 == 0),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (_topPuntajes != null && _topPuntajes!.isNotEmpty) ...[
              _tituloGrafica(
                  'Mejores puntajes (${_topPuntajes!.first.anio})'),
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

  // ---------- helpers de datos ----------

  Map<String, int> _conteo(List<Negocio> lista, String Function(Negocio) clave) {
    final m = <String, int>{};
    for (final n in lista) {
      final k = clave(n);
      m[k] = (m[k] ?? 0) + 1;
    }
    return m;
  }

  List<(String, int)> _combosReconocimiento(List<Negocio> negocios) {
    int c(bool ev, bool sm, bool av) => negocios
        .where((n) =>
            n.emprendimientoVerde == ev &&
            n.selloMarca == sm &&
            n.avalado == av)
        .length;
    return [
      ('Emprendimiento Verde + Sello Marca + Avalado', c(true, true, true)),
      ('Emprendimiento Verde + Sello Marca', c(true, true, false)),
      ('Emprendimiento Verde + Avalado', c(true, false, true)),
      ('Sello Marca + Avalado', c(false, true, true)),
      ('Solo Emprendimiento Verde', c(true, false, false)),
      ('Solo Sello Marca', c(false, true, false)),
      ('Solo Avalado', c(false, false, true)),
      ('Sin ningún reconocimiento', c(false, false, false)),
    ];
  }

  // ---------- widgets ----------

  Widget _tituloGrafica(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(t, style: Theme.of(context).textTheme.titleMedium),
      );

  Widget _kpi(String etiqueta, int valor, IconData icono, Color color) {
    return SizedBox(
      width: 230,
      child: NVCard(
        onTap: () => context.go('/admin/negocios'),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
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

  Widget _filaBarra(String etiqueta, int valor, int maximo,
      {bool esCero = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(etiqueta, style: const TextStyle(fontSize: 13))),
              const SizedBox(width: 8),
              Text('$valor',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: maximo == 0 ? 0 : valor / maximo,
              minHeight: 8,
              backgroundColor: NVColors.fondo,
              valueColor: AlwaysStoppedAnimation(
                  esCero ? NVColors.borde : NVColors.verdeVivo),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaTopPuntaje(
      int puesto, ({String nombre, String slug, int anio, double puntaje}) f) {
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
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(width: 8),
            Expanded(
                child: Text(f.nombre,
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
            Text(f.puntaje.toStringAsFixed(1),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: NVColors.verdeVivo)),
          ],
        ),
      ),
    );
  }
}

class _SinDatos extends StatelessWidget {
  const _SinDatos();
  @override
  Widget build(BuildContext context) => const Center(
        child: Text('No hay datos con esta vista.',
            style: TextStyle(color: NVColors.textoSecundario)),
      );
}

/// Barras horizontales (fl_chart girado): útil cuando las etiquetas son
/// nombres largos como los municipios.
class _BarrasHorizontales extends StatelessWidget {
  final Map<String, int> datos;
  const _BarrasHorizontales({required this.datos});

  @override
  Widget build(BuildContext context) {
    final entradas = datos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxY = (entradas.first.value.toDouble() * 1.15)
        .ceilToDouble()
        .clamp(1.0, 1e9);
    return BarChart(
      BarChartData(
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIdx, rod, rodIdx) => BarTooltipItem(
              '${entradas[group.x].key}\n${rod.toY.toInt()}',
              const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: NVColors.borde, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 56,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= entradas.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(entradas[i].key,
                        style: const TextStyle(fontSize: 10)),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (final (i, e) in entradas.indexed)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: e.value.toDouble(),
                color: NVColors.primary,
                width: 16,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ]),
        ],
      ),
    );
  }
}

/// Torta / dona con leyenda al lado.
class _Torta extends StatelessWidget {
  final Map<String, int> datos;
  const _Torta({required this.datos});

  @override
  Widget build(BuildContext context) {
    final entradas = datos.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entradas.fold<int>(0, (s, e) => s + e.value);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 34,
              sections: [
                for (final (i, e) in entradas.indexed)
                  PieChartSectionData(
                    value: e.value.toDouble(),
                    title: total == 0
                        ? ''
                        : '${(e.value * 100 / total).round()}%',
                    color: _paleta[i % _paleta.length],
                    radius: 52,
                    titleStyle: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (i, e) in entradas.indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _paleta[i % _paleta.length],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('${e.key} (${e.value})',
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LineaPromedio extends StatelessWidget {
  final Map<int, double> promedio;
  const _LineaPromedio({required this.promedio});

  @override
  Widget build(BuildContext context) {
    final anios = promedio.keys.toList()..sort();
    final spots = [
      for (final a in anios) FlSpot(a.toDouble(), promedio[a]!),
    ];
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: NVColors.borde, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, reservedSize: 32, interval: 25)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${value.toInt()}',
                      style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touched) => [
              for (final t in touched)
                LineTooltipItem(
                  '${t.x.toInt()}: ${t.y.toStringAsFixed(1)}',
                  const TextStyle(color: Colors.white, fontSize: 12),
                ),
            ],
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: NVColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: NVColors.primary.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}
