import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsState {
  final CameraPosition initialCamera;
  final Set<Marker> markers;
  final bool isLoading;
  final LatLngBounds? lastRequestedBounds;
  final int? lastRequestedZoom;
  final LatLng? userLocation;

  const MapsState({
    required this.initialCamera,
    this.markers = const {},
    this.isLoading = false,
    this.lastRequestedBounds,
    this.lastRequestedZoom,
    this.userLocation,
  });

  MapsState copyWith({
    CameraPosition? initialCamera,
    Set<Marker>? markers,
    bool? isLoading,
    LatLngBounds? lastRequestedBounds,
    int? lastRequestedZoom,
    LatLng? userLocation,
  }) {
    return MapsState(
      initialCamera: initialCamera ?? this.initialCamera,
      markers: markers ?? this.markers,
      isLoading: isLoading ?? this.isLoading,
      lastRequestedBounds: lastRequestedBounds ?? this.lastRequestedBounds,
      lastRequestedZoom: lastRequestedZoom ?? this.lastRequestedZoom,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}
