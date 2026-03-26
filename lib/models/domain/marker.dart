import 'package:flutter_init/models/domain/category_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Marker {
  final String id;
  final LatLng position;
  final CategoryMarker category;
  final int count;

  Marker({
    required this.id,
    required this.position,
    required this.category,
    this.count = 1,
  });
}
