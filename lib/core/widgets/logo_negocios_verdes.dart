import 'package:flutter/material.dart';

/// Logo de la app en un solo lugar. Para cambiarlo, reemplaza
/// assets/images/logo.png por cualquier otro PNG (idealmente con fondo
/// transparente) — no hace falta tocar código en ningún otro archivo.
/// Si el archivo llegara a faltar o fallar al cargar, cae de vuelta al
/// emoji 🌱 en vez de romper la pantalla.
class LogoNegociosVerdes extends StatelessWidget {
  final double altura;

  const LogoNegociosVerdes({super.key, this.altura = 32});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: altura,
      errorBuilder: (context, error, stackTrace) => Text(
        '🌱',
        style: TextStyle(fontSize: altura * 0.75),
      ),
    );
  }
}
