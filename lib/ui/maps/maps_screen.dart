import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/maps_providers.dart';
import '../../models/domain/category_marker.dart';
import '../../utils/snackbar_util.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    ref.listen(mapViewModelProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        SnackBarUtil.show(
          context,
          message: next.error!,
          type: SnackBarType.error,
        );
      }
    });

    final state = ref.watch(mapViewModelProvider);
    final activeFilters = ref.watch(categoryFilterProvider);

    _moveToUserLocation(state.userLocation);

    final markersOnTab = state.markers
        .where((marker) {
          if (marker.markerId.value.startsWith('cluster_')) {
            return true;
          }

          CategoryMarker category;
          if (marker.markerId.value == 'marker_001' ||
              marker.markerId.value == 'marker_004') {
            category = CategoryMarker.restaurant;
          } else if (marker.markerId.value == 'marker_002' ||
              marker.markerId.value == 'marker_005') {
            category = CategoryMarker.hotel;
          } else if (marker.markerId.value == 'marker_006') {
            category = CategoryMarker.museum; 
          } else if (marker.markerId.value == 'marker_007') {
            category = CategoryMarker.park; 
          } else if (marker.markerId.value == 'marker_008') {
            category = CategoryMarker.cafe;
          } else {
            category = CategoryMarker.store;
          }

          return activeFilters.contains(category);
        })
        .map((marker) {
          if (marker.markerId.value.startsWith('cluster_')) {
            return marker;
          }
          return marker.copyWith(
            onTapParam: () => widget.onMarkerTap(marker.markerId.value),
          );
        })
        .toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navMap, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
            onTap: (_) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),

          if (state.isLoading)
            Positioned(
              top: 70,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(l10n.loadingMarkers),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...CategoryMarker.values
                        .where((category) => category != CategoryMarker.cluster)
                        .map((category) {
                          IconData icon;
                          String labelText;

                          switch (category) {
                            case CategoryMarker.restaurant:
                              icon = Icons.restaurant;
                              labelText = l10n.restaurants;
                              break;
                            case CategoryMarker.hotel:
                              icon = Icons.hotel;
                              labelText = l10n.hotels;
                              break;
                            case CategoryMarker.store:
                              icon = Icons.store;
                              labelText = l10n.stores;
                              break;
                            case CategoryMarker.museum:
                              icon = Icons.museum;
                              labelText = l10n.museums;
                              break;
                            case CategoryMarker.park:
                              icon = Icons.park;
                              labelText = l10n.parks;
                              break;
                            case CategoryMarker.cafe:
                              icon = Icons.local_cafe;
                              labelText = l10n.cafes;
                              break;
                            default:
                              icon = Icons.place;
                              labelText = category.name;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _buildFilterChip(
                              category,
                              icon,
                              labelText,
                              activeFilters,
                              context,
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 4.0),
                      child: ActionChip(
                        avatar: const Icon(
                          Icons.tune,
                          size: 18,
                        ),
                        label: Text(
                          l10n.moreFilters,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          SnackBarUtil.show(
                            context,
                            message: l10n.comingSoonFilters,
                            type: SnackBarType.info,
                            duration: const Duration(seconds: 2),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    CategoryMarker category,
    IconData icon,
    String label,
    Set<CategoryMarker> activeFilters,
    BuildContext context,
  ) {
    final isSelected = activeFilters.contains(category);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return FilterChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : primaryColor,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: primaryColor,
      backgroundColor: Colors.white,
      checkmarkColor: Colors.white,
      elevation: isSelected ? 4 : 1,
      onSelected: (bool selected) {
        ref.read(categoryFilterProvider.notifier).toggleCategory(category);
      },
    );
  }
}