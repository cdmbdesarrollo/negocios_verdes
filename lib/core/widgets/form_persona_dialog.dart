import 'package:flutter/material.dart';

import '../../catalogos.dart';
import '../../models/persona.dart';
import '../../services/personas_service.dart';
import '../../theme/nv_colors.dart';

/// Diálogo para crear o editar una persona de cualquiera de las 3 bases
/// (responsable CDMB / delegado / representante legal — ver 0029 / 0031 /
/// 0036). Devuelve la [Persona] guardada, o null si se canceló. Lo usan
/// SelectorPersona (dentro del formulario de un negocio) y /admin/personas.
///
/// El representante legal es SIEMPRE una persona; `naturaleza` solo dice si
/// firma como persona natural o por una entidad jurídica. La razón social
/// NO es un dato de la persona: es el nombre del negocio verde (ver 0036).
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
  late final TextEditingController _direccion;
  late final TextEditingController _cargo;
  String? _tipoDocumento;
  String? _municipio;
  String _naturaleza = 'Natural';
  bool _guardando = false;
  String? _error;

  /// Solo representante en modo edición: los negocios que representa, con su
  /// NIT y naturaleza. El nombre del negocio ES su razón social.
  List<
      ({
        String negocioId,
        String negocio,
        String? nit,
        String? naturaleza,
        bool vigente
      })>? _negocios;

  bool get _esRepr => widget.tipo == TipoPersona.representante;

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
    _direccion = TextEditingController(text: i?.direccion ?? '');
    _cargo = TextEditingController(text: i?.cargo ?? '');
    _tipoDocumento = i?.tipoDocumento;
    _municipio = i?.municipio;
    _naturaleza = i != null && i.esJuridica ? 'Jurídica' : 'Natural';
    if (_esRepr && i != null && i.id.isNotEmpty) {
      _cargarNegocios();
    }
  }

  Future<void> _cargarNegocios() async {
    try {
      final r =
          await widget.servicio.negociosDeRepresentante(widget.inicial!.id);
      if (mounted) setState(() => _negocios = r);
    } catch (_) {}
  }

  Future<void> _editarVinculo(
      ({
        String negocioId,
        String negocio,
        String? nit,
        String? naturaleza,
        bool vigente
      }) v) async {
    final nitCtrl = TextEditingController(text: v.nit ?? '');
    var nat = v.naturaleza ?? 'Natural';
    final ok = await showDialog<bool>(
      context: context,
      builder: (dc) => StatefulBuilder(
        builder: (dc, setD) => AlertDialog(
          title: Text('Datos en ${v.negocio}'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Razón social: ${v.negocio}',
                    style: const TextStyle(
                        fontSize: 12, color: NVColors.textoSecundario)),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: nat,
                  decoration: const InputDecoration(
                      labelText: 'Naturaleza jurídica del negocio'),
                  items: const [
                    DropdownMenuItem(value: 'Natural', child: Text('Natural')),
                    DropdownMenuItem(value: 'Jurídica', child: Text('Jurídica')),
                  ],
                  onChanged: (x) => setD(() => nat = x ?? 'Natural'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nitCtrl,
                  decoration:
                      const InputDecoration(labelText: 'NIT / cédula del negocio'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dc, false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.pop(dc, true),
                child: const Text('Guardar')),
          ],
        ),
      ),
    );
    final nitEditado = nitCtrl.text.trim();
    nitCtrl.dispose();
    if (ok != true) return;
    try {
      await widget.servicio.asignar(
        TipoPersona.representante,
        negocioId: v.negocioId,
        personaId: widget.inicial!.id,
        nit: nitEditado.isEmpty ? null : nitEditado,
        naturalezaJuridica: nat,
      );
      await _cargarNegocios();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  /// Lista guía + el valor actual si viniera de un dato viejo fuera de la
  /// lista (para no perderlo en el desplegable).
  List<String> get _tiposDoc => [
        if (_tipoDocumento != null &&
            _tipoDocumento!.isNotEmpty &&
            !kTiposDocumento.contains(_tipoDocumento))
          _tipoDocumento!,
        ...kTiposDocumento,
      ];

  @override
  void dispose() {
    _nombres.dispose();
    _apellidos.dispose();
    _documento.dispose();
    _telefono.dispose();
    _correo.dispose();
    _direccion.dispose();
    _cargo.dispose();
    super.dispose();
  }

  String? _nn(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _guardar() async {
    if (_nombres.text.trim().isEmpty) {
      setState(() => _error = 'El nombre es obligatorio.');
      return;
    }
    setState(() {
      _guardando = true;
      _error = null;
    });
    try {
      final propuesta = Persona(
        id: widget.inicial?.id ?? '',
        nombres: _nombres.text.trim(),
        apellidos: _nn(_apellidos),
        naturalezaJuridica: _esRepr ? _naturaleza : null,
        documento: _nn(_documento),
        tipoDocumento: _tipoDocumento,
        telefono: _nn(_telefono),
        correo: _nn(_correo),
        direccion: _nn(_direccion),
        municipio: _municipio,
        cargo: _esRepr ? null : _nn(_cargo),
      );
      final id = await widget.servicio.guardarPersona(widget.tipo, propuesta);
      if (!mounted) return;
      Navigator.pop(
        context,
        Persona(
          id: id,
          nombres: propuesta.nombres,
          apellidos: propuesta.apellidos,
          naturalezaJuridica: propuesta.naturalezaJuridica,
          documento: propuesta.documento,
          tipoDocumento: propuesta.tipoDocumento,
          telefono: propuesta.telefono,
          correo: propuesta.correo,
          direccion: propuesta.direccion,
          municipio: propuesta.municipio,
          cargo: propuesta.cargo,
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
          ? 'Nuevo ${widget.tipo.etiqueta.toLowerCase()}'
          : 'Editar ${widget.inicial!.nombreCompleto}'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_esRepr) ...[
                _rotulo('¿Firma como persona natural o por una entidad jurídica?'),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                        value: 'Natural', label: Text('Persona natural')),
                    ButtonSegment(value: 'Jurídica', label: Text('Jurídica')),
                  ],
                  selected: {_naturaleza},
                  onSelectionChanged: (s) =>
                      setState(() => _naturaleza = s.first),
                ),
                const SizedBox(height: 12),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nombres,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          const InputDecoration(labelText: 'Nombres *'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _apellidos,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          const InputDecoration(labelText: 'Apellidos'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: _tipoDocumento,
                      isExpanded: true,
                      decoration: const InputDecoration(
                          labelText: 'Tipo de documento'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('—')),
                        for (final t in _tiposDoc)
                          DropdownMenuItem(value: t, child: Text(t)),
                      ],
                      onChanged: (v) => setState(() => _tipoDocumento = v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _documento,
                      decoration: const InputDecoration(labelText: 'Número'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (!_esRepr) ...[
                TextField(
                  controller: _cargo,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Cargo'),
                ),
                const SizedBox(height: 10),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _telefono,
                      decoration:
                          const InputDecoration(labelText: 'Teléfono'),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _correo,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _direccion,
                      textCapitalization: TextCapitalization.sentences,
                      decoration:
                          const InputDecoration(labelText: 'Dirección'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _municipio,
                      isExpanded: true,
                      decoration:
                          const InputDecoration(labelText: 'Municipio'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('—')),
                        for (final m in kMunicipios)
                          DropdownMenuItem(value: m, child: Text(m)),
                      ],
                      onChanged: (v) => setState(() => _municipio = v),
                    ),
                  ),
                ],
              ),
              if (_esRepr && (_negocios?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 10),
                const Text(
                    'Representa a  (la razón social es el nombre del negocio; '
                    'toca una fila para editar su NIT / naturaleza)',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: NVColors.textoSecundario)),
                const SizedBox(height: 6),
                for (final n in _negocios!)
                  InkWell(
                    onTap: n.vigente ? () => _editarVinculo(n) : null,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            n.vigente
                                ? Icons.check_circle
                                : Icons.history_toggle_off,
                            size: 14,
                            color: n.vigente
                                ? NVColors.verdeVivo
                                : NVColors.textoSecundario,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Razón social: ${n.negocio}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                Text(
                                  [
                                    if ((n.nit ?? '').isNotEmpty) 'NIT ${n.nit}',
                                    if ((n.naturaleza ?? '').isNotEmpty)
                                      n.naturaleza!,
                                    if (!n.vigente) 'anterior',
                                  ].join('  ·  '),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: NVColors.textoSecundario),
                                ),
                              ],
                            ),
                          ),
                          if (n.vigente)
                            const Icon(Icons.edit_outlined,
                                size: 14, color: NVColors.textoSecundario),
                        ],
                      ),
                    ),
                  ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!,
                    style: const TextStyle(
                        color: NVColors.error, fontSize: 12)),
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

  Widget _rotulo(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style: const TextStyle(
                fontSize: 12, color: NVColors.textoSecundario)),
      );
}
