import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../theme/nv_colors.dart';

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

  /// true para fondos claros (verdeMenu, accent, verdeVivo) -- blanco
  /// encima queda con contraste pobre (~2-2.5:1), textoPrincipal da 6-7:1.
  /// false (default) para fondos oscuros como neutroOscuro, donde blanco
  /// sigue siendo lo correcto.
  final bool textoOscuro;

  const SlideInfo.imagen({required this.imagenUrl, this.onTap})
      : titulo = null,
        subtitulo = null,
        icono = null,
        fondo = null,
        textoBoton = null,
        textoOscuro = false;

  const SlideInfo.texto({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.fondo,
    this.textoBoton,
    this.onTap,
    this.textoOscuro = false,
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
    // 300 es la medida acordada con CDMB. Ancho completo de pantalla
    // siempre (pedido explícito: "los banners son muy importantes... pueden
    // usar todo el ancho") -- ya se probó topar el ancho a 1200 con un
    // fondo de color de marco, pero eso solo tiene sentido junto con
    // BoxFit.cover, y cover fue justamente la causa de los recortes que se
    // venían reportando (arriba/abajo en desktop, a los lados en mobile,
    // según cuánto se pareciera el ancho de pantalla a la proporción real
    // del banner subido). BoxFit.contain (ver _diapositiva) nunca recorta
    // -- muestra el banner completo, centrado, a lo ancho que le
    // corresponda según su propia proporción, con el fondo verdeMenu detrás
    // llenando lo que sobre arriba/abajo o a los lados. Eso hace que el
    // límite de ancho ya no haga falta: sin recorte posible, no hay riesgo
    // de que "ancho completo" se vea mal.
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

    return Container(
      width: double.infinity,
      // verdeMenu SIN degradado (pedido explícito) -- el mismo verde plano
      // de los menús, para que menús y banners se lean como una sola
      // continuidad de color. Con BoxFit.contain en _diapositiva, este
      // color también es el que llena el espacio que un banner no ocupe
      // (arriba/abajo o a los lados, según su proporción real).
      color: NVColors.verdeMenu,
      child: SizedBox(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
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
        // contain (no cover) -- pedido explícito tras reportarse el banner
        // "achatado y acortado"/recortado en mobile. cover siempre recorta
        // cuando la proporción de banner y contenedor no calzan EXACTO
        // (arriba/abajo o a los lados, según cuál sea más ancho); contain
        // nunca recorta, muestra el banner completo y dejar que el
        // verdeMenu del fondo llene el resto. El costo es una franja de
        // color si la proporción no calza perfecto -- se acepta a propósito
        // porque ya es el mismo verde de marca, se lee como marco, no como
        // espacio roto.
        child: CachedNetworkImage(
          imageUrl: slide.imagenUrl!,
          fit: BoxFit.contain,
        ),
      );
    } else {
      final colorTitulo =
          slide.textoOscuro ? NVColors.textoPrincipal : Colors.white;
      final colorSubtitulo =
          slide.textoOscuro ? NVColors.textoSecundario : Colors.white70;
      // LayoutBuilder + SingleChildScrollView + ConstrainedBox(minHeight:)
      // -- el alto del slider es fijo (300), pero el ANCHO disponible no:
      // en mobile el subtítulo envuelve a más líneas que en desktop, así
      // que este contenido puede necesitar más alto del que hay (mismo
      // RenderFlex overflow real que ya se vio una vez en pantallas
      // angostas). minHeight mantiene el centrado vertical de siempre
      // cuando sobra espacio; si no alcanza, se vuelve desplazable en vez
      // de desbordar.
      contenido = Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: slide.fondo),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(slide.icono, color: colorTitulo, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    slide.titulo!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorTitulo,
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
                      style: TextStyle(color: colorSubtitulo, fontSize: 15),
                    ),
                  ),
                  if (slide.textoBoton != null) ...[
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: slide.onTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorTitulo,
                        side: BorderSide(color: colorTitulo),
                      ),
                      child: Text(slide.textoBoton!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (slide.onTap == null) return contenido;
    return InkWell(onTap: slide.onTap, child: contenido);
  }
}
