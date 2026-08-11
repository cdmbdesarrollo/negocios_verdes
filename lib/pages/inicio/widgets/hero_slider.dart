import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Contenido de una diapositiva — dos variantes:
/// - [SlideInfo.imagen]: banner subido desde /admin/apariencia (sin texto,
///   el banner ES la imagen), opcionalmente tocable.
/// - [SlideInfo.texto]: diapositiva "de fábrica" (título+subtítulo+ícono+
///   degradado), la que se muestra mientras no haya banners reales
///   cargados — ver InicioPage.
class SlideInfo {
  final String? imagenUrl;
  final VoidCallback? onTap;
  final String? titulo;
  final String? subtitulo;
  final IconData? icono;
  final Gradient? fondo;
  final String? textoBoton;

  const SlideInfo.imagen({required this.imagenUrl, this.onTap})
      : titulo = null,
        subtitulo = null,
        icono = null,
        fondo = null,
        textoBoton = null;

  const SlideInfo.texto({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.fondo,
    this.textoBoton,
    this.onTap,
  }) : imagenUrl = null;
}

/// Carrusel superior con auto-avance e indicadores de puntos. Construido
/// sobre PageView (nativo de Flutter, sin dependencia nueva) en vez de un
/// paquete de terceros — consistente con el resto del proyecto, que no trae
/// gestor de estado ni librerías de UI adicionales.
class HeroSlider extends StatefulWidget {
  final List<SlideInfo> slides;
  final double altura;
  final Duration intervalo;

  const HeroSlider({
    super.key,
    required this.slides,
    this.altura = 300,
    this.intervalo = const Duration(seconds: 6),
  });

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  late final PageController _controller;
  Timer? _timer;
  int _indiceActual = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _iniciarAutoAvance();
  }

  @override
  void didUpdateWidget(covariant HeroSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si InicioPage termina de cargar los banners reales después del
    // primer build, la cantidad de diapositivas cambia — reinicia el timer
    // para no animar hacia un índice que ya no existe.
    if (oldWidget.slides.length != widget.slides.length) {
      _indiceActual = 0;
      _iniciarAutoAvance();
    }
  }

  void _iniciarAutoAvance() {
    _timer?.cancel();
    if (widget.slides.length <= 1) return;
    _timer = Timer.periodic(widget.intervalo, (_) {
      if (!mounted || !_controller.hasClients) return;
      final siguiente = (_indiceActual + 1) % widget.slides.length;
      _controller.animateToPage(
        siguiente,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: widget.altura,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.slides.length,
            onPageChanged: (i) => setState(() => _indiceActual = i),
            itemBuilder: (context, i) => _diapositiva(widget.slides[i]),
          ),
          if (widget.slides.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.slides.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _indiceActual ? 22 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: i == _indiceActual ? 0.95 : 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _diapositiva(SlideInfo slide) {
    final Widget contenido;
    if (slide.imagenUrl != null) {
      contenido = SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CachedNetworkImage(
          imageUrl: slide.imagenUrl!,
          fit: BoxFit.cover,
        ),
      );
    } else {
      contenido = Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(gradient: slide.fondo),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(slide.icono, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text(
              slide.titulo!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Text(
                slide.subtitulo!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
            if (slide.textoBoton != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: slide.onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
                child: Text(slide.textoBoton!),
              ),
            ],
          ],
        ),
      );
    }

    if (slide.onTap == null) return contenido;
    return InkWell(onTap: slide.onTap, child: contenido);
  }
}
