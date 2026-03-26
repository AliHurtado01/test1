class MapsMarkersRequestDto {
  final double southwestLat;
  final double southwestLng;
  final double northeastLat;
  final double northeastLng;
  final int zoom;

  MapsMarkersRequestDto({
    required this.southwestLat,
    required this.southwestLng,
    required this.northeastLat,
    required this.northeastLng,
    required this.zoom,
  });

  Map<String, dynamic> toJson() => {
    'southwestLat': southwestLat,
    'northeastLat': northeastLat,
    'southwestLng': southwestLng,
    'northeastLng': northeastLng,
    'zoom': zoom,
  };
}
