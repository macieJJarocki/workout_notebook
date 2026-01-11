import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @plan_your_trening.
  ///
  /// In en, this message translates to:
  /// **'Plan your trening'**
  String get plan_your_trening;

  /// No description provided for @dailog_choose_workout.
  ///
  /// In en, this message translates to:
  /// **'Choose workout'**
  String get dailog_choose_workout;

  /// No description provided for @dailog_first_create_workout.
  ///
  /// In en, this message translates to:
  /// **'First create workout'**
  String get dailog_first_create_workout;

  /// No description provided for @dailog_delete_workout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to delete this workout?'**
  String get dailog_delete_workout;

  /// No description provided for @dailog_create_workout.
  ///
  /// In en, this message translates to:
  /// **'Enter workout name'**
  String get dailog_create_workout;

  /// No description provided for @dailog_create_exercise.
  ///
  /// In en, this message translates to:
  /// **'Create exercise'**
  String get dailog_create_exercise;

  /// No description provided for @dailog_delete_exercise.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to delete this exercise?'**
  String get dailog_delete_exercise;

  /// No description provided for @dailog_edit_exercise.
  ///
  /// In en, this message translates to:
  /// **'Adjust the exercise to suit your preferences.'**
  String get dailog_edit_exercise;

  /// No description provided for @string_add_workout.
  ///
  /// In en, this message translates to:
  /// **'Add workouts'**
  String get string_add_workout;

  /// No description provided for @string_workouts.
  ///
  /// In en, this message translates to:
  /// **'workouts'**
  String get string_workouts;

  /// No description provided for @string_dont_waste_time_etc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t waste time - create your workout here!'**
  String get string_dont_waste_time_etc;

  /// No description provided for @string_workout_creator.
  ///
  /// In en, this message translates to:
  /// **'Workout Creator'**
  String get string_workout_creator;

  /// No description provided for @string_exercise_done.
  ///
  /// In en, this message translates to:
  /// **'Exercise done?'**
  String get string_exercise_done;

  /// No description provided for @string_exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get string_exercise;

  /// No description provided for @string_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get string_name;

  /// No description provided for @string_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get string_weight;

  /// No description provided for @string_repetitions.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get string_repetitions;

  /// No description provided for @string_sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get string_sets;

  /// No description provided for @button_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get button_save;

  /// No description provided for @button_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get button_edit;

  /// No description provided for @button_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get button_delete;

  /// No description provided for @button_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get button_add;

  /// No description provided for @button_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get button_create;

  /// No description provided for @button_create_workout.
  ///
  /// In en, this message translates to:
  /// **'Create workout'**
  String get button_create_workout;

  /// No description provided for @snack_bar_assign_workout.
  ///
  /// In en, this message translates to:
  /// **'Assign workout!'**
  String get snack_bar_assign_workout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pl': return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
