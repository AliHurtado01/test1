import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Dealheure'**
  String get appTitle;

  /// No description provided for @homeDescription.
  ///
  /// In es, this message translates to:
  /// **'Encuentra los mejores restaurantes, hoteles y tiendas a tu alrededor. Explora el mapa para descubrir las ofertas disponibles.'**
  String get homeDescription;

  /// No description provided for @exploreMap.
  ///
  /// In es, this message translates to:
  /// **'Explorar mapa'**
  String get exploreMap;

  /// No description provided for @restaurants.
  ///
  /// In es, this message translates to:
  /// **'Restaurantes'**
  String get restaurants;

  /// No description provided for @hotels.
  ///
  /// In es, this message translates to:
  /// **'Hoteles'**
  String get hotels;

  /// No description provided for @stores.
  ///
  /// In es, this message translates to:
  /// **'Tiendas'**
  String get stores;

  /// No description provided for @museums.
  ///
  /// In es, this message translates to:
  /// **'Museos'**
  String get museums;

  /// No description provided for @parks.
  ///
  /// In es, this message translates to:
  /// **'Parques'**
  String get parks;

  /// No description provided for @cafes.
  ///
  /// In es, this message translates to:
  /// **'Cafeterías'**
  String get cafes;

  /// No description provided for @noProductsFound.
  ///
  /// In es, this message translates to:
  /// **'No se han encontrado productos para este marcador.'**
  String get noProductsFound;

  /// No description provided for @errorPrefix.
  ///
  /// In es, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @idCopied.
  ///
  /// In es, this message translates to:
  /// **'copiado al portapapeles'**
  String get idCopied;

  /// No description provided for @products.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get products;

  /// No description provided for @outOfStock.
  ///
  /// In es, this message translates to:
  /// **'Agotado'**
  String get outOfStock;

  /// No description provided for @stockPrefix.
  ///
  /// In es, this message translates to:
  /// **'Stock'**
  String get stockPrefix;

  /// No description provided for @businessPrefix.
  ///
  /// In es, this message translates to:
  /// **'Negocio'**
  String get businessPrefix;

  /// No description provided for @loadingMarkers.
  ///
  /// In es, this message translates to:
  /// **'Cargando marcadores...'**
  String get loadingMarkers;

  /// No description provided for @moreFilters.
  ///
  /// In es, this message translates to:
  /// **'Más'**
  String get moreFilters;

  /// No description provided for @comingSoonFilters.
  ///
  /// In es, this message translates to:
  /// **'Próximamente: Pantalla de todos los filtros'**
  String get comingSoonFilters;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navMap.
  ///
  /// In es, this message translates to:
  /// **'Mapa'**
  String get navMap;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
