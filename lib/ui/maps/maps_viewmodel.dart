import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/maps_config.dart';
import '../../data/helpers/marker_icon_resolver.dart';
import '../../data/helpers/maps_marker_mapper.dart';
import '../../data/services/location_service.dart';
import '../../data/services/maps_marker_service.dart';
import '../../models/dto/maps_markers_request_dto.dart';
import '../../providers/core_providers.dart';
import '../../providers/maps_providers.dart';
import '../../utils/debouncer.dart';
import 'maps_state.dart';
import '../../models/domain/marker.dart' as domain;

class MapViewModel extends Notifier<MapsState> {
  late final MapsMarkerService _service;
  late final MapsMarkerMapper _mapper;
  late final MarkerIconResolver _iconResolver;
  late final Debouncer _debouncer;
  late final MapViewConfig _viewConfig;
  late final MapFetchConfig _fetchConfig;
  late final LocationService _locationService;

  int _requestId = 0;

  @override
  MapsState build() {
    _service = ref.read(mapMarkerServiceProvider);
    _mapper = ref.read(markerMapperProvider);
    _iconResolver = ref.read(iconResolverProvider);
    _viewConfig = ref.read(mapViewConfigProvider);
    _fetchConfig = ref.read(mapFetchConfigProvider);
    _locationService = ref.read(locationServiceProvider);
    _debouncer = Debouncer(
      delay: Duration(milliseconds: _fetchConfig.debounceDelayMs),
    );

    ref.onDispose(() => _debouncer.dispose());

    _iconResolver.init();
    _getUserLocation();

    return MapsState(
      initialCamera: CameraPosition(
        target: _viewConfig.defaultLocation,
        zoom: _viewConfig.defaultZoom,
      ),
    );
  }

  Future<void> _getUserLocation() async {
    final location = await getUserLocation();
    if (location != null) {
      state = state.copyWith(userLocation: location);
    }
  }

  Future<void> handleCameraIdle(LatLngBounds bounds, double zoom) async {
    final position = CameraPosition(
      target: LatLng(
        (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
        (bounds.southwest.longitude + bounds.northeast.longitude) / 2,
      ),
      zoom: zoom,
    );

    _debouncer(() => _handleCameraIdle(position, bounds));
  }

  Future<void> _handleCameraIdle(
    CameraPosition position,
    LatLngBounds bounds,
  ) async {
    final isVisible = ref.read(mapVisibilityProvider);
    if (!isVisible) return;

    final currentZoomLogical = _logicalZoom(position.zoom);

    if (!_shouldFetch(bounds, currentZoomLogical)) return;

    // Increment request ID to invalidate any ongoing fetches
    final currentRequestId = ++_requestId;
    state = state.copyWith(isLoading: true, clearError:true); 

    final expandedBounds = _expandBounds(bounds, _fetchConfig.bufferMultiplier);

    final sw = expandedBounds.southwest;
    final ne = expandedBounds.northeast;
    final request = MapsMarkersRequestDto(
      southwestLat: sw.latitude,
      southwestLng: sw.longitude,
      northeastLat: ne.latitude,
      northeastLng: ne.longitude,
      zoom: currentZoomLogical,
    );

try {
      final response = await _service.fetchMarkers(request);

      if (currentRequestId != _requestId) return;

      final domainMarkers = _mapper.fromDtoToMarkers(response);
      final markers = await _toGoogleMarkers(domainMarkers);

      state = state.copyWith(
        markers: markers,
        isLoading: false,
        lastRequestedBounds: expandedBounds,
        lastRequestedZoom: currentZoomLogical,
        clearError: true,
      );
    } catch (e) {
      if (currentRequestId == _requestId) {
        state = state.copyWith(
          isLoading: false,
          error: 'No se pudieron cargar los marcadores. Revisa tu conexión.',
        );
      }
    }
  }

  bool _shouldFetch(LatLngBounds newBounds, int newZoomLogical) {
    final lastBounds = state.lastRequestedBounds;
    final lastZoom = state.lastRequestedZoom;

    if (lastBounds == null || lastZoom == null) return true;
    if ((newZoomLogical - lastZoom).abs() >=
        _fetchConfig.minZoomChangeForFetch) {
      return true;
    }

    return !_boundsContains(lastBounds, newBounds);
  }

  bool _boundsContains(LatLngBounds container, LatLngBounds contained) {
    return container.contains(contained.southwest) &&
        container.contains(contained.northeast);
  }

  // Allows loading markers beyond the visible bounds to improve user experience when moving the map
  LatLngBounds _expandBounds(LatLngBounds bounds, double multiplier) {
    assert(multiplier >= 1);

    final originalSouthWest = bounds.southwest;
    final originalNorthEast = bounds.northeast;

    final visibleLatitudeHeight =
        originalNorthEast.latitude - originalSouthWest.latitude;
    final visibleLongitudeWidth =
        originalNorthEast.longitude - originalSouthWest.longitude;

    final mapCenterLatitude =
        (originalSouthWest.latitude + originalNorthEast.latitude) / 2;
    final mapCenterLongitude =
        (originalSouthWest.longitude + originalNorthEast.longitude) / 2;

    final expandedHalfLatitude = (visibleLatitudeHeight * multiplier) / 2;
    final expandedHalfLongitude = (visibleLongitudeWidth * multiplier) / 2;

    // clamp(-90.0, 90.0) ensures latitude never exceeds the poles
    return LatLngBounds(
      southwest: LatLng(
        (mapCenterLatitude - expandedHalfLatitude).clamp(-90.0, 90.0),
        mapCenterLongitude - expandedHalfLongitude,
      ),
      northeast: LatLng(
        (mapCenterLatitude + expandedHalfLatitude).clamp(-90.0, 90.0),
        mapCenterLongitude + expandedHalfLongitude,
      ),
    );
  }

  int _logicalZoom(double zoom) {
    final step = _fetchConfig.zoomStep;
    return (zoom / step).floor();
  }

  Future<LatLng?> getUserLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }

  Future<Set<Marker>> _toGoogleMarkers(List<domain.Marker> models) async {
    final markerFutures = models.map((model) async {
      final icon = _iconResolver.resolve(model.category, model.count);
      return Marker(
        markerId: MarkerId(model.id),
        position: model.position,
        icon: await icon,
      );
    });
    return Future.wait(markerFutures).then((markers) => markers.toSet());
  }
}
