import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/seo_tags.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../theme/nv_colors.dart';

class NosotrosPage extends StatefulWidget {
  const NosotrosPage({super.key});

  @override
  State<NosotrosPage> createState() => _NosotrosPageState();
}

class _NosotrosPageState extends State<NosotrosPage> {
  @override
  void initState() {
    super.initState();
    establecerSeo(
      titulo: '¿Qué son los Negocios Verdes? — Negocios Verdes CDMB',
      descripcion:
          'Conoce el programa de Negocios Verdes de la CDMB: qué son, cómo '
          'se clasifican y cómo hacer parte de la Ventanilla de Negocios '
          'Verdes.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(gradient: NVColors.gradientHero),
            child: const Column(
              children: [
                Text('🌱', style: TextStyle(fontSize: 36)),
                SizedBox(height: 8),
                Text(
                  '¿Qué son los Negocios Verdes?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _parrafo(
                      'Los Negocios Verdes son emprendimientos y empresas que '
                      'ofrecen bienes y servicios con un impacto ambiental '
                      'positivo, que incorporan buenas prácticas ambientales, '
                      'sociales y económicas con enfoque de ciclo de vida, y '
                      'que contribuyen a la conservación del ambiente como '
                      'capital natural que soporta el desarrollo del '
                      'territorio.',
                    ),
                    _parrafo(
                      'La Corporación Autónoma Regional para la Defensa de la '
                      'Meseta de Bucaramanga (CDMB) acompaña estos negocios en '
                      'los 13 municipios de su jurisdicción a través de la '
                      'Ventanilla de Negocios Verdes, un espacio de gestión '
                      'técnica que orienta sobre potencialidades, planes de '
                      'mejora, entidades de financiación y oportunidades de '
                      'conexión con organizaciones aliadas.',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Niveles de desarrollo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _nivel(
                      '🌱 En verificación',
                      'Emprendimientos que están iniciando su proceso de '
                          'verificación con la CDMB.',
                    ),
                    _nivel(
                      '✅ Verificado',
                      'Negocios que ya cumplen los criterios del programa y '
                          'fueron verificados por la CDMB.',
                    ),
                    _nivel(
                      '🏆 Negocio ancla',
                      'Negocios verdes consolidados, referentes en su '
                          'categoría y en su municipio.',
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '¿Cómo hacer parte de los Negocios Verdes de la CDMB?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _parrafo(
                      'Por ahora, la vinculación al programa y la '
                      'verificación de cada negocio las gestiona directamente '
                      'el equipo de la Ventanilla de Negocios Verdes de la '
                      'CDMB. Si tienes un negocio verde en alguno de los 13 '
                      'municipios de la jurisdicción y quieres más '
                      'información sobre el proceso, escríbenos desde la '
                      'página de contacto.',
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/contacto'),
                      child: const Text('Ir a contacto'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const PiePagina(),
        ],
      ),
    );
  }

  Widget _parrafo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(texto, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }

  Widget _nivel(String titulo, String descripcion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(descripcion,
              style: const TextStyle(color: NVColors.textoSecundario)),
        ],
      ),
    );
  }
}
