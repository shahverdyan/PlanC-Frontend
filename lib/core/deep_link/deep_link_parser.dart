/// Resultado del análisis de una ruta entrante por deep link.
class DeepLinkRoute {
  const DeepLinkRoute.activitat(this.activitatId) : isActivitat = true;
  const DeepLinkRoute.unknown()
      : activitatId = null,
        isActivitat = false;

  final bool isActivitat;
  final String? activitatId;
}

/// Analiza el `settings.name` que entrega `onGenerateRoute` cuando el motor
/// de Flutter recibe un intent VIEW. Para `planc://activitats/<id>` el motor
/// entrega `/activitats/<id>`.
///
/// También acepta URIs completas (`planc://activitats/<id>`,
/// `https://.../activitats/<id>`) por robustez.
DeepLinkRoute parseDeepLink(String? rawRoute) {
  if (rawRoute == null || rawRoute.isEmpty) {
    return const DeepLinkRoute.unknown();
  }

  final uri = Uri.tryParse(rawRoute);
  if (uri == null) return const DeepLinkRoute.unknown();

  // segmentos no vacíos: ej. ["activitats", "123"]
  final segments =
      uri.pathSegments.where((s) => s.isNotEmpty).toList(growable: false);

  // Para custom-scheme `planc://activitats/123`, el host es "activitats"
  // y los segmentos son ["123"]. Lo normalizamos a ["activitats", "123"].
  final normalized = <String>[
    if (uri.host.isNotEmpty) uri.host,
    ...segments,
  ];

  if (normalized.length >= 2 && normalized[0] == 'activitats') {
    final id = normalized[1].trim();
    if (id.isEmpty) return const DeepLinkRoute.unknown();
    return DeepLinkRoute.activitat(id);
  }

  return const DeepLinkRoute.unknown();
}
