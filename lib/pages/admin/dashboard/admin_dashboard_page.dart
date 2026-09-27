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
/// gráficas — pedido explícito: "una vista por cada categoría, estado, etc. y
/// otro global. Con KPI por cada caso y global".
///
/// `estado` no es una vista fija sino un selector: el estado CDMB concreto
/// (ACTIVO / INACTIVO / RETIRADO / SUSPENDIDO) lo elige el usuario en el
/// dropdown y vive en `_AdminDashboardPageState._estadoSel`.
enum _Vista { global, estado, emprendimientoVerde, selloMarca, avalado }

/// Estados CDMB (columna `negocios.novedad`, CHECK `negocios_novedad_valida`).
const _kEstados = ['ACTIVO', 'INACTIVO', 'RETIRADO', 'SUSPENDIDO'];

/// Puntaje con coma decimal, como se escribe en Colombia (60,3).
String _fmtPuntaje(double p) => p.toStringAsFixed(1).replaceAll('.', ',');

/// Promedio y cantidad de negocios calificados de un grupo de puntajes.
typedef _Resumen = ({double promedio, int negocios});

_Resumen _resumir(Iterable<PuntajeNegocio> ps) {
  var suma = 0.0;
  var n = 0;
  for (final p in ps) {
    suma += p.puntaje;
    n++;
  }
  return (promedio: n == 0 ? 0.0 : suma / n, negocios: n);
}

String _capitalizar(String s) =>
    s.isEmpty ? s : '${s[0]}${s.substring(1).toLowerCase()}';

extension on _Vista {
  String get etiqueta => switch (this) {
        _Vista.global => 'Global',
        _Vista.estado => 'Estado CDMB',
        _Vista.emprendimientoVerde => 'Emprendimiento Verde',
        _Vista.selloMarca => 'Sello Marca',
        _Vista.avalado => 'Avalado',
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
  /// Solo puntajes calificados (> 0) — ver listarPuntajesCalificados().
  List<PuntajeNegocio> _puntajes = [];

  /// Año elegido en "Puntajes por año" (null = el más reciente con datos).
  int? _anioPuntaje;
  bool _rankingCompleto = false;
  static const _topRanking = 10;
  String? _error;
  _Vista _vista = _Vista.global;

  /// Estado CDMB elegido en el selector. `null` = "Todos los estados"
  /// (misma población que Global, pero deja ver el desglose por estado).
  String? _estadoSel = 'ACTIVO';

  /// Etiqueta legible de la vista actual (para el título).
  String get _etiquetaVista => _vista != _Vista.estado
      ? _vista.etiqueta
      : _estadoSel == null
          ? 'Todos los estados'
          : _capitalizar(_estadoSel!);

  bool _aplicaVista(Negocio n) => switch (_vista) {
        _Vista.global => true,
        _Vista.estado => _estadoSel == null ||
            (n.novedad ?? '').toUpperCase() == _estadoSel,
        _Vista.emprendimientoVerde => n.emprendimientoVerde,
        _Vista.selloMarca => n.selloMarca,
        _Vista.avalado => n.avalado,
      };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final negocios = await _service.listarTodosAdmin();
      var puntajes = <PuntajeNegocio>[];
      try {
        puntajes = await _service.listarPuntajesCalificados();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _negocios = negocios;
          _puntajes = puntajes;
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

    final negocios = todos.where(_aplicaVista).toList();

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

    // Los puntajes siguen la vista elegida (estado, reconocimiento…).
    final idsVista = {for (final n in negocios) n.id};
    final puntajes =
        _puntajes.where((p) => idsVista.contains(p.negocioId)).toList();
    final porAnio = <int, _Resumen>{
      for (final anio in {for (final p in puntajes) p.anio})
        anio: _resumir(puntajes.where((p) => p.anio == anio)),
    };
    final porCategoria = _conteo(
        negocios, (n) => n.categoriaOficial?.nombre ?? 'Sin categoría');
    // Vista normal: torta por estado CDMB. Vista = un estado concreto: esa
    // torta sería un solo color, así que se muestra publicado vs. sin
    // publicar dentro de ese estado.
    final vistaEstadoConcreto =
        _vista == _Vista.estado && _estadoSel != null;
    final segundaTorta = vistaEstadoConcreto
        ? (
            titulo: 'Publicación en el sitio',
            datos: _conteo(negocios,
                (n) => n.activo ? 'Publicado' : 'Sin publicar'),
          )
        : (
            titulo: 'Por estado CDMB',
            datos: _conteo(negocios, (n) => (n.novedad ?? 'Sin estado')),
          );

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
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final v in _Vista.values)
                  if (v == _Vista.estado)
                    _SelectorEstado(
                      seleccionado: _vista == _Vista.estado,
                      estado: _estadoSel,
                      onEstado: (e) => setState(() {
                        _vista = _Vista.estado;
                        _estadoSel = e;
                      }),
                    )

                  else
                    ChipFiltro(
                      etiqueta: v.etiqueta,
                      seleccionado: _vista == v,
                      onTap: () => setState(() => _vista = v),
                    ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Vista: $_etiquetaVista · ${negocios.length} negocios',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: NVColors.primaryDark)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _kpi('Publicados en el sitio', activos,
                    Icons.check_circle_outline, NVColors.exito),
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
                      _tituloGrafica(segundaTorta.titulo),
                      NVCard(
                        child: SizedBox(
                          height: 240,
                          child: segundaTorta.datos.isEmpty
                              ? const _SinDatos()
                              : _Torta(datos: segundaTorta.datos),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (porAnio.isNotEmpty) ...[
              _tituloGrafica('Puntaje de seguimiento promedio por año'),
              const Text(
                'Solo cuenta los negocios calificados ese año: los que no '
                'existían o no se evaluaron (puntaje 0 o vacío) no entran al '
                'promedio. Debajo de cada año, cuántos negocios se '
                'promediaron.',
                style: TextStyle(fontSize: 12, color: NVColors.textoSecundario),
              ),
              const SizedBox(height: 8),
              NVCard(
                child: SizedBox(
                  height: 260,
                  child: _LineaPromedio(porAnio: porAnio),
                ),
              ),
              const SizedBox(height: 24),
              ..._seccionPuntajesPorAnio(puntajes, porAnio),
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

          ],
        ),
      ),
    );
  }

  /// "Puntajes por año" — pedido explícito: elegir el año (2026, 2025,
  /// 2024…) y ver el listado de mejores puntajes de ese año, más el
  /// promedio por municipio de ese mismo año.
  List<Widget> _seccionPuntajesPorAnio(
      List<PuntajeNegocio> puntajes, Map<int, _Resumen> porAnio) {
    final anios = porAnio.keys.toList()..sort((a, b) => b.compareTo(a));
    final anio = _anioPuntaje != null && anios.contains(_anioPuntaje)
        ? _anioPuntaje!
        : anios.first;
    final delAnio = puntajes.where((p) => p.anio == anio).toList()
      ..sort((a, b) => b.puntaje.compareTo(a.puntaje));
    final resumen = porAnio[anio]!;

    final municipios = {for (final p in delAnio) p.municipio}.toList();
    final porMunicipio = [
      for (final m in municipios)
        (municipio: m, r: _resumir(delAnio.where((p) => p.municipio == m))),
    ]..sort((a, b) => b.r.promedio.compareTo(a.r.promedio));

    final ranking =
        _rankingCompleto ? delAnio : delAnio.take(_topRanking).toList();

    final tarjetaRanking = NVCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mejores puntajes $anio',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          for (final (i, fila) in ranking.indexed)
            _filaTopPuntaje(i + 1, fila),
          if (delAnio.length > _topRanking)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    setState(() => _rankingCompleto = !_rankingCompleto),
                child: Text(_rankingCompleto
                    ? 'Ver solo los $_topRanking mejores'
                    : 'Ver los ${delAnio.length} negocios calificados'),
              ),
            ),
        ],
      ),
    );

    final tarjetaMunicipios = NVCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Promedio por municipio $anio',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          for (final m in porMunicipio)
            _filaPromedio(
              m.municipio.isEmpty ? 'Sin municipio' : m.municipio,
              m.r,
            ),
        ],
      ),
    );

    return [
      _tituloGrafica('Puntajes por año'),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final a in anios)
            ChipFiltro(
              etiqueta: '$a',
              seleccionado: a == anio,
              onTap: () => setState(() {
                _anioPuntaje = a;
                _rankingCompleto = false;
              }),
            ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        '$anio: promedio ${_fmtPuntaje(resumen.promedio)} de '
        '${resumen.negocios} negocios calificados',
        style: const TextStyle(
            fontWeight: FontWeight.w600, color: NVColors.primaryDark),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, c) => c.maxWidth >= 760
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: tarjetaRanking),
                  const SizedBox(width: 16),
                  Expanded(child: tarjetaMunicipios),
                ],
              )
            : Column(
                children: [
                  tarjetaRanking,
                  const SizedBox(height: 16),
                  tarjetaMunicipios,
                ],
              ),
      ),
      const SizedBox(height: 24),
    ];
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

  Widget _filaTopPuntaje(int puesto, PuntajeNegocio f) {
    final medalla = switch (puesto) {
      1 => '🥇',
      2 => '🥈',
      3 => '🥉',
      _ => '$puesto',
    };
    return InkWell(
      onTap: () => context.go('/admin/negocios/${f.negocioId}/editar'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.nombre,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  if (f.municipio.isNotEmpty)
                    Text(f.municipio,
                        style: const TextStyle(
                            fontSize: 11, color: NVColors.textoSecundario)),
                ],
              ),
            ),
            Text(_fmtPuntaje(f.puntaje),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: NVColors.verdeVivo)),
          ],
        ),
      ),
    );
  }

  /// Fila "Municipio ····· 62,4 · 35 negocios" con barra sobre 100.
  Widget _filaPromedio(String etiqueta, _Resumen r) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(etiqueta, style: const TextStyle(fontSize: 13))),
              const SizedBox(width: 8),
              Text(_fmtPuntaje(r.promedio),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '  · ${r.negocios} '
                '${r.negocios == 1 ? 'negocio' : 'negocios'}',
                style: const TextStyle(
                    fontSize: 11, color: NVColors.textoSecundario),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (r.promedio / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: NVColors.fondo,
              valueColor: const AlwaysStoppedAnimation(NVColors.verdeVivo),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip con dropdown para elegir el estado CDMB (Todos / ACTIVO / INACTIVO
/// / RETIRADO / SUSPENDIDO) como "vista" del panel. Se ve igual que un
/// ChipFiltro pero con una flechita. `null` = "Todos los estados".
const _kTodosEstados = '__todos__';

class _SelectorEstado extends StatelessWidget {
  final bool seleccionado;
  final String? estado;
  final ValueChanged<String?> onEstado;

  const _SelectorEstado({
    required this.seleccionado,
    required this.estado,
    required this.onEstado,
  });

  @override
  Widget build(BuildContext context) {
    final etiqueta = !seleccionado
        ? 'Estado CDMB'
        : estado == null
            ? 'Todos los estados'
            : _capitalizar(estado!);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 40),
      child: PopupMenuButton<String>(
        initialValue: estado ?? _kTodosEstados,
        onSelected: (v) => onEstado(v == _kTodosEstados ? null : v),
        itemBuilder: (_) => [
          const PopupMenuItem(
              value: _kTodosEstados, child: Text('Todos los estados')),
          for (final e in _kEstados)
            PopupMenuItem(
              value: e,
              child: Text(_capitalizar(e)),
            ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color:
                seleccionado ? NVColors.verdeMenu : NVColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (seleccionado)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.check, size: 16),
                ),
              Text(etiqueta,
                  style: TextStyle(
                      color: NVColors.textoPrincipal,
                      fontWeight:
                          seleccionado ? FontWeight.w600 : FontWeight.normal)),
              const Icon(Icons.arrow_drop_down, size: 20),
            ],
          ),
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
    final maxVal = entradas.first.value;
    final maxY = (maxVal * 1.18).ceilToDouble().clamp(4.0, 1e9);
    final paso = (maxY / 4).ceilToDouble().clamp(1.0, 1e9);
    return BarChart(
      BarChartData(
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        // Los valores se muestran SIEMPRE (arriba de cada barra), no solo al
        // tocar (pedido explícito).
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 2,
            getTooltipItem: (group, groupIdx, rod, rodIdx) => BarTooltipItem(
              '${rod.toY.toInt()}',
              const TextStyle(
                  color: NVColors.textoPrincipal,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: paso,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: NVColors.borde, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, reservedSize: 30, interval: paso)),
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
            BarChartGroupData(
              x: i,
              showingTooltipIndicators: const [0],
              barRods: [
                BarChartRodData(
                  toY: e.value.toDouble(),
                  color: NVColors.primary,
                  width: 16,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
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
  final Map<int, _Resumen> porAnio;
  const _LineaPromedio({required this.porAnio});

  @override
  Widget build(BuildContext context) {
    final anios = porAnio.keys.toList()..sort();
    final spots = [
      for (final a in anios) FlSpot(a.toDouble(), porAnio[a]!.promedio),
    ];
    final linea = LineChartBarData(
      spots: spots,
      isCurved: true,
      preventCurveOverShooting: true,
      color: NVColors.primary,
      barWidth: 3,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        color: NVColors.primary.withValues(alpha: 0.12),
      ),
    );
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        // Margen a los lados para que el primer/último año no queden
        // pegados al borde (y con un solo año haya ancho que dibujar).
        minX: anios.first - (anios.length == 1 ? 1 : 0.3),
        maxX: anios.last + (anios.length == 1 ? 1 : 0.3),
        // El valor de cada año se muestra SIEMPRE, no solo al tocar.
        showingTooltipIndicators: [
          for (var i = 0; i < spots.length; i++)
            ShowingTooltipIndicators([LineBarSpot(linea, 0, spots[i])]),
        ],
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
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox();
                final r = porAnio[value.toInt()];
                if (r == null) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${value.toInt()}',
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600)),
                      Text('${r.negocios} negocios',
                          style: const TextStyle(
                              fontSize: 9.5,
                              color: NVColors.textoSecundario)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: false,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => Colors.transparent,
            tooltipPadding: EdgeInsets.zero,
            getTooltipItems: (touched) => [
              for (final t in touched)
                LineTooltipItem(
                  _fmtPuntaje(t.y),
                  const TextStyle(
                      color: NVColors.textoPrincipal,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        lineBarsData: [linea],
      ),
    );
  }
}
