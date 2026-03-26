import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../ui/home/home_screen.dart';
import '../ui/maps/maps_screen.dart';
import '../ui/products/products_bottom_sheet.dart';
import '../ui/navbar/nav_bar.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.map,
                name: 'map',
                builder: (context, state) {
                  return MapsScreen(
                    onMarkerTap: (markerId) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            ProductsBottomSheet(markerId: markerId),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
