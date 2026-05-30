import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('ca'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @titolApp.
  ///
  /// In ca, this message translates to:
  /// **'PlanC'**
  String get titolApp;

  /// No description provided for @holaUsuari.
  ///
  /// In ca, this message translates to:
  /// **'Hola, {nom}!'**
  String holaUsuari(String nom);

  /// No description provided for @seleccionaIdioma.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona un idioma:'**
  String get seleccionaIdioma;

  /// No description provided for @catala.
  ///
  /// In ca, this message translates to:
  /// **'Català'**
  String get catala;

  /// No description provided for @espanol.
  ///
  /// In ca, this message translates to:
  /// **'Español'**
  String get espanol;

  /// No description provided for @angles.
  ///
  /// In ca, this message translates to:
  /// **'English'**
  String get angles;

  /// No description provided for @configuracioTitol.
  ///
  /// In ca, this message translates to:
  /// **'Configuració'**
  String get configuracioTitol;

  /// No description provided for @seccioPreferencies.
  ///
  /// In ca, this message translates to:
  /// **'Preferències'**
  String get seccioPreferencies;

  /// No description provided for @idiomaLabel.
  ///
  /// In ca, this message translates to:
  /// **'Idioma de l\'aplicació'**
  String get idiomaLabel;

  /// No description provided for @errorGoogleMaps.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut obrir Google Maps al dispositiu'**
  String get errorGoogleMaps;

  /// No description provided for @detallActivitatTitol.
  ///
  /// In ca, this message translates to:
  /// **'Detall de l\'activitat'**
  String get detallActivitatTitol;

  /// No description provided for @compartirActivitatTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Compartir activitat'**
  String get compartirActivitatTooltip;

  /// No description provided for @treurePreferidesTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Treure de preferides'**
  String get treurePreferidesTooltip;

  /// No description provided for @afegirPreferidesTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Afegir a preferides'**
  String get afegirPreferidesTooltip;

  /// No description provided for @activitatAfegidaPreferides.
  ///
  /// In ca, this message translates to:
  /// **'Activitat afegida a preferides'**
  String get activitatAfegidaPreferides;

  /// No description provided for @activitatEliminadaPreferides.
  ///
  /// In ca, this message translates to:
  /// **'Activitat eliminada de preferides'**
  String get activitatEliminadaPreferides;

  /// No description provided for @errorActualitzarPreferides.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut actualitzar preferides: {error}'**
  String errorActualitzarPreferides(String error);

  /// No description provided for @descripcioTitol.
  ///
  /// In ca, this message translates to:
  /// **'Descripció'**
  String get descripcioTitol;

  /// No description provided for @quanTitol.
  ///
  /// In ca, this message translates to:
  /// **'Quan'**
  String get quanTitol;

  /// No description provided for @iniciLabel.
  ///
  /// In ca, this message translates to:
  /// **'Inici'**
  String get iniciLabel;

  /// No description provided for @fiLabel.
  ///
  /// In ca, this message translates to:
  /// **'Fi'**
  String get fiLabel;

  /// No description provided for @onTitol.
  ///
  /// In ca, this message translates to:
  /// **'On'**
  String get onTitol;

  /// No description provided for @espaiLabel.
  ///
  /// In ca, this message translates to:
  /// **'Espai'**
  String get espaiLabel;

  /// No description provided for @adrecaLabel.
  ///
  /// In ca, this message translates to:
  /// **'Adreça'**
  String get adrecaLabel;

  /// No description provided for @obrirGoogleMapsButton.
  ///
  /// In ca, this message translates to:
  /// **'Obrir a Google Maps'**
  String get obrirGoogleMapsButton;

  /// No description provided for @entradesTitol.
  ///
  /// In ca, this message translates to:
  /// **'Entrades'**
  String get entradesTitol;

  /// No description provided for @compartirXatTitol.
  ///
  /// In ca, this message translates to:
  /// **'Compartir a un xat'**
  String get compartirXatTitol;

  /// No description provided for @cercaXatHint.
  ///
  /// In ca, this message translates to:
  /// **'Cerca un xat o grup...'**
  String get cercaXatHint;

  /// No description provided for @activitatCompartidaExit.
  ///
  /// In ca, this message translates to:
  /// **'Activitat compartida a: {chatName}'**
  String activitatCompartidaExit(String chatName);

  /// No description provided for @errorCompartir.
  ///
  /// In ca, this message translates to:
  /// **'Error al compartir: {error}'**
  String errorCompartir(String error);

  /// No description provided for @errorCarregarXats.
  ///
  /// In ca, this message translates to:
  /// **'Error al carregar xats: {error}'**
  String errorCarregarXats(String error);

  /// No description provided for @noXatsTrobats.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat xats'**
  String get noXatsTrobats;

  /// No description provided for @enviarButton.
  ///
  /// In ca, this message translates to:
  /// **'Enviar'**
  String get enviarButton;

  /// No description provided for @authDescubreixTitle.
  ///
  /// In ca, this message translates to:
  /// **'Descobreix'**
  String get authDescubreixTitle;

  /// No description provided for @authConnectaTitle.
  ///
  /// In ca, this message translates to:
  /// **'Connecta'**
  String get authConnectaTitle;

  /// No description provided for @authCreixTitle.
  ///
  /// In ca, this message translates to:
  /// **'Creix'**
  String get authCreixTitle;

  /// No description provided for @authDescubreixDesc.
  ///
  /// In ca, this message translates to:
  /// **'Troba esdeveniments culturals a Catalunya personalitzats pels teus interessos.'**
  String get authDescubreixDesc;

  /// No description provided for @authConnectaDesc.
  ///
  /// In ca, this message translates to:
  /// **'Coneix gent amb els mateixos gusts culturals i feu pinya.'**
  String get authConnectaDesc;

  /// No description provided for @authCreixDesc.
  ///
  /// In ca, this message translates to:
  /// **'Guanya insígnies gaudint de la cultura.'**
  String get authCreixDesc;

  /// No description provided for @authLoginButton.
  ///
  /// In ca, this message translates to:
  /// **'Inicia Sessió'**
  String get authLoginButton;

  /// No description provided for @authCreateAccountButton.
  ///
  /// In ca, this message translates to:
  /// **'Crea un compte'**
  String get authCreateAccountButton;

  /// No description provided for @loginTitle.
  ///
  /// In ca, this message translates to:
  /// **'Inicia Sessió'**
  String get loginTitle;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In ca, this message translates to:
  /// **'Encantat de tornar-te a veure'**
  String get loginWelcomeBack;

  /// No description provided for @loginEmailOrUsernameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Correu electrònic / Nom d\'usuari'**
  String get loginEmailOrUsernameLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya'**
  String get loginPasswordLabel;

  /// No description provided for @loginForgotPassword.
  ///
  /// In ca, this message translates to:
  /// **'Has oblidat la contrasenya?'**
  String get loginForgotPassword;

  /// No description provided for @loginLoadingButton.
  ///
  /// In ca, this message translates to:
  /// **'Carregant'**
  String get loginLoadingButton;

  /// No description provided for @loginSignInButton.
  ///
  /// In ca, this message translates to:
  /// **'Iniciar Sessió'**
  String get loginSignInButton;

  /// No description provided for @loginContinueWith.
  ///
  /// In ca, this message translates to:
  /// **'o continua amb'**
  String get loginContinueWith;

  /// No description provided for @loginGoogleButton.
  ///
  /// In ca, this message translates to:
  /// **'Continua amb Google'**
  String get loginGoogleButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In ca, this message translates to:
  /// **'No tens compte?'**
  String get loginNoAccount;

  /// No description provided for @loginSignUpHere.
  ///
  /// In ca, this message translates to:
  /// **'Registra\'t aquí'**
  String get loginSignUpHere;

  /// No description provided for @loginRequiredField.
  ///
  /// In ca, this message translates to:
  /// **'Camp obligatori'**
  String get loginRequiredField;

  /// No description provided for @loginErrorFallback.
  ///
  /// In ca, this message translates to:
  /// **'Error d\'inici de sessió'**
  String get loginErrorFallback;

  /// No description provided for @loginSuccessSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'Sessió iniciada correctament'**
  String get loginSuccessSnackbar;

  /// No description provided for @registerCreateAccountTitle.
  ///
  /// In ca, this message translates to:
  /// **'Crea el teu compte'**
  String get registerCreateAccountTitle;

  /// No description provided for @registerUsernameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nom d\'usuari'**
  String get registerUsernameLabel;

  /// No description provided for @registerEmailLabel.
  ///
  /// In ca, this message translates to:
  /// **'Correu electrònic'**
  String get registerEmailLabel;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya'**
  String get registerPasswordLabel;

  /// No description provided for @registerRepeatPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Confirma la contrasenya'**
  String get registerRepeatPasswordLabel;

  /// No description provided for @registerLoadingButton.
  ///
  /// In ca, this message translates to:
  /// **'Carregant'**
  String get registerLoadingButton;

  /// No description provided for @registerSubmitButton.
  ///
  /// In ca, this message translates to:
  /// **'Registra\'t'**
  String get registerSubmitButton;

  /// No description provided for @registerUsernameMinError.
  ///
  /// In ca, this message translates to:
  /// **'El nom d\'usuari ha de contenir mínim 3 caràcters'**
  String get registerUsernameMinError;

  /// No description provided for @registerUsernameMaxError.
  ///
  /// In ca, this message translates to:
  /// **'El nom d\'usuari ha de contenir màxim 20 caràcters'**
  String get registerUsernameMaxError;

  /// No description provided for @registerEmailInvalidError.
  ///
  /// In ca, this message translates to:
  /// **'El camp ha de contenir una adressa electrònica vàlida'**
  String get registerEmailInvalidError;

  /// No description provided for @registerEmailTaken.
  ///
  /// In ca, this message translates to:
  /// **'Aquest correu ja està en ús'**
  String get registerEmailTaken;

  /// No description provided for @registerUsernameTaken.
  ///
  /// In ca, this message translates to:
  /// **'Aquest nom d\'usuari ja està en ús'**
  String get registerUsernameTaken;

  /// No description provided for @registerChecking.
  ///
  /// In ca, this message translates to:
  /// **'Comprovant...'**
  String get registerChecking;

  /// No description provided for @registerPasswordInvalidError.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya invàlida'**
  String get registerPasswordInvalidError;

  /// No description provided for @registerPasswordMismatchError.
  ///
  /// In ca, this message translates to:
  /// **'Les contrasenyes no coincideixen'**
  String get registerPasswordMismatchError;

  /// No description provided for @registerErrorFallback.
  ///
  /// In ca, this message translates to:
  /// **'Error al registrarse'**
  String get registerErrorFallback;

  /// No description provided for @registerSuccessSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'¡Cuenta creada exitosamente!'**
  String get registerSuccessSnackbar;

  /// No description provided for @registerVerificationTitle.
  ///
  /// In ca, this message translates to:
  /// **'Compte creat!'**
  String get registerVerificationTitle;

  /// No description provided for @registerVerificationSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Benvingut/da a PlanC'**
  String get registerVerificationSubtitle;

  /// No description provided for @registerVerificationBody.
  ///
  /// In ca, this message translates to:
  /// **'Hem enviat un correu de verificació a {email}. Verifica el teu compte per gaudir de totes les funcionalitats.'**
  String registerVerificationBody(String email);

  /// No description provided for @registerVerificationButton.
  ///
  /// In ca, this message translates to:
  /// **'Entrar a l\'app'**
  String get registerVerificationButton;

  /// No description provided for @registerContinueButton.
  ///
  /// In ca, this message translates to:
  /// **'Continua'**
  String get registerContinueButton;

  /// No description provided for @registerSkipButton.
  ///
  /// In ca, this message translates to:
  /// **'Ometre'**
  String get registerSkipButton;

  /// No description provided for @registerStep2Title.
  ///
  /// In ca, this message translates to:
  /// **'Sobre tu'**
  String get registerStep2Title;

  /// No description provided for @registerStep3Title.
  ///
  /// In ca, this message translates to:
  /// **'Foto de perfil'**
  String get registerStep3Title;

  /// No description provided for @registerNameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nom'**
  String get registerNameLabel;

  /// No description provided for @registerSurnameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Cognoms'**
  String get registerSurnameLabel;

  /// No description provided for @registerBioLabel.
  ///
  /// In ca, this message translates to:
  /// **'Biografia'**
  String get registerBioLabel;

  /// No description provided for @registerBioHint.
  ///
  /// In ca, this message translates to:
  /// **'Explica\'ns alguna cosa de tu (opcional)...'**
  String get registerBioHint;

  /// No description provided for @registerAddPhotoButton.
  ///
  /// In ca, this message translates to:
  /// **'Afegir foto'**
  String get registerAddPhotoButton;

  /// No description provided for @registerNameRequiredError.
  ///
  /// In ca, this message translates to:
  /// **'El nom és obligatori'**
  String get registerNameRequiredError;

  /// No description provided for @registerSurnameRequiredError.
  ///
  /// In ca, this message translates to:
  /// **'Els cognoms són obligatoris'**
  String get registerSurnameRequiredError;

  /// No description provided for @registerBioMaxError.
  ///
  /// In ca, this message translates to:
  /// **'Màxim 160 caràcters'**
  String get registerBioMaxError;

  /// No description provided for @registerStepOf.
  ///
  /// In ca, this message translates to:
  /// **'Pas {current} de {total}'**
  String registerStepOf(int current, int total);

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In ca, this message translates to:
  /// **'Recupera la teva contrasenya'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix el teu correu i rebràs un correu electrònic amb les indicacions per restablir-la'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordEmailInvalid.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix un correu vàlid'**
  String get forgotPasswordEmailInvalid;

  /// No description provided for @forgotPasswordButton.
  ///
  /// In ca, this message translates to:
  /// **'Recuperar contrasenya'**
  String get forgotPasswordButton;

  /// No description provided for @forgotPasswordEmailSent.
  ///
  /// In ca, this message translates to:
  /// **'S\'ha enviat un correu a l\'adressa indicada'**
  String get forgotPasswordEmailSent;

  /// No description provided for @forgotPasswordGoToLogin.
  ///
  /// In ca, this message translates to:
  /// **'Anar al login'**
  String get forgotPasswordGoToLogin;

  /// No description provided for @authWrapperCheckingSession.
  ///
  /// In ca, this message translates to:
  /// **'Comprovant sessió...'**
  String get authWrapperCheckingSession;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar compte'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountIrreversibleWarning.
  ///
  /// In ca, this message translates to:
  /// **'Aquesta acció és irreversible'**
  String get deleteAccountIrreversibleWarning;

  /// No description provided for @deleteAccountWarningDetails.
  ///
  /// In ca, this message translates to:
  /// **'S\'eliminaran permanentment: el teu perfil, publicacions, comentaris, amistats i totes les dades personals.'**
  String get deleteAccountWarningDetails;

  /// No description provided for @deleteAccountTypeConfirmInstruction.
  ///
  /// In ca, this message translates to:
  /// **'Escriu \"ELIMINAR\" per confirmar'**
  String get deleteAccountTypeConfirmInstruction;

  /// No description provided for @deleteAccountTypeConfirmLabel.
  ///
  /// In ca, this message translates to:
  /// **'Escriu ELIMINAR'**
  String get deleteAccountTypeConfirmLabel;

  /// No description provided for @deleteAccountTypeConfirmRequired.
  ///
  /// In ca, this message translates to:
  /// **'Escriu \"ELIMINAR\" per confirmar'**
  String get deleteAccountTypeConfirmRequired;

  /// No description provided for @deleteAccountPasswordLabel.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix la teva contrasenya per confirmar'**
  String get deleteAccountPasswordLabel;

  /// No description provided for @deleteAccountPasswordRequired.
  ///
  /// In ca, this message translates to:
  /// **'Introdueix la teva contrasenya'**
  String get deleteAccountPasswordRequired;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Estàs segur?'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogContent.
  ///
  /// In ca, this message translates to:
  /// **'Aquesta acció no es pot desfer. Totes les teves dades s\'eliminaran permanentment.'**
  String get deleteAccountDialogContent;

  /// No description provided for @deleteAccountDialogCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get deleteAccountDialogCancel;

  /// No description provided for @deleteAccountDialogConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar definitivament'**
  String get deleteAccountDialogConfirm;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In ca, this message translates to:
  /// **'El teu compte s\'ha eliminat correctament'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountErrorFallback.
  ///
  /// In ca, this message translates to:
  /// **'Error eliminant el compte'**
  String get deleteAccountErrorFallback;

  /// No description provided for @homeTabFeed.
  ///
  /// In ca, this message translates to:
  /// **'Feed'**
  String get homeTabFeed;

  /// No description provided for @homeTabExplora.
  ///
  /// In ca, this message translates to:
  /// **'Explora'**
  String get homeTabExplora;

  /// No description provided for @navInici.
  ///
  /// In ca, this message translates to:
  /// **'Inici'**
  String get navInici;

  /// No description provided for @feedDiscover.
  ///
  /// In ca, this message translates to:
  /// **'Descobreix'**
  String get feedDiscover;

  /// No description provided for @feedTrending.
  ///
  /// In ca, this message translates to:
  /// **'Tendències'**
  String get feedTrending;

  /// No description provided for @feedCategories.
  ///
  /// In ca, this message translates to:
  /// **'Categories'**
  String get feedCategories;

  /// No description provided for @feedRecommended.
  ///
  /// In ca, this message translates to:
  /// **'Recomanat per a tu'**
  String get feedRecommended;

  /// No description provided for @feedNearby.
  ///
  /// In ca, this message translates to:
  /// **'A prop teu'**
  String get feedNearby;

  /// No description provided for @feedQuedades.
  ///
  /// In ca, this message translates to:
  /// **'Quedades obertes'**
  String get feedQuedades;

  /// No description provided for @feedQuedadesEmpty.
  ///
  /// In ca, this message translates to:
  /// **'No hi ha quedades disponibles ara'**
  String get feedQuedadesEmpty;

  /// No description provided for @feedQuedadesParticipants.
  ///
  /// In ca, this message translates to:
  /// **'{current}/{max} participants'**
  String feedQuedadesParticipants(int current, int max);

  /// No description provided for @feedQuedadesJoin.
  ///
  /// In ca, this message translates to:
  /// **'Veure activitat'**
  String get feedQuedadesJoin;

  /// No description provided for @searchDiscoverTitle.
  ///
  /// In ca, this message translates to:
  /// **'Suggeriments'**
  String get searchDiscoverTitle;

  /// No description provided for @feedSeeAll.
  ///
  /// In ca, this message translates to:
  /// **'Veure tot'**
  String get feedSeeAll;

  /// No description provided for @feedFree.
  ///
  /// In ca, this message translates to:
  /// **'Gratuït'**
  String get feedFree;

  /// No description provided for @feedInfoUnavailable.
  ///
  /// In ca, this message translates to:
  /// **'Info no disp.'**
  String get feedInfoUnavailable;

  /// No description provided for @feedLoadError.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han pogut carregar'**
  String get feedLoadError;

  /// No description provided for @activitatDetailError.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar l\'activitat'**
  String get activitatDetailError;

  /// No description provided for @feedEmpty.
  ///
  /// In ca, this message translates to:
  /// **'No hi ha activitats'**
  String get feedEmpty;

  /// No description provided for @feedNoMoreActivities.
  ///
  /// In ca, this message translates to:
  /// **'No hi ha més activitats'**
  String get feedNoMoreActivities;

  /// No description provided for @feedNoCategoryActivities.
  ///
  /// In ca, this message translates to:
  /// **'No hi ha activitats en aquesta categoria'**
  String get feedNoCategoryActivities;

  /// No description provided for @feedRetry.
  ///
  /// In ca, this message translates to:
  /// **'Torna-ho a provar'**
  String get feedRetry;

  /// No description provided for @feedLoadingMore.
  ///
  /// In ca, this message translates to:
  /// **'Carregant més...'**
  String get feedLoadingMore;

  /// No description provided for @homeTabMap.
  ///
  /// In ca, this message translates to:
  /// **'Mapa'**
  String get homeTabMap;

  /// No description provided for @homeTabSearch.
  ///
  /// In ca, this message translates to:
  /// **'Cerca'**
  String get homeTabSearch;

  /// No description provided for @homeTabChat.
  ///
  /// In ca, this message translates to:
  /// **'Comunitat'**
  String get homeTabChat;

  /// No description provided for @homeTabNotifications.
  ///
  /// In ca, this message translates to:
  /// **'Notificacions'**
  String get homeTabNotifications;

  /// No description provided for @homeTabCalendar.
  ///
  /// In ca, this message translates to:
  /// **'Calendari'**
  String get homeTabCalendar;

  /// No description provided for @homeTabProfile.
  ///
  /// In ca, this message translates to:
  /// **'Perfil'**
  String get homeTabProfile;

  /// No description provided for @profileFriendsBox.
  ///
  /// In ca, this message translates to:
  /// **'Amics'**
  String get profileFriendsBox;

  /// No description provided for @profilePostsBox.
  ///
  /// In ca, this message translates to:
  /// **'Publicacions'**
  String get profilePostsBox;

  /// No description provided for @profileNoDescription.
  ///
  /// In ca, this message translates to:
  /// **'No descripció encara'**
  String get profileNoDescription;

  /// No description provided for @profileEditButton.
  ///
  /// In ca, this message translates to:
  /// **'Editar perfil'**
  String get profileEditButton;

  /// No description provided for @profileNoPosts.
  ///
  /// In ca, this message translates to:
  /// **'Encara no hi ha publicacions'**
  String get profileNoPosts;

  /// No description provided for @profileEnviarMissatge.
  ///
  /// In ca, this message translates to:
  /// **'Enviar missatge'**
  String get profileEnviarMissatge;

  /// No description provided for @profileXatNoDisponible.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha trobat cap xat amb aquest usuari'**
  String get profileXatNoDisponible;

  /// No description provided for @profilePublicationsSection.
  ///
  /// In ca, this message translates to:
  /// **'Publicacions'**
  String get profilePublicationsSection;

  /// No description provided for @profileTrophiesSection.
  ///
  /// In ca, this message translates to:
  /// **'Trofeus'**
  String get profileTrophiesSection;

  /// No description provided for @profileNoTrophies.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens trofeus. Participa en activitats per guanyar-ne!'**
  String get profileNoTrophies;

  /// No description provided for @trophyLevelLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nivell'**
  String get trophyLevelLabel;

  /// No description provided for @actualRankLabel.
  ///
  /// In ca, this message translates to:
  /// **'Rang actual'**
  String get actualRankLabel;

  /// No description provided for @achievedLevelLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nivell aconseguit'**
  String get achievedLevelLabel;

  /// No description provided for @levelProgressLabel.
  ///
  /// In ca, this message translates to:
  /// **'Progrés de nivell'**
  String get levelProgressLabel;

  /// No description provided for @pointsForNextLevelLabel.
  ///
  /// In ca, this message translates to:
  /// **' punts per arribar al nivell'**
  String get pointsForNextLevelLabel;

  /// No description provided for @close.
  ///
  /// In ca, this message translates to:
  /// **'Tancar'**
  String get close;

  /// No description provided for @editProfileTitle.
  ///
  /// In ca, this message translates to:
  /// **'Edita Perfil'**
  String get editProfileTitle;

  /// No description provided for @editProfileImageUpdated.
  ///
  /// In ca, this message translates to:
  /// **'Foto de perfil actualitzada correctament'**
  String get editProfileImageUpdated;

  /// No description provided for @editProfileImageError.
  ///
  /// In ca, this message translates to:
  /// **'Error al actualizar la foto: {error}'**
  String editProfileImageError(String error);

  /// No description provided for @editProfileUsernameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Usuari'**
  String get editProfileUsernameLabel;

  /// No description provided for @editProfileDescriptionLabel.
  ///
  /// In ca, this message translates to:
  /// **'Biografia'**
  String get editProfileDescriptionLabel;

  /// No description provided for @editProfileNameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Nom'**
  String get editProfileNameLabel;

  /// No description provided for @editProfileSurnameLabel.
  ///
  /// In ca, this message translates to:
  /// **'Cognom'**
  String get editProfileSurnameLabel;

  /// No description provided for @editProfileLogoutButton.
  ///
  /// In ca, this message translates to:
  /// **'Tancar sessió'**
  String get editProfileLogoutButton;

  /// No description provided for @editProfileDangerZone.
  ///
  /// In ca, this message translates to:
  /// **'Zona perillosa'**
  String get editProfileDangerZone;

  /// No description provided for @editProfileDeleteAccount.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar compte'**
  String get editProfileDeleteAccount;

  /// No description provided for @editProfileFieldSave.
  ///
  /// In ca, this message translates to:
  /// **'Save'**
  String get editProfileFieldSave;

  /// No description provided for @friendsScreenTitle.
  ///
  /// In ca, this message translates to:
  /// **'Amistats'**
  String get friendsScreenTitle;

  /// No description provided for @friendsScreenSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Aquí pots veure les sol·licituds rebudes i les enviades pendents.'**
  String get friendsScreenSubtitle;

  /// No description provided for @friendsScreenSectionReceived.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licituds rebudes'**
  String get friendsScreenSectionReceived;

  /// No description provided for @friendsScreenSectionSent.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licituds enviades'**
  String get friendsScreenSectionSent;

  /// No description provided for @friendsScreenNoReceived.
  ///
  /// In ca, this message translates to:
  /// **'No tens cap sol·licitud rebuda pendent.'**
  String get friendsScreenNoReceived;

  /// No description provided for @friendsScreenNoSent.
  ///
  /// In ca, this message translates to:
  /// **'No tens cap sol·licitud enviada pendent.'**
  String get friendsScreenNoSent;

  /// No description provided for @friendsScreenWantsFriend.
  ///
  /// In ca, this message translates to:
  /// **'Vol ser el teu amic'**
  String get friendsScreenWantsFriend;

  /// No description provided for @friendsScreenAcceptButton.
  ///
  /// In ca, this message translates to:
  /// **'Acceptar'**
  String get friendsScreenAcceptButton;

  /// No description provided for @friendsScreenRejectButton.
  ///
  /// In ca, this message translates to:
  /// **'Rebutjar'**
  String get friendsScreenRejectButton;

  /// No description provided for @friendsScreenCancelButton.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get friendsScreenCancelButton;

  /// No description provided for @friendsScreenPendingRequest.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licitud pendent'**
  String get friendsScreenPendingRequest;

  /// No description provided for @friendsScreenRetry.
  ///
  /// In ca, this message translates to:
  /// **'Reintentar'**
  String get friendsScreenRetry;

  /// No description provided for @friendsScreenAcceptedSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licitud acceptada correctament'**
  String get friendsScreenAcceptedSuccess;

  /// No description provided for @friendsScreenRejectedSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licitud rebutjada correctament'**
  String get friendsScreenRejectedSuccess;

  /// No description provided for @friendsScreenCanceledSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licitud cancel·lada correctament'**
  String get friendsScreenCanceledSuccess;

  /// No description provided for @friendsListTitle.
  ///
  /// In ca, this message translates to:
  /// **'Amics'**
  String get friendsListTitle;

  /// No description provided for @friendsListSearchHint.
  ///
  /// In ca, this message translates to:
  /// **'Cerca un amic...'**
  String get friendsListSearchHint;

  /// No description provided for @friendsListNoResults.
  ///
  /// In ca, this message translates to:
  /// **'Cap amic coincideix amb la cerca.'**
  String get friendsListNoResults;

  /// No description provided for @friendsListNoneOwn.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens amics.'**
  String get friendsListNoneOwn;

  /// No description provided for @friendsListNoneOther.
  ///
  /// In ca, this message translates to:
  /// **'Aquest usuari no té amics.'**
  String get friendsListNoneOther;

  /// No description provided for @friendsListRemoveTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar amic'**
  String get friendsListRemoveTooltip;

  /// No description provided for @friendsListRemoveDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar amic'**
  String get friendsListRemoveDialogTitle;

  /// No description provided for @friendsListRemoveDialogContent.
  ///
  /// In ca, this message translates to:
  /// **'Vols eliminar {nom} de la teva llista d\'amics?'**
  String friendsListRemoveDialogContent(String nom);

  /// No description provided for @friendsListRemoveCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get friendsListRemoveCancel;

  /// No description provided for @friendsListRemoveConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar'**
  String get friendsListRemoveConfirm;

  /// No description provided for @friendsListRetry.
  ///
  /// In ca, this message translates to:
  /// **'Reintentar'**
  String get friendsListRetry;

  /// No description provided for @relationshipRemoveFriend.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar amic'**
  String get relationshipRemoveFriend;

  /// No description provided for @relationshipAccept.
  ///
  /// In ca, this message translates to:
  /// **'Acceptar'**
  String get relationshipAccept;

  /// No description provided for @relationshipReject.
  ///
  /// In ca, this message translates to:
  /// **'Rebutjar'**
  String get relationshipReject;

  /// No description provided for @relationshipRequestSent.
  ///
  /// In ca, this message translates to:
  /// **'Sol·licitud enviada'**
  String get relationshipRequestSent;

  /// No description provided for @relationshipCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get relationshipCancel;

  /// No description provided for @relationshipSendRequest.
  ///
  /// In ca, this message translates to:
  /// **'Enviar sol·licitud d\'amistat'**
  String get relationshipSendRequest;

  /// No description provided for @relationshipRetry.
  ///
  /// In ca, this message translates to:
  /// **'Reintentar'**
  String get relationshipRetry;

  /// No description provided for @relationshipErrorPrefix.
  ///
  /// In ca, this message translates to:
  /// **'Error: {error}'**
  String relationshipErrorPrefix(String error);

  /// No description provided for @searchTabAll.
  ///
  /// In ca, this message translates to:
  /// **'Tots'**
  String get searchTabAll;

  /// No description provided for @searchTabProfiles.
  ///
  /// In ca, this message translates to:
  /// **'Perfils'**
  String get searchTabProfiles;

  /// No description provided for @searchTabActivities.
  ///
  /// In ca, this message translates to:
  /// **'Activitats'**
  String get searchTabActivities;

  /// No description provided for @searchTabSpaces.
  ///
  /// In ca, this message translates to:
  /// **'Espais'**
  String get searchTabSpaces;

  /// No description provided for @searchHint.
  ///
  /// In ca, this message translates to:
  /// **'Cerca activitats, espais...'**
  String get searchHint;

  /// No description provided for @searchFiltersTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Filtres'**
  String get searchFiltersTooltip;

  /// No description provided for @searchRecentTitle.
  ///
  /// In ca, this message translates to:
  /// **'Cerques recents'**
  String get searchRecentTitle;

  /// No description provided for @searchActivitiesHeader.
  ///
  /// In ca, this message translates to:
  /// **'Activitats ({count})'**
  String searchActivitiesHeader(int count);

  /// No description provided for @searchSpacesHeader.
  ///
  /// In ca, this message translates to:
  /// **'Espais ({count})'**
  String searchSpacesHeader(int count);

  /// No description provided for @filterTitle.
  ///
  /// In ca, this message translates to:
  /// **'Filtres'**
  String get filterTitle;

  /// No description provided for @filterClear.
  ///
  /// In ca, this message translates to:
  /// **'Netejar filtres'**
  String get filterClear;

  /// No description provided for @filterPriceLabel.
  ///
  /// In ca, this message translates to:
  /// **'Preu'**
  String get filterPriceLabel;

  /// No description provided for @filterPriceAll.
  ///
  /// In ca, this message translates to:
  /// **'Tots'**
  String get filterPriceAll;

  /// No description provided for @filterPriceFree.
  ///
  /// In ca, this message translates to:
  /// **'Gratuït'**
  String get filterPriceFree;

  /// No description provided for @filterPricePaid.
  ///
  /// In ca, this message translates to:
  /// **'De pagament'**
  String get filterPricePaid;

  /// No description provided for @filterDistanceLabel.
  ///
  /// In ca, this message translates to:
  /// **'Distància: {km} km'**
  String filterDistanceLabel(int km);

  /// No description provided for @filterLocationPermissionNeeded.
  ///
  /// In ca, this message translates to:
  /// **'Cal concedir permisos d\'ubicació per usar aquest filtre.'**
  String get filterLocationPermissionNeeded;

  /// No description provided for @filterDateLabel.
  ///
  /// In ca, this message translates to:
  /// **'Data'**
  String get filterDateLabel;

  /// No description provided for @filterDateAll.
  ///
  /// In ca, this message translates to:
  /// **'Totes les dates'**
  String get filterDateAll;

  /// No description provided for @filterDateToday.
  ///
  /// In ca, this message translates to:
  /// **'Avui'**
  String get filterDateToday;

  /// No description provided for @filterDateWeekend.
  ///
  /// In ca, this message translates to:
  /// **'Cap de setmana'**
  String get filterDateWeekend;

  /// No description provided for @filterDateCalendar.
  ///
  /// In ca, this message translates to:
  /// **'📅 Calendari'**
  String get filterDateCalendar;

  /// No description provided for @filterApply.
  ///
  /// In ca, this message translates to:
  /// **'Aplicar filtres'**
  String get filterApply;

  /// No description provided for @filterNoLocation.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut obtenir la ubicació. El filtre de distància no s\'aplicarà.'**
  String get filterNoLocation;

  /// No description provided for @emptySearchFilterTitle.
  ///
  /// In ca, this message translates to:
  /// **'Cap activitat coincideix amb els filtres'**
  String get emptySearchFilterTitle;

  /// No description provided for @emptySearchSearchTitle.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha trobat cap coincidència'**
  String get emptySearchSearchTitle;

  /// No description provided for @emptySearchFilterDescription.
  ///
  /// In ca, this message translates to:
  /// **'Prova d\'ampliar la distància, canviar les dates o modificar els filtres de preu.'**
  String get emptySearchFilterDescription;

  /// No description provided for @emptySearchSearchDescription.
  ///
  /// In ca, this message translates to:
  /// **'No hem trobat resultats per \"{terme}\".\nProva amb un altre terme o explora les categories.'**
  String emptySearchSearchDescription(String terme);

  /// No description provided for @emptySearchModifyFilters.
  ///
  /// In ca, this message translates to:
  /// **'Modificar filtres'**
  String get emptySearchModifyFilters;

  /// No description provided for @emptySearchCategoryMusic.
  ///
  /// In ca, this message translates to:
  /// **'Música'**
  String get emptySearchCategoryMusic;

  /// No description provided for @emptySearchCategoryTheater.
  ///
  /// In ca, this message translates to:
  /// **'Teatre'**
  String get emptySearchCategoryTheater;

  /// No description provided for @emptySearchCategoryArt.
  ///
  /// In ca, this message translates to:
  /// **'Art'**
  String get emptySearchCategoryArt;

  /// No description provided for @emptySearchCategoryCinema.
  ///
  /// In ca, this message translates to:
  /// **'Cinema'**
  String get emptySearchCategoryCinema;

  /// No description provided for @chatNotificationsTitle.
  ///
  /// In ca, this message translates to:
  /// **'Comunitat'**
  String get chatNotificationsTitle;

  /// No description provided for @chatTabChats.
  ///
  /// In ca, this message translates to:
  /// **'Xats'**
  String get chatTabChats;

  /// No description provided for @chatTabFriendships.
  ///
  /// In ca, this message translates to:
  /// **'Amistats'**
  String get chatTabFriendships;

  /// No description provided for @myChatsTitle.
  ///
  /// In ca, this message translates to:
  /// **'Els meus xats'**
  String get myChatsTitle;

  /// No description provided for @chatListError.
  ///
  /// In ca, this message translates to:
  /// **'Error al carregar xats: {error}'**
  String chatListError(String error);

  /// No description provided for @chatListEmpty.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens cap xat actiu.\nUneix-te a una quedada!'**
  String get chatListEmpty;

  /// No description provided for @chatDeleteDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar xat'**
  String get chatDeleteDialogTitle;

  /// No description provided for @chatDeleteDialogContent.
  ///
  /// In ca, this message translates to:
  /// **'Estàs segur que vols eliminar \"{name}\"? L\'historial de missatges desapareixerà per a tu.'**
  String chatDeleteDialogContent(String name);

  /// No description provided for @chatDeleteCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get chatDeleteCancel;

  /// No description provided for @chatDeleteConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar'**
  String get chatDeleteConfirm;

  /// No description provided for @chatDeletedSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'{name} eliminat'**
  String chatDeletedSnackbar(String name);

  /// No description provided for @chatUnmuteAction.
  ///
  /// In ca, this message translates to:
  /// **'Dessilenciar xat'**
  String get chatUnmuteAction;

  /// No description provided for @chatMuteAction.
  ///
  /// In ca, this message translates to:
  /// **'Silenciar xat'**
  String get chatMuteAction;

  /// No description provided for @chatUnmutedSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'{name} dessilenciat'**
  String chatUnmutedSnackbar(String name);

  /// No description provided for @chatMutedSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'{name} silenciat'**
  String chatMutedSnackbar(String name);

  /// No description provided for @chatRoomNotFoundError.
  ///
  /// In ca, this message translates to:
  /// **'Error al enviar missatge: {error}'**
  String chatRoomNotFoundError(String error);

  /// No description provided for @chatRoomImagePickError.
  ///
  /// In ca, this message translates to:
  /// **'Error al seleccionar imatge: {error}'**
  String chatRoomImagePickError(String error);

  /// No description provided for @chatRoomImageCaptureError.
  ///
  /// In ca, this message translates to:
  /// **'Error al capturar imatge: {error}'**
  String chatRoomImageCaptureError(String error);

  /// No description provided for @chatRoomTodayLabel.
  ///
  /// In ca, this message translates to:
  /// **'AVUI'**
  String get chatRoomTodayLabel;

  /// No description provided for @chatRoomYesterdayLabel.
  ///
  /// In ca, this message translates to:
  /// **'AHIR'**
  String get chatRoomYesterdayLabel;

  /// No description provided for @chatRoomAttachmentGallery.
  ///
  /// In ca, this message translates to:
  /// **'Galeria'**
  String get chatRoomAttachmentGallery;

  /// No description provided for @chatRoomAttachmentCamera.
  ///
  /// In ca, this message translates to:
  /// **'Càmera'**
  String get chatRoomAttachmentCamera;

  /// No description provided for @chatRoomNoMessages.
  ///
  /// In ca, this message translates to:
  /// **'Sense missatges encara'**
  String get chatRoomNoMessages;

  /// No description provided for @chatRoomStartConversation.
  ///
  /// In ca, this message translates to:
  /// **'Comença la conversa!'**
  String get chatRoomStartConversation;

  /// No description provided for @chatRoomLoadOlder.
  ///
  /// In ca, this message translates to:
  /// **'Cargar missatges més antics'**
  String get chatRoomLoadOlder;

  /// No description provided for @chatRoomSomeoneTyping.
  ///
  /// In ca, this message translates to:
  /// **'Algú està escrivint...'**
  String get chatRoomSomeoneTyping;

  /// No description provided for @chatRoomInactiveBannerTitle.
  ///
  /// In ca, this message translates to:
  /// **'Xat inactiu'**
  String get chatRoomInactiveBannerTitle;

  /// No description provided for @chatRoomInactiveBannerBody.
  ///
  /// In ca, this message translates to:
  /// **'Aquest xat ja no permet enviar missatges. Pot ser per un d\'aquests motius:\n\n• La quedada va tenir lloc fa més de 48 hores i el xat s\'ha tancat automàticament.\n• Un administrador va cancel·lar la quedada i el xat va quedar bloquejat.'**
  String get chatRoomInactiveBannerBody;

  /// No description provided for @chatRoomReadOnlyNotice.
  ///
  /// In ca, this message translates to:
  /// **'Xat inactiu · Només lectura'**
  String get chatRoomReadOnlyNotice;

  /// No description provided for @chatRoomInputHint.
  ///
  /// In ca, this message translates to:
  /// **'Escriu un missatge...'**
  String get chatRoomInputHint;

  /// No description provided for @chatRoomMuteUnmuteError.
  ///
  /// In ca, this message translates to:
  /// **'Error al canviar l\'estat de silenci'**
  String get chatRoomMuteUnmuteError;

  /// No description provided for @chatRoomMuteOff.
  ///
  /// In ca, this message translates to:
  /// **'Notificacions activades'**
  String get chatRoomMuteOff;

  /// No description provided for @chatRoomMuteOn.
  ///
  /// In ca, this message translates to:
  /// **'Xat silenciat'**
  String get chatRoomMuteOn;

  /// No description provided for @chatRoomActivityError.
  ///
  /// In ca, this message translates to:
  /// **'Error al cargar la activitat'**
  String get chatRoomActivityError;

  /// No description provided for @chatRoomActivityNoTitle.
  ///
  /// In ca, this message translates to:
  /// **'Sense títol'**
  String get chatRoomActivityNoTitle;

  /// No description provided for @chatRoomActivityNoLocation.
  ///
  /// In ca, this message translates to:
  /// **'Sense ubicació'**
  String get chatRoomActivityNoLocation;

  /// No description provided for @chatRoomActivityCategoryOther.
  ///
  /// In ca, this message translates to:
  /// **'Altres'**
  String get chatRoomActivityCategoryOther;

  /// No description provided for @chatRoomViewActivity.
  ///
  /// In ca, this message translates to:
  /// **'Veure activitat'**
  String get chatRoomViewActivity;

  /// No description provided for @chatDetailsAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Detalls del xat'**
  String get chatDetailsAppBarTitle;

  /// No description provided for @chatDetailsLoadError.
  ///
  /// In ca, this message translates to:
  /// **'Error al carregar els detalls del xat'**
  String get chatDetailsLoadError;

  /// No description provided for @chatDetailsFallbackTitle.
  ///
  /// In ca, this message translates to:
  /// **'Detalls'**
  String get chatDetailsFallbackTitle;

  /// No description provided for @chatDetailsTypeFriendGroup.
  ///
  /// In ca, this message translates to:
  /// **'Grup d\'amics'**
  String get chatDetailsTypeFriendGroup;

  /// No description provided for @chatDetailsTypeMeetup.
  ///
  /// In ca, this message translates to:
  /// **'Quedada'**
  String get chatDetailsTypeMeetup;

  /// No description provided for @chatDetailsTypeIndividual.
  ///
  /// In ca, this message translates to:
  /// **'Xat Individual'**
  String get chatDetailsTypeIndividual;

  /// No description provided for @chatDetailsPhotoUpdateNotice.
  ///
  /// In ca, this message translates to:
  /// **'L\'actualització de foto requereix suport del servidor (Properament)'**
  String get chatDetailsPhotoUpdateNotice;

  /// No description provided for @chatDetailsPhotoUpdateSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Foto del grup actualitzada correctament'**
  String get chatDetailsPhotoUpdateSuccess;

  /// No description provided for @chatDetailsPhotoUpdateError.
  ///
  /// In ca, this message translates to:
  /// **'Error actualitzant la foto: {error}'**
  String chatDetailsPhotoUpdateError(String error);

  /// No description provided for @chatDetailsMembersHeader.
  ///
  /// In ca, this message translates to:
  /// **'MEMBRES DEL XAT'**
  String get chatDetailsMembersHeader;

  /// No description provided for @chatDetailsLeaveChat.
  ///
  /// In ca, this message translates to:
  /// **'Abandonar Xat'**
  String get chatDetailsLeaveChat;

  /// No description provided for @chatDetailsDeleteChat.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar Xat'**
  String get chatDetailsDeleteChat;

  /// No description provided for @chatDetailsLeaveGroupDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Abandonar Grup'**
  String get chatDetailsLeaveGroupDialogTitle;

  /// No description provided for @chatDetailsDeleteChatDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar Xat'**
  String get chatDetailsDeleteChatDialogTitle;

  /// No description provided for @chatDetailsLeaveGroupDialogContent.
  ///
  /// In ca, this message translates to:
  /// **'Estàs segur que vols abandonar \"{name}\"? Deixaràs de rebre missatges d\'aquest grup.'**
  String chatDetailsLeaveGroupDialogContent(String name);

  /// No description provided for @chatDetailsDeleteChatDialogContent.
  ///
  /// In ca, this message translates to:
  /// **'Estàs segur que vols eliminar \"{name}\"? L\'historial desapareixerà.'**
  String chatDetailsDeleteChatDialogContent(String name);

  /// No description provided for @chatDetailsActionCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get chatDetailsActionCancel;

  /// No description provided for @chatDetailsLeaveButton.
  ///
  /// In ca, this message translates to:
  /// **'Abandonar'**
  String get chatDetailsLeaveButton;

  /// No description provided for @chatDetailsDeleteButton.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar'**
  String get chatDetailsDeleteButton;

  /// No description provided for @chatDetailsGroupLeftSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'Has abandonat el grup'**
  String get chatDetailsGroupLeftSnackbar;

  /// No description provided for @chatDetailsChatDeletedSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'Xat eliminat'**
  String get chatDetailsChatDeletedSnackbar;

  /// No description provided for @chatDetailsActionError.
  ///
  /// In ca, this message translates to:
  /// **'Error realitzant l\'acció'**
  String get chatDetailsActionError;

  /// No description provided for @veurQuedades.
  ///
  /// In ca, this message translates to:
  /// **'Veure quedades'**
  String get veurQuedades;

  /// No description provided for @mostrarMes.
  ///
  /// In ca, this message translates to:
  /// **'Mostra més'**
  String get mostrarMes;

  /// No description provided for @mostrarMenys.
  ///
  /// In ca, this message translates to:
  /// **'Mostra menys'**
  String get mostrarMenys;

  /// No description provided for @chatDetailsQuedadaInfoHeader.
  ///
  /// In ca, this message translates to:
  /// **'INFORMACIÓ DE LA QUEDADA'**
  String get chatDetailsQuedadaInfoHeader;

  /// No description provided for @chatDetailsQuedadaActivity.
  ///
  /// In ca, this message translates to:
  /// **'Activitat'**
  String get chatDetailsQuedadaActivity;

  /// No description provided for @chatDetailsQuedadaDate.
  ///
  /// In ca, this message translates to:
  /// **'Data'**
  String get chatDetailsQuedadaDate;

  /// No description provided for @chatDetailsQuedadaViewActivity.
  ///
  /// In ca, this message translates to:
  /// **'Veure activitat'**
  String get chatDetailsQuedadaViewActivity;

  /// No description provided for @groupsActivityTitle.
  ///
  /// In ca, this message translates to:
  /// **'Quedades: {titol}'**
  String groupsActivityTitle(String titol);

  /// No description provided for @groupsLoadError.
  ///
  /// In ca, this message translates to:
  /// **'Error al carregar les quedades:\n{error}'**
  String groupsLoadError(String error);

  /// No description provided for @groupsEmpty.
  ///
  /// In ca, this message translates to:
  /// **'Encara no hi ha quedades per aquesta activitat.\nSigues el primer en crear-ne una!'**
  String get groupsEmpty;

  /// No description provided for @groupsCreateButton.
  ///
  /// In ca, this message translates to:
  /// **'Crear Quedada'**
  String get groupsCreateButton;

  /// No description provided for @groupFormEditTitle.
  ///
  /// In ca, this message translates to:
  /// **'Editar Quedada'**
  String get groupFormEditTitle;

  /// No description provided for @groupFormCreateTitle.
  ///
  /// In ca, this message translates to:
  /// **'Crear Quedada'**
  String get groupFormCreateTitle;

  /// No description provided for @groupFormModifyHeader.
  ///
  /// In ca, this message translates to:
  /// **'Modifica els detalls de la quedada'**
  String get groupFormModifyHeader;

  /// No description provided for @groupFormConfigureHeader.
  ///
  /// In ca, this message translates to:
  /// **'Configura la teva quedada'**
  String get groupFormConfigureHeader;

  /// No description provided for @groupFormTitleLabel.
  ///
  /// In ca, this message translates to:
  /// **'Títol de la quedada'**
  String get groupFormTitleLabel;

  /// No description provided for @groupFormTitleHint.
  ///
  /// In ca, this message translates to:
  /// **'Ex: Partida de Pàdel'**
  String get groupFormTitleHint;

  /// No description provided for @groupFormDescriptionLabel.
  ///
  /// In ca, this message translates to:
  /// **'Descripció'**
  String get groupFormDescriptionLabel;

  /// No description provided for @groupFormMinLabel.
  ///
  /// In ca, this message translates to:
  /// **'Mínim'**
  String get groupFormMinLabel;

  /// No description provided for @groupFormMaxLabel.
  ///
  /// In ca, this message translates to:
  /// **'Màxim'**
  String get groupFormMaxLabel;

  /// No description provided for @groupFormMinAtLeastOne.
  ///
  /// In ca, this message translates to:
  /// **'Ha de ser com a mínim 1'**
  String get groupFormMinAtLeastOne;

  /// No description provided for @groupFormMaxGreaterEqualMin.
  ///
  /// In ca, this message translates to:
  /// **'Ha de ser igual o superior al mínim'**
  String get groupFormMaxGreaterEqualMin;

  /// No description provided for @groupFormPickDateTime.
  ///
  /// In ca, this message translates to:
  /// **'Triar data i hora'**
  String get groupFormPickDateTime;

  /// No description provided for @groupFormDateValue.
  ///
  /// In ca, this message translates to:
  /// **'Data: {dia}/{mes} a les {hora}'**
  String groupFormDateValue(int dia, int mes, String hora);

  /// No description provided for @groupFormDateRequired.
  ///
  /// In ca, this message translates to:
  /// **'Cal seleccionar data i hora'**
  String get groupFormDateRequired;

  /// No description provided for @groupFormSaveButton.
  ///
  /// In ca, this message translates to:
  /// **'GUARDAR CANVIS'**
  String get groupFormSaveButton;

  /// No description provided for @groupFormCreateButton.
  ///
  /// In ca, this message translates to:
  /// **'CREAR GRUP'**
  String get groupFormCreateButton;

  /// No description provided for @groupFormRequiredField.
  ///
  /// In ca, this message translates to:
  /// **'Camp obligatori'**
  String get groupFormRequiredField;

  /// No description provided for @groupFormNoUser.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha trobat l\'usuari autenticat'**
  String get groupFormNoUser;

  /// No description provided for @groupFormCreateSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Grup creat correctament!'**
  String get groupFormCreateSuccess;

  /// No description provided for @groupFormUpdateSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Grup actualitzat correctament!'**
  String get groupFormUpdateSuccess;

  /// No description provided for @groupFormErrorPrefix.
  ///
  /// In ca, this message translates to:
  /// **'Error: {error}'**
  String groupFormErrorPrefix(String error);

  /// No description provided for @groupFormDatePast.
  ///
  /// In ca, this message translates to:
  /// **'La data i hora no pot ser anterior a l\'actual'**
  String get groupFormDatePast;

  /// No description provided for @groupFormAddPhoto.
  ///
  /// In ca, this message translates to:
  /// **'Afegir foto de la quedada'**
  String get groupFormAddPhoto;

  /// No description provided for @groupFormAddPhotoSubtitle.
  ///
  /// In ca, this message translates to:
  /// **'Opcional · Toca per seleccionar'**
  String get groupFormAddPhotoSubtitle;

  /// No description provided for @groupFormChangePhoto.
  ///
  /// In ca, this message translates to:
  /// **'Canviar foto'**
  String get groupFormChangePhoto;

  /// No description provided for @groupCardNoUserError.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha trobat l\'usuari autenticat'**
  String get groupCardNoUserError;

  /// No description provided for @groupCardDeleteDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar grup?'**
  String get groupCardDeleteDialogTitle;

  /// No description provided for @groupCardDeleteDialogContent.
  ///
  /// In ca, this message translates to:
  /// **'Aquesta acció cancel·larà la trobada per a tothom.'**
  String get groupCardDeleteDialogContent;

  /// No description provided for @groupCardDeleteBack.
  ///
  /// In ca, this message translates to:
  /// **'Enrere'**
  String get groupCardDeleteBack;

  /// No description provided for @groupCardDeleteConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar'**
  String get groupCardDeleteConfirm;

  /// No description provided for @groupCardLeaveDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Abandonar grup?'**
  String get groupCardLeaveDialogTitle;

  /// No description provided for @groupCardLeaveDialogContent.
  ///
  /// In ca, this message translates to:
  /// **'Segur que vols marxar del grup?'**
  String get groupCardLeaveDialogContent;

  /// No description provided for @groupCardCreatorCannotLeave.
  ///
  /// In ca, this message translates to:
  /// **'Ets el creador. Si vols cancel·lar la quedada, elimina-la.'**
  String get groupCardCreatorCannotLeave;

  /// No description provided for @groupCardLeaveCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get groupCardLeaveCancel;

  /// No description provided for @groupCardLeaveConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Abandonar'**
  String get groupCardLeaveConfirm;

  /// No description provided for @groupCardConfirmAttendanceTitle.
  ///
  /// In ca, this message translates to:
  /// **'Confirmar assistència?'**
  String get groupCardConfirmAttendanceTitle;

  /// No description provided for @groupCardConfirmAttendanceContent.
  ///
  /// In ca, this message translates to:
  /// **'Vols confirmar la teva assistència a aquesta quedada?'**
  String get groupCardConfirmAttendanceContent;

  /// No description provided for @groupCardConfirmAttendanceCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get groupCardConfirmAttendanceCancel;

  /// No description provided for @groupCardConfirmAttendanceConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Confirmar'**
  String get groupCardConfirmAttendanceConfirm;

  /// No description provided for @groupCardUnconfirmAttendanceTitle.
  ///
  /// In ca, this message translates to:
  /// **'Desconfirmar assistència?'**
  String get groupCardUnconfirmAttendanceTitle;

  /// No description provided for @groupCardUnconfirmAttendanceContent.
  ///
  /// In ca, this message translates to:
  /// **'Passaràs a estar en llista d\'espera. Podràs tornar a confirmar més endavant.'**
  String get groupCardUnconfirmAttendanceContent;

  /// No description provided for @groupCardUnconfirmAttendanceCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get groupCardUnconfirmAttendanceCancel;

  /// No description provided for @groupCardUnconfirmAttendanceConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Desconfirmar'**
  String get groupCardUnconfirmAttendanceConfirm;

  /// No description provided for @groupCardGroupDeleted.
  ///
  /// In ca, this message translates to:
  /// **'Grup eliminat correctament'**
  String get groupCardGroupDeleted;

  /// No description provided for @groupCardJoinedSuccess.
  ///
  /// In ca, this message translates to:
  /// **'T\'has unit a la quedada'**
  String get groupCardJoinedSuccess;

  /// No description provided for @groupCardLeftSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Has abandonat la quedada'**
  String get groupCardLeftSuccess;

  /// No description provided for @groupCardAttendanceConfirmed.
  ///
  /// In ca, this message translates to:
  /// **'Assistència confirmada'**
  String get groupCardAttendanceConfirmed;

  /// No description provided for @groupCardAttendanceUnconfirmed.
  ///
  /// In ca, this message translates to:
  /// **'Assistència desconfirmada. Estàs en llista d\'espera.'**
  String get groupCardAttendanceUnconfirmed;

  /// No description provided for @groupCardConfirmedCount.
  ///
  /// In ca, this message translates to:
  /// **'✅ {count} / {max} confirmats'**
  String groupCardConfirmedCount(int count, int max);

  /// No description provided for @groupCardPendingCount.
  ///
  /// In ca, this message translates to:
  /// **'🕓 {count} pendents'**
  String groupCardPendingCount(int count);

  /// No description provided for @groupCardPendingAttendance.
  ///
  /// In ca, this message translates to:
  /// **'La teva assistència està pendent de confirmació'**
  String get groupCardPendingAttendance;

  /// No description provided for @groupCardConfirmedAttendance.
  ///
  /// In ca, this message translates to:
  /// **'Assistència confirmada'**
  String get groupCardConfirmedAttendance;

  /// No description provided for @groupCardFullButton.
  ///
  /// In ca, this message translates to:
  /// **'Grup ple'**
  String get groupCardFullButton;

  /// No description provided for @groupCardJoinButton.
  ///
  /// In ca, this message translates to:
  /// **'Unir-se'**
  String get groupCardJoinButton;

  /// No description provided for @groupCardCreatedByYou.
  ///
  /// In ca, this message translates to:
  /// **'Creat per tu'**
  String get groupCardCreatedByYou;

  /// No description provided for @groupCardUnconfirmButton.
  ///
  /// In ca, this message translates to:
  /// **'Desconfirmar'**
  String get groupCardUnconfirmButton;

  /// No description provided for @groupCardLeaveButton.
  ///
  /// In ca, this message translates to:
  /// **'Abandonar'**
  String get groupCardLeaveButton;

  /// No description provided for @groupCardConfirmButton.
  ///
  /// In ca, this message translates to:
  /// **'Confirmar assistència'**
  String get groupCardConfirmButton;

  /// No description provided for @groupCardJoinedCount.
  ///
  /// In ca, this message translates to:
  /// **'👥 {count} / {max} units'**
  String groupCardJoinedCount(int count, int max);

  /// No description provided for @groupCardValidatedText.
  ///
  /// In ca, this message translates to:
  /// **'Assistència validada per geolocalització ✓'**
  String get groupCardValidatedText;

  /// No description provided for @validateAttendanceValidatedSnackbar.
  ///
  /// In ca, this message translates to:
  /// **'Assistència validada correctament ✓'**
  String get validateAttendanceValidatedSnackbar;

  /// No description provided for @validateAttendanceTooFarKnown.
  ///
  /// In ca, this message translates to:
  /// **'Ets massa lluny de l\'activitat: ets a {distance} metres. Cal estar a un màxim de 200 metres de l\'activitat per validar l\'assistència.'**
  String validateAttendanceTooFarKnown(String distance);

  /// No description provided for @validateAttendanceTooFar.
  ///
  /// In ca, this message translates to:
  /// **'Ets massa lluny de l\'activitat. Cal estar a un màxim de 200 metres de l\'activitat per validar l\'assistència.'**
  String get validateAttendanceTooFar;

  /// No description provided for @validateAttendanceGenericError.
  ///
  /// In ca, this message translates to:
  /// **'Error validant l\'assistència'**
  String get validateAttendanceGenericError;

  /// No description provided for @validateAttendanceValidatedButton.
  ///
  /// In ca, this message translates to:
  /// **'Assistència validada ✓'**
  String get validateAttendanceValidatedButton;

  /// No description provided for @validateAttendanceOutsideWindow.
  ///
  /// In ca, this message translates to:
  /// **'No pots validar l\'assistència perquè estàs fora del període de l\'activitat'**
  String get validateAttendanceOutsideWindow;

  /// No description provided for @validateAttendanceLocationRequired.
  ///
  /// In ca, this message translates to:
  /// **'Cal activar la ubicació per validar l\'assistència'**
  String get validateAttendanceLocationRequired;

  /// No description provided for @validateAttendanceButton.
  ///
  /// In ca, this message translates to:
  /// **'Validar assistència'**
  String get validateAttendanceButton;

  /// No description provided for @mapLocationDenied.
  ///
  /// In ca, this message translates to:
  /// **'No has concedit la ubicació. Es mostra el mapa en una posició predefinida.'**
  String get mapLocationDenied;

  /// No description provided for @mapLocationServiceDisabled.
  ///
  /// In ca, this message translates to:
  /// **'La ubicació del dispositiu està desactivada. Es mostra el mapa en una posició predefinida.'**
  String get mapLocationServiceDisabled;

  /// No description provided for @mapLocationPermissionRequiredTitle.
  ///
  /// In ca, this message translates to:
  /// **'Permís d\'ubicació necessari'**
  String get mapLocationPermissionRequiredTitle;

  /// No description provided for @mapLocationPermissionRequiredContent.
  ///
  /// In ca, this message translates to:
  /// **'Has denegat el permís d\'ubicació de manera permanent. Si vols centrar el mapa a la teva posició, has d\'anar a la configuració del mòbil i habilitar-lo.'**
  String get mapLocationPermissionRequiredContent;

  /// No description provided for @mapLocationDialogNotNow.
  ///
  /// In ca, this message translates to:
  /// **'Ara no'**
  String get mapLocationDialogNotNow;

  /// No description provided for @mapLocationDialogOpenSettings.
  ///
  /// In ca, this message translates to:
  /// **'Obrir configuració'**
  String get mapLocationDialogOpenSettings;

  /// No description provided for @mapInfoStart.
  ///
  /// In ca, this message translates to:
  /// **'Inici'**
  String get mapInfoStart;

  /// No description provided for @mapInfoEnd.
  ///
  /// In ca, this message translates to:
  /// **'Fi'**
  String get mapInfoEnd;

  /// No description provided for @mapInfoSpace.
  ///
  /// In ca, this message translates to:
  /// **'Espai'**
  String get mapInfoSpace;

  /// No description provided for @mapInfoAddress.
  ///
  /// In ca, this message translates to:
  /// **'Adreça'**
  String get mapInfoAddress;

  /// No description provided for @mapDetailsButton.
  ///
  /// In ca, this message translates to:
  /// **'Detalls'**
  String get mapDetailsButton;

  /// No description provided for @mapGroupsButton.
  ///
  /// In ca, this message translates to:
  /// **'Quedades'**
  String get mapGroupsButton;

  /// No description provided for @mapAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Mapa d\'activitats'**
  String get mapAppBarTitle;

  /// No description provided for @mapFavoritesTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Preferides'**
  String get mapFavoritesTooltip;

  /// No description provided for @mapNotificacionsTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Notificacions'**
  String get mapNotificacionsTooltip;

  /// No description provided for @mapCategoryAll.
  ///
  /// In ca, this message translates to:
  /// **'Totes'**
  String get mapCategoryAll;

  /// No description provided for @preferitsAppBarTitle.
  ///
  /// In ca, this message translates to:
  /// **'Preferits'**
  String get preferitsAppBarTitle;

  /// No description provided for @preferitsLoadError.
  ///
  /// In ca, this message translates to:
  /// **'Error carregant preferides: {error}'**
  String preferitsLoadError(String error);

  /// No description provided for @preferitsEmptyTitle.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens activitats preferides'**
  String get preferitsEmptyTitle;

  /// No description provided for @preferitsEmptyDescription.
  ///
  /// In ca, this message translates to:
  /// **'Afegeix-les des del detall d\'una activitat.'**
  String get preferitsEmptyDescription;

  /// No description provided for @buyTicketsFree.
  ///
  /// In ca, this message translates to:
  /// **'Enllaç no disponible'**
  String get buyTicketsFree;

  /// No description provided for @buyTicketsGratuit.
  ///
  /// In ca, this message translates to:
  /// **'Entrada gratuïta, no cal inscripció'**
  String get buyTicketsGratuit;

  /// No description provided for @buyTicketsLinkError.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut obrir l\'enllaç. Torna-ho a intentar.'**
  String get buyTicketsLinkError;

  /// No description provided for @buyTicketsLabel.
  ///
  /// In ca, this message translates to:
  /// **'Comprar entrades'**
  String get buyTicketsLabel;

  /// No description provided for @secureImageLoadError.
  ///
  /// In ca, this message translates to:
  /// **'Error carregant imatge'**
  String get secureImageLoadError;

  /// No description provided for @secureImageDownloadTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Descarregar imatge'**
  String get secureImageDownloadTooltip;

  /// No description provided for @errorScreenTitle.
  ///
  /// In ca, this message translates to:
  /// **'Error!'**
  String get errorScreenTitle;

  /// No description provided for @passwordRequirementsHeader.
  ///
  /// In ca, this message translates to:
  /// **'Requisits de contrasenya:'**
  String get passwordRequirementsHeader;

  /// No description provided for @passwordRequirementMinLength.
  ///
  /// In ca, this message translates to:
  /// **'Mínim {min} caràcters'**
  String passwordRequirementMinLength(int min);

  /// No description provided for @passwordRequirementUppercase.
  ///
  /// In ca, this message translates to:
  /// **'Almenys una majúscula'**
  String get passwordRequirementUppercase;

  /// No description provided for @passwordRequirementLowercase.
  ///
  /// In ca, this message translates to:
  /// **'Almenys una minúscula'**
  String get passwordRequirementLowercase;

  /// No description provided for @passwordRequirementNumber.
  ///
  /// In ca, this message translates to:
  /// **'Almenys un número'**
  String get passwordRequirementNumber;

  /// No description provided for @passwordRequirementSpecialChar.
  ///
  /// In ca, this message translates to:
  /// **'Almenys un caràcter especial'**
  String get passwordRequirementSpecialChar;

  /// No description provided for @categoriaExposicions.
  ///
  /// In ca, this message translates to:
  /// **'Exposicions'**
  String get categoriaExposicions;

  /// No description provided for @categoriaInfantil.
  ///
  /// In ca, this message translates to:
  /// **'Infantil'**
  String get categoriaInfantil;

  /// No description provided for @categoriaTeatre.
  ///
  /// In ca, this message translates to:
  /// **'Teatre'**
  String get categoriaTeatre;

  /// No description provided for @categoriaConcerts.
  ///
  /// In ca, this message translates to:
  /// **'Concerts'**
  String get categoriaConcerts;

  /// No description provided for @categoriaFestes.
  ///
  /// In ca, this message translates to:
  /// **'Festes'**
  String get categoriaFestes;

  /// No description provided for @categoriaFestivalsIMostres.
  ///
  /// In ca, this message translates to:
  /// **'Festivals i mostres'**
  String get categoriaFestivalsIMostres;

  /// No description provided for @categoriaConferencies.
  ///
  /// In ca, this message translates to:
  /// **'Conferències'**
  String get categoriaConferencies;

  /// No description provided for @categoriaRutesIVisites.
  ///
  /// In ca, this message translates to:
  /// **'Rutes i visites'**
  String get categoriaRutesIVisites;

  /// No description provided for @categoriaAltres.
  ///
  /// In ca, this message translates to:
  /// **'Altres'**
  String get categoriaAltres;

  /// No description provided for @categoriaActivitatsVirtuals.
  ///
  /// In ca, this message translates to:
  /// **'Activitats virtuals'**
  String get categoriaActivitatsVirtuals;

  /// No description provided for @categoriaDansa.
  ///
  /// In ca, this message translates to:
  /// **'Dansa'**
  String get categoriaDansa;

  /// No description provided for @categoriaFiresIMercats.
  ///
  /// In ca, this message translates to:
  /// **'Fires i mercats'**
  String get categoriaFiresIMercats;

  /// No description provided for @categoriaCarnavals.
  ///
  /// In ca, this message translates to:
  /// **'Carnavals'**
  String get categoriaCarnavals;

  /// No description provided for @categoriaCicles.
  ///
  /// In ca, this message translates to:
  /// **'Cicles'**
  String get categoriaCicles;

  /// No description provided for @categoriaSetmanaSanta.
  ///
  /// In ca, this message translates to:
  /// **'Setmana Santa'**
  String get categoriaSetmanaSanta;

  /// No description provided for @categoriaSardanes.
  ///
  /// In ca, this message translates to:
  /// **'Sardanes'**
  String get categoriaSardanes;

  /// No description provided for @categoriaGegants.
  ///
  /// In ca, this message translates to:
  /// **'Gegants'**
  String get categoriaGegants;

  /// No description provided for @categoriaCirc.
  ///
  /// In ca, this message translates to:
  /// **'Circ'**
  String get categoriaCirc;

  /// No description provided for @categoriaCommemoracions.
  ///
  /// In ca, this message translates to:
  /// **'Commemoracions'**
  String get categoriaCommemoracions;

  /// No description provided for @categoriaCursos.
  ///
  /// In ca, this message translates to:
  /// **'Cursos'**
  String get categoriaCursos;

  /// No description provided for @categoriaNadal.
  ///
  /// In ca, this message translates to:
  /// **'Nadal'**
  String get categoriaNadal;

  /// No description provided for @categoriaCulturaDigital.
  ///
  /// In ca, this message translates to:
  /// **'Cultura digital'**
  String get categoriaCulturaDigital;

  /// No description provided for @categoriaAnyGaudi.
  ///
  /// In ca, this message translates to:
  /// **'Any Gaudí'**
  String get categoriaAnyGaudi;

  /// No description provided for @gustosTitol.
  ///
  /// In ca, this message translates to:
  /// **'Els meus gustos'**
  String get gustosTitol;

  /// No description provided for @gustosSettingsSubtitol.
  ///
  /// In ca, this message translates to:
  /// **'Modifica les categories culturals que t\'interessen'**
  String get gustosSettingsSubtitol;

  /// No description provided for @gustosErrorCarregarCategories.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han pogut carregar les categories'**
  String get gustosErrorCarregarCategories;

  /// No description provided for @gustosTornaAIntentarHo.
  ///
  /// In ca, this message translates to:
  /// **'Torna a intentar-ho'**
  String get gustosTornaAIntentarHo;

  /// No description provided for @gustosSeleccionaInteressos.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona els teus interessos'**
  String get gustosSeleccionaInteressos;

  /// No description provided for @gustosDesc.
  ///
  /// In ca, this message translates to:
  /// **'Tria les categories culturals que t\'agraden per rebre recomanacions personalitzades.'**
  String get gustosDesc;

  /// No description provided for @gustosCategoriesCount.
  ///
  /// In ca, this message translates to:
  /// **'{count, plural, =1{{count} categoria seleccionada} other{{count} categories seleccionades}}'**
  String gustosCategoriesCount(int count);

  /// No description provided for @gustosContinuaButton.
  ///
  /// In ca, this message translates to:
  /// **'Guardar'**
  String get gustosContinuaButton;

  /// No description provided for @gustosBenvingudaTitol.
  ///
  /// In ca, this message translates to:
  /// **'Defineix els teus gustos!'**
  String get gustosBenvingudaTitol;

  /// No description provided for @gustosBenvingudaDesc.
  ///
  /// In ca, this message translates to:
  /// **'Encara no has seleccionat cap interès cultural. Escull les teves preferències per rebre recomanacions d\'activitats personalitzades.'**
  String get gustosBenvingudaDesc;

  /// No description provided for @gustosBenvingudaAraNo.
  ///
  /// In ca, this message translates to:
  /// **'Ara no'**
  String get gustosBenvingudaAraNo;

  /// No description provided for @gustosBenvingudaEscullButton.
  ///
  /// In ca, this message translates to:
  /// **'Escull gustos'**
  String get gustosBenvingudaEscullButton;

  /// No description provided for @searchHintWithProfiles.
  ///
  /// In ca, this message translates to:
  /// **'Cerca activitats, perfils, espais...'**
  String get searchHintWithProfiles;

  /// No description provided for @notificacionsTitol.
  ///
  /// In ca, this message translates to:
  /// **'Notificacions'**
  String get notificacionsTitol;

  /// No description provided for @notificacionsRetry.
  ///
  /// In ca, this message translates to:
  /// **'Tornar a intentar'**
  String get notificacionsRetry;

  /// No description provided for @notificacionsEmpty.
  ///
  /// In ca, this message translates to:
  /// **'No tens cap notificació'**
  String get notificacionsEmpty;

  /// No description provided for @notificacionsDataAvui.
  ///
  /// In ca, this message translates to:
  /// **'Avui a les {hora}'**
  String notificacionsDataAvui(String hora);

  /// No description provided for @notificacionsDataAhir.
  ///
  /// In ca, this message translates to:
  /// **'Ahir a les {hora}'**
  String notificacionsDataAhir(String hora);

  /// No description provided for @notificacionsDataDiaSetmana.
  ///
  /// In ca, this message translates to:
  /// **'{dia} a les {hora}'**
  String notificacionsDataDiaSetmana(String dia, String hora);

  /// No description provided for @calendariTitol.
  ///
  /// In ca, this message translates to:
  /// **'El meu calendari'**
  String get calendariTitol;

  /// No description provided for @calendariSyncTooltip.
  ///
  /// In ca, this message translates to:
  /// **'Sincronitzar amb Google Calendar'**
  String get calendariSyncTooltip;

  /// No description provided for @calendariSyncSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Sincronitzat: {created} creats, {updated} actualitzats, {deleted} eliminats'**
  String calendariSyncSuccess(int created, int updated, int deleted);

  /// No description provided for @calendariSyncSuccessNoResult.
  ///
  /// In ca, this message translates to:
  /// **'Sincronització completada'**
  String get calendariSyncSuccessNoResult;

  /// No description provided for @calendariSyncPermisDenega.
  ///
  /// In ca, this message translates to:
  /// **'Cal concedir permisos d\'accés al calendari des de Configuració'**
  String get calendariSyncPermisDenega;

  /// No description provided for @calendariSyncError.
  ///
  /// In ca, this message translates to:
  /// **'Error: {error}'**
  String calendariSyncError(String error);

  /// No description provided for @calendariErrorDesconegut.
  ///
  /// In ca, this message translates to:
  /// **'Error desconegut'**
  String get calendariErrorDesconegut;

  /// No description provided for @calendariFormatMes.
  ///
  /// In ca, this message translates to:
  /// **'Mes'**
  String get calendariFormatMes;

  /// No description provided for @calendariErrorCarregant.
  ///
  /// In ca, this message translates to:
  /// **'Error carregant les quedades'**
  String get calendariErrorCarregant;

  /// No description provided for @calendariSeleccionaDia.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona un dia per veure les quedades'**
  String get calendariSeleccionaDia;

  /// No description provided for @calendariCapQuedada.
  ///
  /// In ca, this message translates to:
  /// **'Cap quedada aquest dia'**
  String get calendariCapQuedada;

  /// No description provided for @calendariLabelActivitat.
  ///
  /// In ca, this message translates to:
  /// **'Activitat'**
  String get calendariLabelActivitat;

  /// No description provided for @calendariLabelCategoria.
  ///
  /// In ca, this message translates to:
  /// **'Categoria'**
  String get calendariLabelCategoria;

  /// No description provided for @calendariLabelHora.
  ///
  /// In ca, this message translates to:
  /// **'Hora'**
  String get calendariLabelHora;

  /// No description provided for @calendariLabelRol.
  ///
  /// In ca, this message translates to:
  /// **'Rol'**
  String get calendariLabelRol;

  /// No description provided for @calendariLabelEstat.
  ///
  /// In ca, this message translates to:
  /// **'Estat'**
  String get calendariLabelEstat;

  /// No description provided for @calendariRolAdministrador.
  ///
  /// In ca, this message translates to:
  /// **'Administrador'**
  String get calendariRolAdministrador;

  /// No description provided for @calendariRolMembre.
  ///
  /// In ca, this message translates to:
  /// **'Membre'**
  String get calendariRolMembre;

  /// No description provided for @calendariEstatConfirmat.
  ///
  /// In ca, this message translates to:
  /// **'Confirmat'**
  String get calendariEstatConfirmat;

  /// No description provided for @calendariEstatPendent.
  ///
  /// In ca, this message translates to:
  /// **'Pendent'**
  String get calendariEstatPendent;

  /// No description provided for @calendariEstatPendentConfirmacio.
  ///
  /// In ca, this message translates to:
  /// **'Pendent de confirmació'**
  String get calendariEstatPendentConfirmacio;

  /// No description provided for @estatCreador.
  ///
  /// In ca, this message translates to:
  /// **'Creador'**
  String get estatCreador;

  /// No description provided for @estatValidat.
  ///
  /// In ca, this message translates to:
  /// **'Validat'**
  String get estatValidat;

  /// No description provided for @estatApuntat.
  ///
  /// In ca, this message translates to:
  /// **'Apuntat'**
  String get estatApuntat;

  /// No description provided for @estatAmic.
  ///
  /// In ca, this message translates to:
  /// **'Amic'**
  String get estatAmic;

  /// No description provided for @whatsappShareMessage.
  ///
  /// In ca, this message translates to:
  /// **'Dona un cop d\'ull a aquesta activitat a PlanC: {titol}. Pots veure més detalls aquí: {url}'**
  String whatsappShareMessage(String titol, String url);

  /// No description provided for @postTooltipComentaris.
  ///
  /// In ca, this message translates to:
  /// **'Veure comentaris'**
  String get postTooltipComentaris;

  /// No description provided for @modeFoscLabel.
  ///
  /// In ca, this message translates to:
  /// **'Mode fosc'**
  String get modeFoscLabel;

  /// No description provided for @modeFoscSubtitol.
  ///
  /// In ca, this message translates to:
  /// **'Canvia l\'aparença de l\'aplicació'**
  String get modeFoscSubtitol;

  /// No description provided for @qualitatAireTitol.
  ///
  /// In ca, this message translates to:
  /// **'Qualitat de l\'aire'**
  String get qualitatAireTitol;

  /// No description provided for @qualitatAireBona.
  ///
  /// In ca, this message translates to:
  /// **'Bona'**
  String get qualitatAireBona;

  /// No description provided for @qualitatAireModerada.
  ///
  /// In ca, this message translates to:
  /// **'Moderada'**
  String get qualitatAireModerada;

  /// No description provided for @qualitatAireDolentaGrups.
  ///
  /// In ca, this message translates to:
  /// **'Dolenta per a grups sensibles'**
  String get qualitatAireDolentaGrups;

  /// No description provided for @qualitatAireDolenta.
  ///
  /// In ca, this message translates to:
  /// **'Dolenta'**
  String get qualitatAireDolenta;

  /// No description provided for @qualitatAireMoltDolenta.
  ///
  /// In ca, this message translates to:
  /// **'Molt dolenta'**
  String get qualitatAireMoltDolenta;

  /// No description provided for @qualitatAireEstacio.
  ///
  /// In ca, this message translates to:
  /// **'Estació: {nom}'**
  String qualitatAireEstacio(String nom);

  /// No description provided for @qualitatAireDistancia.
  ///
  /// In ca, this message translates to:
  /// **'{km} km de l\'activitat'**
  String qualitatAireDistancia(String km);

  /// No description provided for @qualitatAireNoDisponible.
  ///
  /// In ca, this message translates to:
  /// **'Dades no disponibles per a aquesta ubicació'**
  String get qualitatAireNoDisponible;

  /// No description provided for @valorarTitol.
  ///
  /// In ca, this message translates to:
  /// **'Deixa la teva valoració'**
  String get valorarTitol;

  /// No description provided for @valorarLabelQuedada.
  ///
  /// In ca, this message translates to:
  /// **'Quedada'**
  String get valorarLabelQuedada;

  /// No description provided for @valorarSelectQuedada.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona una quedada'**
  String get valorarSelectQuedada;

  /// No description provided for @valorarLabelPuntuacio.
  ///
  /// In ca, this message translates to:
  /// **'Puntuació'**
  String get valorarLabelPuntuacio;

  /// No description provided for @valorarLabelComentari.
  ///
  /// In ca, this message translates to:
  /// **'Comentari (opcional)'**
  String get valorarLabelComentari;

  /// No description provided for @valorarComentariHint.
  ///
  /// In ca, this message translates to:
  /// **'Escriu el teu comentari…'**
  String get valorarComentariHint;

  /// No description provided for @valorarSuccessWithPoints.
  ///
  /// In ca, this message translates to:
  /// **'Valoració enviada! Has guanyat {punts} punts de bonificació.'**
  String valorarSuccessWithPoints(int punts);

  /// No description provided for @valorarSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Valoració enviada correctament.'**
  String get valorarSuccess;

  /// No description provided for @valorarButtonNoPuntuacio.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona una puntuació'**
  String get valorarButtonNoPuntuacio;

  /// No description provided for @valorarButtonEnviar.
  ///
  /// In ca, this message translates to:
  /// **'Enviar valoració'**
  String get valorarButtonEnviar;

  /// No description provided for @valorarButtonNoQuedada.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona una quedada'**
  String get valorarButtonNoQuedada;

  /// No description provided for @valoracionsEmpty.
  ///
  /// In ca, this message translates to:
  /// **'Encara no hi ha ressenyes per a aquesta activitat'**
  String get valoracionsEmpty;

  /// No description provided for @valoracionsCount.
  ///
  /// In ca, this message translates to:
  /// **'{count, plural, one{1 valoració} other{{count} valoracions}}'**
  String valoracionsCount(int count);

  /// No description provided for @valoracionsMitjana.
  ///
  /// In ca, this message translates to:
  /// **'Puntuació mitjana'**
  String get valoracionsMitjana;

  /// No description provided for @valoracionsLaTeva.
  ///
  /// In ca, this message translates to:
  /// **'(la teva)'**
  String get valoracionsLaTeva;

  /// No description provided for @valoracionsCarregarMes.
  ///
  /// In ca, this message translates to:
  /// **'Carregar més'**
  String get valoracionsCarregarMes;

  /// No description provided for @valoracionsTitol.
  ///
  /// In ca, this message translates to:
  /// **'Valoracions'**
  String get valoracionsTitol;

  /// No description provided for @amicsApuntats.
  ///
  /// In ca, this message translates to:
  /// **'{count} amics apuntats'**
  String amicsApuntats(int count);

  /// No description provided for @mesAmics.
  ///
  /// In ca, this message translates to:
  /// **'+{count} amics'**
  String mesAmics(int count);

  /// No description provided for @nombreAssistents.
  ///
  /// In ca, this message translates to:
  /// **'{count} assistents'**
  String nombreAssistents(int count);

  /// No description provided for @valoracionsEmptyQuedada.
  ///
  /// In ca, this message translates to:
  /// **'Encara no hi ha valoracions per a aquesta quedada.'**
  String get valoracionsEmptyQuedada;

  /// No description provided for @seleccionaHora.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona l\'hora'**
  String get seleccionaHora;

  /// No description provided for @cancelLa.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·la'**
  String get cancelLa;

  /// No description provided for @dacord.
  ///
  /// In ca, this message translates to:
  /// **'D\'acord'**
  String get dacord;

  /// No description provided for @filterAirQualityLabel.
  ///
  /// In ca, this message translates to:
  /// **'Qualitat de l\'aire'**
  String get filterAirQualityLabel;

  /// No description provided for @filterAirQualityToggle.
  ///
  /// In ca, this message translates to:
  /// **'Buscar per qualitat de l\'aire'**
  String get filterAirQualityToggle;

  /// No description provided for @filterAirQualityLevelAny.
  ///
  /// In ca, this message translates to:
  /// **'Qualsevol'**
  String get filterAirQualityLevelAny;

  /// No description provided for @filterAirQualityErrorNotFound.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat activitats amb aquesta qualitat d\'aire a la zona'**
  String get filterAirQualityErrorNotFound;

  /// No description provided for @filterAirQualityErrorUnavailable.
  ///
  /// In ca, this message translates to:
  /// **'El servei de qualitat de l\'aire no està disponible ara mateix'**
  String get filterAirQualityErrorUnavailable;

  /// No description provided for @filterAirQualityDisabledTooltip.
  ///
  /// In ca, this message translates to:
  /// **'No disponible amb el filtre de qualitat de l\'aire'**
  String get filterAirQualityDisabledTooltip;

  /// No description provided for @feedTabActivities.
  ///
  /// In ca, this message translates to:
  /// **'Activitats'**
  String get feedTabActivities;

  /// No description provided for @feedTabPublications.
  ///
  /// In ca, this message translates to:
  /// **'Publicacions'**
  String get feedTabPublications;

  /// No description provided for @feedNoPublications.
  ///
  /// In ca, this message translates to:
  /// **'Encara no hi ha publicacions'**
  String get feedNoPublications;

  /// No description provided for @feedPublicationsError.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han pogut carregar les publicacions'**
  String get feedPublicationsError;

  /// No description provided for @feedPublicationsRetry.
  ///
  /// In ca, this message translates to:
  /// **'Reintentar'**
  String get feedPublicationsRetry;

  /// No description provided for @createPublicacioTitle.
  ///
  /// In ca, this message translates to:
  /// **'Nova publicació'**
  String get createPublicacioTitle;

  /// No description provided for @createPublicacioDescriptionHint.
  ///
  /// In ca, this message translates to:
  /// **'Escriu alguna cosa...'**
  String get createPublicacioDescriptionHint;

  /// No description provided for @createPublicacioSelectActivity.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona una activitat'**
  String get createPublicacioSelectActivity;

  /// No description provided for @createPublicacioLoadingActivities.
  ///
  /// In ca, this message translates to:
  /// **'Carregant activitats...'**
  String get createPublicacioLoadingActivities;

  /// No description provided for @createPublicacioNoActivities.
  ///
  /// In ca, this message translates to:
  /// **'No estàs apuntat a cap activitat activa'**
  String get createPublicacioNoActivities;

  /// No description provided for @createPublicacioAddImage.
  ///
  /// In ca, this message translates to:
  /// **'Afegir imatge'**
  String get createPublicacioAddImage;

  /// No description provided for @createPublicacioChangeImage.
  ///
  /// In ca, this message translates to:
  /// **'Canviar imatge'**
  String get createPublicacioChangeImage;

  /// No description provided for @createPublicacioPublish.
  ///
  /// In ca, this message translates to:
  /// **'Publicar'**
  String get createPublicacioPublish;

  /// No description provided for @createPublicacioRequiredDesc.
  ///
  /// In ca, this message translates to:
  /// **'Escriu una descripció'**
  String get createPublicacioRequiredDesc;

  /// No description provided for @createPublicacioRequiredActivity.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona una activitat'**
  String get createPublicacioRequiredActivity;

  /// No description provided for @createPublicacioSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Publicació creada correctament!'**
  String get createPublicacioSuccess;

  /// No description provided for @createPublicacioError.
  ///
  /// In ca, this message translates to:
  /// **'Error en crear la publicació'**
  String get createPublicacioError;

  /// No description provided for @selectActivity.
  ///
  /// In ca, this message translates to:
  /// **'Selecciona sobre quina activitat vols publicar'**
  String get selectActivity;

  /// No description provided for @searchActivity.
  ///
  /// In ca, this message translates to:
  /// **'Busca l\'activitat'**
  String get searchActivity;

  /// No description provided for @noActivitiesFound.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat activitats recents'**
  String get noActivitiesFound;

  /// No description provided for @mentionFriends.
  ///
  /// In ca, this message translates to:
  /// **'Menciona a amics'**
  String get mentionFriends;

  /// No description provided for @done.
  ///
  /// In ca, this message translates to:
  /// **'Llest'**
  String get done;

  /// No description provided for @searchFriends.
  ///
  /// In ca, this message translates to:
  /// **'Busca a amics'**
  String get searchFriends;

  /// No description provided for @noFriendsFound.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat amics'**
  String get noFriendsFound;

  /// No description provided for @createPost.
  ///
  /// In ca, this message translates to:
  /// **'Crear publicació'**
  String get createPost;

  /// No description provided for @createPostWarning.
  ///
  /// In ca, this message translates to:
  /// **'Afegeix el tipus d\'activitat i almenys una imatge per publicar!'**
  String get createPostWarning;

  /// No description provided for @posting.
  ///
  /// In ca, this message translates to:
  /// **'Publicant'**
  String get posting;

  /// No description provided for @post.
  ///
  /// In ca, this message translates to:
  /// **'Publicar'**
  String get post;

  /// No description provided for @writeMessage.
  ///
  /// In ca, this message translates to:
  /// **'Escriu el teu missatge aquí...'**
  String get writeMessage;

  /// No description provided for @addMultimedia.
  ///
  /// In ca, this message translates to:
  /// **'Afegir multimèdia'**
  String get addMultimedia;

  /// No description provided for @editPost.
  ///
  /// In ca, this message translates to:
  /// **'Editar publicació'**
  String get editPost;

  /// No description provided for @editPostWarning.
  ///
  /// In ca, this message translates to:
  /// **'La publicació ha de tenir almenys una imatge'**
  String get editPostWarning;

  /// No description provided for @saving.
  ///
  /// In ca, this message translates to:
  /// **'Desant'**
  String get saving;

  /// No description provided for @save.
  ///
  /// In ca, this message translates to:
  /// **'Desar'**
  String get save;

  /// No description provided for @postTitle.
  ///
  /// In ca, this message translates to:
  /// **'Publicació'**
  String get postTitle;

  /// No description provided for @postDeleteMenuItem.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar publicació'**
  String get postDeleteMenuItem;

  /// No description provided for @postEditMenuItem.
  ///
  /// In ca, this message translates to:
  /// **'Editar publicació'**
  String get postEditMenuItem;

  /// No description provided for @postDeleteDialogTitle.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar publicació'**
  String get postDeleteDialogTitle;

  /// No description provided for @postDeleteDialogBody.
  ///
  /// In ca, this message translates to:
  /// **'Estàs segur que vols eliminar aquesta publicació? Aquesta acció no es pot desfer.'**
  String get postDeleteDialogBody;

  /// No description provided for @postDeleteCancel.
  ///
  /// In ca, this message translates to:
  /// **'Cancel·lar'**
  String get postDeleteCancel;

  /// No description provided for @postDeleteConfirm.
  ///
  /// In ca, this message translates to:
  /// **'Eliminar'**
  String get postDeleteConfirm;

  /// No description provided for @postDeletedSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Publicació eliminada correctament'**
  String get postDeletedSuccess;

  /// No description provided for @postLikesCount.
  ///
  /// In ca, this message translates to:
  /// **'{count} m\'agrades'**
  String postLikesCount(int count);

  /// No description provided for @postViewComments.
  ///
  /// In ca, this message translates to:
  /// **'Veure els {count} comentaris'**
  String postViewComments(int count);

  /// No description provided for @postSaveAction.
  ///
  /// In ca, this message translates to:
  /// **'Guardar'**
  String get postSaveAction;

  /// No description provided for @postUnsaveAction.
  ///
  /// In ca, this message translates to:
  /// **'Deixar de guardar'**
  String get postUnsaveAction;

  /// No description provided for @postSavedSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Publicació guardada'**
  String get postSavedSuccess;

  /// No description provided for @postUnsavedSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Publicació eliminada dels guardats'**
  String get postUnsavedSuccess;

  /// No description provided for @postSaveError.
  ///
  /// In ca, this message translates to:
  /// **'Error en guardar la publicació'**
  String get postSaveError;

  /// No description provided for @postLikedByTitle.
  ///
  /// In ca, this message translates to:
  /// **'M\'agrades'**
  String get postLikedByTitle;

  /// No description provided for @postNoLikes.
  ///
  /// In ca, this message translates to:
  /// **'Sigues el primer en donar m\'agrada!'**
  String get postNoLikes;

  /// No description provided for @postLikesError.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar la llista'**
  String get postLikesError;

  /// No description provided for @comentarisTitle.
  ///
  /// In ca, this message translates to:
  /// **'Comentaris'**
  String get comentarisTitle;

  /// No description provided for @comentarisError.
  ///
  /// In ca, this message translates to:
  /// **'Error al carregar els comentaris'**
  String get comentarisError;

  /// No description provided for @comentarisEmpty.
  ///
  /// In ca, this message translates to:
  /// **'Encara no hi ha comentaris.\nSigues el primer!'**
  String get comentarisEmpty;

  /// No description provided for @comentariResponder.
  ///
  /// In ca, this message translates to:
  /// **'Respondre'**
  String get comentariResponder;

  /// No description provided for @comentariResponent.
  ///
  /// In ca, this message translates to:
  /// **'Responent a {nom}'**
  String comentariResponent(String nom);

  /// No description provided for @comentariHint.
  ///
  /// In ca, this message translates to:
  /// **'Escriu un comentari...'**
  String get comentariHint;

  /// No description provided for @comentariHintReply.
  ///
  /// In ca, this message translates to:
  /// **'Respon a {nom}...'**
  String comentariHintReply(String nom);

  /// No description provided for @createPostTitle.
  ///
  /// In ca, this message translates to:
  /// **'Crear publicació'**
  String get createPostTitle;

  /// No description provided for @createPostRequiredFields.
  ///
  /// In ca, this message translates to:
  /// **'Afegeix el tipus d\'activitat i almenys una imatge per publicar!'**
  String get createPostRequiredFields;

  /// No description provided for @createPostImageError.
  ///
  /// In ca, this message translates to:
  /// **'No s\'ha pogut carregar la imatge: {error}'**
  String createPostImageError(String error);

  /// No description provided for @createPostPublishing.
  ///
  /// In ca, this message translates to:
  /// **'Publicant...'**
  String get createPostPublishing;

  /// No description provided for @createPostPublish.
  ///
  /// In ca, this message translates to:
  /// **'Publicar'**
  String get createPostPublish;

  /// No description provided for @createPostActivityPickerTitle.
  ///
  /// In ca, this message translates to:
  /// **'Què estàs fent?'**
  String get createPostActivityPickerTitle;

  /// No description provided for @createPostActivitySearch.
  ///
  /// In ca, this message translates to:
  /// **'Cerca activitat...'**
  String get createPostActivitySearch;

  /// No description provided for @createPostActivityEmpty.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat activitats'**
  String get createPostActivityEmpty;

  /// No description provided for @createPostMentionTitle.
  ///
  /// In ca, this message translates to:
  /// **'Mencionar un amic'**
  String get createPostMentionTitle;

  /// No description provided for @createPostMentionSearch.
  ///
  /// In ca, this message translates to:
  /// **'Cerca per nom o username...'**
  String get createPostMentionSearch;

  /// No description provided for @createPostMentionEmpty.
  ///
  /// In ca, this message translates to:
  /// **'No s\'han trobat amics'**
  String get createPostMentionEmpty;

  /// No description provided for @createPostHint.
  ///
  /// In ca, this message translates to:
  /// **'Escriu el teu missatge aquí...'**
  String get createPostHint;

  /// No description provided for @createPostAddMedia.
  ///
  /// In ca, this message translates to:
  /// **'Afegir multimèdia'**
  String get createPostAddMedia;

  /// No description provided for @createPostErrorActivity.
  ///
  /// In ca, this message translates to:
  /// **'Error en carregar activitats: {error}'**
  String createPostErrorActivity(String error);

  /// No description provided for @createPostErrorFriends.
  ///
  /// In ca, this message translates to:
  /// **'Error en carregar amics: {error}'**
  String createPostErrorFriends(String error);

  /// No description provided for @createPostError.
  ///
  /// In ca, this message translates to:
  /// **'Error en crear la publicació: {error}'**
  String createPostError(String error);

  /// No description provided for @timeJustNow.
  ///
  /// In ca, this message translates to:
  /// **'Ara'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In ca, this message translates to:
  /// **'Fa {n} min'**
  String timeMinutesAgo(int n);

  /// No description provided for @timeHoursAgo.
  ///
  /// In ca, this message translates to:
  /// **'Fa {n} h'**
  String timeHoursAgo(int n);

  /// No description provided for @timeYesterday.
  ///
  /// In ca, this message translates to:
  /// **'Ahir'**
  String get timeYesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In ca, this message translates to:
  /// **'Fa {n} dies'**
  String timeDaysAgo(int n);

  /// No description provided for @comentariShowReplies.
  ///
  /// In ca, this message translates to:
  /// **'Veure {count} respostes'**
  String comentariShowReplies(int count);

  /// No description provided for @comentariHideReplies.
  ///
  /// In ca, this message translates to:
  /// **'Amagar respostes'**
  String get comentariHideReplies;

  /// No description provided for @preferitsTabActivitats.
  ///
  /// In ca, this message translates to:
  /// **'Activitats'**
  String get preferitsTabActivitats;

  /// No description provided for @preferitsTabPublicacions.
  ///
  /// In ca, this message translates to:
  /// **'Publicacions'**
  String get preferitsTabPublicacions;

  /// No description provided for @preferitsPublicacionsEmptyTitle.
  ///
  /// In ca, this message translates to:
  /// **'Encara no tens publicacions guardades'**
  String get preferitsPublicacionsEmptyTitle;

  /// No description provided for @preferitsPublicacionsEmptyDescription.
  ///
  /// In ca, this message translates to:
  /// **'Guarda publicacions per veure-les aquí.'**
  String get preferitsPublicacionsEmptyDescription;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In ca, this message translates to:
  /// **'Verifica el teu correu'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailBody.
  ///
  /// In ca, this message translates to:
  /// **'Hem enviat un correu de verificació a {email}. Obre-l i fes clic a l\'enllaç per activar el compte.'**
  String verifyEmailBody(String email);

  /// No description provided for @verifyEmailAlreadyVerified.
  ///
  /// In ca, this message translates to:
  /// **'Ja he verificat'**
  String get verifyEmailAlreadyVerified;

  /// No description provided for @verifyEmailResend.
  ///
  /// In ca, this message translates to:
  /// **'Reenviar correu'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailResendSuccess.
  ///
  /// In ca, this message translates to:
  /// **'Correu reenviat correctament'**
  String get verifyEmailResendSuccess;

  /// No description provided for @verifyEmailNotYet.
  ///
  /// In ca, this message translates to:
  /// **'Encara no has verificat el correu electrònic'**
  String get verifyEmailNotYet;

  /// No description provided for @verifyEmailBackToLogin.
  ///
  /// In ca, this message translates to:
  /// **'Tornar a l\'inici'**
  String get verifyEmailBackToLogin;
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
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
