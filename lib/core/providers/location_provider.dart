import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/map/presentation/services/location_service.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});