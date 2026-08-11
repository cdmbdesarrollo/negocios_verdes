import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/admin_guard.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/admin_log.dart';
import '../../../services/admin_log_service.dart';
import '../../../theme/nv_colors.dart';

class AdminLogsPage extends StatefulWidget {
  const AdminLogsPage({super.key});

  @override
  State<AdminLogsPage> createState() => _AdminLogsPageState();
}

class _AdminLogsPageState extends State<AdminLogsPage> {
  final _service = AdminLogService();
  List<AdminLog>? _logs;
  String? _error;
  final _formatoFecha = DateFormat('d MMM yyyy, h:mm a', 'es_CO');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final logs = await _service.listarRecientes();
      if (mounted) setState(() => _logs = logs);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  String _resumenAccion(String accion) {
    switch (accion) {
      case 'crear_negocio':
        return 'Creó un negocio';
      case 'editar_negocio':
        return 'Editó un negocio';
      default:
        return accion;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Center(child: Text(_error!));
    final logs = _logs;
    if (logs == null) return const Center(child: CircularProgressIndicator());
    if (logs.isEmpty) {
      return const Center(child: Text('Todavía no hay acciones registradas.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final log = logs[i];
        final nombreDetalle = log.detalle?['nombre']?.toString();
        return NVCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.history, color: NVColors.textoSecundario),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _resumenAccion(log.accion) +
                          (nombreDetalle != null ? ': $nombreDetalle' : ''),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (log.createdAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          _formatoFecha.format(log.createdAt!.toLocal()),
                          style: const TextStyle(
                              fontSize: 12, color: NVColors.textoSecundario),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
