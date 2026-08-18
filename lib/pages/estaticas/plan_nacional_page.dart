import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/seo_tags.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../theme/nv_colors.dart';

/// Resumen del documento oficial "Plan Nacional de Negocios Verdes
/// 2022-2030" (Ministerio de Ambiente y Desarrollo Sostenible / BID /
/// Biointropic / Corporación Biocomercio Sostenible) — el marco de política
/// nacional del que la Ventanilla de Negocios Verdes de la CDMB es la
/// implementación regional. No es un resumen ejecutivo completo del
/// documento (tiene más de 200 páginas): son las secciones que más le
/// sirven a un visitante del directorio para entender el "para qué" detrás
/// de las categorías/subcategorías/actividades que ya puede explorar en
/// /buscar. No vive en el navbar principal a propósito — es contenido de
/// referencia, no algo que la mayoría de visitas necesite de entrada; se
/// llega desde el enlace en /nosotros o desde el pie de página.
class PlanNacionalPage extends StatefulWidget {
  const PlanNacionalPage({super.key});

  @override
  State<PlanNacionalPage> createState() => _PlanNacionalPageState();
}

class _PlanNacionalPageState extends State<PlanNacionalPage> {
  @override
  void initState() {
    super.initState();
    establecerSeo(
      titulo: 'Plan Nacional de Negocios Verdes 2022-2030 — Negocios Verdes CDMB',
      descripcion:
          'Propósito, objetivos, metas a 2030 y líneas estratégicas del '
          'Plan Nacional de Negocios Verdes 2022-2030 del Ministerio de '
          'Ambiente y Desarrollo Sostenible.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            // Pedido explícito: sin el logo (ya está en el navbar arriba,
            // sobraba acá) y con menos padding vertical (antes 40) para
            // que la franja ocupe menos espacio.
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            // verdeMenu sin degradado (pedido explícito) -- el mismo verde
            // plano de los menús, para que se lea como una continuidad de
            // color. El texto pasa de blanco a textoPrincipal/
            // textoSecundario: blanco sobre este verde tan claro es casi
            // ilegible.
            color: NVColors.verdeMenu,
            child: Column(
              children: [
                const Text(
                  'Plan Nacional de Negocios Verdes 2022-2030',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: NVColors.textoPrincipal,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ministerio de Ambiente y Desarrollo Sostenible de Colombia',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: NVColors.textoSecundario, fontSize: 13),
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
                    _seccion('Propósito superior'),
                    _parrafo(
                      'En 2030 los negocios verdes serán un renglón de '
                      'impacto social y ambiental en la economía nacional, '
                      'competitivos, inclusivos y sostenibles, contribuyendo '
                      'al desarrollo bajo en carbono y resiliente al clima, '
                      'así como al aprovechamiento y conservación de capital '
                      'natural que soporta el desarrollo de los territorios.',
                    ),
                    _seccion('Objetivo general'),
                    _parrafo(
                      'Incrementar y consolidar los negocios verdes que '
                      'generan impacto ambiental positivo, empleo verde '
                      'inclusivo e impulsan el crecimiento verde del país, '
                      'incentivando el consumo consciente y sostenible.',
                    ),
                    _seccion('Objetivos específicos'),
                    _objetivo(
                      'OE1',
                      'Desarrollar e implementar una ruta de acompañamiento '
                          'replicable para aumentar la oferta de '
                          'emprendimientos verdes inclusivos en los '
                          'territorios, con el apoyo de todo el Sistema '
                          'Nacional Ambiental.',
                    ),
                    _objetivo(
                      'OE2',
                      'Fortalecer y escalar negocios verdes verificados con '
                          'presencia en mercados regionales, nacionales e '
                          'internacionales, con reportes de indicadores de '
                          'sostenibilidad.',
                    ),
                    _objetivo(
                      'OE3',
                      'Fortalecer los mercados de los negocios verdes con la '
                          'integración de empresas ancla que cumplen '
                          'indicadores de sostenibilidad e incorporan '
                          'negocios verdes en redes de suministro y cadenas '
                          'de valor.',
                    ),
                    const SizedBox(height: 8),
                    _seccion('Meta a 2030'),
                    // Frailejón (iconografía de marca) centrado sobre las
                    // cifras -- mismo tratamiento que la franja de
                    // estadísticas del inicio, en flujo normal (nunca
                    // superpuesto) para no arriesgar overlap en pantallas
                    // angostas.
                    Center(
                      child: Image.asset(
                        'assets/images/iconografia/frailejon_2.png',
                        height: 64,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _filaMetas(context),
                    const SizedBox(height: 8),
                    _seccion('Tres enfoques'),
                    _enfoque(
                      'Social',
                      'Pone a las economías populares y comunidades en el '
                          'centro del Plan: empoderamiento, saberes '
                          'ancestrales y enfoque diferencial (étnico, '
                          'jóvenes, género, campesino), buscando que la '
                          'riqueza natural también genere riqueza monetaria '
                          'para quienes cuidan los ecosistemas.',
                    ),
                    _enfoque(
                      'Ambiental',
                      'El impacto ambiental positivo es la razón principal '
                          'de los negocios verdes: conservación, cambio de '
                          'materiales y energías no renovables por '
                          'renovables, mantenimiento de la biodiversidad y '
                          'de servicios ecosistémicos, y reducción de '
                          'emisiones de gases efecto invernadero.',
                    ),
                    _enfoque(
                      'Económico',
                      'Impulsa la transición hacia una economía de la '
                          'biodiversidad: instrumentos económicos y '
                          'financieros, circuitos cortos de '
                          'comercialización, encadenamientos regionales y '
                          'consumo responsable en instituciones públicas, '
                          'empresas privadas y clientes finales.',
                    ),
                    const SizedBox(height: 8),
                    _seccion('8 líneas estratégicas'),
                    _parrafo(
                      'El plan de acción hacia 2030 se organiza en 8 líneas '
                      'estratégicas de intervención — cuatro transversales '
                      'y de soporte, cuatro con alcance específico:',
                    ),
                    _lineaEstrategica(1, 'Alianzas, articulación y política'),
                    _lineaEstrategica(
                        2, 'Sistema de información, monitoreo y seguimiento'),
                    _lineaEstrategica(
                        3, 'Instrumentos económicos, financieros e incentivos'),
                    _lineaEstrategica(4, 'Consumo responsable y sostenible'),
                    _lineaEstrategica(5, 'Fortalecimiento de capacidades'),
                    _lineaEstrategica(
                        6, 'Desarrollo y fortalecimiento de la oferta'),
                    _lineaEstrategica(
                        7, 'Investigación, desarrollo e innovación'),
                    _lineaEstrategica(8, 'Acceso a mercados'),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NVColors.fondo,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NVColors.borde),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Fuente',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Plan Nacional de Negocios Verdes 2022-2030. '
                            'Ministerio de Ambiente y Desarrollo Sostenible, '
                            'Colombia (2022). Banco Interamericano de '
                            'Desarrollo (BID), Biointropic y Corporación '
                            'Biocomercio Sostenible.',
                            style: TextStyle(
                                color: NVColors.textoSecundario,
                                fontSize: 12.5,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => context.go('/nosotros'),
                            child: const Text('← ¿Qué son los Negocios Verdes?'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.go('/buscar'),
                            child: const Text('Explorar negocios'),
                          ),
                        ),
                      ],
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

  Widget _seccion(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: NVColors.primaryDark),
      ),
    );
  }

  Widget _parrafo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(texto, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }

  Widget _objetivo(String etiqueta, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: NVColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              etiqueta,
              style: const TextStyle(
                  color: NVColors.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(texto, style: const TextStyle(fontSize: 14.5, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _enfoque(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 4),
          Text(texto,
              style: const TextStyle(
                  color: NVColors.textoSecundario, fontSize: 13.5, height: 1.4)),
        ],
      ),
    );
  }

  Widget _lineaEstrategica(int numero, String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: NVColors.verdeVivo,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$numero',
              style: const TextStyle(
                  color: NVColors.textoPrincipal,
                  fontSize: 11,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(titulo, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _filaMetas(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _tarjetaMeta('12.630', 'negocios verdes\nverificados'),
        _tarjetaMeta('150 mil', 'empleos verdes\ne inclusivos'),
        _tarjetaMeta('\$2,1 billones', 'en ingresos\ngenerados'),
      ],
    );
  }

  Widget _tarjetaMeta(String numero, String etiqueta) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // verdeMenu (no verdeVivo) -- es una tarjeta de cifra/contador,
        // mismo tratamiento que la franja de estadísticas del inicio: el
        // verde de relleno grande es siempre verdeMenu, verdeVivo se
        // reserva para acentos chicos (íconos, bordes, texto de enlace).
        color: NVColors.verdeMenu,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(numero,
              style: const TextStyle(
                  color: NVColors.textoPrincipal,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(etiqueta,
              style: const TextStyle(
                  color: NVColors.textoPrincipal, fontSize: 12.5)),
        ],
      ),
    );
  }
}
