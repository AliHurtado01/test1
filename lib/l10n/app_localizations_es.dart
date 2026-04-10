// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Dealheure';

  @override
  String get homeDescription =>
      'Encuentra los mejores restaurantes, hoteles y tiendas a tu alrededor. Explora el mapa para descubrir las ofertas disponibles.';

  @override
  String get exploreMap => 'Explorar mapa';

  @override
  String get restaurants => 'Restaurantes';

  @override
  String get hotels => 'Hoteles';

  @override
  String get stores => 'Tiendas';

  @override
  String get museums => 'Museos';

  @override
  String get parks => 'Parques';

  @override
  String get cafes => 'Cafeterías';

  @override
  String get noProductsFound =>
      'No se han encontrado productos para este marcador.';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get idCopied => 'copiado al portapapeles';

  @override
  String get products => 'Productos';

  @override
  String get outOfStock => 'Agotado';

  @override
  String get stockPrefix => 'Stock';

  @override
  String get businessPrefix => 'Negocio';

  @override
  String get loadingMarkers => 'Cargando marcadores...';

  @override
  String get moreFilters => 'Más';

  @override
  String get comingSoonFilters => 'Próximamente: Pantalla de todos los filtros';

  @override
  String get navHome => 'Inicio';

  @override
  String get navMap => 'Mapa';
}
