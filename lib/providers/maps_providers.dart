import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/maps_config.dart';
import '../data/helpers/cluster_icon.dart';
import '../data/helpers/marker_icon_resolver.dart';
import '../data/helpers/maps_marker_mapper.dart';
import '../data/services/maps_marker_service.dart';
import '../ui/maps/maps_state.dart';
import '../ui/maps/maps_viewmodel.dart';
import 'core_providers.dart';
import '../models/domain/category_marker.dart';

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

class CategoryFilterNotifier extends Notifier<Set<CategoryMarker>> {
  @override
  Set<CategoryMarker> build() {
    // Por defecto, todas las categorías (excepto cluster) están activas
    return {
      CategoryMarker.restaurant,
      CategoryMarker.hotel,
      CategoryMarker.store,
    };
  }

  void toggleCategory(CategoryMarker category) {
    // Si ya está, la quitamos; si no está, la añadimos.
    // En Riverpod, para modificar colecciones debemos crear una nueva instancia.
    if (state.contains(category)) {
      state = {...state}..remove(category);
    } else {
      state = {...state}..add(category);
    }
  }
}

//Provider que expone el estado del filtro de categorías para los marcadores en el mapa. 
//Permite activar o desactivar categorías específicas (restaurantes, hoteles, tiendas) 
//y se puede usar para filtrar qué marcadores se muestran en el mapa según la selección del usuario.
final categoryFilterProvider =
    NotifierProvider<CategoryFilterNotifier, Set<CategoryMarker>>(() {
  return CategoryFilterNotifier();
});