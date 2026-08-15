import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/admin_guard.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/negocio.dart';
import '../../../services/negocio_service.dart';
import '../../../theme/nv_colors.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _service = NegocioService();
  List<Negocio>? _negocios;
  String? _error;

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

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    final negocios = _negocios;
    if (negocios == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final activos = negocios.where((n) => n.activo).length;
    final enVerificacion =
        negocios.where((n) => n.nivelDesarrollo == 'en_verificacion').length;
    final sinFoto = negocios
        .where((n) => n.fotoPortadaUrl == null || n.fotoPortadaUrl!.isEmpty)
        .length;
    final porMunicipio = <String, int>{};
    for (final n in negocios) {
      porMunicipio[n.municipio] = (porMunicipio[n.municipio] ?? 0) + 1;
    }
    final municipiosOrdenados = porMunicipio.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxMunicipio = municipiosOrdenados.isEmpty
        ? 1
        : municipiosOrdenados.first.value;

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
                        '${negocios.length} negocios registrados en total',
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
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _tarjetaEstadistica(
                  context,
                  etiqueta: 'Publicados',
                  valor: activos,
                  icono: Icons.check_circle_outline,
                  color: NVColors.exito,
                ),
                _tarjetaEstadistica(
                  context,
                  etiqueta: 'En verificación',
                  valor: enVerificacion,
                  icono: Icons.hourglass_top,
                  color: NVColors.nivelEnVerificacion,
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
                  etiqueta: 'Municipios con negocios',
                  valor: porMunicipio.length,
                  icono: Icons.map_outlined,
                  color: NVColors.verdeVivo,
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Negocios por municipio',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            NVCard(
              child: municipiosOrdenados.isEmpty
                  ? const Text('Todavía no hay negocios registrados.')
                  : Column(
                      children: [
                        for (final entrada in municipiosOrdenados)
                          _filaMunicipio(entrada.key, entrada.value, maxMunicipio),
                      ],
                    ),
            ),
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
