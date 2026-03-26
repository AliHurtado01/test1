import 'package:flutter/material.dart';
import 'package:flutter_init/data/helpers/cluster_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/domain/category_marker.dart';

class MarkerIconResolver {
  final Map<CategoryMarker, BitmapDescriptor> _cache = {};
  final Map<int, BitmapDescriptor> _clusterCache = {};

  final ClusterIcon _clusterPainter;

  MarkerIconResolver({required ClusterIcon clusterPainter})
    : _clusterPainter = clusterPainter;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    for (final category in CategoryMarker.values) {
      try {
        final icon = await BitmapDescriptor.asset(
          const ImageConfiguration(size: Size(42, 42)),
          'lib/public/markers/${category.name}.png',
        );
        _cache[category] = icon;
      } catch (_) {
        _cache[category] = BitmapDescriptor.defaultMarker;
      }
    }

    _initialized = true;
  }

  Future<BitmapDescriptor> resolve(
    CategoryMarker category, [
    int count = 1,
  ]) async {
    if (category != CategoryMarker.cluster) {
      return _cache[category] ?? BitmapDescriptor.defaultMarker;
    }

    if (_clusterCache.containsKey(count)) {
      return _clusterCache[count]!;
    }

    final icon = await _clusterPainter.paint(count);
    _clusterCache[count] = icon;

    return icon;
  }
}
