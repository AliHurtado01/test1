import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/maps_providers.dart';

class MapsScreen extends ConsumerStatefulWidget {
  final void Function(String markerId) onMarkerTap;

  const MapsScreen({super.key, required this.onMarkerTap});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen>
    with AutomaticKeepAliveClientMixin {
  GoogleMapController? _controller;
  bool _movedUserLocation = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapVisibilityProvider.notifier).setVisible(true);
    });
  }

  @override
  void dispose() {
    ref.read(mapVisibilityProvider.notifier).setVisible(false);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      route.animation?.addStatusListener(_routeStatusListener);
    }
  }

  void _routeStatusListener(AnimationStatus status) {
    final isVisible = status == AnimationStatus.completed;
    ref.read(mapVisibilityProvider.notifier).setVisible(isVisible);
  }

  Future<void> _handleCameraIdle() async {
    final controller = _controller;
    if (controller == null) return;

    final bounds = await controller.getVisibleRegion();
    final zoom = await controller.getZoomLevel();

    ref.read(mapViewModelProvider.notifier).handleCameraIdle(bounds, zoom);
  }

  void _moveToUserLocation(LatLng? userLocation) {
    if (_controller != null && userLocation != null && !_movedUserLocation) {
      _movedUserLocation = true;
      final zoom = ref.read(mapViewModelProvider).initialCamera.zoom;
      _controller!.animateCamera(
        CameraUpdate.newLatLngZoom(userLocation, zoom),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(mapViewModelProvider);

    _moveToUserLocation(state.userLocation);

    final markersOnTab = state.markers.map((marker) {
      if (marker.markerId.value.startsWith('cluster_')) {
        return marker;
      }
      return marker.copyWith(
        onTapParam: () => widget.onMarkerTap(marker.markerId.value),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: state.initialCamera,
            markers: markersOnTab,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (controller) {
              _controller = controller;
              _moveToUserLocation(state.userLocation);
            },
            onCameraIdle: _handleCameraIdle,
          ),
          if (state.isLoading)
            Positioned(
              top: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Loading markers...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
