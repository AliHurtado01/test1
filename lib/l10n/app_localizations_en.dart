// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Dealheure';

  @override
  String get homeDescription =>
      'Find the best restaurants, hotels and stores around you. Explore the map to discover available deals.';

  @override
  String get exploreMap => 'Explore map';

  @override
  String get restaurants => 'Restaurants';

  @override
  String get hotels => 'Hotels';

  @override
  String get stores => 'Stores';

  @override
  String get museums => 'Museums';

  @override
  String get parks => 'Parks';

  @override
  String get cafes => 'Cafes';

  @override
  String get noProductsFound => 'No products found for this marker.';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get idCopied => 'copied to clipboard';

  @override
  String get products => 'Products';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get stockPrefix => 'Stock';

  @override
  String get businessPrefix => 'Business';

  @override
  String get loadingMarkers => 'Loading markers...';

  @override
  String get moreFilters => 'More';

  @override
  String get comingSoonFilters => 'Coming soon: All filters screen';

  @override
  String get navHome => 'Home';

  @override
  String get navMap => 'Map';
}
