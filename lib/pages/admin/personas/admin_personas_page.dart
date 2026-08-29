import 'package:flutter/material.dart';

import '../../../core/admin_guard.dart';
import '../../../core/texto_utils.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/form_persona_dialog.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/persona.dart';
import '../../../services/personas_service.dart';
import '../../../theme/nv_colors.dart';

/// Gestión de las tres bases de personas (ver 0029 / 0030) sin tener que
/// abrir un negocio: responsables CDMB, delegados y representantes legales.
/// Crear / modificar / eliminar — lo mismo que se puede hacer desde el
/// formulario de un negocio con SelectorPersona, pero en un solo lugar.
class AdminPersonasPage extends StatefulWidget {
  const AdminPersonasPage({super.key});

  @override
  State<AdminPersonasPage> createState() => _AdminPersonasPageState();
}

class _AdminPersonasPageState extends State<AdminPersonasPage> {
  final _servicio = PersonasService();
  TipoPersona _tipo = TipoPersona.responsable;
  List<Persona>? _personas;
  String? _error;
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _personas = null;
      _error = null;
    });
    try {
      final lista = await _servicio.listarConConteo(_tipo);
      if (mounted) setState(() => _personas = lista);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  List<Persona> get _visibles {
    final lista = _personas ?? [];
    final q = quitarTildes(_busqueda.trim().toLowerCase());
    if (q.isEmpty) return lista;
    return lista.where((p) {
      final texto = quitarTildes(
          '${p.nombreCompleto} ${p.documento ?? ''} ${p.telefono ?? ''} ${p.correo ?? ''}'
              .toLowerCase());
      return texto.contains(q);
    }).toList();
  }

  Future<void> _crearOEditar({Persona? persona}) async {
    final guardada = await showDialog<Persona>(
      context: context,
      builder: (_) => FormPersonaDialog(
        tipo: _tipo,
        servicio: _servicio,
        inicial: persona,
      ),
    );
    if (guardada != null) _cargar();
  }

  Future<void> _eliminar(Persona persona) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dc) => AlertDialog(
        title: Text('Eliminar a ${persona.nombreCompleto}'),
        content: const Text(
            'Se borra la persona de esta base. Solo se puede si nunca estuvo '
            'asignada a un negocio.'),
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
    if (confirmar != true) return;
    try {
      await _servicio.eliminarPersona(_tipo, persona.id);
      _cargar();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearOEditar(),
        icon: const Icon(Icons.person_add_alt),
        label: Text('Nuevo ${_tipo.etiqueta.toLowerCase()}'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('Personas',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in TipoPersona.values)
                    ChipFiltro(
                      etiqueta: t.etiqueta,
                      seleccionado: _tipo == t,
                      onTap: () {
                        if (_tipo == t) return;
                        setState(() => _tipo = t);
                        _cargar();
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar por nombre, documento, teléfono o correo…',
                ),
                onChanged: (v) => setState(() => _busqueda = v),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _cuerpo()),
          ],
        ),
      ),
    );
  }

  Widget _cuerpo() {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_personas == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final visibles = _visibles;
    if (visibles.isEmpty) {
      return Center(
        child: Text(
          _personas!.isEmpty
              ? 'Todavía no hay ${_tipo.etiqueta.toLowerCase()}s. Usa el botón "+".'
              : 'Nadie coincide con la búsqueda.',
          style: const TextStyle(color: NVColors.textoSecundario),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
      itemCount: visibles.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _tarjeta(visibles[i]),
    );
  }

  Widget _tarjeta(Persona p) {
    final total = p.negociosTotal ?? 0;
    final vigentes = p.negociosVigentes ?? 0;
    final sePuedeEliminar = total == 0;
    return NVCard(
      key: ValueKey(p.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: NVColors.primaryLight,
            child: Icon(Icons.person_outline,
                size: 18, color: NVColors.primaryDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.nombreCompleto,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if ([p.documento, p.telefono, p.correo]
                    .any((e) => (e ?? '').isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      [
                        if ((p.documento ?? '').isNotEmpty) 'CC ${p.documento}',
                        if ((p.telefono ?? '').isNotEmpty) p.telefono!,
                        if ((p.correo ?? '').isNotEmpty) p.correo!,
                      ].join('  ·  '),
                      style: const TextStyle(
                          fontSize: 12, color: NVColors.textoSecundario),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  total == 0
                      ? 'Sin negocios asignados'
                      : 'En $vigentes negocio(s) ahora'
                          '${total > vigentes ? ' · $total en el historial' : ''}',
                  style: const TextStyle(
                      fontSize: 11, color: NVColors.textoSecundario),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _crearOEditar(persona: p),
          ),
          IconButton(
            tooltip: sePuedeEliminar
                ? 'Eliminar'
                : 'No se puede eliminar: tiene negocios en el historial',
            icon: const Icon(Icons.delete_outline),
            color: sePuedeEliminar ? NVColors.error : NVColors.textoSecundario,
            onPressed: sePuedeEliminar ? () => _eliminar(p) : null,
          ),
        ],
      ),
    );
  }
}
