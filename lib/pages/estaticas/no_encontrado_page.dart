import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/logo_negocios_verdes.dart';
import '../../theme/nv_colors.dart';

class NoEncontradoPage extends StatelessWidget {
  const NoEncontradoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVColors.fondo,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LogoNegociosVerdes(altura: 56),
              const SizedBox(height: 16),
              const Text(
                'No encontramos esta página',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Puede que el negocio que buscas ya no esté publicado o la '
                'dirección esté mal escrita.',
                textAlign: TextAlign.center,
                style: TextStyle(color: NVColors.textoSecundario),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
