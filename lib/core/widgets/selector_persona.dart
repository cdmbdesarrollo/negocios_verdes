import 'package:flutter/material.dart';

import '../../models/persona.dart';
import '../../services/personas_service.dart';
import '../../theme/nv_colors.dart';
import '../texto_utils.dart';

/// Campo para elegir un responsable CDMB / delegado / representante desde su
/// base de datos (ver PersonasService / 0029). En vez de un desplegable
/// (inservible cuando hay decenas o cientos de nombres) abre un buscador:
/// se escribe parte del nombre o del documento, se elige de la lista, o se
/// crea/edita la persona ahí mismo (nombres, apellidos, documento, teléfono,
/// correo — cada campo por aparte). Solo muestra el nombre; el resto está a
/// un clic.
class SelectorPersona extends StatelessWidget {
  final TipoPersona tipo;
  final List<Persona> personas;
  final String? seleccionadaId;
  final ValueChanged<Persona?> onSeleccion;
  final ValueChanged<List<Persona>> onPersonasCambiaron;
  final PersonasService servicio;
  final String? etiqueta;

  const SelectorPersona({
    super.key,
    required this.tipo,
    required this.personas,
    required this.seleccionadaId,
    required this.onSeleccion,
    required this.onPersonasCambiaron,
    required this.servicio,
    this.etiqueta,
  });

  Persona? get _seleccionada {
    if (seleccionadaId == null) return null;
    for (final p in personas) {
      if (p.id == seleccionadaId) return p;
    }
    return null;
  }

  Future<void> _abrirBuscador(BuildContext context) async {
    final resultado = await showDialog<_ResultadoBuscador>(
      context: context,
      builder: (_) => _BuscadorPersonaDialog(
        tipo: tipo,
        personas: personas,
        servicio: servicio,
      ),
    );
    if (resultado == null) return;
    onPersonasCambiaron(resultado.lista);
    onSeleccion(resultado.seleccionada);
  }

  Future<void> _editar(BuildContext context, Persona persona) async {
    final actualizada = await showDialog<Persona>(
      context: context,
      builder: (_) => _FormPersonaDialog(
        tipo: tipo,
        servicio: servicio,
        inicial: persona,
      ),
    );
    if (actualizada == null) return;
    final lista = [
      for (final p in personas) if (p.id == actualizada.id) actualizada else p,
    ];
    onPersonasCambiaron(lista);
    onSeleccion(actualizada);
  }

  @override
  Widget build(BuildContext context) {
    final sel = _seleccionada;
    return InputDecorator(
      decoration: InputDecoration(
        labelText: etiqueta ?? tipo.etiqueta,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        children: [
          Expanded(
            child: sel == null
                ? const Text('Sin asignar',
                    style: TextStyle(color: NVColors.textoSecundario))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(sel.nombreCompleto,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      if ((sel.documento ?? '').isNotEmpty ||
                          (sel.telefono ?? '').isNotEmpty)
                        Text(
                          [
                            if ((sel.documento ?? '').isNotEmpty)
                              'CC ${sel.documento}',
                            if ((sel.telefono ?? '').isNotEmpty) sel.telefono!,
                          ].join(' · '),
                          style: const TextStyle(
                              fontSize: 12, color: NVColors.textoSecundario),
                        ),
                    ],
                  ),
          ),
          if (sel != null)
            IconButton(
              tooltip: 'Editar datos de ${sel.nombreCompleto}',
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: () => _editar(context, sel),
            ),
          if (sel != null)
            IconButton(
              tooltip: 'Quitar asignación',
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => onSeleccion(null),
            ),
          TextButton.icon(
            onPressed: () => _abrirBuscador(context),
            icon: const Icon(Icons.search, size: 18),
            label: Text(sel == null ? 'Buscar / crear' : 'Cambiar'),
          ),
        ],
      ),
    );
  }
}

class _ResultadoBuscador {
  final Persona? seleccionada;
  final List<Persona> lista;
  const _ResultadoBuscador(this.seleccionada, this.lista);
}

class _BuscadorPersonaDialog extends StatefulWidget {
  final TipoPersona tipo;
  final List<Persona> personas;
  final PersonasService servicio;

  const _BuscadorPersonaDialog({
    required this.tipo,
    required this.personas,
    required this.servicio,
  });

  @override
  State<_BuscadorPersonaDialog> createState() => _BuscadorPersonaDialogState();
}

class _BuscadorPersonaDialogState extends State<_BuscadorPersonaDialog> {
  late List<Persona> _lista;
  final _busquedaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lista = List.of(widget.personas);
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  List<Persona> get _filtradas {
    final q = quitarTildes(_busquedaCtrl.text.trim().toLowerCase());
    if (q.isEmpty) return _lista;
    return _lista.where((p) {
      final texto = quitarTildes(
          '${p.nombreCompleto} ${p.documento ?? ''} ${p.correo ?? ''}'
              .toLowerCase());
      return texto.contains(q);
    }).toList();
  }

  Future<void> _crear() async {
    final nueva = await showDialog<Persona>(
      context: context,
      builder: (_) => _FormPersonaDialog(
        tipo: widget.tipo,
        servicio: widget.servicio,
        inicial: null,
        nombreSugerido: _busquedaCtrl.text.trim(),
      ),
    );
    if (nueva == null) return;
    setState(() => _lista = [..._lista, nueva]
      ..sort((a, b) => a.nombreCompleto
          .toLowerCase()
          .compareTo(b.nombreCompleto.toLowerCase())));
    if (mounted) {
      Navigator.pop(context, _ResultadoBuscador(nueva, _lista));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtradas = _filtradas;
    return AlertDialog(
      title: Text('Buscar ${widget.tipo.etiqueta.toLowerCase()}'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _busquedaCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Nombre, documento o correo…',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 320,
              child: filtradas.isEmpty
                  ? Center(
                      child: Text(
                        _lista.isEmpty
                            ? 'Todavía no hay ${widget.tipo.etiqueta.toLowerCase()}s.'
                            : 'Nadie coincide con "${_busquedaCtrl.text.trim()}".',
                        style: const TextStyle(color: NVColors.textoSecundario),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filtradas.length,
                      itemBuilder: (context, i) {
                        final p = filtradas[i];
                        return ListTile(
                          dense: true,
                          title: Text(p.nombreCompleto),
                          subtitle: [
                                    if ((p.documento ?? '').isNotEmpty)
                                      'CC ${p.documento}',
                                    if ((p.telefono ?? '').isNotEmpty)
                                      p.telefono!,
                                    if ((p.correo ?? '').isNotEmpty) p.correo!,
                                  ].isEmpty
                              ? null
                              : Text([
                                  if ((p.documento ?? '').isNotEmpty)
                                    'CC ${p.documento}',
                                  if ((p.telefono ?? '').isNotEmpty) p.telefono!,
                                  if ((p.correo ?? '').isNotEmpty) p.correo!,
                                ].join(' · ')),
                          onTap: () => Navigator.pop(
                              context, _ResultadoBuscador(p, _lista)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _crear,
          icon: const Icon(Icons.person_add_alt, size: 18),
          label: const Text('Crear nueva'),
        ),
      ],
    );
  }
}

class _FormPersonaDialog extends StatefulWidget {
  final TipoPersona tipo;
  final PersonasService servicio;
  final Persona? inicial;
  final String? nombreSugerido;

  const _FormPersonaDialog({
    required this.tipo,
    required this.servicio,
    required this.inicial,
    this.nombreSugerido,
  });

  @override
  State<_FormPersonaDialog> createState() => _FormPersonaDialogState();
}

class _FormPersonaDialogState extends State<_FormPersonaDialog> {
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
    _nombres = TextEditingController(
        text: i?.nombres ?? widget.nombreSugerido ?? '');
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
                decoration: const InputDecoration(labelText: 'Nombres *'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _apellidos,
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
