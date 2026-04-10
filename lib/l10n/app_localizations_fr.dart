// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Dealheure';

  @override
  String get homeDescription =>
      'Trouvez les meilleurs restaurants, hôtels et magasins autour de vous. Explorez la carte pour découvrir les offres disponibles.';

  @override
  String get exploreMap => 'Explorer la carte';

  @override
  String get restaurants => 'Restaurants';

  @override
  String get hotels => 'Hôtels';

  @override
  String get stores => 'Magasins';

  @override
  String get museums => 'Musées';

  @override
  String get parks => 'Parcs';

  @override
  String get cafes => 'Cafés';

  @override
  String get noProductsFound => 'Aucun produit trouvé pour ce marqueur.';

  @override
  String get errorPrefix => 'Erreur:';

  @override
  String get idCopied => 'copié dans le presse-papiers';

  @override
  String get products => 'Produits';

  @override
  String get outOfStock => 'Épuisé';

  @override
  String get stockPrefix => 'Stock';

  @override
  String get businessPrefix => 'Entreprise';

  @override
  String get loadingMarkers => 'Chargement des marqueurs...';

  @override
  String get moreFilters => 'Plus';

  @override
  String get comingSoonFilters => 'Bientôt: Écran de tous les filtres';

  @override
  String get navHome => 'Accueil';

  @override
  String get navMap => 'Carte';
}
