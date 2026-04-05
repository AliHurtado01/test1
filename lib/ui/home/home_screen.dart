import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routing/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Dealheure',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Encuentra los mejores restaurantes, hoteles y tiendas a tu alrededor. Explora el mapa para descubrir las ofertas disponibles.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: const [
                    Chip(
                      avatar: Icon(Icons.restaurant, size: 18),
                      label: Text('Restaurant'),
                    ),
                    Chip(
                      avatar: Icon(Icons.hotel, size: 18),
                      label: Text('Hotel'),
                    ),
                    Chip(
                      avatar: Icon(Icons.store, size: 18),
                      label: Text('Store'),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                FilledButton.icon(
                  onPressed: () => context.go(Routes.map),
                  icon: const Icon(Icons.map),
                  label: const Text('Explorar mapa'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}