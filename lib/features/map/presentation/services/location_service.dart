import 'package:geolocator/geolocator.dart';

enum EstatPermisUbicacio {
  concedit,
  denegat,
  denegatPermanentment,
  serveiDesactivat,
}

class ResultatUbicacio {
  final Position? position;
  final EstatPermisUbicacio estat;

  const ResultatUbicacio({
    this.position,
    required this.estat,
  });
}

class LocationService {
  Future<ResultatUbicacio> obtenirUbicacioActual() async {
    final serveiActivat = await Geolocator.isLocationServiceEnabled();

    if (!serveiActivat) {
      return const ResultatUbicacio(
        estat: EstatPermisUbicacio.serveiDesactivat,
      );
    }

    LocationPermission permis = await Geolocator.checkPermission();

    if (permis == LocationPermission.denied) {
      permis = await Geolocator.requestPermission();
    }

    if (permis == LocationPermission.denied) {
      return const ResultatUbicacio(
        estat: EstatPermisUbicacio.denegat,
      );
    }

    if (permis == LocationPermission.deniedForever) {
      return const ResultatUbicacio(
        estat: EstatPermisUbicacio.denegatPermanentment,
      );
    }

    final position = await Geolocator.getCurrentPosition();

    return ResultatUbicacio(
      estat: EstatPermisUbicacio.concedit,
      position: position,
    );
  }

  Future<bool> tePermisUbicacio() async {
    final serveiActivat = await Geolocator.isLocationServiceEnabled();
    if (!serveiActivat) return false;
    final permis = await Geolocator.checkPermission();
    return permis == LocationPermission.always ||
        permis == LocationPermission.whileInUse;
  }

  Future<bool> obrirConfiguracioApp() {
    return Geolocator.openAppSettings();
  }

  Future<bool> obrirConfiguracioUbicacio() {
    return Geolocator.openLocationSettings();
  }
}