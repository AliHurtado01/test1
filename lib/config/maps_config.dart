import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewConfig {
  final LatLng defaultLocation;
  final double defaultZoom;

  const MapViewConfig({
    this.defaultLocation = const LatLng(48.8566, 2.3522),
    this.defaultZoom = 14.0,
  });

  static const defaultConfig = MapViewConfig();

  MapViewConfig copyWith({LatLng? defaultLocation, double? defaultZoom}) {
    return MapViewConfig(
      defaultLocation: defaultLocation ?? this.defaultLocation,
      defaultZoom: defaultZoom ?? this.defaultZoom,
    );
  }
}

class MapFetchConfig {
  final double bufferMultiplier;
  final int debounceDelayMs;
  final double minZoomChangeForFetch;
  final double zoomStep;
  final String apiBaseUrl;

  const MapFetchConfig({
    this.bufferMultiplier = 1.5,
    this.debounceDelayMs = 300,
    this.minZoomChangeForFetch = 1.0,
    this.zoomStep = 1.0,
    this.apiBaseUrl = 'https://api.example.com',
  }) : assert(bufferMultiplier >= 1.0),
       assert(debounceDelayMs > 0),
       assert(minZoomChangeForFetch >= 0),
       assert(zoomStep > 0);

  static const defaultConfig = MapFetchConfig();

  MapFetchConfig copyWith({
    double? bufferMultiplier,
    int? debounceDelayMs,
    double? minZoomChangeForFetch,
    double? zoomStep,
    String? apiBaseUrl,
  }) {
    return MapFetchConfig(
      bufferMultiplier: bufferMultiplier ?? this.bufferMultiplier,
      debounceDelayMs: debounceDelayMs ?? this.debounceDelayMs,
      minZoomChangeForFetch:
          minZoomChangeForFetch ?? this.minZoomChangeForFetch,
      zoomStep: zoomStep ?? this.zoomStep,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
    );
  }
}
