import 'package:flutter/material.dart';

import '../../../core/widgets/logo_negocios_verdes.dart';
import '../../../services/auth_service.dart';
import '../../../theme/nv_colors.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authService = AuthService();
  bool _cargando = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      await _authService.login(_emailCtrl.text.trim(), _passwordCtrl.text);
      // El redirect() del router navega a /admin al detectar la sesión
      // nueva (ver _GoRouterRefreshStream en main.dart) — no hace falta
      // navegar manualmente aquí.
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: LogoNegociosVerdes(altura: 56)),
                const SizedBox(height: 8),
                const Text(
                  'Negocios Verdes CDMB',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Panel administrativo — solo staff CDMB',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: NVColors.textoSecundario),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Escribe tu correo'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  onFieldSubmitted: (_) => _entrar(),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Escribe tu contraseña' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: NVColors.error)),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _cargando ? null : _entrar,
                  child: _cargando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
