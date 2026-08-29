import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../catalogos.dart';
import '../../../core/admin_guard.dart';
import '../../../core/widgets/selector_con_catalogo.dart';
import '../../../core/widgets/selector_persona.dart';
import '../../../models/actividad_productiva.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/ficha_tecnica_negocio.dart';
import '../../../models/negocio_foto.dart';
import '../../../models/opcion_campo.dart';
import '../../../models/persona.dart';
import '../../../models/subcategoria.dart';
import '../../../models/vereda.dart';
import '../../../services/actividad_productiva_service.dart';
import '../../../services/categoria_service.dart';
import '../../../services/negocio_foto_service.dart';
import '../../../services/negocio_service.dart';
import '../../../services/opcion_campo_service.dart';
import '../../../services/personas_service.dart';
import '../../../services/subcategoria_service.dart';
import '../../../services/vereda_service.dart';
import '../../../theme/nv_colors.dart';
import 'widgets/galeria_editor.dart';
import 'widgets/selector_taxonomia_negocio.dart';
import 'widgets/selector_ubicacion_mapa.dart';

/// Un campo categórico de la "Ficha técnica CDMB" respaldado por
/// opciones_campo (ver 0025_ficha_tecnica_catalogos.sql) — [campo] es la
/// clave tal cual vive en esa tabla (snake_case, igual que la columna real
/// en negocios), así _valoresSelector/_guardarFichaTecnica no necesitan
/// traducir nombres entre Dart y la base.
class _CampoSelector {
  final String campo;
  final String etiqueta;
  const _CampoSelector(this.campo, this.etiqueta);
}

const _kGruposSelector = <String, List<_CampoSelector>>{
  'Permisos y trámites ambientales': [
    _CampoSelector('registro_nacional_turismo', 'Registro Nacional de Turismo'),
    _CampoSelector('uso_suelo', 'Uso del suelo'),
    _CampoSelector('concesion_aguas', 'Concesión de aguas'),
    _CampoSelector('vertimientos', 'Vertimientos'),
    _CampoSelector('pueaa', 'PUEAA'),
    _CampoSelector('pgris', 'PGRIS'),
    _CampoSelector('pozo_septico', 'Pozo séptico'),
    _CampoSelector('alcantarillado', 'Alcantarillado'),
    _CampoSelector('ica', 'ICA (registro producción/comercialización abono)'),
    _CampoSelector('invima', 'INVIMA'),
    _CampoSelector('certificado_tenencia_animales', 'Certificado tenencia de animales'),
    _CampoSelector('buenas_practicas_agricolas', 'Buenas prácticas agrícolas'),
    _CampoSelector('buenas_practicas_apicolas', 'Buenas prácticas apícolas'),
    _CampoSelector('registro_apicola', 'Registro apícola'),
    _CampoSelector('intervencion_cauce', 'Intervención de cauce'),
    _CampoSelector('capacidad_carga', 'Capacidad de carga'),
    _CampoSelector('sstt', 'SSTT'),
  ],
  'Mercado': [
    _CampoSelector('canal_venta', 'Canal de venta'),
    _CampoSelector('exportacion', 'Exportación / internacionalización actual'),
  ],
};

/// Los 4 permisos que además llevan fecha de vencimiento — [campo] es el
/// selector Sí/No/…, [campoVencimiento] la columna date correspondiente.
class _PermisoConVencimiento {
  final String campo;
  final String campoVencimiento;
  final String etiqueta;
  const _PermisoConVencimiento(this.campo, this.campoVencimiento, this.etiqueta);
}

const _kPermisosConVencimiento = [
  _PermisoConVencimiento('concesion_aguas', 'concesion_aguas_vencimiento', 'Concesión de aguas'),
  _PermisoConVencimiento('vertimientos', 'vertimientos_vencimiento', 'Vertimientos'),
  _PermisoConVencimiento('ica', 'ica_vencimiento', 'ICA'),
  _PermisoConVencimiento('invima', 'invima_vencimiento', 'INVIMA'),
];

/// novedad es de las pocas cosas de la ficha técnica que NO usa el
/// catálogo editable opciones_campo — a propósito: tiene una restricción
/// real en la base (CHECK negocios_novedad_valida, ver
/// 0025_ficha_tecnica_catalogos.sql) que exige exactamente estos 4
/// valores, así que dejar que el admin "agregue una opción nueva" acá
/// rompería el guardado en vez de ayudar.
const _kNovedadOpciones = ['ACTIVO', 'INACTIVO', 'RETIRADO', 'SUSPENDIDO'];

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
  final _opcionCampoService = OpcionCampoService();
  final _personasService = PersonasService();

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
  final _telefonoSecundarioCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _sitioWebCtrl = TextEditingController();
  final _facebookCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _anioRegistroCtrl = TextEditingController();
  final _observacionesCtrl = TextEditingController();
  final _huellaCarbonoCtrl = TextEditingController();
  final _fortalezasAmbientalCtrl = TextEditingController();
  final _fortalezasSocialCtrl = TextEditingController();
  final _fortalezasEconomicoCtrl = TextEditingController();

  /// Catálogo cargado una sola vez al abrir el formulario — campo (clave
  /// snake_case) → sus opciones existentes, ordenadas. "no hardcodeada":
  /// las opciones viven en la base (opciones_campo), no en este archivo.
  Map<String, List<OpcionCampo>> _opciones = {};
  /// Valor elegido por campo, para todos los _kGruposSelector +
  /// tipoNegocioVerde/aplicacionFicha2025/rutCamaraComercio/responsable_cdmb/
  /// delegado — todos comparten esta misma forma (String? simple, no
  /// TextEditingController, porque son selectores, no texto libre).
  final Map<String, String?> _valoresSelector = {};
  final Map<String, DateTime?> _vencimientos = {
    for (final p in _kPermisosConVencimiento) p.campoVencimiento: null,
  };
  String? _novedad;

  /// Puntajes por año — Set de años en vez de una lista fija de 2020-2025:
  /// "piensa en futuro, no solo hasta 2025" (pedido explícito). Arranca
  /// con los años que el negocio ya tenga cargados + el año actual;
  /// "+ Agregar año" deja escribir cualquier otro.
  final Set<int> _aniosPuntaje = {};
  final Map<int, TextEditingController> _puntajeCtrls = {};
  /// Años que ya venían guardados en negocio_puntajes al abrir el formulario
  /// — para saber, al quitar un año o dejarlo en blanco, si hay que llamar a
  /// la RPC `eliminar_puntaje_negocio` o basta con sacarlo del estado local.
  final Set<int> _aniosPuntajeGuardados = {};

  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<ActividadProductiva> _actividades = [];
  List<Vereda> _veredas = [];

  /// Bases de personas (ver PersonasService / 0029) + la asignación vigente
  /// de cada una a este negocio. `_xIdOriginal` es lo que había al abrir el
  /// formulario — si al guardar cambió, se llama a la RPC asignar/quitar que
  /// deja la traza.
  List<Persona> _responsables = [];
  List<Persona> _delegados = [];
  List<Persona> _representantes = [];
  String? _responsableId;
  String? _delegadoId;
  String? _representanteId;
  String? _responsableIdOriginal;
  String? _delegadoIdOriginal;
  String? _representanteIdOriginal;
  String? _nitOriginal;
  String? _naturalezaOriginal;
  List<AsignacionPersona> _histResp = [];
  List<AsignacionPersona> _histDeleg = [];
  List<AsignacionPersona> _histRepr = [];
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
  /// Cambia cada vez que Este/Norte calculan un punto nuevo — se usa como
  /// key de SelectorUbicacionMapa para forzar que se vuelva a montar con
  /// el lat/lng recién calculado (ese widget solo lee su lat/lng inicial
  /// una vez, en su propio initState).
  int _mapaVersion = 0;
  final _esteCtrl = TextEditingController();
  final _norteCtrl = TextEditingController();
  final _cotaCtrl = TextEditingController();
  String? _errorEsteNorte;
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
    _telefonoSecundarioCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _sitioWebCtrl.dispose();
    _facebookCtrl.dispose();
    _instagramCtrl.dispose();
    _direccionCtrl.dispose();
    _nitCtrl.dispose();
    _anioRegistroCtrl.dispose();
    _observacionesCtrl.dispose();
    _huellaCarbonoCtrl.dispose();
    _fortalezasAmbientalCtrl.dispose();
    _fortalezasSocialCtrl.dispose();
    _fortalezasEconomicoCtrl.dispose();
    _esteCtrl.dispose();
    _norteCtrl.dispose();
    _cotaCtrl.dispose();
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
      final opciones = await _opcionCampoService.listarTodas();
      _responsables = await _personasService.listar(TipoPersona.responsable);
      _delegados = await _personasService.listar(TipoPersona.delegado);
      _representantes = await _personasService.listar(TipoPersona.representante);

      _aniosPuntaje.add(DateTime.now().year);

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
        _telefonoSecundarioCtrl.text = existente.telefonoSecundario ?? '';
        _whatsappCtrl.text = existente.whatsapp ?? '';
        _emailCtrl.text = existente.email ?? '';
        _sitioWebCtrl.text = existente.sitioWeb ?? '';
        _facebookCtrl.text = existente.facebookUrl ?? '';
        _instagramCtrl.text = existente.instagramUrl ?? '';
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

        final actuales = await _personasService.actuales(_negocioId);
        _responsableId = _responsableIdOriginal = actuales.responsableId;
        _delegadoId = _delegadoIdOriginal = actuales.delegadoId;
        _representanteId = _representanteIdOriginal = actuales.representanteId;
        _nitOriginal = actuales.nit;
        _naturalezaOriginal = actuales.naturalezaJuridica;
        _histResp = await _personasService.historial(
            TipoPersona.responsable, _negocioId);
        _histDeleg =
            await _personasService.historial(TipoPersona.delegado, _negocioId);
        _histRepr = await _personasService.historial(
            TipoPersona.representante, _negocioId);
      }

      if (!mounted) return;
      setState(() {
        _categorias = categorias;
        _subcategorias = subcategorias;
        _actividades = actividades;
        _veredas = veredas;
        _opciones = opciones;
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

  void _poblarFicha(FichaTecnicaNegocio f) {
    _novedad = f.novedad;
    _valoresSelector['tipo_negocio_verde'] = f.tipoNegocioVerde;
    _valoresSelector['aplicacion_ficha_2025'] = f.aplicacionFicha2025;
    _valoresSelector['rut_camara_comercio'] = f.rutCamaraComercio;
    // responsable_cdmb / delegado ya no son texto libre: se manejan como
    // personas (ver _responsableId/_delegadoId + SelectorPersona).
    _valoresSelector['registro_nacional_turismo'] = f.registroNacionalTurismo;
    _valoresSelector['uso_suelo'] = f.usoSuelo;
    _valoresSelector['concesion_aguas'] = f.concesionAguas;
    _valoresSelector['vertimientos'] = f.vertimientos;
    _valoresSelector['pueaa'] = f.pueaa;
    _valoresSelector['pgris'] = f.pgris;
    _valoresSelector['pozo_septico'] = f.pozoSeptico;
    _valoresSelector['alcantarillado'] = f.alcantarillado;
    _valoresSelector['ica'] = f.ica;
    _valoresSelector['invima'] = f.invima;
    _valoresSelector['certificado_tenencia_animales'] =
        f.certificadoTenenciaAnimales;
    _valoresSelector['buenas_practicas_agricolas'] = f.buenasPracticasAgricolas;
    _valoresSelector['buenas_practicas_apicolas'] = f.buenasPracticasApicolas;
    _valoresSelector['registro_apicola'] = f.registroApicola;
    _valoresSelector['intervencion_cauce'] = f.intervencionCauce;
    _valoresSelector['capacidad_carga'] = f.capacidadCarga;
    _valoresSelector['sstt'] = f.sstt;
    _valoresSelector['canal_venta'] = f.canalVenta;
    _valoresSelector['exportacion'] = f.exportacion;
    _vencimientos['concesion_aguas_vencimiento'] = f.concesionAguasVencimiento;
    _vencimientos['vertimientos_vencimiento'] = f.vertimientosVencimiento;
    _vencimientos['ica_vencimiento'] = f.icaVencimiento;
    _vencimientos['invima_vencimiento'] = f.invimaVencimiento;
    _anioRegistroCtrl.text = f.anioRegistro?.toString() ?? '';
    _observacionesCtrl.text = f.observaciones ?? '';
    _huellaCarbonoCtrl.text = f.huellaCarbono ?? '';
    _fortalezasAmbientalCtrl.text = f.fortalezasAmbiental ?? '';
    _fortalezasSocialCtrl.text = f.fortalezasSocial ?? '';
    _fortalezasEconomicoCtrl.text = f.fortalezasEconomico ?? '';
    _esteCtrl.text = f.este ?? '';
    _norteCtrl.text = f.norte ?? '';
    _cotaCtrl.text = f.cotaMsnm ?? '';
    _aniosPuntaje.addAll(f.puntajes.keys);
    _aniosPuntajeGuardados.addAll(f.puntajes.keys);
    for (final anio in _aniosPuntaje) {
      _puntajeCtrls[anio] =
          TextEditingController(text: f.puntajes[anio]?.toString() ?? '');
    }
    // Auto-ubicar: si el negocio no tenía lat/lng propios pero sí
    // Este/Norte, arma el punto del mapa apenas se abre el formulario —
    // "no solo mostrarlo sino ubicarlo" (pedido explícito), no hace falta
    // que el admin toque nada para verlo en el mapa la primera vez.
    if (_latitud == null && _longitud == null) {
      final este = _parsearGrados(f.este ?? '');
      final norte = _parsearGrados(f.norte ?? '');
      if (este != null && norte != null) {
        _latitud = norte;
        _longitud = -este;
      }
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
    // (ver 0023_foto_portada_opcional.sql) — sin ella se muestra el logo
    // de Negocios Verdes en la ficha pública y las tarjetas.

    setState(() => _guardando = true);
    try {
      final (whatsappNorm, telefonoNorm, secundarioNorm) = _normalizarContacto();

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
        telefono: telefonoNorm,
        telefonoSecundario: secundarioNorm,
        whatsapp: whatsappNorm,
        email: _vacioANulo(_emailCtrl.text),
        sitioWeb: _vacioANulo(_sitioWebCtrl.text),
        facebookUrl: _vacioANulo(_facebookCtrl.text),
        instagramUrl: _vacioANulo(_instagramCtrl.text),
        fotoPortadaUrl: _fotoPortadaUrl,
        fotoPortadaPath: _fotoPortadaPath,
        representanteLegal: _personaNombre(_representantes, _representanteId),
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
      await _sincronizarAsignaciones();
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

  Future<void> _guardarFichaTecnica() async {
    await _negocioService.guardarFichaTecnica(
      id: _negocioId,
      novedad: _novedad,
      tipoNegocioVerde: _valoresSelector['tipo_negocio_verde'],
      anioRegistro: int.tryParse(_anioRegistroCtrl.text.trim()),
      cotaMsnm: _vacioANulo(_cotaCtrl.text),
      aplicacionFicha2025: _valoresSelector['aplicacion_ficha_2025'],
      observaciones: _vacioANulo(_observacionesCtrl.text),
      // responsable_cdmb / delegado: se pasan como texto (copia
      // denormalizada) para no romper la RPC, pero la fuente de verdad y la
      // traza son las tablas de personas (ver _sincronizarAsignaciones).
      delegado: _personaNombre(_delegados, _delegadoId),
      rutCamaraComercio: _valoresSelector['rut_camara_comercio'],
      responsableCdmb: _personaNombre(_responsables, _responsableId),
      registroNacionalTurismo: _valoresSelector['registro_nacional_turismo'],
      usoSuelo: _valoresSelector['uso_suelo'],
      concesionAguas: _valoresSelector['concesion_aguas'],
      concesionAguasVencimiento: _vencimientos['concesion_aguas_vencimiento'],
      vertimientos: _valoresSelector['vertimientos'],
      vertimientosVencimiento: _vencimientos['vertimientos_vencimiento'],
      pueaa: _valoresSelector['pueaa'],
      pgris: _valoresSelector['pgris'],
      pozoSeptico: _valoresSelector['pozo_septico'],
      alcantarillado: _valoresSelector['alcantarillado'],
      ica: _valoresSelector['ica'],
      icaVencimiento: _vencimientos['ica_vencimiento'],
      invima: _valoresSelector['invima'],
      invimaVencimiento: _vencimientos['invima_vencimiento'],
      certificadoTenenciaAnimales: _valoresSelector['certificado_tenencia_animales'],
      buenasPracticasAgricolas: _valoresSelector['buenas_practicas_agricolas'],
      buenasPracticasApicolas: _valoresSelector['buenas_practicas_apicolas'],
      registroApicola: _valoresSelector['registro_apicola'],
      intervencionCauce: _valoresSelector['intervencion_cauce'],
      capacidadCarga: _valoresSelector['capacidad_carga'],
      sstt: _valoresSelector['sstt'],
      canalVenta: _valoresSelector['canal_venta'],
      exportacion: _valoresSelector['exportacion'],
      huellaCarbono: _vacioANulo(_huellaCarbonoCtrl.text),
      fortalezasAmbiental: _vacioANulo(_fortalezasAmbientalCtrl.text),
      fortalezasSocial: _vacioANulo(_fortalezasSocialCtrl.text),
      fortalezasEconomico: _vacioANulo(_fortalezasEconomicoCtrl.text),
      este: _vacioANulo(_esteCtrl.text),
      norte: _vacioANulo(_norteCtrl.text),
    );

    for (final anio in _aniosPuntaje) {
      final texto = _puntajeCtrls[anio]?.text.trim() ?? '';
      if (texto.isEmpty) {
        // Un año que quedó en blanco: si estaba guardado, se elimina de la
        // base (si no, no había nada que hacer).
        if (_aniosPuntajeGuardados.contains(anio)) {
          await _negocioService.eliminarPuntaje(_negocioId, anio);
        }
        continue;
      }
      final puntaje = double.tryParse(texto.replaceAll(',', '.'));
      if (puntaje != null) {
        await _negocioService.guardarPuntaje(_negocioId, anio, puntaje);
      }
    }
  }

  String? _personaNombre(List<Persona> lista, String? id) {
    if (id == null) return null;
    for (final p in lista) {
      if (p.id == id) return p.nombreCompleto;
    }
    return null;
  }

  /// Si cambió el responsable / delegado / representante (o, para
  /// representante, el NIT o la naturaleza jurídica), llama a la RPC
  /// asignar/quitar que cierra la asignación vigente y abre otra — así queda
  /// la traza (quién, cuándo). Corre DESPUÉS de guardar_negocio para que el
  /// negocio ya exista.
  Future<void> _sincronizarAsignaciones() async {
    if (_responsableId != _responsableIdOriginal) {
      if (_responsableId == null) {
        await _personasService.quitar(TipoPersona.responsable,
            negocioId: _negocioId);
      } else {
        await _personasService.asignar(TipoPersona.responsable,
            negocioId: _negocioId, personaId: _responsableId!);
      }
    }
    if (_delegadoId != _delegadoIdOriginal) {
      if (_delegadoId == null) {
        await _personasService.quitar(TipoPersona.delegado,
            negocioId: _negocioId);
      } else {
        await _personasService.asignar(TipoPersona.delegado,
            negocioId: _negocioId, personaId: _delegadoId!);
      }
    }
    final nit = _vacioANulo(_nitCtrl.text);
    if (_representanteId == null) {
      // Sin representante: solo hay que hacer algo si antes había uno.
      if (_representanteIdOriginal != null) {
        await _personasService.quitar(TipoPersona.representante,
            negocioId: _negocioId);
      }
    } else if (_representanteId != _representanteIdOriginal ||
        nit != _nitOriginal ||
        _naturalezaJuridica != _naturalezaOriginal) {
      await _personasService.asignar(TipoPersona.representante,
          negocioId: _negocioId,
          personaId: _representanteId!,
          nit: nit,
          naturalezaJuridica: _naturalezaJuridica);
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

  /// Reparte lo escrito en WhatsApp / Teléfono fijo / Teléfono secundario en
  /// esos mismos 3 campos ya normalizados, siguiendo las reglas que pidió
  /// CDMB: un celular colombiano (10 dígitos, empieza por 3) va a WhatsApp
  /// con indicativo `57` adelante para que `wa.me` funcione; un número que
  /// no es celular se queda como teléfono fijo; y si hay más de uno, el
  /// resto va a secundario (antes se pegaban dos con un guion en un solo
  /// campo, rompiendo el link). Devuelve (whatsapp, telefono, secundario).
  (String?, String?, String?) _normalizarContacto() {
    String dig(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');
    bool celular(String d) => d.length == 10 && d.startsWith('3');
    bool celularConPais(String d) => d.length == 12 && d.startsWith('573');
    String aWhatsapp(String d) => celular(d) ? '57$d' : d;

    // Un campo puede traer dos números pegados ("300… - 301…").
    List<String> partes(String s) => s
        .split(RegExp(r'\s*[-/,;]+\s*'))
        .map(dig)
        .where((d) => d.length >= 7)
        .toList();

    final escritoWhatsapp = partes(_whatsappCtrl.text);
    final pendientes = <String>[
      ...escritoWhatsapp.skip(1),
      ...partes(_telefonoCtrl.text),
      ...partes(_telefonoSecundarioCtrl.text),
    ];

    String? whatsapp = escritoWhatsapp.isNotEmpty
        ? aWhatsapp(escritoWhatsapp.first)
        : null;
    // Si no se escribió WhatsApp pero hay un celular entre los demás, se usa.
    if (whatsapp == null) {
      final idx = pendientes.indexWhere((d) => celular(d) || celularConPais(d));
      if (idx >= 0) whatsapp = aWhatsapp(pendientes.removeAt(idx));
    }

    final vistos = <String>{if (whatsapp != null) dig(whatsapp)};
    final restantes = <String>[];
    for (final d in pendientes) {
      if (vistos.add(d)) restantes.add(d);
    }

    return (
      whatsapp,
      restantes.isEmpty ? null : restantes.first,
      restantes.length > 1 ? restantes.sublist(1).join(' / ') : null,
    );
  }

  /// Grados decimales (siempre positivos) desde un texto Este/Norte, o null
  /// si no calza con ningún formato reconocible — mismo criterio que
  /// generar_0026.py (nunca "adivina" un valor a medias): acepta grados
  /// decimales ya listos (ej. "72.87") o el patrón DMS más común
  /// (73°12'34.5"), rechaza minutos/segundos fuera de rango.
  double? _parsearGrados(String texto) {
    final s = texto.trim();
    if (s.isEmpty) return null;
    final directo = double.tryParse(s.replaceAll(',', '.'));
    if (directo != null && directo > 0 && directo < 200) return directo;
    final m = RegExp(r'^\(?-?\)?\s*(\d{1,3})[°:]\s*(\d{1,2})[' "'’:" r']\s*([\d.,]+)')
        .firstMatch(s);
    if (m == null) return null;
    final grados = int.tryParse(m.group(1)!);
    final minutos = int.tryParse(m.group(2)!);
    final segundos = double.tryParse(m.group(3)!.replaceAll(',', '.'));
    if (grados == null || minutos == null || segundos == null) return null;
    if (minutos >= 60 || segundos >= 60) return null;
    return grados + minutos / 60 + segundos / 3600;
  }

  /// Botón explícito ("Actualizar mapa"): sí avisa si Este/Norte no se
  /// pueden leer, porque acá el admin pidió la conversión a propósito.
  void _calcularUbicacionDesdeEsteNorte() {
    final este = _parsearGrados(_esteCtrl.text);
    final norte = _parsearGrados(_norteCtrl.text);
    if (este == null || norte == null) {
      setState(() => _errorEsteNorte =
          'No se pudo leer Este/Norte — revisa el formato (ej. 72°58\'36.7" o 72.976861).');
      return;
    }
    setState(() {
      _errorEsteNorte = null;
      _latitud = norte;
      _longitud = -este;
      _mapaVersion++;
    });
  }

  /// Se llama en cada tecla de Este/Norte ("no solo mostrarlo sino
  /// ubicarlo": el mapa se actualiza solo mientras se escribe, sin
  /// esperar un clic aparte) — a diferencia del botón, mientras se escribe
  /// la mayoría de los estados intermedios son inválidos a propósito (ej.
  /// "72." o "-72"), así que acá nunca se muestra error, solo se actualiza
  /// el mapa cuando ambos ya parsean a un punto válido.
  void _actualizarMapaSiValido() {
    final este = _parsearGrados(_esteCtrl.text);
    final norte = _parsearGrados(_norteCtrl.text);
    if (este == null || norte == null) return;
    final lat = norte, lng = -este;
    if (_latitud == lat && _longitud == lng) return;
    setState(() {
      _errorEsteNorte = null;
      _latitud = lat;
      _longitud = lng;
      _mapaVersion++;
    });
  }

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

  /// "Deja una opción adicional si es necesario para el administrador":
  /// un solo diálogo reusado por CADA SelectorConCatalogo del formulario
  /// (permisos, nombres de responsable/delegado, tipo de negocio, etc.) —
  /// agrega la opción al catálogo real (opciones_campo) y la deja
  /// seleccionada de una vez, así el admin no tiene que buscarla de
  /// nuevo en la lista.
  Future<void> _agregarOpcion(BuildContext context, String campo) async {
    final controller = TextEditingController();
    final valor = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Agregar opción nueva'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Valor'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
    if (valor == null || valor.trim().isEmpty) return;
    try {
      final opcion =
          await _opcionCampoService.agregar(campo: campo, valor: valor.trim());
      if (!mounted) return;
      setState(() {
        _opciones = {..._opciones};
        _opciones.putIfAbsent(campo, () => []).add(opcion);
        _valoresSelector[campo] = opcion.valor;
      });
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  List<String> _valoresDe(String campo) =>
      (_opciones[campo] ?? []).map((o) => o.valor).toList();

  Future<void> _agregarAnioPuntaje() async {
    final controller = TextEditingController();
    final texto = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Agregar año'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Año', hintText: '2026'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
    final anio = int.tryParse(texto?.trim() ?? '');
    if (anio == null) return;
    setState(() {
      _aniosPuntaje.add(anio);
      _puntajeCtrls.putIfAbsent(anio, () => TextEditingController());
    });
  }

  /// Quitar un año del historial. Si ya estaba guardado en la base se borra
  /// de una vez (no se espera al "Guardar" general) — así el historial que
  /// se muestra siempre coincide con lo que hay en negocio_puntajes.
  Future<void> _eliminarAnioPuntaje(int anio) async {
    final estabaGuardado = _aniosPuntajeGuardados.contains(anio);
    if (estabaGuardado) {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Quitar el puntaje $anio'),
          content: Text(
              'Se eliminará el puntaje de seguimiento del año $anio para este '
              'negocio. Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Quitar'),
            ),
          ],
        ),
      );
      if (confirmar != true) return;
      try {
        await _negocioService.eliminarPuntaje(_negocioId, anio);
      } catch (e) {
        _avisar(e.toString().replaceFirst('Exception: ', ''));
        return;
      }
    }
    if (!mounted) return;
    setState(() {
      _aniosPuntaje.remove(anio);
      _aniosPuntajeGuardados.remove(anio);
      _puntajeCtrls.remove(anio)?.dispose();
    });
  }

  /// Historial año→puntaje tal cual está escrito ahora en los campos, para
  /// dibujar la mini-gráfica de barras (solo los años con un número válido).
  Map<int, double> get _puntajesActuales {
    final m = <int, double>{};
    for (final anio in _aniosPuntaje) {
      final t = _puntajeCtrls[anio]?.text.trim().replaceAll(',', '.') ?? '';
      final v = double.tryParse(t);
      if (v != null) m[anio] = v;
    }
    return m;
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
          SelectorPersona(
            tipo: TipoPersona.representante,
            personas: _representantes,
            seleccionadaId: _representanteId,
            servicio: _personasService,
            onSeleccion: (p) => setState(() => _representanteId = p?.id),
            onPersonasCambiaron: (lista) =>
                setState(() => _representantes = lista),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4, left: 4),
            child: Text(
              'El nombre se muestra en la ficha pública. El NIT y la '
              'naturaleza jurídica son de este negocio (la misma persona '
              'puede representar varios, cada uno con su NIT).',
              style: TextStyle(fontSize: 12, color: NVColors.textoSecundario),
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
          const SizedBox(height: 16),
          // Este/Norte/Cota son la fuente primaria de ubicación (pedido
          // explícito: "se deben presentar en Este, Norte y Cota... es
          // como lo tenemos"), no la latitud/longitud del mapa — esas se
          // calculan A PARTIR de acá, nunca al revés.
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: NVColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Este / Norte / Cota',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                const Text(
                  'Tal cual vienen de la base de CDMB — el mapa de abajo se '
                  'ubica solo a partir de estos 3 datos.',
                  style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _esteCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Este',
                          isDense: true,
                          hintText: '72°58\'36.7"',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (_) => _actualizarMapaSiValido(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _norteCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Norte',
                          isDense: true,
                          hintText: '7°23\'2.0"',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (_) => _actualizarMapaSiValido(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _cotaCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Cota',
                          isDense: true,
                          hintText: '999 msnm',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _calcularUbicacionDesdeEsteNorte,
                      icon: const Icon(Icons.my_location, size: 18),
                      label: const Text('Actualizar mapa'),
                    ),
                    if (_latitud != null && _longitud != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Convertido: ${_latitud!.toStringAsFixed(6)}, '
                          '${_longitud!.toStringAsFixed(6)}'
                          '${_cotaCtrl.text.trim().isNotEmpty ? ', ${_cotaCtrl.text.trim()}' : ''}',
                          style: const TextStyle(
                              color: NVColors.textoSecundario, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                if (_errorEsteNorte != null) ...[
                  const SizedBox(height: 6),
                  Text(_errorEsteNorte!,
                      style: const TextStyle(color: NVColors.error, fontSize: 12)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_municipio != null)
            SelectorUbicacionMapa(
              key: ValueKey(_mapaVersion),
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
              labelText: 'WhatsApp / celular (opcional)',
              helperText: 'Al guardar: un celular (10 dígitos, empieza por 3) '
                  'se guarda como 57… para que el botón de WhatsApp funcione.',
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _telefonoCtrl,
            decoration: const InputDecoration(
              labelText: 'Teléfono fijo (opcional)',
              helperText: 'Números que no son celular. Si hay más de uno, el '
                  'resto pasa a "Teléfono secundario" al guardar.',
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _telefonoSecundarioCtrl,
            decoration:
                const InputDecoration(labelText: 'Teléfono secundario (opcional)'),
            keyboardType: TextInputType.phone,
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
  /// NegocioService._selectPublico). Antes iba dentro de un ExpansionTile
  /// que se abría/cerraba con cualquier toque y dejaba todo escondido
  /// (pedido explícito de corrección: "es muy incómodo la ficha se abra al
  /// dar clic... esté toda la información disponible sin abrirla y más
  /// agrupada"). Ahora es una sección fija, siempre visible, con las mismas
  /// tarjetas por grupo (ícono + campos categóricos vía SelectorConCatalogo,
  /// las opciones viven en la base, no en este archivo).
  Widget _fichaTecnica() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: NVColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.assignment_outlined,
                  size: 20, color: NVColors.primaryDark),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Ficha técnica CDMB (gestión interna)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: NVColors.primaryDark)),
                    SizedBox(height: 2),
                    Text(
                      'Permisos, fortalezas y puntajes — nunca visible en el '
                      'sitio público. Puede ir quedando incompleta: la '
                      'actualiza el personal de campo.',
                      style: TextStyle(
                          fontSize: 12, color: NVColors.textoSecundario),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _tarjetaGrupo(
          icono: Icons.badge_outlined,
          titulo: 'Identificación y seguimiento',
          hijos: [
            DropdownButtonFormField<String?>(
              initialValue: _novedad,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Estado (novedad CDMB)'),
              items: [
                const DropdownMenuItem(value: null, child: Text('—')),
                for (final o in _kNovedadOpciones)
                  DropdownMenuItem(value: o, child: Text(o)),
              ],
              onChanged: (v) => setState(() => _novedad = v),
            ),
            const SizedBox(height: 12),
            SelectorConCatalogo(
              etiqueta: 'Tipo / madurez de negocio verde',
              valor: _valoresSelector['tipo_negocio_verde'],
              opciones: _valoresDe('tipo_negocio_verde'),
              onCambio: (v) =>
                  setState(() => _valoresSelector['tipo_negocio_verde'] = v),
              onAgregarOpcion: (ctx) => _agregarOpcion(ctx, 'tipo_negocio_verde'),
            ),
            const SizedBox(height: 12),
            // La columna sigue llamándose `aplicacion_ficha_2025` en la base
            // (no vale la pena una migración de rename solo por la etiqueta),
            // pero de cara al admin es "de la vigencia", no de un año fijo —
            // así 2026, 2027… no obligan a tocar nada.
            SelectorConCatalogo(
              etiqueta: 'Aplicación de ficha (vigencia actual)',
              valor: _valoresSelector['aplicacion_ficha_2025'],
              opciones: _valoresDe('aplicacion_ficha_2025'),
              onCambio: (v) =>
                  setState(() => _valoresSelector['aplicacion_ficha_2025'] = v),
              onAgregarOpcion: (ctx) => _agregarOpcion(ctx, 'aplicacion_ficha_2025'),
            ),
            const SizedBox(height: 12),
            SelectorConCatalogo(
              etiqueta: 'RUT / Cámara de comercio',
              valor: _valoresSelector['rut_camara_comercio'],
              opciones: _valoresDe('rut_camara_comercio'),
              onCambio: (v) =>
                  setState(() => _valoresSelector['rut_camara_comercio'] = v),
              onAgregarOpcion: (ctx) => _agregarOpcion(ctx, 'rut_camara_comercio'),
            ),
            const SizedBox(height: 12),
            SelectorPersona(
              tipo: TipoPersona.responsable,
              personas: _responsables,
              seleccionadaId: _responsableId,
              servicio: _personasService,
              onSeleccion: (p) => setState(() => _responsableId = p?.id),
              onPersonasCambiaron: (lista) =>
                  setState(() => _responsables = lista),
            ),
            const SizedBox(height: 12),
            SelectorPersona(
              tipo: TipoPersona.delegado,
              personas: _delegados,
              seleccionadaId: _delegadoId,
              servicio: _personasService,
              onSeleccion: (p) => setState(() => _delegadoId = p?.id),
              onPersonasCambiaron: (lista) =>
                  setState(() => _delegados = lista),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _anioRegistroCtrl,
              decoration: InputDecoration(
                labelText: 'Año de registro',
                helperText: _anioTrayectoria(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _observacionesCtrl,
              decoration: const InputDecoration(labelText: 'Observaciones'),
              maxLines: 3,
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final entrada in _kGruposSelector.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _tarjetaGrupo(
              icono: entrada.key == 'Mercado'
                  ? Icons.trending_up
                  : Icons.eco_outlined,
              titulo: entrada.key,
              hijos: [
                for (final campo in entrada.value) ...[
                  SelectorConCatalogo(
                    etiqueta: campo.etiqueta,
                    valor: _valoresSelector[campo.campo],
                    opciones: _valoresDe(campo.campo),
                    onCambio: (v) =>
                        setState(() => _valoresSelector[campo.campo] = v),
                    onAgregarOpcion: (ctx) => _agregarOpcion(ctx, campo.campo),
                  ),
                  if (_kPermisosConVencimiento.any((p) => p.campo == campo.campo))
                    _campoVencimiento(_kPermisosConVencimiento
                        .firstWhere((p) => p.campo == campo.campo)),
                  const SizedBox(height: 12),
                ],
                if (entrada.key == 'Mercado')
                  TextFormField(
                    controller: _huellaCarbonoCtrl,
                    decoration: const InputDecoration(labelText: 'Huella de carbono'),
                  ),
              ],
            ),
          ),
        _tarjetaGrupo(
          icono: Icons.thumb_up_outlined,
          titulo: 'Fortalezas',
          hijos: [
            TextFormField(
              controller: _fortalezasAmbientalCtrl,
              decoration: const InputDecoration(labelText: 'Ambiental'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fortalezasSocialCtrl,
              decoration: const InputDecoration(labelText: 'Social'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _fortalezasEconomicoCtrl,
              decoration: const InputDecoration(labelText: 'Económico'),
              maxLines: 2,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _tarjetaGrupo(
          icono: Icons.leaderboard_outlined,
          titulo: 'Puntajes de seguimiento por año',
          hijos: [
            const Text(
              'Historial completo de la calificación de seguimiento de este '
              'negocio. Agrega los años que necesites (2026, 2027…); cada año '
              'se guarda por separado.',
              style: TextStyle(fontSize: 12, color: NVColors.textoSecundario),
            ),
            const SizedBox(height: 14),
            _GraficaPuntajes(puntajes: _puntajesActuales),
            const SizedBox(height: 16),
            for (final anio in (_aniosPuntaje.toList()..sort()))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 96,
                      child: TextFormField(
                        controller: _puntajeCtrls[anio],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: '$anio',
                          isDense: true,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BarraPuntaje(
                          valor: _puntajesActuales[anio], maximo: 100),
                    ),
                    IconButton(
                      tooltip: 'Quitar el año $anio',
                      icon: const Icon(Icons.close, size: 18),
                      color: NVColors.textoSecundario,
                      onPressed: () => _eliminarAnioPuntaje(anio),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: _agregarAnioPuntaje,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar año'),
            ),
          ],
        ),
        if (_esEdicion) ...[
          const SizedBox(height: 14),
          _tarjetaGrupo(
            icono: Icons.history,
            titulo: 'Historial de responsable / delegado / representante',
            hijos: [
              const Text(
                'Cada vez que cambia el responsable, el delegado o el '
                'representante queda registrado quién estaba antes y hasta '
                'cuándo. Se puede cambiar en cualquier momento.',
                style: TextStyle(fontSize: 12, color: NVColors.textoSecundario),
              ),
              const SizedBox(height: 12),
              _bloqueHistorial('Responsable CDMB', _histResp),
              const SizedBox(height: 12),
              _bloqueHistorial('Delegado', _histDeleg),
              const SizedBox(height: 12),
              _bloqueHistorial('Representante legal', _histRepr),
            ],
          ),
        ],
      ],
    );
  }

  Widget _bloqueHistorial(String titulo, List<AsignacionPersona> filas) {
    String fecha(DateTime? d) => d == null
        ? '—'
        : '${d.day.toString().padLeft(2, '0')}/'
            '${d.month.toString().padLeft(2, '0')}/${d.year}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 4),
        if (filas.isEmpty)
          const Text('Sin asignaciones registradas.',
              style: TextStyle(fontSize: 12, color: NVColors.textoSecundario))
        else
          for (final f in filas)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    f.vigente ? Icons.check_circle : Icons.circle_outlined,
                    size: 14,
                    color: f.vigente
                        ? NVColors.verdeVivo
                        : NVColors.textoSecundario,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: f.personaNombre,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      if ((f.documento ?? '').isNotEmpty)
                        TextSpan(text: '  ·  CC ${f.documento}'),
                      if ((f.nit ?? '').isNotEmpty)
                        TextSpan(text: '  ·  NIT ${f.nit}'),
                      TextSpan(
                        text: f.vigente
                            ? '\nDesde ${fecha(f.vigenteDesde)} — actual'
                            : '\n${fecha(f.vigenteDesde)} → ${fecha(f.vigenteHasta)}',
                        style: const TextStyle(
                            fontSize: 12, color: NVColors.textoSecundario),
                      ),
                      if ((f.nota ?? '').isNotEmpty)
                        TextSpan(
                          text: '\n“${f.nota}”',
                          style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: NVColors.textoSecundario),
                        ),
                    ])),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  String? _anioTrayectoria() {
    final anio = int.tryParse(_anioRegistroCtrl.text.trim());
    if (anio == null) return null;
    final anios = DateTime.now().year - anio;
    if (anios < 0) return null;
    return anios == 0 ? 'Registrado este año' : '$anios años de trayectoria';
  }

  Widget _campoVencimiento(_PermisoConVencimiento permiso) {
    final fecha = _vencimientos[permiso.campoVencimiento];
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: InkWell(
        onTap: () async {
          final elegida = await showDatePicker(
            context: context,
            initialDate: fecha ?? DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime(2100),
          );
          if (elegida != null) {
            setState(() => _vencimientos[permiso.campoVencimiento] = elegida);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Vencimiento — ${permiso.etiqueta}',
            isDense: true,
            suffixIcon: fecha == null
                ? const Icon(Icons.calendar_today_outlined, size: 18)
                : IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => setState(
                        () => _vencimientos[permiso.campoVencimiento] = null),
                  ),
          ),
          child: Text(
            fecha == null
                ? 'Sin definir'
                : '${fecha.day.toString().padLeft(2, '0')}/'
                    '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}',
          ),
        ),
      ),
    );
  }

  Widget _tarjetaGrupo({
    required IconData icono,
    required String titulo,
    required List<Widget> hijos,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVColors.fondo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NVColors.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: NVColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icono, size: 18, color: NVColors.primaryDark),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(titulo,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: NVColors.primaryDark)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...hijos,
        ],
      ),
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

/// Mini-gráfica de barras del historial de puntajes (un CustomPaint liviano,
/// sin dependencias nuevas — el stack del proyecto no trae librería de
/// charts, ver pubspec). Escala fija 0–100 porque los puntajes de
/// seguimiento de CDMB van en esa escala.
class _GraficaPuntajes extends StatelessWidget {
  final Map<int, double> puntajes;
  const _GraficaPuntajes({required this.puntajes});

  @override
  Widget build(BuildContext context) {
    final anios = puntajes.keys.toList()..sort();
    if (anios.isEmpty) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: NVColors.fondo,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: NVColors.borde),
        ),
        child: const Text('Sin puntajes cargados todavía.',
            style: TextStyle(fontSize: 12, color: NVColors.textoSecundario)),
      );
    }
    return Container(
      height: 150,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: NVColors.borde),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final anio in anios)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (puntajes[anio] ?? 0).toStringAsFixed(1),
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor:
                          ((puntajes[anio] ?? 0) / 100).clamp(0.02, 1.0),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: NVColors.verdeVivo,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('$anio',
                      style: const TextStyle(
                          fontSize: 11, color: NVColors.textoSecundario)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Barra fina al lado de cada campo de año — refuerzo visual de la gráfica
/// de arriba, para leer de un vistazo cuál año subió o bajó.
class _BarraPuntaje extends StatelessWidget {
  final double? valor;
  final double maximo;
  const _BarraPuntaje({required this.valor, required this.maximo});

  @override
  Widget build(BuildContext context) {
    final v = valor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: LinearProgressIndicator(
        value: v == null ? 0 : (v / maximo).clamp(0.0, 1.0),
        minHeight: 8,
        backgroundColor: NVColors.fondo,
        valueColor: const AlwaysStoppedAnimation(NVColors.verdeVivo),
      ),
    );
  }
}
