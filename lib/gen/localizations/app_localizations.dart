import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localizations/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('nl')];

  /// No description provided for @new_task.
  ///
  /// In nl, this message translates to:
  /// **'Nieuwe taak'**
  String get new_task;

  /// No description provided for @my_tasks.
  ///
  /// In nl, this message translates to:
  /// **'Mijn Taken'**
  String get my_tasks;

  /// No description provided for @settings.
  ///
  /// In nl, this message translates to:
  /// **'Instellingen'**
  String get settings;

  /// No description provided for @no_tasks.
  ///
  /// In nl, this message translates to:
  /// **'Geen taken'**
  String get no_tasks;

  /// No description provided for @tap_to_add.
  ///
  /// In nl, this message translates to:
  /// **'Tik op + om een taak toe te voegen'**
  String get tap_to_add;

  /// No description provided for @never_done.
  ///
  /// In nl, this message translates to:
  /// **'Nog nooit gedaan'**
  String get never_done;

  /// No description provided for @mark_as_done.
  ///
  /// In nl, this message translates to:
  /// **'Markeren als gedaan?'**
  String get mark_as_done;

  /// No description provided for @cancel.
  ///
  /// In nl, this message translates to:
  /// **'Annuleren'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In nl, this message translates to:
  /// **'Bevestigen'**
  String get confirm;

  /// No description provided for @add_task.
  ///
  /// In nl, this message translates to:
  /// **'Taak toevoegen'**
  String get add_task;

  /// No description provided for @delete.
  ///
  /// In nl, this message translates to:
  /// **'Verwijderen'**
  String get delete;

  /// No description provided for @edit_task.
  ///
  /// In nl, this message translates to:
  /// **'Taak bewerken'**
  String get edit_task;

  /// No description provided for @delete_task_prompt.
  ///
  /// In nl, this message translates to:
  /// **'Taak verwijderen?'**
  String get delete_task_prompt;

  /// No description provided for @will_be_deleted.
  ///
  /// In nl, this message translates to:
  /// **'wordt permanent verwijderd.'**
  String get will_be_deleted;

  /// No description provided for @name.
  ///
  /// In nl, this message translates to:
  /// **'Naam'**
  String get name;

  /// No description provided for @give_name.
  ///
  /// In nl, this message translates to:
  /// **'Geef de taak een naam'**
  String get give_name;

  /// No description provided for @interval.
  ///
  /// In nl, this message translates to:
  /// **'Herhaalinterval'**
  String get interval;

  /// No description provided for @number_of_days.
  ///
  /// In nl, this message translates to:
  /// **'Aantal dagen (optioneel)'**
  String get number_of_days;

  /// No description provided for @save_changes.
  ///
  /// In nl, this message translates to:
  /// **'Wijzigingen opslaan'**
  String get save_changes;
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
      <String>['nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
