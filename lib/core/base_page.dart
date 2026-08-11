import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/nv_colors.dart';

/// Scaffold reutilizable para páginas fuera de ambos shells (login, 404) —
/// AppBar propia con back inteligente (context.canPop() de go_router, no
/// Navigator.canPop(): con rutas declarativas/enlaces directos el stack de
/// Navigator no siempre refleja lo que go_router considera "se puede
/// volver"), sin la navbar/drawer del resto del sitio.
class BasePage extends StatelessWidget {
  final String titulo;
  final Widget child;
  final List<Widget>? acciones;

  const BasePage({
    super.key,
    required this.titulo,
    required this.child,
    this.acciones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        actions: acciones,
      ),
      backgroundColor: NVColors.fondo,
      body: SafeArea(child: child),
    );
  }
}
