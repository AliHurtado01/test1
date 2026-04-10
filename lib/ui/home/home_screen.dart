import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routing/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/core_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        // ¡Reutilizamos la variable del NavBar aquí!
        title: Text(l10n.navHome, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.settings),
            tooltip: 'Ajustes',
            onSelected: (Locale newLocale) {
              ref.read(localeProvider.notifier).changeLocale(newLocale);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                enabled: false,
                child: Text(
                  'Idioma',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<Locale>(
                value: const Locale('es'),
                child: Row(
                  children: [
                    if (currentLocale?.languageCode == 'es' || currentLocale == null)
                      const Icon(Icons.check, size: 18, color: Colors.green)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('Español'),
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: const Locale('en'),
                child: Row(
                  children: [
                    if (currentLocale?.languageCode == 'en')
                      const Icon(Icons.check, size: 18, color: Colors.green)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('English'),
                  ],
                ),
              ),
              PopupMenuItem<Locale>(
                value: const Locale('fr'),
                child: Row(
                  children: [
                    if (currentLocale?.languageCode == 'fr')
                      const Icon(Icons.check, size: 18, color: Colors.green)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    const Text('Français'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.homeDescription,
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
                  label: Text(l10n.exploreMap),
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