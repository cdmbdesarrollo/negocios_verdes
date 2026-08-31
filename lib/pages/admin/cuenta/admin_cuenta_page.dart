import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/admin_guard.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../theme/nv_colors.dart';

/// "Mi cuenta" — cada administrador cambia su propia contraseña. No pasa por
/// la Edge Function ni por SQL: es la sesión del propio usuario llamando a
/// supabase.auth.updateUser(). Disponible para cualquier admin (normal o
/// súper).
class AdminCuentaPage extends StatefulWidget {
  const AdminCuentaPage({super.key});

  @override
  State<AdminCuentaPage> createState() => _AdminCuentaPageState();
}

class _AdminCuentaPageState extends State<AdminCuentaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nuevaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();
  bool _guardando = false;
  bool _verClave = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
  }

  @override
  void dispose() {
    _nuevaCtrl.dispose();
    _confirmarCtrl.dispose();
    super.dispose();
  }

  Future<void> _cambiar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _guardando = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _nuevaCtrl.text),
      );
      if (!mounted) return;
      _nuevaCtrl.clear();
      _confirmarCtrl.clear();
      _formKey.currentState?.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña actualizada.')),
      );
    } on AuthException catch (e) {
      _error(e.message);
    } catch (e) {
      _error(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _error(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final email = Supabase.instance.client.auth.currentUser?.email ?? '—';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NVCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Correo',
                        style: TextStyle(
                            color: NVColors.textoSecundario, fontSize: 13)),
                    const SizedBox(height: 2),
                    Text(email,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              NVCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Cambiar contraseña',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nuevaCtrl,
                        obscureText: !_verClave,
                        decoration: InputDecoration(
                          labelText: 'Nueva contraseña',
                          helperText: 'Mínimo 8 caracteres.',
                          suffixIcon: IconButton(
                            icon: Icon(_verClave
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => _verClave = !_verClave),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 8)
                            ? 'Al menos 8 caracteres'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmarCtrl,
                        obscureText: !_verClave,
                        decoration: const InputDecoration(
                            labelText: 'Repetir contraseña'),
                        onFieldSubmitted: (_) => _cambiar(),
                        validator: (v) => v != _nuevaCtrl.text
                            ? 'No coincide con la nueva contraseña'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _guardando ? null : _cambiar,
                        child: _guardando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Guardar contraseña'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
