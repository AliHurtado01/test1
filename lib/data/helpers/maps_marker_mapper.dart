import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../../models/domain/category_marker.dart';
import '../../models/domain/marker.dart';
import '../../models/dto/maps_markers_response_dto.dart';

class MapsMarkerMapper {
  List<Marker> fromDtoToMarkers(MapsMarkersResponseDto dto) {
    return dto.data.map((item) {
      return Marker(
        id: item.isCluster
            ? 'cluster_${item.latitude}_${item.longitude}_${item.count}'
            : item.markerId!,
        position: gmaps.LatLng(item.latitude, item.longitude),
        category: _mapCategory(item.category),
        count: item.count ?? 1,
      );
    }).toList();
  }

  CategoryMarker _mapCategory(String category) {
    return CategoryMarker.values.firstWhere(
      (cat) => cat.name == category.toLowerCase(),
      orElse: () => CategoryMarker.cluster,
    );
  }
}
