import 'package:flutter/material.dart';

import '../../models/persona.dart';
import '../../services/personas_service.dart';
import '../../theme/nv_colors.dart';
import '../texto_utils.dart';
import 'form_persona_dialog.dart';

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
    if (resultado.cambioSeleccion) {
      onSeleccion(resultado.seleccionada);
    } else if (resultado.idsEliminados.contains(seleccionadaId)) {
      // Borraron (desde el buscador) a la persona que estaba seleccionada.
      onSeleccion(null);
    }
  }

  Future<void> _editar(BuildContext context, Persona persona) async {
    final actualizada = await showDialog<Persona>(
      context: context,
      builder: (_) => FormPersonaDialog(
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
  final bool cambioSeleccion;
  final Set<String> idsEliminados;
  const _ResultadoBuscador(
    this.seleccionada,
    this.lista, {
    this.cambioSeleccion = false,
    this.idsEliminados = const {},
  });
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
  final _idsEliminados = <String>{};

  @override
  void initState() {
    super.initState();
    _lista = List.of(widget.personas);
  }

  void _ordenar() => _lista.sort((a, b) => a.nombreCompleto
      .toLowerCase()
      .compareTo(b.nombreCompleto.toLowerCase()));

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
      builder: (_) => FormPersonaDialog(
        tipo: widget.tipo,
        servicio: widget.servicio,
        inicial: null,
        nombreSugerido: _busquedaCtrl.text.trim(),
      ),
    );
    if (nueva == null || !mounted) return;
    setState(() {
      _lista = [..._lista, nueva];
      _ordenar();
    });
    Navigator.pop(context,
        _ResultadoBuscador(nueva, _lista, cambioSeleccion: true));
  }

  Future<void> _editar(Persona p) async {
    final actualizada = await showDialog<Persona>(
      context: context,
      builder: (_) => FormPersonaDialog(
        tipo: widget.tipo,
        servicio: widget.servicio,
        inicial: p,
      ),
    );
    if (actualizada == null || !mounted) return;
    setState(() {
      _lista = [
        for (final x in _lista)
          if (x.id == actualizada.id) actualizada else x,
      ];
      _ordenar();
    });
  }

  Future<void> _eliminar(Persona p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text('Eliminar a ${p.nombreCompleto}'),
        content: const Text(
            'Solo se puede si nunca estuvo asignada a un negocio.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dc, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(dc, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await widget.servicio.eliminarPersona(widget.tipo, p.id);
      if (!mounted) return;
      setState(() {
        _lista = [for (final x in _lista) if (x.id != p.id) x];
        _idsEliminados.add(p.id);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
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
                        final subtitulo = [
                          if ((p.documento ?? '').isNotEmpty)
                            'CC ${p.documento}',
                          if ((p.telefono ?? '').isNotEmpty) p.telefono!,
                          if ((p.correo ?? '').isNotEmpty) p.correo!,
                        ].join(' · ');
                        final sePuedeEliminar = (p.negociosTotal ?? 0) == 0;
                        return ListTile(
                          dense: true,
                          title: Text(p.nombreCompleto),
                          subtitle:
                              subtitulo.isEmpty ? null : Text(subtitulo),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () => _editar(p),
                              ),
                              IconButton(
                                tooltip: sePuedeEliminar
                                    ? 'Eliminar'
                                    : 'Tiene negocios en el historial',
                                visualDensity: VisualDensity.compact,
                                icon:
                                    const Icon(Icons.delete_outline, size: 18),
                                onPressed:
                                    sePuedeEliminar ? () => _eliminar(p) : null,
                              ),
                            ],
                          ),
                          onTap: () => Navigator.pop(
                              context,
                              _ResultadoBuscador(p, _lista,
                                  cambioSeleccion: true)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
              context,
              _ResultadoBuscador(null, _lista,
                  idsEliminados: _idsEliminados)),
          child: const Text('Cerrar'),
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
