import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/maps_providers.dart';
import '../../models/domain/category_marker.dart';

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
    
    // 1. Escuchamos cambios en el estado para disparar efectos secundarios (el SnackBar)
    ref.listen(mapViewModelProvider, (previous, next) {
      // Verificamos que haya un error nuevo y que sea diferente al anterior
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(next.error!)),
              ],
            ),
            backgroundColor: Colors.red.shade800,
            behavior: SnackBarBehavior.floating, // Flotante para no tapar navegación inferior
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });

    // 2. Observamos el estado para renderizar la UI
    final state = ref.watch(mapViewModelProvider);
    //Observar el estado del filtro
    final activeFilters = ref.watch(categoryFilterProvider);

    _moveToUserLocation(state.userLocation);

    //Aplicar la lógica de filtrado
    final markersOnTab = state.markers.where((marker) {
      // Los clusters siempre se muestran
      if (marker.markerId.value.startsWith('cluster_')) {
        return true;
      }
      
      // Usamos el id del marcador para buscar la correspondencia
      CategoryMarker category;
      if (marker.markerId.value == 'marker_001' || marker.markerId.value == 'marker_004') {
        category = CategoryMarker.restaurant;
      } else if (marker.markerId.value == 'marker_002' || marker.markerId.value == 'marker_005') {
        category = CategoryMarker.hotel;
      } else if (marker.markerId.value == 'marker_003') {
        category = CategoryMarker.store;
      } else {
        category = CategoryMarker.store; // fallback
      }

      // Regla 3: Si la categoría está activa, lo mostramos
      return activeFilters.contains(category);
      
    }).map((marker) {
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
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: state.initialCamera,
            markers: markersOnTab, // El mapa recibe los marcadores filtrados
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

          //La barra horizontal de filtros
          Positioned(
            top: 16, // Espacio desde abajo
            left: 16,
            right: 16, // Para que ocupe todo el ancho
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(CategoryMarker.restaurant, Icons.restaurant, 'Restaurantes', activeFilters, context),
                  const SizedBox(width: 8),
                  _buildFilterChip(CategoryMarker.hotel, Icons.hotel, 'Hoteles', activeFilters, context),
                  const SizedBox(width: 8),
                  _buildFilterChip(CategoryMarker.store, Icons.store, 'Tiendas', activeFilters, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildFilterChip(CategoryMarker category, IconData icon, String label, Set<CategoryMarker> activeFilters, BuildContext context) {
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