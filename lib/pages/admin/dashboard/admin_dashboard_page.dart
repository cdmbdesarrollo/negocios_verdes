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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panel administrativo',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '${negocios.length} negocios en total',
            style: const TextStyle(color: NVColors.textoSecundario),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _tarjetaEstadistica(
                  'Publicados', activos, Icons.check_circle, NVColors.exito),
              _tarjetaEstadistica('En verificación', enVerificacion,
                  Icons.hourglass_top, NVColors.nivelEnVerificacion),
              _tarjetaEstadistica('Sin foto de portada', sinFoto,
                  Icons.image_not_supported, NVColors.error),
              _tarjetaEstadistica('Municipios con negocios',
                  porMunicipio.length, Icons.map, NVColors.primary),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Negocios por municipio',
                  style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () => context.go('/admin/negocios'),
                child: const Text('Ver todos los negocios'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          NVCard(
            child: Column(
              children: [
                for (final entrada in municipiosOrdenados)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entrada.key),
                        Text('${entrada.value}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                if (municipiosOrdenados.isEmpty)
                  const Text('Todavía no hay negocios registrados.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaEstadistica(
      String etiqueta, int valor, IconData icono, Color color) {
    return SizedBox(
      width: 220,
      child: NVCard(
        child: Row(
          children: [
            Icon(icono, color: color, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$valor',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
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
}
