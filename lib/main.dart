import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart'; 
import 'routing/router.dart';
import 'providers/core_providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    // Escuchamos el idioma que el usuario haya seleccionado (NotifierProvider)
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      routerConfig: router,
      locale: currentLocale, // Si es null, usa el idioma del sistema operativo
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}