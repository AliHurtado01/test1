import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsState {
  final CameraPosition initialCamera;
  final Set<Marker> markers;
  final bool isLoading;
  final LatLngBounds? lastRequestedBounds;
  final int? lastRequestedZoom;
  final LatLng? userLocation;
  final String? error; //Añadimos el campo de error

  const MapsState({
    required this.initialCamera,
    this.markers = const {},
    this.isLoading = false,
    this.lastRequestedBounds,
    this.lastRequestedZoom,
    this.userLocation,
    this.error, //Por defecto será null
  });

  MapsState copyWith({
    CameraPosition? initialCamera,
    Set<Marker>? markers,
    bool? isLoading,
    LatLngBounds? lastRequestedBounds,
    int? lastRequestedZoom,
    LatLng? userLocation,
    String? error,
    bool clearError = false, //Flag para forzar la limpieza del error a null
  }) {
    return MapsState(
      initialCamera: initialCamera ?? this.initialCamera,
      markers: markers ?? this.markers,
      isLoading: isLoading ?? this.isLoading,
      lastRequestedBounds: lastRequestedBounds ?? this.lastRequestedBounds,
      lastRequestedZoom: lastRequestedZoom ?? this.lastRequestedZoom,
      userLocation: userLocation ?? this.userLocation,
      // Si clearError es true, ponemos null. Si no, tomamos el nuevo error o mantenemos el viejo.
      error: clearError ? null : (error ?? this.error), 
    );
  }
}