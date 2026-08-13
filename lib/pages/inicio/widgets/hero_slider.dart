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

/// Carrusel superior con auto-avance, indicadores de puntos, flechas
/// prev/next y control de pausa — mismo patrón de interacción que el
/// carrusel de la Sede Electrónica de la CDMB (pausa/reanuda + puntos +
/// flechas), pero construido sobre PageView nativo de Flutter (sin
/// dependencia nueva) y a la medida que le sirve a este sitio, no una
/// réplica pixel a pixel.
class HeroSlider extends StatefulWidget {
  final List<SlideInfo> slides;
  final double altura;
  final Duration intervalo;

  const HeroSlider({
    super.key,
    required this.slides,
    // Los banners reales que sube CDMB suelen venir panorámicos y bastante
    // más anchos que altos (ej. una diapositiva de una feria a 10000x2639px,
    // relación ~3.8:1) — a 300 fijo el recorte de BoxFit.cover (arriba y
    // abajo por igual) se comía contenido cerca del borde inferior de la
    // imagen. 420 no elimina el recorte en pantallas muy anchas (ninguna
    // altura fija lo hace si el ancho de viewport varía), pero lo reduce a
    // la mitad aproximadamente en desktop típico.
    this.altura = 420,
    this.intervalo = const Duration(seconds: 6),
  });

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  late final PageController _controller;
  Timer? _timer;
  int _indiceActual = 0;
  bool _reproduciendo = true;

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
    if (!_reproduciendo || widget.slides.length <= 1) return;
    _timer = Timer.periodic(widget.intervalo, (_) => _irA(_indiceActual + 1));
  }

  void _irA(int indice) {
    if (!mounted || !_controller.hasClients || widget.slides.isEmpty) return;
    final destino = indice % widget.slides.length;
    _controller.animateToPage(
      destino,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _anterior() {
    _irA(_indiceActual - 1 + widget.slides.length);
    _iniciarAutoAvance(); // no pelea con el auto-avance justo después
  }

  void _siguiente() {
    _irA(_indiceActual + 1);
    _iniciarAutoAvance();
  }

  void _alternarReproduccion() {
    setState(() => _reproduciendo = !_reproduciendo);
    _iniciarAutoAvance();
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
    final variasSlides = widget.slides.length > 1;

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
          if (variasSlides) ...[
            Positioned(
              left: 8,
              top: 0,
              bottom: 32,
              child: Center(
                child: _botonRedondo(Icons.chevron_left, _anterior),
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 32,
              child: Center(
                child: _botonRedondo(Icons.chevron_right, _siguiente),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black.withValues(alpha: 0.25),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: _alternarReproduccion,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _reproduciendo
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _reproduciendo ? 'Detener' : 'Reanudar',
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < widget.slides.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: i == _indiceActual ? 22 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                  alpha: i == _indiceActual ? 0.95 : 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _botonRedondo(IconData icono, VoidCallback onTap) {
    return Material(
      color: Colors.black.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icono, color: Colors.white, size: 22),
        ),
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
