import 'package:dio/dio.dart';
import '../../models/dto/maps_markers_request_dto.dart';
import '../../models/dto/maps_markers_response_dto.dart';

class MapsMarkerService {
  final Dio _dio;
  final String? apiBaseUrl;

  MapsMarkerService({required Dio dio, this.apiBaseUrl}) : _dio = dio;

  Future<MapsMarkersResponseDto> fetchMarkers(
    MapsMarkersRequestDto request,
  ) async {
    return _fetchMarkers(request);
  }

  Future<MapsMarkersResponseDto> _fetchMarkers(
    MapsMarkersRequestDto request,
  ) async {
    try {
      final response = await _dio.get(
        '$apiBaseUrl/markers',
        queryParameters: {
          'southwest_lat': request.southwestLat,
          'northeast_lat': request.northeastLat,
          'southwest_lng': request.southwestLng,
          'northeast_lng': request.northeastLng,
          'zoom': request.zoom,
        },
      );

      return MapsMarkersResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch markers: ${e.message}');
    }
  }
}
