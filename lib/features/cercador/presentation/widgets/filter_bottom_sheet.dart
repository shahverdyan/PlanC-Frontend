import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import '../providers/filter_provider.dart';
import '../providers/search_provider.dart';
import '../../../../core/providers/location_provider.dart';
import '../../../map/presentation/services/location_service.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  double _radiKm = 10;
  bool? _gratuit;
  String? _dataInici;
  String? _dataFi;
  late int _radiIndex;
  bool _tePermisUbicacio = false;
  bool _activarQualitatAire = false;
  int? _aqiMax = 50; // default "Bona"
  int _aqiLevelIndex = 2; // default: index of 50 (Bona)

  static const List<double> _distanciaValues = [
    1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50,
    60, 70, 80, 90, 100, 125, 150, 175, 200,
  ];

  // null = Qualsevol/Any (no aqiMax param sent)
  static const List<int?> _aqiLevelValues = [
    null, 10, 25, 50, 75, 100, 125, 150, 175, 200,
  ];

  @override
  void initState() {
    super.initState();
    final filtres = ref.read(filterProvider);
    _gratuit = filtres.gratuit;
    _dataInici = filtres.dataInici;
    _dataFi = filtres.dataFi;
    _activarQualitatAire = filtres.activarQualitatAire;
    if (filtres.activarQualitatAire) {
      _aqiMax = filtres.aqiMax;
      final idx = _aqiLevelValues.indexOf(filtres.aqiMax);
      _aqiLevelIndex = idx >= 0 ? idx : 3; // default index of 50
    } else {
      _aqiMax = 50;
      _aqiLevelIndex = 3; // index of 50 in the new array
    }

    final radi = filtres.radiKm ?? 10;
    _radiIndex = _distanciaValues.indexWhere((v) => v >= radi);
    if (_radiIndex < 0) _radiIndex = 2; // default 10km
    _radiKm = _distanciaValues[_radiIndex];
    _comprovarPermisUbicacio();
  }

  Future<void> _comprovarPermisUbicacio() async {
    final locationService = ref.read(locationServiceProvider);
    final tePermis = await locationService.tePermisUbicacio();
    if (mounted) {
      setState(() {
        _tePermisUbicacio = tePermis;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        t.filterTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    TextButton(
                      onPressed: _netejarFiltres,
                      child: Text(
                        t.filterClear,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),

                // Preu (desactivat quan qualitat de l'aire és actiu)
                IgnorePointer(
                  ignoring: _activarQualitatAire,
                  child: Opacity(
                    opacity: _activarQualitatAire ? 0.35 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.filterPriceLabel,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                        if (_activarQualitatAire)
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 4),
                            child: Text(
                              t.filterAirQualityDisabledTooltip,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _FilterChip(
                              label: t.filterPriceAll,
                              selected: _gratuit == null,
                              onTap: () => setState(() => _gratuit = null),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: t.filterPriceFree,
                              selected: _gratuit == true,
                              onTap: () => setState(() => _gratuit = true),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: t.filterPricePaid,
                              selected: _gratuit == false,
                              onTap: () => setState(() => _gratuit = false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Distància (sempre actiu)
                Text(
                  t.filterDistanceLabel(_radiKm.toInt()),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _tePermisUbicacio ? null : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Opacity(
                  opacity: _tePermisUbicacio ? 1.0 : 0.35,
                  child: Slider(
                    value: _radiIndex.toDouble(),
                    min: 0,
                    max: (_distanciaValues.length - 1).toDouble(),
                    divisions: _distanciaValues.length - 1,
                    activeColor: Theme.of(context).colorScheme.primary,
                    label: '${_radiKm.toInt()} km',
                    onChanged: _tePermisUbicacio
                        ? (val) => setState(() {
                              _radiIndex = val.round();
                              _radiKm = _distanciaValues[_radiIndex];
                            })
                        : null,
                  ),
                ),
                if (!_tePermisUbicacio)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.location_off,
                            size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            t.filterLocationPermissionNeeded,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(height: 16),

                // Data (desactivada quan qualitat de l'aire és actiu)
                IgnorePointer(
                  ignoring: _activarQualitatAire,
                  child: Opacity(
                    opacity: _activarQualitatAire ? 0.35 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.filterDateLabel,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                )),
                        if (_activarQualitatAire)
                          Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 4),
                            child: Text(
                              t.filterAirQualityDisabledTooltip,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _FilterChip(
                              label: t.filterDateAll,
                              selected: _dataInici == null && _dataFi == null,
                              onTap: () => setState(() {
                                _dataInici = null;
                                _dataFi = null;
                              }),
                            ),
                            _FilterChip(
                              label: t.filterDateToday,
                              selected: _dataInici == _avui() && _dataFi == _avui(),
                              onTap: () => setState(() {
                                _dataInici = _avui();
                                _dataFi = _avui();
                              }),
                            ),
                            _FilterChip(
                              label: t.filterDateWeekend,
                              selected: _isCapDeSetmanaSelected(),
                              onTap: () {
                                final caps = _capDeSetmana();
                                setState(() {
                                  _dataInici = caps.$1;
                                  _dataFi = caps.$2;
                                });
                              },
                            ),
                            _FilterChip(
                              label: t.filterDateCalendar,
                              selected: _isCustomDateSelected(),
                              onTap: _obrirCalendari,
                            ),
                          ],
                        ),
                        if (_isCustomDateSelected())
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${_formatDateDisplay(_dataInici!)} → ${_formatDateDisplay(_dataFi!)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary.withAlpha((0.7 * 255).toInt()),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Qualitat de l'aire
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.filterAirQualityLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Switch(
                      value: _activarQualitatAire,
                      onChanged: (val) => setState(() {
                        _activarQualitatAire = val;
                      }),
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ],
                ),
                if (_activarQualitatAire) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${t.filterAirQualityLabel}: ${_aqiLevelLabel(t)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Slider(
                    value: _aqiLevelIndex.toDouble(),
                    min: 0,
                    max: (_aqiLevelValues.length - 1).toDouble(),
                    divisions: _aqiLevelValues.length - 1,
                    activeColor: Theme.of(context).colorScheme.primary,
                    label: _aqiSliderLabel(t),
                    onChanged: (val) => setState(() {
                      _aqiLevelIndex = val.round();
                      _aqiMax = _aqiLevelValues[_aqiLevelIndex];
                    }),
                  ),
                  const SizedBox(height: 4),
                ],

                const SizedBox(height: 24),

                // Botó aplicar
                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _aplicarFiltres,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: Text(
                        t.filterApply,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Calendari ----------

  Future<void> _obrirCalendari() async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      currentDate: now,
      initialDateRange: _dataInici != null && _dataFi != null
          ? DateTimeRange(
              start: DateTime.parse(_dataInici!),
              end: DateTime.parse(_dataFi!),
            )
          : null,
      locale: const Locale('ca'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dataInici = _fmtDate(picked.start);
        _dataFi = _fmtDate(picked.end);
      });
    }
  }

  // ---------- Helpers de selecció ----------

  bool _isCapDeSetmanaSelected() {
    final caps = _capDeSetmana();
    return _dataInici == caps.$1 && _dataFi == caps.$2;
  }

  bool _isCustomDateSelected() {
    if (_dataInici == null || _dataFi == null) return false;
    if (_dataInici == _avui() && _dataFi == _avui()) return false;
    if (_isCapDeSetmanaSelected()) return false;
    return true;
  }

  String _formatDateDisplay(String isoDate) {
    final d = DateTime.parse(isoDate);
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  // ---------- Accions ----------

  void _aplicarFiltres() async {
    double? latitud;
    double? longitud;
    double? radiKmAplicat;

    final locationService = ref.read(locationServiceProvider);
    final resultat = await locationService.obtenirUbicacioActual();

    if (resultat.estat == EstatPermisUbicacio.concedit &&
        resultat.position != null) {
      latitud = resultat.position!.latitude;
      longitud = resultat.position!.longitude;
      radiKmAplicat = _radiKm;
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.filterNoLocation),
        ),
      );
    }

    if (_activarQualitatAire) {
      if (latitud == null) return; // ja s'ha mostrat el snackbar d'error
      ref.read(filterProvider.notifier).setActivarQualitatAire(true);
      ref.read(filterProvider.notifier).setAqiMax(_aqiMax);
      ref.read(filterProvider.notifier).setRadiKm(radiKmAplicat);
      ref.read(searchProvider.notifier).aplicarFiltresQualitatAire(
        lat: latitud,
        lng: longitud!,
        radi: _radiKm,
        aqiMax: _aqiMax,
      );
    } else {
      ref.read(filterProvider.notifier).setActivarQualitatAire(false);
      ref.read(filterProvider.notifier).setAqiMax(null);
      ref.read(filterProvider.notifier).setGratuit(_gratuit);
      ref.read(filterProvider.notifier).setRadiKm(radiKmAplicat);
      ref.read(filterProvider.notifier).setDataInici(_dataInici);
      ref.read(filterProvider.notifier).setDataFi(_dataFi);
      ref.read(searchProvider.notifier).netejarResultatsQualitatAire();
      ref.read(searchProvider.notifier).aplicarFiltres(
        gratuit: _gratuit,
        radiKm: radiKmAplicat,
        latitud: latitud,
        longitud: longitud,
        dataInici: _dataInici,
        dataFi: _dataFi,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  void _netejarFiltres() {
    setState(() {
      _gratuit = null;
      _radiKm = 10;
      _dataInici = null;
      _dataFi = null;
      _activarQualitatAire = false;
      _aqiMax = 50;
      _aqiLevelIndex = 3;
    });
    ref.read(filterProvider.notifier).netejar();
    ref.read(searchProvider.notifier).netejarResultatsQualitatAire();
  }

  // Títol sobre el slider: "Qualsevol" o "≤50 · Bona"
  String _aqiLevelLabel(AppLocalizations t) {
    if (_aqiMax == null) return t.filterAirQualityLevelAny;
    return '≤$_aqiMax · ${_aqiLevelName(t)}';
  }

  // Etiqueta compacta per al tooltip del slider: "Qualsevol" o "≤50"
  String _aqiSliderLabel(AppLocalizations t) {
    if (_aqiMax == null) return t.filterAirQualityLevelAny;
    return '≤$_aqiMax';
  }

  String _aqiLevelName(AppLocalizations t) {
    if (_aqiMax == null) return t.filterAirQualityLevelAny;
    if (_aqiMax! <= 50) return t.qualitatAireBona;
    if (_aqiMax! <= 100) return t.qualitatAireModerada;
    if (_aqiMax! <= 150) return t.qualitatAireDolentaGrups;
    if (_aqiMax! <= 200) return t.qualitatAireDolenta;
    return t.qualitatAireMoltDolenta;
  }

  // ---------- Utilitats de dates ----------

  String _avui() => _fmtDate(DateTime.now());

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  (String, String) _capDeSetmana() {
    final now = DateTime.now();
    final daysUntilSaturday = (6 - now.weekday) % 7;
    final saturday = now.add(Duration(days: daysUntilSaturday));
    final sunday = saturday.add(const Duration(days: 1));
    return (_fmtDate(saturday), _fmtDate(sunday));
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
