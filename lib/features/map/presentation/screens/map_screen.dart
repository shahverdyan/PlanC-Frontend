import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import '../../../activitats/model/activitat.dart';
import '../../../activitats/presentation/provider/activitats_providers.dart';
import '../../../activitats/presentation/screens/activitat_detail_screen.dart';
import '../../../activitats/presentation/widgets/amics_assistents_widget.dart';
import '../../../groups/presentation/screens/activity_groups_screen.dart';
import '../services/location_service.dart';
import '../state/mapa_activitats_state.dart';
import '../utils/categoria_color_helper.dart';
import '../utils/categoria_icon_helper.dart';
import '../utils/categoria_normalizer.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/core/providers/theme_provider.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'edifici_activitats_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const CameraPosition _posicioInicial = CameraPosition(
    target: LatLng(41.3874, 2.1686),
    zoom: 12,
  );

  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  String? _mapStyle;
  Brightness? _lastBrightness;

  Set<Marker> _markers = {};
  // Canvas dimensions shared by every marker generator (logical pts).
  // kMarkerSize is the total canvas height; _kMarkerW the width.
  // The visible circle fills the top 60 % of kMarkerSize and ~86 % of _kMarkerW,
  // leaving 2 pt padding on every side so the circle is never clipped.
  static const double kMarkerSize = 50;   // canvas height (logical pts)
  static const double _kMarkerW   = 33;   // canvas width  (logical pts)

  final Map<String, BitmapDescriptor> _edificiIconCache = {};
  final Map<String, BitmapDescriptor> _categoriaIconCache = {};
  List<Activitat>? _lastActivitatsComputed;

  bool _tePermisUbicacio = false;
  bool _ubicacioInicialJaIntentada = false;

  Future<void> _carregarEstilMapa({ThemeMode? themeMode}) async {
    final mode = themeMode ?? ref.read(themeProvider);
    final brightness = mode == ThemeMode.dark
        ? Brightness.dark
        : mode == ThemeMode.light
            ? Brightness.light
            : MediaQuery.of(context).platformBrightness;
    if (_lastBrightness == brightness && _mapStyle != null) return;
    _lastBrightness = brightness;
    final path = brightness == Brightness.dark
        ? 'assets/map_style_dark.json'
        : 'assets/map_style_light.json';
    _mapStyle = await rootBundle.loadString(path);
    if (mounted) setState(() {});
  }

  Future<void> _intentarUbicacioInicial() async {
    if (_ubicacioInicialJaIntentada) return;
    if (_mapController == null) return;

    _ubicacioInicialJaIntentada = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _demanarICentrarUbicacio();
    });
  }

  Future<void> _demanarICentrarUbicacio() async {
    final resultat = await _locationService.obtenirUbicacioActual();

    if (!mounted) return;

    switch (resultat.estat) {
      case EstatPermisUbicacio.concedit:
        setState(() {
          _tePermisUbicacio = true;
        });

        final pos = resultat.position;
        if (pos == null || _mapController == null) return;

        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(pos.latitude, pos.longitude),
            13,
          ),
        );
        break;

      case EstatPermisUbicacio.denegat:
        setState(() {
          _tePermisUbicacio = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.mapLocationDenied),
          ),
        );
        break;

      case EstatPermisUbicacio.denegatPermanentment:
        setState(() {
          _tePermisUbicacio = false;
        });
        _mostrarDialegConfiguracio();
        break;

      case EstatPermisUbicacio.serveiDesactivat:
        setState(() {
          _tePermisUbicacio = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.mapLocationServiceDisabled),
          ),
        );
        break;
    }
  }

  void _mostrarDialegConfiguracio() {
    final t = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.mapLocationPermissionRequiredTitle),
          content: Text(t.mapLocationPermissionRequiredContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(t.mapLocationDialogNotNow),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _locationService.obrirConfiguracioApp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.primary,
                foregroundColor: Theme.of(dialogContext).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
              child: Text(t.mapLocationDialogOpenSettings),
            ),
          ],
        );
      },
    );
  }

  String _formatData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final any = data.year.toString();
    final hora = data.hour.toString().padLeft(2, '0');
    final minut = data.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$any $hora:$minut';
  }

  // NUEVO: Función para traducir categorías dinámicamente
  String _traducirCategoria(BuildContext context, String categoriaOriginal) {
    final t = AppLocalizations.of(context)!;
    switch (categoriaOriginal.toLowerCase()) {
      case 'exposicions': return t.categoriaExposicions;
      case 'infantil': return t.categoriaInfantil;
      case 'teatre': return t.categoriaTeatre;
      case 'concerts': return t.categoriaConcerts;
      case 'festes': return t.categoriaFestes;
      case 'festivals i mostres': return t.categoriaFestivalsIMostres;
      case 'conferencies':
      case 'conferències': return t.categoriaConferencies;
      case 'rutes i visites': return t.categoriaRutesIVisites;
      case 'altres': return t.categoriaAltres;
      default: return categoriaOriginal;
    }
  }

  void _mostrarPopupActivitat(BuildContext context, Activitat activitat) {
    final t = AppLocalizations.of(context)!;
    final colorCategoria = CategoriaColorHelper.getColor(activitat.categoria);
    
    // Traducimos la categoría que va dentro de la pastilla de color
    final categoriaTraduida = _traducirCategoria(context, activitat.categoria);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: badge de categoria + botó tancar + títol
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      const SizedBox(width: double.infinity),
                      Positioned.fill(
                        child: activitat.imatge != null && activitat.imatge!.isNotEmpty
                            ? Image.network(
                                activitat.imatge!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    Container(color: Theme.of(sheetContext).colorScheme.primary),
                              )
                            : Container(color: Theme.of(sheetContext).colorScheme.primary),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.black.withValues(alpha: 0.65),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorCategoria,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    categoriaTraduida,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => Navigator.of(sheetContext).pop(),
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              activitat.titol,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AmicsAssistentsWidget(activitatId: activitat.id),
                const SizedBox(height: 16),
                // Informació
                _DialogInfoRow(
                  icon: Icons.calendar_today,
                  label: t.mapInfoStart,
                  value: _formatData(activitat.dataInici),
                  color: colorCategoria,
                ),
                const SizedBox(height: 12),
                _DialogInfoRow(
                  icon: Icons.access_time,
                  label: t.mapInfoEnd,
                  value: _formatData(activitat.dataFi),
                  color: colorCategoria,
                ),
                const SizedBox(height: 12),
                _DialogInfoRow(
                  icon: Icons.location_on,
                  label: t.mapInfoSpace,
                  value: activitat.nomEspai,
                  color: colorCategoria,
                ),
                if ((activitat.adreca.isNotEmpty) ||
                    (activitat.localitat.isNotEmpty)) ...[
                  const SizedBox(height: 12),
                  _DialogInfoRow(
                    icon: Icons.home_outlined,
                    label: t.mapInfoAddress,
                    value: [activitat.adreca, activitat.localitat]
                        .where((s) => s.isNotEmpty)
                        .join(', '),
                    color: colorCategoria,
                  ),
                ],
                const SizedBox(height: 24),
                // Botó Detalls (primari, ample complet)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ActivitatDetailScreen(activitat: activitat),
                        ),
                      );
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        _mostrarPopupActivitat(context, activitat);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(sheetContext).colorScheme.primary,
                      foregroundColor: Theme.of(sheetContext).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: AppElevation.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      t.mapDetailsButton,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Botó Quedades (secundari, ample complet)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ActivityGroupsScreen(activitat: activitat),
                        ),
                      );
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        _mostrarPopupActivitat(context, activitat);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(sheetContext).colorScheme.primary,
                      side: BorderSide(
                        color: Theme.of(sheetContext).colorScheme.primary,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: Text(
                      t.mapGroupsButton,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Path _museumSvgPath({required double scale, required double dx, required double dy}) {
    final p = Path();
    double sx(double v) => v * scale + dx;
    double sy(double v) => v * scale + dy;

    // SP1: left column
    p.moveTo(sx(9.27), sy(19)); p.lineTo(sx(13.186), sy(19));
    p.lineTo(sx(13.788), sy(37)); p.lineTo(sx(8.749), sy(37)); p.close();

    // SP2: base platform (stepped)
    p.moveTo(sx(6), sy(38)); p.lineTo(sx(44), sy(38));
    p.lineTo(sx(44), sy(40)); p.lineTo(sx(47), sy(40));
    p.lineTo(sx(47), sy(43)); p.lineTo(sx(49), sy(43));
    p.lineTo(sx(49), sy(45)); p.lineTo(sx(1), sy(45));
    p.lineTo(sx(1), sy(43)); p.lineTo(sx(3), sy(43));
    p.lineTo(sx(3), sy(40)); p.lineTo(sx(6), sy(40)); p.close();

    // SP3: pediment
    p.moveTo(sx(46), sy(13.812)); p.lineTo(sx(25), sy(5));
    p.lineTo(sx(4), sy(13.812)); p.lineTo(sx(4), sy(15));
    p.lineTo(sx(46), sy(15)); p.close();

    // SP4: entablature
    p.moveTo(sx(8), sy(16)); p.lineTo(sx(42), sy(16));
    p.lineTo(sx(42), sy(18)); p.lineTo(sx(8), sy(18)); p.close();

    // SP5: right column
    p.moveTo(sx(36.736), sy(19)); p.lineTo(sx(40.65), sy(19));
    p.lineTo(sx(41.257), sy(37)); p.lineTo(sx(36.211), sy(37)); p.close();

    // SP6: middle-right column
    p.moveTo(sx(27.584), sy(19)); p.lineTo(sx(31.498), sy(19));
    p.lineTo(sx(32.098), sy(37)); p.lineTo(sx(27.057), sy(37)); p.close();

    // SP7: middle-left column
    p.moveTo(sx(18.43), sy(19)); p.lineTo(sx(22.345), sy(19));
    p.lineTo(sx(22.941), sy(37)); p.lineTo(sx(17.902), sy(37)); p.close();

    return p;
  }

  Future<BitmapDescriptor> _generarMarkerEdifici(int count, {Color? categoriaColor}) async {
    final double dpr =
        ui.PlatformDispatcher.instance.displays.first.devicePixelRatio;

    final double w = _kMarkerW   * dpr;
    final double h = kMarkerSize * dpr;

    // All coords in physical pixels (logical × dpr).
    // r=14 → diameter 28 pt = 85 % of _kMarkerW=33
    // cy=16 → top padding 2 pt (cy−r=2); circle bottom 30 pt = 60 % of 50
    // tipY=48 → bottom padding 2 pt; tail 18 pt ≈ 36 % ≈ 40 %
    final double cx   = (_kMarkerW / 2) * dpr;   // 16.5·dpr
    final double cy   = 16 * dpr;
    final double r    = 14 * dpr;
    final double rInn = 11 * dpr;                 // inner white circle (3 pt gap)
    final double tipY = 48 * dpr;

    // Badge (top-right, ~45° on circle boundary)
    final double badgeR        = 5 * dpr;
    final Offset badgeCenter   = Offset(26 * dpr, 6 * dpr);

    final recorder = ui.PictureRecorder();
    final canvas   = Canvas(recorder);

    // ── Silhouette path ──────────────────────────────────────────────────────
    // Built with cubicTo so the tail-to-circle junction is C¹ smooth:
    //   • CP2 of each cubic is directly above/below the arc endpoint (same x),
    //     matching the arc's vertical tangent at the equator.
    //   • This eliminates the "deformed" kink seen with quadraticBezierTo.
    final silhouette = Path()
      ..moveTo(cx, tipY)
      // right tail → right side of circle (arrives from below, vertically)
      ..cubicTo(
        cx + r * 0.10, tipY - r * 0.05,   // CP1 – tiny rightward spread at tip
        cx + r,        cy + r * 0.40,       // CP2 – same x as endpoint → vertical arrival
        cx + r,        cy,
      )
      // top arc, counterclockwise (over the top)
      ..arcToPoint(Offset(cx - r, cy),
          radius: Radius.circular(r), clockwise: false)
      // left side of circle → tip (departs downward, vertically)
      ..cubicTo(
        cx - r,        cy + r * 0.40,       // CP1 – same x as start → vertical departure
        cx - r * 0.10, tipY - r * 0.05,    // CP2 – tiny leftward spread near tip
        cx,            tipY,
      );
    silhouette.close();

    // Draw black border first (stroke bleeds equally in/out); fill on top
    // covers the inside bleed → net visible outer border = strokeWidth / 2.
    canvas.drawPath(
      silhouette,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * dpr
        ..strokeJoin = StrokeJoin.round
        ..strokeCap  = StrokeCap.round,
    );
    final Color fillColor = categoriaColor ?? AppColors.neutral800;
    canvas.drawPath(silhouette, Paint()..color = fillColor);

    // White inner circle + thin black border
    canvas.drawCircle(Offset(cx, cy), rInn, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(cx, cy),
      rInn,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * dpr,
    );

    // Museum icon centred at (cx, cy). SVG spans 0–50, centre at (25, 25).
    final double iconScale = 0.30 * dpr;
    canvas.drawPath(
      _museumSvgPath(
        scale: iconScale,
        dx: cx - 25 * iconScale,
        dy: cy - 25 * iconScale,
      ),
      Paint()..color = fillColor,
    );

    // Orange activity-count badge
    canvas.drawCircle(
        badgeCenter, badgeR, Paint()..color = AppColors.orange500);
    canvas.drawCircle(
      badgeCenter,
      badgeR,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * dpr,
    );

    final double fontSize = 5.5 * dpr;
    final pb = ui.ParagraphBuilder(
        ui.ParagraphStyle(textAlign: TextAlign.center, fontSize: fontSize))
      ..pushStyle(ui.TextStyle(
        color: const ui.Color(0xFFFFFFFF),
        fontWeight: ui.FontWeight.bold,
        fontSize: fontSize,
      ))
      ..addText(count.toString());
    final paragraph = pb.build()
      ..layout(ui.ParagraphConstraints(width: badgeR * 2));
    canvas.drawParagraph(
      paragraph,
      Offset(badgeCenter.dx - badgeR, badgeCenter.dy - paragraph.height / 2),
    );

    final picture = recorder.endRecording();
    final img     = await picture.toImage(w.toInt(), h.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
    return BitmapDescriptor.bytes(
      byteData.buffer.asUint8List(),
      width: _kMarkerW,
      height: kMarkerSize,
    );
  }

  Future<BitmapDescriptor> _getEdificiDescriptor(int count, {Color? categoriaColor}) async {
    final key = '${count}_${categoriaColor?.toARGB32() ?? 'gray'}';
    if (_edificiIconCache.containsKey(key)) return _edificiIconCache[key]!;
    final descriptor = await _generarMarkerEdifici(count, categoriaColor: categoriaColor);
    _edificiIconCache[key] = descriptor;
    return descriptor;
  }

  Future<BitmapDescriptor> _generarMarkerCategoria(
    String categoria,
    double dpr,
  ) async {
    // Same canvas and geometry as _generarMarkerEdifici (kMarkerSize × _kMarkerW).
    final double w = _kMarkerW   * dpr;
    final double h = kMarkerSize * dpr;

    final double cx   = (_kMarkerW / 2) * dpr;
    final double cy   = 16 * dpr;
    final double r    = 14 * dpr;
    final double rInn = 11 * dpr;
    final double tipY = 48 * dpr;

    final Color    catColor = CategoriaColorHelper.getColor(categoria);
    final IconData iconData = CategoriaIconHelper.getIcon(categoria);

    final recorder = ui.PictureRecorder();
    final canvas   = Canvas(recorder);

    // Identical C¹-smooth silhouette (cubicTo, same control-point logic).
    final silhouette = Path()
      ..moveTo(cx, tipY)
      ..cubicTo(
        cx + r * 0.10, tipY - r * 0.05,
        cx + r,        cy + r * 0.40,
        cx + r,        cy,
      )
      ..arcToPoint(Offset(cx - r, cy),
          radius: Radius.circular(r), clockwise: false)
      ..cubicTo(
        cx - r,        cy + r * 0.40,
        cx - r * 0.10, tipY - r * 0.05,
        cx,            tipY,
      );
    silhouette.close();

    // Black outer border (stroke first, fill on top covers inside bleed).
    canvas.drawPath(
      silhouette,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * dpr
        ..strokeJoin = StrokeJoin.round
        ..strokeCap  = StrokeCap.round,
    );
    canvas.drawPath(silhouette, Paint()..color = catColor);

    // White inner circle + thin black border.
    canvas.drawCircle(Offset(cx, cy), rInn, Paint()..color = Colors.white);
    canvas.drawCircle(
      Offset(cx, cy),
      rInn,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * dpr,
    );

    // Category icon centred inside the white circle (≈ 65 % of inner diameter).
    final double iconSize = rInn * 1.3;
    final iconPb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontFamily: iconData.fontFamily,
      fontSize: iconSize,
    ))
      ..pushStyle(ui.TextStyle(
        color: catColor,
        fontSize: iconSize,
        fontFamily: iconData.fontFamily,
      ))
      ..addText(String.fromCharCode(iconData.codePoint));
    final iconPara = iconPb.build()
      ..layout(ui.ParagraphConstraints(width: iconSize * 2));
    canvas.drawParagraph(
      iconPara,
      Offset(cx - iconSize, cy - iconPara.height / 2),
    );

    final picture  = recorder.endRecording();
    final img      = await picture.toImage(w.toInt(), h.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      return BitmapDescriptor.defaultMarkerWithHue(
          CategoriaColorHelper.getHue(categoria));
    }
    return BitmapDescriptor.bytes(
      byteData.buffer.asUint8List(),
      width: _kMarkerW,
      height: kMarkerSize,
    );
  }

  Future<BitmapDescriptor> _getCategoriaDescriptor(
    String categoria,
    double dpr,
  ) async {
    if (_categoriaIconCache.containsKey(categoria)) {
      return _categoriaIconCache[categoria]!;
    }
    final descriptor = await _generarMarkerCategoria(categoria, dpr);
    _categoriaIconCache[categoria] = descriptor;
    return descriptor;
  }

  // ─────────────────────────────────────────────────────────────────────────

  static double _distanciaMetres(
      double lat1, double lng1, double lat2, double lng2) {
    const double R = 6371000;
    final phi1 = lat1 * math.pi / 180;
    final phi2 = lat2 * math.pi / 180;
    final dphi = (lat2 - lat1) * math.pi / 180;
    final dl   = (lng2 - lng1) * math.pi / 180;
    final a = math.sin(dphi / 2) * math.sin(dphi / 2) +
        math.cos(phi1) * math.cos(phi2) *
            math.sin(dl / 2) * math.sin(dl / 2);
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  static Map<String, List<Activitat>> _fusionarPerProximitat(
      Map<String, List<Activitat>> grups) {
    final result = Map<String, List<Activitat>>.from(grups);
    bool anyMerge = true;
    while (anyMerge) {
      anyMerge = false;
      final keys = result.keys.toList();
      outerLoop:
      for (var i = 0; i < keys.length; i++) {
        for (var j = i + 1; j < keys.length; j++) {
          final nomA = keys[i];
          final nomB = keys[j];
          if (!result.containsKey(nomA) || !result.containsKey(nomB)) continue;

          final activsA = result[nomA]!;
          final activsB = result[nomB]!;

          final centreLatA = activsA.map((a) => a.lat).reduce((x, y) => x + y) / activsA.length;
          final centreLngA = activsA.map((a) => a.lng).reduce((x, y) => x + y) / activsA.length;
          final centreLatB = activsB.map((a) => a.lat).reduce((x, y) => x + y) / activsB.length;
          final centreLngB = activsB.map((a) => a.lng).reduce((x, y) => x + y) / activsB.length;

          if (_distanciaMetres(centreLatA, centreLngA, centreLatB, centreLngB) >= 50) continue;

          final String nomFinal;
          if (activsA.length > activsB.length) {
            nomFinal = nomA;
          } else if (activsB.length > activsA.length) {
            nomFinal = nomB;
          } else {
            nomFinal = nomA.length <= nomB.length ? nomA : nomB;
          }

          result[nomFinal] = [...activsA, ...activsB];
          if (nomFinal != nomA) result.remove(nomA);
          if (nomFinal != nomB) result.remove(nomB);
          anyMerge = true;
          break outerLoop;
        }
      }
    }
    return result;
  }

  Future<void> _computarMarkers(List<Activitat> activitats) async {
    final Map<String, List<Activitat>> grupsExactes = {};
    for (final a in activitats) {
      final clau = a.nomEspai.trim().toLowerCase();
      grupsExactes.putIfAbsent(clau, () => []).add(a);
    }
    final Map<String, List<Activitat>> grupsPorEspai =
        _fusionarPerProximitat(grupsExactes);

    final Map<String, int> comptadorPerCoordenada = {};
    final Set<Marker> nousMakers = {};
    final double dpr =
        ui.PlatformDispatcher.instance.displays.first.devicePixelRatio;

    for (final entry in grupsPorEspai.entries) {
      final grupActivitats = entry.value;

      if (grupActivitats.length >= 2) {
        final nomEspai = grupActivitats.first.nomEspai.trim();
        final activitatsEdifici = List<Activitat>.from(grupActivitats);
        final first = activitatsEdifici.first;
        final categoriesEdifici = activitatsEdifici.map((a) => a.categoria).toSet();
        final Color? colorEdifici = categoriesEdifici.length == 1
            ? CategoriaColorHelper.getColor(categoriesEdifici.first)
            : null;
        try {
          final icon = await _getEdificiDescriptor(
            activitatsEdifici.length,
            categoriaColor: colorEdifici,
          );
          if (!mounted) return;
          nousMakers.add(Marker(
            markerId: MarkerId('edifici_$nomEspai'),
            position: LatLng(first.lat, first.lng),
            icon: icon,
            onTap: () {
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => EdificiActivitatsScreen(
                    nomEspai: nomEspai,
                    adreca: first.adreca,
                    localitat: first.localitat,
                    activitats: activitatsEdifici,
                  ),
                ),
              );
            },
          ));
        } catch (e) {
          debugPrint('❌ Error creant marker edifici "$nomEspai": $e');
        }
      } else {
        final activitat = grupActivitats.first;
        final key = '${activitat.lat},${activitat.lng}';
        final index = comptadorPerCoordenada[key] ?? 0;
        comptadorPerCoordenada[key] = index + 1;

        double lat = activitat.lat;
        double lng = activitat.lng;
        if (index > 0) {
          const double offsetBase = 0.0003;
          final double angle = index * 0.8;
          lat += offsetBase * index * math.cos(angle);
          lng += offsetBase * index * math.sin(angle);
        }

        try {
          final icon =
              await _getCategoriaDescriptor(activitat.categoria, dpr);
          if (!mounted) return;
          nousMakers.add(Marker(
            markerId: MarkerId(activitat.id),
            position: LatLng(lat, lng),
            icon: icon,
            onTap: () => _mostrarPopupActivitat(context, activitat),
          ));
        } catch (e) {
          debugPrint(
            '❌ Error creant marker categoria "${activitat.categoria}": $e',
          );
          if (!mounted) return;
          nousMakers.add(Marker(
            markerId: MarkerId(activitat.id),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              CategoriaColorHelper.getHue(activitat.categoria),
            ),
            onTap: () => _mostrarPopupActivitat(context, activitat),
          ));
        }
      }
    }

    if (mounted) setState(() => _markers = nousMakers);
  }

  Widget _buildFiltres(
      BuildContext context,
      WidgetRef ref,
      MapaActivitatsState mapaState,
      ) {
    final tAll = AppLocalizations.of(context)!.mapCategoryAll;
    final opcions = [
      tAll,
      ...CategoriaNormalizer.categoriesValides,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: opcions.map((categoria) {
          final esTotes = categoria == tAll;
          final seleccionada = esTotes
              ? mapaState.categoriesSeleccionades.isEmpty
              : mapaState.categoriesSeleccionades.contains(categoria);

          final color = esTotes
              ? AppColors.catTotes
              : CategoriaColorHelper.getColor(categoria);
              
          // Traducimos SOLO lo que se va a mostrar en el texto del Chip
          final textAMostrar = esTotes ? categoria : _traducirCategoria(context, categoria);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    esTotes
                        ? Icons.apps_outlined
                        : CategoriaIconHelper.getIcon(categoria),
                    size: 18,
                    color: seleccionada ? AppColors.neutral0 : color,
                  ),
                  const SizedBox(width: 6),
                  Text(textAMostrar),
                ],
              ),
              selected: seleccionada,
              labelStyle: TextStyle(
                color: seleccionada ? AppColors.neutral0 : color,
                fontWeight: FontWeight.w600,
              ),
              selectedColor: color,
              backgroundColor: color.withAlpha(26),
              onSelected: (_) {
                if (esTotes) {
                  ref
                      .read(mapaActivitatsProvider.notifier)
                      .mostrarTotesLesCategories();
                } else {
                  // Mantenemos la lógica de Riverpod intacta usando la categoría original
                  ref
                      .read(mapaActivitatsProvider.notifier)
                      .toggleCategoria(categoria);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final brightness = themeMode == ThemeMode.dark
        ? Brightness.dark
        : themeMode == ThemeMode.light
            ? Brightness.light
            : MediaQuery.of(context).platformBrightness;
    if (_lastBrightness != null && _lastBrightness != brightness) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _carregarEstilMapa(themeMode: themeMode);
      });
    }

    final mapaActivitatsAsync = ref.watch(mapaActivitatsProvider);

    return Scaffold(
      body: mapaActivitatsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (mapaState) {
          final activitatsActuals = mapaState.activitatsVisibles;
          if (_lastActivitatsComputed != activitatsActuals) {
            _lastActivitatsComputed = activitatsActuals;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _computarMarkers(activitatsActuals);
            });
          }
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: _posicioInicial,
                onMapCreated: (controller) async {
                  _mapController = controller;
                  await _carregarEstilMapa();
                  await _intentarUbicacioInicial();
                },
                style: _mapStyle,
                myLocationButtonEnabled: false,
                myLocationEnabled: _tePermisUbicacio,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: _markers,
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLow.withAlpha(242),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildFiltres(context, ref, mapaState),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 16,
                child: SafeArea(
                  child: FloatingActionButton(
                    heroTag: 'btn_my_location',
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: _demanarICentrarUbicacio,
                    elevation: AppElevation.medium,
                    child: const Icon(Icons.my_location, size: 28),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DialogInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DialogInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}