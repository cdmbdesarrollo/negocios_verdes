import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:negocios_verdes_cdmb/pages/inicio/widgets/hero_slider.dart';
import 'package:negocios_verdes_cdmb/theme/nv_colors.dart';

// Regresión de un bug real reportado en producción: con el ancho angosto de
// un celular, el subtítulo de una diapositiva de fábrica envuelve a más
// líneas que en desktop -- ese contenido (ícono+título+subtítulo+botón)
// puede terminar necesitando más alto que los 300px fijos del slider
// (RenderFlex overflow real, capturado en consola al probar con el servidor
// de desarrollo). Este test fija un viewport angosto y confirma que ninguna
// diapositiva de fábrica desborda (ver LayoutBuilder+SingleChildScrollView
// en hero_slider.dart).
void main() {
  testWidgets(
      'diapositiva de fábrica no desborda en un marco angosto (mobile)',
      (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroSlider(
            slides: [
              SlideInfo.texto(
                titulo: 'Negocios Verdes CDMB',
                subtitulo: 'El directorio de negocios verdes de los 13 '
                    'municipios de la jurisdicción CDMB',
                icono: Icons.eco,
                fondo: const LinearGradient(
                    colors: [NVColors.verdeMenu, NVColors.verdeMenu]),
                textoBoton: 'Conocer más',
                onTap: () {},
                textoOscuro: true,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
