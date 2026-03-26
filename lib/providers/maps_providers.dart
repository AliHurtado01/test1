import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/maps_config.dart';
import '../data/helpers/cluster_icon.dart';
import '../data/helpers/marker_icon_resolver.dart';
import '../data/helpers/maps_marker_mapper.dart';
import '../data/services/maps_marker_service.dart';
import '../ui/maps/maps_state.dart';
import '../ui/maps/maps_viewmodel.dart';
import 'core_providers.dart';

final mapViewConfigProvider = Provider<MapViewConfig>((ref) {
  return MapViewConfig.defaultConfig;
});

final mapFetchConfigProvider = Provider<MapFetchConfig>((ref) {
  return MapFetchConfig.defaultConfig;
});

final mapMarkerServiceProvider = Provider<MapsMarkerService>((ref) {
  final dio = ref.watch(dioProvider);
  final fetchConfig = ref.watch(mapFetchConfigProvider);

  return MapsMarkerService(dio: dio, apiBaseUrl: fetchConfig.apiBaseUrl);
});

final markerMapperProvider = Provider<MapsMarkerMapper>((ref) {
  return MapsMarkerMapper();
});

final clusterIconProvider = Provider<ClusterIcon>((ref) {
  return ClusterIcon();
});

final iconResolverProvider = Provider<MarkerIconResolver>((ref) {
  final clusterIcon = ref.watch(clusterIconProvider);
  return MarkerIconResolver(clusterPainter: clusterIcon);
});

final mapVisibilityProvider = NotifierProvider<MapVisibilityNotifier, bool>(() {
  return MapVisibilityNotifier();
});

final mapViewModelProvider = NotifierProvider<MapViewModel, MapsState>(() {
  return MapViewModel();
});

class MapVisibilityNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setVisible(bool visible) => state = visible;
}
