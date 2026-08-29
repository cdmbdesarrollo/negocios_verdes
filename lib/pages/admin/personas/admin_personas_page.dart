import 'package:flutter/material.dart';

import '../../../catalogos.dart';
import '../../../core/admin_guard.dart';
import '../../../core/texto_utils.dart';
import '../../../core/widgets/barra_paginacion.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../core/widgets/dialogo_confirmar_borrado.dart';
import '../../../core/widgets/form_persona_dialog.dart';
import '../../../models/persona.dart';
import '../../../services/personas_service.dart';
import '../../../theme/nv_colors.dart';

/// Gestión de las tres bases de personas (ver 0029–0032) sin abrir un
/// negocio: responsables CDMB, delegados y representantes legales. La lista
/// se muestra como tabla (identificación, nombre / razón social, municipio,
/// negocios) al estilo de la lista de solicitantes de trámites CDMB.
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
  String? _municipio;

  static const _porPagina = 20;
  int _pagina = 0;

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
    var lista = _personas ?? [];
    if (_municipio != null) {
      lista = lista.where((p) => p.municipio == _municipio).toList();
    }
    final q = quitarTildes(_busqueda.trim().toLowerCase());
    if (q.isNotEmpty) {
      lista = lista.where((p) {
        final texto = quitarTildes([
          p.nombreCompleto,
          p.negociosNombres ?? '',
          p.documento ?? '',
          p.nitsNegocios ?? '',
          p.telefono ?? '',
          p.correo ?? '',
          p.cargo ?? '',
        ].join(' ').toLowerCase());
        return texto.contains(q);
      }).toList();
    }
    return lista;
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
      builder: (dc) => DialogoConfirmarBorrado(
        titulo: 'Eliminar a ${persona.nombreCompleto}',
        advertencia:
            'Se borra a ${persona.nombreCompleto} de la base de '
            '${_tipo.etiqueta.toLowerCase()}s. Esto no se puede deshacer. '
            'Solo funciona si nunca estuvo asignada a un negocio.',
        etiquetaConfirmar: 'Eliminar',
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

  void _cambiarFiltro(VoidCallback cambio) => setState(() {
        cambio();
        _pagina = 0;
      });

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
                        setState(() {
                          _tipo = t;
                          _pagina = 0;
                        });
                        _cargar();
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'NIT, cédula, nombre, cargo o correo…',
                        isDense: true,
                      ),
                      onChanged: (v) => _cambiarFiltro(() => _busqueda = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      initialValue: _municipio,
                      isExpanded: true,
                      decoration: const InputDecoration(
                          labelText: 'Municipio', isDense: true),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todos')),
                        for (final m in kMunicipios)
                          DropdownMenuItem(value: m, child: Text(m)),
                      ],
                      onChanged: (v) => _cambiarFiltro(() => _municipio = v),
                    ),
                  ),
                ],
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
    if (_error != null) return Center(child: Text(_error!));
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

    final totalPaginas = ((visibles.length - 1) ~/ _porPagina) + 1;
    final pagina = _pagina.clamp(0, totalPaginas - 1);
    final desde = pagina * _porPagina;
    final hasta = (desde + _porPagina).clamp(0, visibles.length);
    final filas = visibles.sublist(desde, hasta);

    return Column(
      children: [
        // Paginador ARRIBA de la tabla: siempre visible sin scroll y sin que
        // el FloatingActionButton (abajo a la derecha) lo tape.
        BarraPaginacion(
          desde: desde + 1,
          hasta: hasta,
          total: visibles.length,
          pagina: pagina,
          totalPaginas: totalPaginas,
          onCambioPagina: (p) => setState(() => _pagina = p),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
            child: Column(
              children: [
                _encabezado(),
                for (final p in filas) _fila(p),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static const _wIdent = 3;
  static const _wNombre = 4;
  static const _wMunicipio = 2;
  static const _wNegocios = 2;
  static const _wAcciones = 2;

  /// Documento propio; si no lo tiene (representante con NIT distinto por
  /// negocio), el/los NIT de sus negocios.
  String _identificacion(Persona p) {
    final d = p.documento?.trim() ?? '';
    if (d.isNotEmpty) return d;
    final nits = (p.nitsNegocios ?? '')
        .split(' ')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    if (nits.isEmpty) return '—';
    return nits.length == 1 ? nits.first : '${nits.first} +${nits.length - 1}';
  }

  Widget _encabezado() {
    Widget h(String t, int flex) => Expanded(
          flex: flex,
          child: Text(t.toUpperCase(),
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: NVColors.textoSecundario)),
        );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: NVColors.borde)),
      ),
      child: Row(
        children: [
          h('Identificación', _wIdent),
          h(_tipo == TipoPersona.representante
              ? 'Representante legal / razón social'
              : 'Nombre', _wNombre),
          h('Municipio', _wMunicipio),
          h('Negocios', _wNegocios),
          h('', _wAcciones),
        ],
      ),
    );
  }

  Widget _fila(Persona p) {
    final total = p.negociosTotal ?? 0;
    final vigentes = p.negociosVigentes ?? 0;
    final sePuedeEliminar = total == 0;
    final esRepr = _tipo == TipoPersona.representante;
    final razones = (p.negociosNombres ?? '').replaceAll(' | ', ', ');
    return InkWell(
      onTap: () => _crearOEditar(persona: p),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: NVColors.borde)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: _wIdent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_identificacion(p)),
                  Text(
                    esRepr
                        ? (p.naturalezaJuridica ?? '—')
                        : (p.tipoDocumento ?? ''),
                    style: const TextStyle(
                        fontSize: 11, color: NVColors.textoSecundario),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: _wNombre,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.nombreCompleto,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (esRepr && razones.isNotEmpty)
                    Text('Razón social: $razones',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11, color: NVColors.textoSecundario)),
                  if ([p.cargo, p.telefono, p.correo]
                      .any((e) => (e ?? '').isNotEmpty))
                    Text(
                      [
                        if ((p.cargo ?? '').isNotEmpty) p.cargo!,
                        if ((p.telefono ?? '').isNotEmpty) p.telefono!,
                        if ((p.correo ?? '').isNotEmpty) p.correo!,
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, color: NVColors.textoSecundario),
                    ),
                ],
              ),
            ),
            Expanded(
                flex: _wMunicipio,
                child: Text(p.municipio ?? '—',
                    style: const TextStyle(fontSize: 13))),
            Expanded(
              flex: _wNegocios,
              child: Text(
                total == 0
                    ? '—'
                    : '$vigentes${total > vigentes ? ' ($total hist.)' : ''}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              flex: _wAcciones,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Editar',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () => _crearOEditar(persona: p),
                  ),
                  IconButton(
                    tooltip: sePuedeEliminar
                        ? 'Eliminar'
                        : 'Tiene negocios en el historial',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: sePuedeEliminar
                        ? NVColors.error
                        : NVColors.textoSecundario,
                    onPressed: sePuedeEliminar ? () => _eliminar(p) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
