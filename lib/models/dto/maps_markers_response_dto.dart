class MapsMarkersResponseDto {
  final List<MarkerItemDto> data;

  MapsMarkersResponseDto({required this.data});

  factory MapsMarkersResponseDto.fromJson(Map<String, dynamic> json) {
    return MapsMarkersResponseDto(
      data: (json['data'] as List)
          .map((item) => MarkerItemDto.fromJson(item))
          .toList(),
    );
  }
}

class MarkerItemDto {
  final String category;
  final String? markerId;
  final int? count;
  final double latitude;
  final double longitude;

  MarkerItemDto({
    required this.category,
    this.markerId,
    this.count,
    required this.latitude,
    required this.longitude,
  });

  factory MarkerItemDto.fromJson(Map<String, dynamic> json) {
    return MarkerItemDto(
      category: json['category'],
      markerId: json['marker_id'],
      count: json['count'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  bool get isCluster => category == 'cluster';
}
