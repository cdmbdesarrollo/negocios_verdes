import 'package:flutter/material.dart';

import '../../models/persona.dart';
import '../../services/personas_service.dart';
import '../../theme/nv_colors.dart';

/// Diálogo para crear o editar una persona (responsable CDMB / delegado /
/// representante) — nombres, apellidos, documento, teléfono y correo, cada
/// campo por aparte. Devuelve la [Persona] guardada, o null si se canceló.
/// Lo usan tanto SelectorPersona (dentro del formulario de un negocio) como
/// la pantalla /admin/personas.
class FormPersonaDialog extends StatefulWidget {
  final TipoPersona tipo;
  final PersonasService servicio;
  final Persona? inicial;
  final String? nombreSugerido;

  const FormPersonaDialog({
    super.key,
    required this.tipo,
    required this.servicio,
    this.inicial,
    this.nombreSugerido,
  });

  @override
  State<FormPersonaDialog> createState() => _FormPersonaDialogState();
}

class _FormPersonaDialogState extends State<FormPersonaDialog> {
  late final TextEditingController _nombres;
  late final TextEditingController _apellidos;
  late final TextEditingController _documento;
  late final TextEditingController _telefono;
  late final TextEditingController _correo;
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final i = widget.inicial;
    _nombres =
        TextEditingController(text: i?.nombres ?? widget.nombreSugerido ?? '');
    _apellidos = TextEditingController(text: i?.apellidos ?? '');
    _documento = TextEditingController(text: i?.documento ?? '');
    _telefono = TextEditingController(text: i?.telefono ?? '');
    _correo = TextEditingController(text: i?.correo ?? '');
  }

  @override
  void dispose() {
    _nombres.dispose();
    _apellidos.dispose();
    _documento.dispose();
    _telefono.dispose();
    _correo.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_nombres.text.trim().isEmpty) {
      setState(() => _error = 'Los nombres son obligatorios.');
      return;
    }
    setState(() {
      _guardando = true;
      _error = null;
    });
    try {
      String? nn(TextEditingController c) =>
          c.text.trim().isEmpty ? null : c.text.trim();
      final id = await widget.servicio.guardarPersona(
        widget.tipo,
        id: widget.inicial?.id,
        nombres: _nombres.text.trim(),
        apellidos: nn(_apellidos),
        documento: nn(_documento),
        telefono: nn(_telefono),
        correo: nn(_correo),
      );
      if (!mounted) return;
      Navigator.pop(
        context,
        Persona(
          id: id,
          nombres: _nombres.text.trim(),
          apellidos: nn(_apellidos),
          documento: nn(_documento),
          telefono: nn(_telefono),
          correo: nn(_correo),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esNueva = widget.inicial == null;
    return AlertDialog(
      title: Text(esNueva
          ? 'Nueva persona — ${widget.tipo.etiqueta.toLowerCase()}'
          : 'Editar ${widget.inicial!.nombreCompleto}'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombres,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nombres *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _apellidos,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _documento,
                decoration:
                    const InputDecoration(labelText: 'Documento de identidad'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _correo,
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!,
                    style: const TextStyle(color: NVColors.error, fontSize: 12)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
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
