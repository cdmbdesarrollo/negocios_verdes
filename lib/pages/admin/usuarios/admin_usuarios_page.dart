import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/admin_guard.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/perfil_admin.dart';
import '../../../services/usuarios_service.dart';
import '../../../theme/nv_colors.dart';

/// Gestión de cuentas administradoras — solo para súper administradores
/// (ver 0039). Crear un usuario, activarlo/desactivarlo, y promover/quitar
/// el nivel de súper admin. No hay correo de invitación (no hay SMTP): al
/// crear una cuenta se muestra la contraseña una vez para entregarla en
/// mano; luego cada quien la cambia en "Mi cuenta".
class AdminUsuariosPage extends StatefulWidget {
  const AdminUsuariosPage({super.key});

  @override
  State<AdminUsuariosPage> createState() => _AdminUsuariosPageState();
}

class _AdminUsuariosPageState extends State<AdminUsuariosPage> {
  final _service = UsuariosService();
  List<PerfilAdmin>? _usuarios;
  String? _error;

  String? get _miId => Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => exigirSuperAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _usuarios = null;
      _error = null;
    });
    try {
      final u = await _service.listar();
      if (mounted) setState(() => _usuarios = u);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  void _mostrarError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
    );
  }

  Future<void> _crear() async {
    final creado = await showDialog<_DatosNuevoUsuario>(
      context: context,
      builder: (_) => const _DialogoNuevoUsuario(),
    );
    if (creado == null) return;
    try {
      await _service.crear(
        email: creado.email,
        password: creado.password,
        nombre: creado.nombre,
        esSuperAdmin: creado.esSuperAdmin,
      );
      if (!mounted) return;
      await _cargar();
      if (mounted) await _mostrarCredenciales(creado);
    } catch (e) {
      _mostrarError(e);
    }
  }

  Future<void> _mostrarCredenciales(_DatosNuevoUsuario d) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cuenta creada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Entrega estos datos a la persona. La contraseña no se vuelve '
              'a mostrar; podrá cambiarla desde "Mi cuenta".',
              style: TextStyle(color: NVColors.textoSecundario, fontSize: 13),
            ),
            const SizedBox(height: 14),
            _filaCopiable('Correo', d.email),
            const SizedBox(height: 8),
            _filaCopiable('Contraseña', d.password),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }

  Widget _filaCopiable(String etiqueta, String valor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(etiqueta,
                  style: const TextStyle(
                      color: NVColors.textoSecundario, fontSize: 12)),
              SelectableText(valor,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Copiar',
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: valor));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$etiqueta copiado')),
            );
          },
        ),
      ],
    );
  }

  Future<void> _cambiarEstado(PerfilAdmin u, bool activo) async {
    try {
      await _service.cambiarEstado(id: u.id, activo: activo);
      await _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  Future<void> _cambiarSuper(PerfilAdmin u, bool esSuper) async {
    final texto = esSuper
        ? '¿Dar a ${u.nombre ?? u.email} acceso de súper administrador? '
            'Podrá gestionar usuarios, taxonomía y apariencia.'
        : '¿Quitar el acceso de súper administrador a ${u.nombre ?? u.email}? '
            'Seguirá siendo administrador normal.';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(texto),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirmar')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _service.cambiarSuperAdmin(id: u.id, esSuperAdmin: esSuper);
      await _cargar();
    } catch (e) {
      _mostrarError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crear,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Nuevo usuario'),
      ),
      body: _cuerpo(),
    );
  }

  Widget _cuerpo() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              OutlinedButton(
                  onPressed: _cargar, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    final usuarios = _usuarios;
    if (usuarios == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (usuarios.isEmpty) {
      return const Center(child: Text('Todavía no hay usuarios.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
      itemCount: usuarios.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, i) => _fila(usuarios[i]),
    );
  }

  Widget _fila(PerfilAdmin u) {
    final soyYo = u.id == _miId;
    return NVCard(
      key: ValueKey(u.id),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        u.nombre ?? u.email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (soyYo)
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Text('(tú)',
                            style: TextStyle(
                                color: NVColors.textoSecundario, fontSize: 12)),
                      ),
                  ],
                ),
                if (u.nombre != null)
                  Text(u.email,
                      style: const TextStyle(
                          color: NVColors.textoSecundario, fontSize: 13)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    _chip(u.nivel,
                        destacado: u.esSuperAdmin),
                    if (!u.activo)
                      _chip('Inactivo', color: NVColors.error),
                  ],
                ),
              ],
            ),
          ),
          Tooltip(
            message: u.activo ? 'Activa' : 'Desactivada',
            child: Switch(
              value: u.activo,
              onChanged:
                  soyYo ? null : (v) => _cambiarEstado(u, v),
            ),
          ),
          PopupMenuButton<String>(
            enabled: !soyYo,
            onSelected: (v) {
              if (v == 'promover') _cambiarSuper(u, true);
              if (v == 'degradar') _cambiarSuper(u, false);
            },
            itemBuilder: (_) => [
              if (!u.esSuperAdmin)
                const PopupMenuItem(
                    value: 'promover',
                    child: Text('Hacer súper administrador')),
              if (u.esSuperAdmin)
                const PopupMenuItem(
                    value: 'degradar',
                    child: Text('Quitar súper administrador')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String texto, {bool destacado = false, Color? color}) {
    final c = color ?? (destacado ? NVColors.primary : NVColors.textoSecundario);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(texto,
          style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _DatosNuevoUsuario {
  final String email;
  final String password;
  final String? nombre;
  final bool esSuperAdmin;
  const _DatosNuevoUsuario({
    required this.email,
    required this.password,
    this.nombre,
    required this.esSuperAdmin,
  });
}

class _DialogoNuevoUsuario extends StatefulWidget {
  const _DialogoNuevoUsuario();

  @override
  State<_DialogoNuevoUsuario> createState() => _DialogoNuevoUsuarioState();
}

class _DialogoNuevoUsuarioState extends State<_DialogoNuevoUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _esSuper = false;
  bool _verClave = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _generar() {
    // Contraseña temporal legible (sin caracteres ambiguos): la persona la
    // cambia luego en "Mi cuenta".
    const minus = 'abcdefghijkmnpqrstuvwxyz';
    const mayus = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const nums = '23456789';
    const patron = [mayus, minus, minus, nums, minus, mayus, nums, minus, minus, nums];
    final r = DateTime.now().microsecondsSinceEpoch;
    final chars = <String>[
      for (var i = 0; i < patron.length; i++)
        patron[i][(r ~/ (i * 6 + 7)) % patron[i].length],
    ];
    setState(() {
      _passwordCtrl.text = chars.join();
      _verClave = true;
    });
  }

  void _enviar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final nombre = _nombreCtrl.text.trim();
    Navigator.pop(
      context,
      _DatosNuevoUsuario(
        email: _emailCtrl.text.trim().toLowerCase(),
        password: _passwordCtrl.text,
        nombre: nombre.isEmpty ? null : nombre,
        esSuperAdmin: _esSuper,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo usuario'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                    labelText: 'Nombre (opcional)'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Escribe un correo válido'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: !_verClave,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  helperText: 'Mínimo 8 caracteres.',
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Generar',
                        icon: const Icon(Icons.casino_outlined),
                        onPressed: _generar,
                      ),
                      IconButton(
                        icon: Icon(_verClave
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _verClave = !_verClave),
                      ),
                    ],
                  ),
                ),
                validator: (v) => (v == null || v.length < 8)
                    ? 'Al menos 8 caracteres'
                    : null,
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _esSuper,
                onChanged: (v) => setState(() => _esSuper = v ?? false),
                title: const Text('Súper administrador'),
                subtitle: const Text(
                  'Puede gestionar usuarios, taxonomía y apariencia.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        ElevatedButton(onPressed: _enviar, child: const Text('Crear')),
      ],
    );
  }
}
