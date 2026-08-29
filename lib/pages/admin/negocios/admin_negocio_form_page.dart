import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../catalogos.dart';
import '../../../core/admin_guard.dart';
import '../../../models/actividad_productiva.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/ficha_tecnica_negocio.dart';
import '../../../models/negocio_foto.dart';
import '../../../models/subcategoria.dart';
import '../../../models/vereda.dart';
import '../../../services/actividad_productiva_service.dart';
import '../../../services/categoria_service.dart';
import '../../../services/negocio_foto_service.dart';
import '../../../services/negocio_service.dart';
import '../../../services/subcategoria_service.dart';
import '../../../services/vereda_service.dart';
import '../../../theme/nv_colors.dart';
import 'widgets/galeria_editor.dart';
import 'widgets/selector_taxonomia_negocio.dart';
import 'widgets/selector_ubicacion_mapa.dart';

/// Campo de texto libre de la "Ficha técnica CDMB" (ver
/// 0022_ficha_ampliada_negocios.sql) — [clave] coincide 1:1 con el nombre
/// del parámetro con nombre en NegocioService.guardarFichaTecnica (sin el
/// prefijo p_), así _guardarFichaTecnica() puede armar esos ~40 argumentos
/// en un loop en vez de escribirlos a mano dos veces.
class _CampoFicha {
  final String clave;
  final String etiqueta;
  final bool esFecha;
  const _CampoFicha(this.clave, this.etiqueta, {this.esFecha = false});
}

const _kGruposFichaTecnica = <String, List<_CampoFicha>>{
  'Identificación y seguimiento': [
    _CampoFicha('novedad', 'Estado original (novedad CDMB)'),
    _CampoFicha('tipoNegocioVerde', 'Tipo / madurez de negocio verde'),
    _CampoFicha('codigoMarca', 'Código de marca'),
    _CampoFicha('cotaMsnm', 'Cota (msnm)'),
    _CampoFicha('aplicacionFicha2025', 'Aplicación de ficha 2025'),
    _CampoFicha('delegado', 'Delegado'),
    _CampoFicha('tiempoConstitucion', 'Tiempo de constitución'),
    _CampoFicha('rutCamaraComercio', 'RUT / Cámara de comercio'),
    _CampoFicha('responsableCdmb', 'Responsable CDMB'),
  ],
  'Permisos y trámites ambientales': [
    _CampoFicha('registroNacionalTurismo', 'Registro Nacional de Turismo'),
    _CampoFicha('usoSuelo', 'Uso del suelo'),
    _CampoFicha('concesionAguas', 'Concesión de aguas'),
    _CampoFicha('concesionAguasVencimiento', 'Vencimiento concesión de aguas',
        esFecha: true),
    _CampoFicha('vertimientos', 'Vertimientos'),
    _CampoFicha('vertimientosVencimiento', 'Vencimiento vertimientos',
        esFecha: true),
    _CampoFicha('pueaa', 'PUEAA'),
    _CampoFicha('pgris', 'PGRIS'),
    _CampoFicha('pozoSeptico', 'Pozo séptico'),
    _CampoFicha('alcantarillado', 'Alcantarillado'),
    _CampoFicha('ica', 'ICA (registro producción/comercialización abono)'),
    _CampoFicha('icaVencimiento', 'Vencimiento ICA', esFecha: true),
    _CampoFicha('invima', 'INVIMA'),
    _CampoFicha('invimaVencimiento', 'Vencimiento INVIMA', esFecha: true),
    _CampoFicha('certificadoTenenciaAnimales', 'Certificado tenencia de animales'),
    _CampoFicha('buenasPracticasAgricolas', 'Buenas prácticas agrícolas'),
    _CampoFicha('buenasPracticasApicolas', 'Buenas prácticas apícolas'),
    _CampoFicha('registroApicola', 'Registro apícola'),
    _CampoFicha('intervencionCauce', 'Intervención de cauce'),
    _CampoFicha('capacidadCarga', 'Capacidad de carga'),
    _CampoFicha('sstt', 'SSTT'),
  ],
  'Mercado y fortalecimiento': [
    _CampoFicha('canalVenta', 'Canal de venta (B2B / B2C / mixta)'),
    _CampoFicha('exportacion', 'Exportación / internacionalización actual'),
    _CampoFicha('huellaCarbono', 'Huella de carbono'),
    _CampoFicha('fortalecimientoTecnico', 'Fortalecimiento técnico'),
    _CampoFicha('fortalecimientoAcademico', 'Fortalecimiento académico'),
    _CampoFicha('fortalecimientoFinanciero', 'Fortalecimiento financiero'),
    _CampoFicha('internacionalizacion', 'Internacionalización'),
    _CampoFicha('certificaciones', 'Certificaciones'),
    _CampoFicha('posicionamientoMarca', 'Posicionamiento de marca'),
    _CampoFicha('beneficiosVentanilla', 'Beneficios recibidos de la Ventanilla NV'),
  ],
  'Análisis DOFA': [
    _CampoFicha('fortalezasAmbiental', 'Fortalezas — ambiental'),
    _CampoFicha('fortalezasSocial', 'Fortalezas — social'),
    _CampoFicha('fortalezasEconomico', 'Fortalezas — económico'),
    _CampoFicha('debilidadesAmbiental', 'Debilidades — ambiental'),
    _CampoFicha('debilidadesSocial', 'Debilidades — social'),
    _CampoFicha('debilidadesFinanciera', 'Debilidades — financiera'),
  ],
};

const _kAniosPuntaje = [2020, 2021, 2022, 2023, 2024, 2025];

/// Un solo formulario para crear y editar (negocioId nulo = crear). El id
/// del negocio se genera en el cliente ANTES de guardar (ver initState) —
/// lo necesita GaleriaEditor para las rutas de Storage de portada/galería
/// desde el primer momento, no solo después de guardar.
class AdminNegocioFormPage extends StatefulWidget {
  final String? negocioId;

  const AdminNegocioFormPage({super.key, this.negocioId});

  @override
  State<AdminNegocioFormPage> createState() => _AdminNegocioFormPageState();
}

class _AdminNegocioFormPageState extends State<AdminNegocioFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _categoriaService = CategoriaService();
  final _subcategoriaService = SubcategoriaService();
  final _actividadService = ActividadProductivaService();
  final _veredaService = VeredaService();
  final _negocioService = NegocioService();
  final _negocioFotoService = NegocioFotoService();

  late final String _negocioId;
  bool get _esEdicion => widget.negocioId != null;

  bool _cargando = true;
  bool _guardando = false;
  String? _error;

  final _nombreCtrl = TextEditingController();
  final _descripcionCortaCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _productoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _sitioWebCtrl = TextEditingController();
  final _facebookCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _representanteLegalCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _anioRegistroCtrl = TextEditingController();
  final _observacionesCtrl = TextEditingController();

  /// Las ~40 columnas de "ficha técnica" (ver _kGruposFichaTecnica arriba)
  /// — un controller por clave, poblado/leído en loop en vez de a mano.
  final Map<String, TextEditingController> _fichaCtrls = {
    for (final grupo in _kGruposFichaTecnica.values)
      for (final campo in grupo) campo.clave: TextEditingController(),
  };
  final Map<int, TextEditingController> _puntajeCtrls = {
    for (final anio in _kAniosPuntaje) anio: TextEditingController(),
  };

  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<ActividadProductiva> _actividades = [];
  List<Vereda> _veredas = [];
  /// Hasta 3 — orden de selección, la primera es la "principal" (la que
  /// queda en negocios.categoria_oficial_id para todo lo que ya filtra o
  /// muestra por una sola categoría). Lista, no Set, para que ese orden sea
  /// predecible.
  List<String> _categoriaOficialIds = [];
  Set<String> _subcategoriaIds = {};
  Set<String> _actividadIds = {};
  String? _municipio;
  String? _veredaId;
  String? _naturalezaJuridica;
  double? _latitud;
  double? _longitud;
  bool _destacado = false;
  bool _activo = false;
  bool _emprendimientoVerde = false;
  bool _selloMarca = false;
  bool _avalado = false;
  String? _fotoPortadaUrl;
  String? _fotoPortadaPath;
  List<NegocioFoto> _galeriaInicial = [];
  List<FotoLocal> _galeriaActual = [];

  @override
  void initState() {
    super.initState();
    _negocioId = widget.negocioId ?? const Uuid().v4();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargarDatos();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCortaCtrl.dispose();
    _descripcionCtrl.dispose();
    _productoCtrl.dispose();
    _telefonoCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _sitioWebCtrl.dispose();
    _facebookCtrl.dispose();
    _instagramCtrl.dispose();
    _direccionCtrl.dispose();
    _representanteLegalCtrl.dispose();
    _nitCtrl.dispose();
    _anioRegistroCtrl.dispose();
    _observacionesCtrl.dispose();
    for (final c in _fichaCtrls.values) {
      c.dispose();
    }
    for (final c in _puntajeCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      final categorias = await _categoriaService.listarTodas();
      final subcategorias = await _subcategoriaService.listarTodas();
      final actividades = await _actividadService.listarTodas();
      final veredas = await _veredaService.listarTodas();

      if (_esEdicion) {
        final existente = await _negocioService.obtenerPorId(_negocioId);
        if (existente == null) {
          throw Exception('No se encontró el negocio.');
        }
        _nombreCtrl.text = existente.nombre;
        _categoriaOficialIds = existente.categoriasOficiales.isNotEmpty
            ? existente.categoriasOficiales.map((c) => c.id).toList()
            : [existente.categoriaOficialId];
        _municipio = existente.municipio;
        _veredaId = existente.veredaId;
        _direccionCtrl.text = existente.direccion ?? '';
        _latitud = existente.latitud;
        _longitud = existente.longitud;
        _descripcionCortaCtrl.text = existente.descripcionCorta ?? '';
        _descripcionCtrl.text = existente.descripcion ?? '';
        _productoCtrl.text = existente.producto ?? '';
        _telefonoCtrl.text = existente.telefono ?? '';
        _whatsappCtrl.text = existente.whatsapp ?? '';
        _emailCtrl.text = existente.email ?? '';
        _sitioWebCtrl.text = existente.sitioWeb ?? '';
        _facebookCtrl.text = existente.facebookUrl ?? '';
        _instagramCtrl.text = existente.instagramUrl ?? '';
        _representanteLegalCtrl.text = existente.representanteLegal ?? '';
        _nitCtrl.text = existente.nit ?? '';
        _naturalezaJuridica = existente.naturalezaJuridica;
        _fotoPortadaUrl = existente.fotoPortadaUrl;
        _fotoPortadaPath = existente.fotoPortadaPath;
        _destacado = existente.destacado;
        _activo = existente.activo;
        _emprendimientoVerde = existente.emprendimientoVerde;
        _selloMarca = existente.selloMarca;
        _avalado = existente.avalado;
        _subcategoriaIds = existente.subcategorias.map((s) => s.id).toSet();
        _actividadIds =
            existente.actividadesProductivas.map((a) => a.id).toSet();
        _galeriaInicial = existente.fotos;
        // Crítico: _galeriaActual es lo que _sincronizarGaleria() vuelve a
        // insertar al guardar (borra todo _galeriaInicial primero). Si el
        // admin guarda SIN tocar la galería, GaleriaEditor nunca dispara
        // onGaleriaCambiada (solo lo hace al agregar/quitar/reordenar), así
        // que sin esta línea _galeriaActual se quedaba en su valor por
        // defecto (lista vacía) y el guardado borraba las fotos existentes
        // sin volver a insertar ninguna — las fotos "desaparecían solas"
        // en una edición posterior que no tocaba la galería para nada.
        _galeriaActual = existente.fotos
            .map((f) => FotoLocal(url: f.url, storagePath: f.storagePath))
            .toList();

        final ficha = await _negocioService.obtenerFichaTecnica(_negocioId);
        _poblarFicha(ficha);
      }

      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _subcategorias = subcategorias;
        _actividades = actividades;
        _veredas = veredas;
        _cargando = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _cargando = false;
        });
      }
    }
  }

  String _fmtFecha(DateTime? d) =>
      d == null ? '' : d.toIso8601String().split('T').first;

  void _poblarFicha(FichaTecnicaNegocio f) {
    _fichaCtrls['novedad']!.text = f.novedad ?? '';
    _fichaCtrls['tipoNegocioVerde']!.text = f.tipoNegocioVerde ?? '';
    _fichaCtrls['codigoMarca']!.text = f.codigoMarca ?? '';
    _fichaCtrls['cotaMsnm']!.text = f.cotaMsnm ?? '';
    _fichaCtrls['aplicacionFicha2025']!.text = f.aplicacionFicha2025 ?? '';
    _fichaCtrls['delegado']!.text = f.delegado ?? '';
    _fichaCtrls['tiempoConstitucion']!.text = f.tiempoConstitucion ?? '';
    _fichaCtrls['rutCamaraComercio']!.text = f.rutCamaraComercio ?? '';
    _fichaCtrls['responsableCdmb']!.text = f.responsableCdmb ?? '';
    _fichaCtrls['registroNacionalTurismo']!.text =
        f.registroNacionalTurismo ?? '';
    _fichaCtrls['usoSuelo']!.text = f.usoSuelo ?? '';
    _fichaCtrls['concesionAguas']!.text = f.concesionAguas ?? '';
    _fichaCtrls['concesionAguasVencimiento']!.text =
        _fmtFecha(f.concesionAguasVencimiento);
    _fichaCtrls['vertimientos']!.text = f.vertimientos ?? '';
    _fichaCtrls['vertimientosVencimiento']!.text =
        _fmtFecha(f.vertimientosVencimiento);
    _fichaCtrls['pueaa']!.text = f.pueaa ?? '';
    _fichaCtrls['pgris']!.text = f.pgris ?? '';
    _fichaCtrls['pozoSeptico']!.text = f.pozoSeptico ?? '';
    _fichaCtrls['alcantarillado']!.text = f.alcantarillado ?? '';
    _fichaCtrls['ica']!.text = f.ica ?? '';
    _fichaCtrls['icaVencimiento']!.text = _fmtFecha(f.icaVencimiento);
    _fichaCtrls['invima']!.text = f.invima ?? '';
    _fichaCtrls['invimaVencimiento']!.text = _fmtFecha(f.invimaVencimiento);
    _fichaCtrls['certificadoTenenciaAnimales']!.text =
        f.certificadoTenenciaAnimales ?? '';
    _fichaCtrls['buenasPracticasAgricolas']!.text =
        f.buenasPracticasAgricolas ?? '';
    _fichaCtrls['buenasPracticasApicolas']!.text =
        f.buenasPracticasApicolas ?? '';
    _fichaCtrls['registroApicola']!.text = f.registroApicola ?? '';
    _fichaCtrls['intervencionCauce']!.text = f.intervencionCauce ?? '';
    _fichaCtrls['capacidadCarga']!.text = f.capacidadCarga ?? '';
    _fichaCtrls['sstt']!.text = f.sstt ?? '';
    _fichaCtrls['canalVenta']!.text = f.canalVenta ?? '';
    _fichaCtrls['exportacion']!.text = f.exportacion ?? '';
    _fichaCtrls['huellaCarbono']!.text = f.huellaCarbono ?? '';
    _fichaCtrls['fortalecimientoTecnico']!.text =
        f.fortalecimientoTecnico ?? '';
    _fichaCtrls['fortalecimientoAcademico']!.text =
        f.fortalecimientoAcademico ?? '';
    _fichaCtrls['fortalecimientoFinanciero']!.text =
        f.fortalecimientoFinanciero ?? '';
    _fichaCtrls['internacionalizacion']!.text = f.internacionalizacion ?? '';
    _fichaCtrls['certificaciones']!.text = f.certificaciones ?? '';
    _fichaCtrls['posicionamientoMarca']!.text = f.posicionamientoMarca ?? '';
    _fichaCtrls['beneficiosVentanilla']!.text = f.beneficiosVentanilla ?? '';
    _fichaCtrls['fortalezasAmbiental']!.text = f.fortalezasAmbiental ?? '';
    _fichaCtrls['fortalezasSocial']!.text = f.fortalezasSocial ?? '';
    _fichaCtrls['fortalezasEconomico']!.text = f.fortalezasEconomico ?? '';
    _fichaCtrls['debilidadesAmbiental']!.text = f.debilidadesAmbiental ?? '';
    _fichaCtrls['debilidadesSocial']!.text = f.debilidadesSocial ?? '';
    _fichaCtrls['debilidadesFinanciera']!.text =
        f.debilidadesFinanciera ?? '';
    _anioRegistroCtrl.text = f.anioRegistro?.toString() ?? '';
    _observacionesCtrl.text = f.observaciones ?? '';
    for (final anio in _kAniosPuntaje) {
      final valor = f.puntajes[anio];
      if (valor != null) _puntajeCtrls[anio]!.text = valor.toString();
    }
  }

  Future<void> _guardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_categoriaOficialIds.isEmpty) {
      _avisar('Selecciona al menos una categoría oficial.');
      return;
    }
    if (_municipio == null) {
      _avisar('Selecciona un municipio.');
      return;
    }
    // La foto de portada ya no es obligatoria para activar un negocio
    // (ver 0024_foto_portada_opcional.sql) — sin ella se muestra el logo
    // de Negocios Verdes en la ficha pública y las tarjetas.

    setState(() => _guardando = true);
    try {
      // Solo dígitos — un número guardado con espacios/guiones/+ produce un
      // link wa.me roto (ver comentario en negocios.whatsapp / BotonWhatsapp).
      final whatsappLimpio =
          _whatsappCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');

      await _negocioService.guardar(
        id: _negocioId,
        nombre: _nombreCtrl.text.trim(),
        categoriaOficialIds: _categoriaOficialIds,
        municipio: _municipio!,
        veredaId: _veredaId,
        direccion: _vacioANulo(_direccionCtrl.text),
        latitud: _latitud,
        longitud: _longitud,
        descripcionCorta: _vacioANulo(_descripcionCortaCtrl.text),
        descripcion: _vacioANulo(_descripcionCtrl.text),
        telefono: _vacioANulo(_telefonoCtrl.text),
        whatsapp: whatsappLimpio.isEmpty ? null : whatsappLimpio,
        email: _vacioANulo(_emailCtrl.text),
        sitioWeb: _vacioANulo(_sitioWebCtrl.text),
        facebookUrl: _vacioANulo(_facebookCtrl.text),
        instagramUrl: _vacioANulo(_instagramCtrl.text),
        fotoPortadaUrl: _fotoPortadaUrl,
        fotoPortadaPath: _fotoPortadaPath,
        representanteLegal: _vacioANulo(_representanteLegalCtrl.text),
        producto: _vacioANulo(_productoCtrl.text),
        nit: _vacioANulo(_nitCtrl.text),
        naturalezaJuridica: _naturalezaJuridica,
        emprendimientoVerde: _emprendimientoVerde,
        selloMarca: _selloMarca,
        avalado: _avalado,
        destacado: _destacado,
        activo: _activo,
        subcategoriaIds: _subcategoriaIds.toList(),
        actividadIds: _actividadIds.toList(),
      );

      await _guardarFichaTecnica();
      await _sincronizarGaleria();

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Negocio guardado.')));
        context.go('/admin/negocios');
      }
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  String? _c(String clave) => _vacioANulo(_fichaCtrls[clave]!.text);
  DateTime? _fecha(String clave) =>
      DateTime.tryParse(_fichaCtrls[clave]!.text.trim());

  Future<void> _guardarFichaTecnica() async {
    await _negocioService.guardarFichaTecnica(
      id: _negocioId,
      novedad: _c('novedad'),
      tipoNegocioVerde: _c('tipoNegocioVerde'),
      codigoMarca: _c('codigoMarca'),
      anioRegistro: int.tryParse(_anioRegistroCtrl.text.trim()),
      cotaMsnm: _c('cotaMsnm'),
      aplicacionFicha2025: _c('aplicacionFicha2025'),
      observaciones: _vacioANulo(_observacionesCtrl.text),
      delegado: _c('delegado'),
      tiempoConstitucion: _c('tiempoConstitucion'),
      rutCamaraComercio: _c('rutCamaraComercio'),
      responsableCdmb: _c('responsableCdmb'),
      registroNacionalTurismo: _c('registroNacionalTurismo'),
      usoSuelo: _c('usoSuelo'),
      concesionAguas: _c('concesionAguas'),
      concesionAguasVencimiento: _fecha('concesionAguasVencimiento'),
      vertimientos: _c('vertimientos'),
      vertimientosVencimiento: _fecha('vertimientosVencimiento'),
      pueaa: _c('pueaa'),
      pgris: _c('pgris'),
      pozoSeptico: _c('pozoSeptico'),
      alcantarillado: _c('alcantarillado'),
      ica: _c('ica'),
      icaVencimiento: _fecha('icaVencimiento'),
      invima: _c('invima'),
      invimaVencimiento: _fecha('invimaVencimiento'),
      certificadoTenenciaAnimales: _c('certificadoTenenciaAnimales'),
      buenasPracticasAgricolas: _c('buenasPracticasAgricolas'),
      buenasPracticasApicolas: _c('buenasPracticasApicolas'),
      registroApicola: _c('registroApicola'),
      intervencionCauce: _c('intervencionCauce'),
      capacidadCarga: _c('capacidadCarga'),
      sstt: _c('sstt'),
      canalVenta: _c('canalVenta'),
      exportacion: _c('exportacion'),
      huellaCarbono: _c('huellaCarbono'),
      fortalecimientoTecnico: _c('fortalecimientoTecnico'),
      fortalecimientoAcademico: _c('fortalecimientoAcademico'),
      fortalecimientoFinanciero: _c('fortalecimientoFinanciero'),
      internacionalizacion: _c('internacionalizacion'),
      certificaciones: _c('certificaciones'),
      posicionamientoMarca: _c('posicionamientoMarca'),
      beneficiosVentanilla: _c('beneficiosVentanilla'),
      fortalezasAmbiental: _c('fortalezasAmbiental'),
      fortalezasSocial: _c('fortalezasSocial'),
      fortalezasEconomico: _c('fortalezasEconomico'),
      debilidadesAmbiental: _c('debilidadesAmbiental'),
      debilidadesSocial: _c('debilidadesSocial'),
      debilidadesFinanciera: _c('debilidadesFinanciera'),
    );

    for (final anio in _kAniosPuntaje) {
      final texto = _puntajeCtrls[anio]!.text.trim();
      if (texto.isEmpty) continue;
      final puntaje = double.tryParse(texto.replaceAll(',', '.'));
      if (puntaje != null) {
        await _negocioService.guardarPuntaje(_negocioId, anio, puntaje);
      }
    }
  }

  /// Borrar+reinsertar, igual que negocios_subcategorias en la RPC — a esta
  /// escala (hasta 5 fotos) es más simple y confiable que diffear altas,
  /// bajas y reordenamientos por separado. Corre DESPUÉS de que el negocio
  /// ya existe en la base de datos (si no, negocio_fotos.negocio_id no
  /// tendría a qué apuntar).
  Future<void> _sincronizarGaleria() async {
    if (_esEdicion) {
      for (final foto in _galeriaInicial) {
        await _negocioFotoService.eliminar(foto.id);
      }
    }
    for (var i = 0; i < _galeriaActual.length; i++) {
      final foto = _galeriaActual[i];
      await _negocioFotoService.agregar(
        negocioId: _negocioId,
        url: foto.url,
        storagePath: foto.storagePath,
        orden: i,
      );
    }
  }

  String? _vacioANulo(String texto) =>
      texto.trim().isEmpty ? null : texto.trim();

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  List<Vereda> get _veredasDelMunicipio =>
      _veredas.where((v) => v.municipio == _municipio).toList();

  Future<void> _crearVereda() async {
    if (_municipio == null) return;
    final controller = TextEditingController();
    final nombre = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nueva vereda'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: 'Nombre — $_municipio'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    if (nombre == null || nombre.trim().isEmpty) return;
    try {
      final vereda =
          await _veredaService.crear(municipio: _municipio!, nombre: nombre);
      if (!mounted) return;
      setState(() {
        _veredas = [..._veredas, vereda];
        _veredaId = vereda.id;
      });
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
        children: [
          Text(
            _esEdicion ? 'Editar negocio' : 'Nuevo negocio',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _seccion('Datos básicos'),
          TextFormField(
            controller: _nombreCtrl,
            decoration: const InputDecoration(labelText: 'Nombre del negocio'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descripcionCortaCtrl,
            decoration: const InputDecoration(
              labelText: 'Descripción corta',
              helperText: 'Para la tarjeta de resultados, máximo ~160 caracteres.',
            ),
            maxLength: 160,
            maxLines: 2,
          ),
          TextFormField(
            controller: _descripcionCtrl,
            decoration: const InputDecoration(labelText: 'Descripción completa'),
            maxLines: 5,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _productoCtrl,
            decoration: const InputDecoration(
              labelText: 'Producto (opcional)',
              helperText: 'Qué vende/ofrece en concreto, ej. "Agua natural 300 cc".',
            ),
          ),
          const SizedBox(height: 20),
          _seccion('Identificación'),
          TextFormField(
            controller: _representanteLegalCtrl,
            decoration: const InputDecoration(
              labelText: 'Representante legal (opcional)',
              helperText: 'Público en la ficha.',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nitCtrl,
                  decoration: const InputDecoration(
                    labelText: 'NIT / CC (opcional)',
                    helperText: 'Nunca se muestra en la ficha pública.',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: _naturalezaJuridica,
                  decoration:
                      const InputDecoration(labelText: 'Naturaleza jurídica'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('—')),
                    for (final n in kNaturalezasJuridicas)
                      DropdownMenuItem(value: n, child: Text(n)),
                  ],
                  onChanged: (v) => setState(() => _naturalezaJuridica = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _seccion('Municipio y categorización'),
          DropdownButtonFormField<String>(
            initialValue: _municipio,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Municipio'),
            items: [
              for (final m in kMunicipios) DropdownMenuItem(value: m, child: Text(m)),
            ],
            onChanged: (v) => setState(() {
              _municipio = v;
              // Una vereda de otro municipio ya no aplica.
              if (_veredaId != null &&
                  !_veredasDelMunicipio.any((ve) => ve.id == _veredaId)) {
                _veredaId = null;
              }
            }),
            validator: (v) => v == null ? 'Requerido' : null,
          ),
          const SizedBox(height: 12),
          if (_municipio != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    initialValue: _veredaId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Vereda (opcional)',
                      helperText: 'Público en la ficha.',
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('—')),
                      for (final v in _veredasDelMunicipio)
                        DropdownMenuItem(value: v.id, child: Text(v.nombre)),
                    ],
                    onChanged: (v) => setState(() => _veredaId = v),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Nueva vereda',
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _crearVereda,
                ),
              ],
            ),
          const SizedBox(height: 16),
          // Categoría → subcategoría → actividad vive en su propio widget
          // con estado local, no acá: si estos chips dispararan el
          // setState de esta página, cada toque reconstruiría TODO el
          // formulario (mapa de ubicación incluido) — ver el comentario en
          // SelectorTaxonomiaNegocio para el porqué eso importa de verdad.
          SelectorTaxonomiaNegocio(
            categorias: _categorias,
            subcategorias: _subcategorias,
            actividades: _actividades,
            categoriaIdsIniciales: _categoriaOficialIds,
            subcategoriaIdsIniciales: _subcategoriaIds,
            actividadIdsIniciales: _actividadIds,
            onCambio: (categoriaIds, subcategoriaIds, actividadIds) {
              _categoriaOficialIds = categoriaIds;
              _subcategoriaIds = subcategoriaIds;
              _actividadIds = actividadIds;
            },
          ),
          const SizedBox(height: 20),
          _seccion('Ubicación'),
          TextFormField(
            controller: _direccionCtrl,
            decoration: const InputDecoration(labelText: 'Dirección (opcional)'),
          ),
          const SizedBox(height: 12),
          if (_municipio != null)
            SelectorUbicacionMapa(
              municipio: _municipio!,
              direccionController: _direccionCtrl,
              latitudInicial: _latitud,
              longitudInicial: _longitud,
              onCambio: (lat, lng) {
                _latitud = lat;
                _longitud = lng;
              },
            )
          else
            const Text(
              'Selecciona un municipio para poder marcar la ubicación en el mapa.',
              style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
            ),
          const SizedBox(height: 20),
          _seccion('Contacto y redes sociales'),
          TextFormField(
            controller: _whatsappCtrl,
            decoration: const InputDecoration(
              labelText: 'WhatsApp (opcional)',
              helperText: 'Con indicativo de país, ej. 573001234567',
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _telefonoCtrl,
            decoration: const InputDecoration(labelText: 'Teléfono fijo (opcional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Correo (opcional)'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _sitioWebCtrl,
            decoration: const InputDecoration(labelText: 'Sitio web (opcional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _facebookCtrl,
            decoration: const InputDecoration(labelText: 'Facebook (opcional)'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _instagramCtrl,
            decoration: const InputDecoration(labelText: 'Instagram (opcional)'),
          ),
          const SizedBox(height: 20),
          _seccion('Fotos'),
          GaleriaEditor(
            negocioId: _negocioId,
            portadaUrlInicial: _fotoPortadaUrl,
            portadaPathInicial: _fotoPortadaPath,
            galeriaInicial: _galeriaInicial,
            onPortadaCambiada: (url, path) {
              _fotoPortadaUrl = url;
              _fotoPortadaPath = path;
            },
            onGaleriaCambiada: (fotos) => _galeriaActual = fotos,
          ),
          const SizedBox(height: 20),
          _seccion('Reconocimientos'),
          const Text(
            'Las 3 categorías de CDMB son independientes entre sí — un '
            'negocio puede tener una, dos o las tres a la vez.',
            style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('🌱 Emprendimiento Verde'),
            value: _emprendimientoVerde,
            onChanged: (v) => setState(() => _emprendimientoVerde = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('🎖️ Negocio Verde — Sello Marca'),
            subtitle: const Text(
              'Certificación oficial que reconoce impacto ambiental '
              'positivo, buenas prácticas sociales y económicas, y '
              'protección de los recursos naturales. Más de 71 % de '
              'cumplimiento.',
            ),
            value: _selloMarca,
            onChanged: (v) => setState(() => _selloMarca = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('✅ Negocio Verde Avalado'),
            subtitle: const Text(
              'Reconocimiento oficial de la Ventanilla de Negocios Verdes: '
              'cumple los requisitos mínimos y supera el 51 % de avance en '
              'criterios ambientales, sociales y económicos.',
            ),
            value: _avalado,
            onChanged: (v) => setState(() => _avalado = v),
          ),
          const SizedBox(height: 20),
          _seccion('Publicación'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Destacado'),
            subtitle: const Text('Aparece en la portada del sitio público.'),
            value: _destacado,
            onChanged: (v) => setState(() => _destacado = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Activo'),
            subtitle: const Text(
                'Visible en el buscador público (sin foto se muestra el '
                'logo de Negocios Verdes). Inactivo = solo visible acá en el admin.'),
            value: _activo,
            onChanged: (v) => setState(() => _activo = v),
          ),
          const SizedBox(height: 20),
          _fichaTecnica(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/admin/negocios'),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _guardando ? null : _guardar,
                  child: _guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Guardar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Sección "Ficha técnica CDMB" — gestión interna, nunca pública (ver
  /// NegocioService._selectPublico). Colapsada por defecto: son ~40 campos
  /// que la mayoría de las ediciones del día a día no toca.
  Widget _fichaTecnica() {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: const Text(
        'Ficha técnica CDMB (gestión interna)',
        style: TextStyle(fontWeight: FontWeight.bold, color: NVColors.primaryDark),
      ),
      subtitle: const Text(
        'Permisos, DOFA, fortalecimiento y puntajes — nunca visible en el sitio público.',
        style: TextStyle(fontSize: 12, color: NVColors.textoSecundario),
      ),
      childrenPadding: const EdgeInsets.only(top: 8, bottom: 12),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _anioRegistroCtrl,
                decoration: const InputDecoration(labelText: 'Año de registro'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final entrada in _kGruposFichaTecnica.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(entrada.key,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: NVColors.primaryDark)),
          ),
          for (final campo in entrada.value)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextFormField(
                controller: _fichaCtrls[campo.clave],
                decoration: InputDecoration(
                  labelText: campo.etiqueta,
                  helperText: campo.esFecha ? 'Formato AAAA-MM-DD' : null,
                ),
              ),
            ),
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: _observacionesCtrl,
            decoration: const InputDecoration(labelText: 'Observaciones'),
            maxLines: 3,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text('Puntajes de seguimiento por año',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: NVColors.primaryDark)),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final anio in _kAniosPuntaje)
              SizedBox(
                width: 110,
                child: TextFormField(
                  controller: _puntajeCtrls[anio],
                  decoration: InputDecoration(labelText: '$anio'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _seccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: NVColors.primaryDark,
        ),
      ),
    );
  }
}
