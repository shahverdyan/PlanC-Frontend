// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get titolApp => 'PlanC';

  @override
  String holaUsuari(String nom) {
    return 'Hola, $nom!';
  }

  @override
  String get seleccionaIdioma => 'Selecciona un idioma:';

  @override
  String get catala => 'Català';

  @override
  String get espanol => 'Español';

  @override
  String get angles => 'English';

  @override
  String get configuracioTitol => 'Configuració';

  @override
  String get seccioPreferencies => 'Preferències';

  @override
  String get idiomaLabel => 'Idioma de l\'aplicació';

  @override
  String get errorGoogleMaps =>
      'No s\'ha pogut obrir Google Maps al dispositiu';

  @override
  String get detallActivitatTitol => 'Detall de l\'activitat';

  @override
  String get compartirActivitatTooltip => 'Compartir activitat';

  @override
  String get treurePreferidesTooltip => 'Treure de preferides';

  @override
  String get afegirPreferidesTooltip => 'Afegir a preferides';

  @override
  String get activitatAfegidaPreferides => 'Activitat afegida a preferides';

  @override
  String get activitatEliminadaPreferides =>
      'Activitat eliminada de preferides';

  @override
  String errorActualitzarPreferides(String error) {
    return 'No s\'ha pogut actualitzar preferides: $error';
  }

  @override
  String get descripcioTitol => 'Descripció';

  @override
  String get quanTitol => 'Quan';

  @override
  String get iniciLabel => 'Inici';

  @override
  String get fiLabel => 'Fi';

  @override
  String get onTitol => 'On';

  @override
  String get espaiLabel => 'Espai';

  @override
  String get adrecaLabel => 'Adreça';

  @override
  String get obrirGoogleMapsButton => 'Obrir a Google Maps';

  @override
  String get entradesTitol => 'Entrades';

  @override
  String get compartirXatTitol => 'Compartir a un xat';

  @override
  String get cercaXatHint => 'Cerca un xat o grup...';

  @override
  String activitatCompartidaExit(String chatName) {
    return 'Activitat compartida a: $chatName';
  }

  @override
  String errorCompartir(String error) {
    return 'Error al compartir: $error';
  }

  @override
  String errorCarregarXats(String error) {
    return 'Error al carregar xats: $error';
  }

  @override
  String get noXatsTrobats => 'No s\'han trobat xats';

  @override
  String get enviarButton => 'Enviar';

  @override
  String get authDescubreixTitle => 'Descobreix';

  @override
  String get authConnectaTitle => 'Connecta';

  @override
  String get authCreixTitle => 'Creix';

  @override
  String get authDescubreixDesc =>
      'Troba esdeveniments culturals a Catalunya personalitzats pels teus interessos.';

  @override
  String get authConnectaDesc =>
      'Coneix gent amb els mateixos gusts culturals i feu pinya.';

  @override
  String get authCreixDesc => 'Guanya insígnies gaudint de la cultura.';

  @override
  String get authLoginButton => 'Inicia Sessió';

  @override
  String get authCreateAccountButton => 'Crea un compte';

  @override
  String get loginTitle => 'Inicia Sessió';

  @override
  String get loginWelcomeBack => 'Encantat de tornar-te a veure';

  @override
  String get loginEmailOrUsernameLabel => 'Correu electrònic / Nom d\'usuari';

  @override
  String get loginPasswordLabel => 'Contrasenya';

  @override
  String get loginForgotPassword => 'Has oblidat la contrasenya?';

  @override
  String get loginLoadingButton => 'Carregant';

  @override
  String get loginSignInButton => 'Iniciar Sessió';

  @override
  String get loginContinueWith => 'o continua amb';

  @override
  String get loginGoogleButton => 'Continua amb Google';

  @override
  String get loginNoAccount => 'No tens compte?';

  @override
  String get loginSignUpHere => 'Registra\'t aquí';

  @override
  String get loginRequiredField => 'Camp obligatori';

  @override
  String get loginErrorFallback => 'Error d\'inici de sessió';

  @override
  String get loginSuccessSnackbar => 'Sessió iniciada correctament';

  @override
  String get registerCreateAccountTitle => 'Crea el teu compte';

  @override
  String get registerUsernameLabel => 'Nom d\'usuari';

  @override
  String get registerEmailLabel => 'Correu electrònic';

  @override
  String get registerPasswordLabel => 'Contrasenya';

  @override
  String get registerRepeatPasswordLabel => 'Confirma la contrasenya';

  @override
  String get registerLoadingButton => 'Carregant';

  @override
  String get registerSubmitButton => 'Registra\'t';

  @override
  String get registerUsernameMinError =>
      'El nom d\'usuari ha de contenir mínim 3 caràcters';

  @override
  String get registerUsernameMaxError =>
      'El nom d\'usuari ha de contenir màxim 20 caràcters';

  @override
  String get registerEmailInvalidError =>
      'El camp ha de contenir una adressa electrònica vàlida';

  @override
  String get registerEmailTaken => 'Aquest correu ja està en ús';

  @override
  String get registerUsernameTaken => 'Aquest nom d\'usuari ja està en ús';

  @override
  String get registerChecking => 'Comprovant...';

  @override
  String get registerPasswordInvalidError => 'Contrasenya invàlida';

  @override
  String get registerPasswordMismatchError =>
      'Les contrasenyes no coincideixen';

  @override
  String get registerErrorFallback => 'Error al registrarse';

  @override
  String get registerSuccessSnackbar => '¡Cuenta creada exitosamente!';

  @override
  String get registerVerificationTitle => 'Compte creat!';

  @override
  String get registerVerificationSubtitle => 'Benvingut/da a PlanC';

  @override
  String registerVerificationBody(String email) {
    return 'Hem enviat un correu de verificació a $email. Verifica el teu compte per gaudir de totes les funcionalitats.';
  }

  @override
  String get registerVerificationButton => 'Entrar a l\'app';

  @override
  String get registerContinueButton => 'Continua';

  @override
  String get registerSkipButton => 'Ometre';

  @override
  String get registerStep2Title => 'Sobre tu';

  @override
  String get registerStep3Title => 'Foto de perfil';

  @override
  String get registerNameLabel => 'Nom';

  @override
  String get registerSurnameLabel => 'Cognoms';

  @override
  String get registerBioLabel => 'Biografia';

  @override
  String get registerBioHint => 'Explica\'ns alguna cosa de tu (opcional)...';

  @override
  String get registerAddPhotoButton => 'Afegir foto';

  @override
  String get registerNameRequiredError => 'El nom és obligatori';

  @override
  String get registerSurnameRequiredError => 'Els cognoms són obligatoris';

  @override
  String get registerBioMaxError => 'Màxim 160 caràcters';

  @override
  String registerStepOf(int current, int total) {
    return 'Pas $current de $total';
  }

  @override
  String get forgotPasswordTitle => 'Recupera la teva contrasenya';

  @override
  String get forgotPasswordDescription =>
      'Introdueix el teu correu i rebràs un correu electrònic amb les indicacions per restablir-la';

  @override
  String get forgotPasswordEmailInvalid => 'Introdueix un correu vàlid';

  @override
  String get forgotPasswordButton => 'Recuperar contrasenya';

  @override
  String get forgotPasswordEmailSent =>
      'S\'ha enviat un correu a l\'adressa indicada';

  @override
  String get forgotPasswordGoToLogin => 'Anar al login';

  @override
  String get authWrapperCheckingSession => 'Comprovant sessió...';

  @override
  String get deleteAccountTitle => 'Eliminar compte';

  @override
  String get deleteAccountIrreversibleWarning =>
      'Aquesta acció és irreversible';

  @override
  String get deleteAccountWarningDetails =>
      'S\'eliminaran permanentment: el teu perfil, publicacions, comentaris, amistats i totes les dades personals.';

  @override
  String get deleteAccountTypeConfirmInstruction =>
      'Escriu \"ELIMINAR\" per confirmar';

  @override
  String get deleteAccountTypeConfirmLabel => 'Escriu ELIMINAR';

  @override
  String get deleteAccountTypeConfirmRequired =>
      'Escriu \"ELIMINAR\" per confirmar';

  @override
  String get deleteAccountPasswordLabel =>
      'Introdueix la teva contrasenya per confirmar';

  @override
  String get deleteAccountPasswordRequired => 'Introdueix la teva contrasenya';

  @override
  String get deleteAccountDialogTitle => 'Estàs segur?';

  @override
  String get deleteAccountDialogContent =>
      'Aquesta acció no es pot desfer. Totes les teves dades s\'eliminaran permanentment.';

  @override
  String get deleteAccountDialogCancel => 'Cancel·lar';

  @override
  String get deleteAccountDialogConfirm => 'Eliminar definitivament';

  @override
  String get deleteAccountSuccess =>
      'El teu compte s\'ha eliminat correctament';

  @override
  String get deleteAccountErrorFallback => 'Error eliminant el compte';

  @override
  String get homeTabFeed => 'Feed';

  @override
  String get homeTabExplora => 'Explora';

  @override
  String get navInici => 'Inici';

  @override
  String get feedDiscover => 'Descobreix';

  @override
  String get feedTrending => 'Tendències';

  @override
  String get feedCategories => 'Categories';

  @override
  String get feedRecommended => 'Recomanat per a tu';

  @override
  String get feedNearby => 'A prop teu';

  @override
  String get feedQuedades => 'Quedades obertes';

  @override
  String get feedQuedadesEmpty => 'No hi ha quedades disponibles ara';

  @override
  String feedQuedadesParticipants(int current, int max) {
    return '$current/$max participants';
  }

  @override
  String get feedQuedadesJoin => 'Veure activitat';

  @override
  String get searchDiscoverTitle => 'Suggeriments';

  @override
  String get feedSeeAll => 'Veure tot';

  @override
  String get feedFree => 'Gratuït';

  @override
  String get feedInfoUnavailable => 'Info no disp.';

  @override
  String get feedLoadError => 'No s\'han pogut carregar';

  @override
  String get activitatDetailError => 'No s\'ha pogut carregar l\'activitat';

  @override
  String get feedEmpty => 'No hi ha activitats';

  @override
  String get feedNoMoreActivities => 'No hi ha més activitats';

  @override
  String get feedNoCategoryActivities =>
      'No hi ha activitats en aquesta categoria';

  @override
  String get feedRetry => 'Torna-ho a provar';

  @override
  String get feedLoadingMore => 'Carregant més...';

  @override
  String get homeTabMap => 'Mapa';

  @override
  String get homeTabSearch => 'Cerca';

  @override
  String get homeTabChat => 'Comunitat';

  @override
  String get homeTabNotifications => 'Notificacions';

  @override
  String get homeTabCalendar => 'Calendari';

  @override
  String get homeTabProfile => 'Perfil';

  @override
  String get profileFriendsBox => 'Amics';

  @override
  String get profilePostsBox => 'Publicacions';

  @override
  String get profileNoDescription => 'No descripció encara';

  @override
  String get profileEditButton => 'Editar perfil';

  @override
  String get profileNoPosts => 'Encara no hi ha publicacions';

  @override
  String get profileEnviarMissatge => 'Enviar missatge';

  @override
  String get profileXatNoDisponible =>
      'No s\'ha trobat cap xat amb aquest usuari';

  @override
  String get profilePublicationsSection => 'Publicacions';

  @override
  String get profileTrophiesSection => 'Trofeus';

  @override
  String get profileNoTrophies =>
      'Encara no tens trofeus. Participa en activitats per guanyar-ne!';

  @override
  String get trophyLevelLabel => 'Nivell';

  @override
  String get actualRankLabel => 'Rang actual';

  @override
  String get achievedLevelLabel => 'Nivell aconseguit';

  @override
  String get levelProgressLabel => 'Progrés de nivell';

  @override
  String get pointsForNextLevelLabel => ' punts per arribar al nivell';

  @override
  String get close => 'Tancar';

  @override
  String get editProfileTitle => 'Edita Perfil';

  @override
  String get editProfileImageUpdated =>
      'Foto de perfil actualitzada correctament';

  @override
  String editProfileImageError(String error) {
    return 'Error al actualizar la foto: $error';
  }

  @override
  String get editProfileUsernameLabel => 'Usuari';

  @override
  String get editProfileDescriptionLabel => 'Biografia';

  @override
  String get editProfileNameLabel => 'Nom';

  @override
  String get editProfileSurnameLabel => 'Cognom';

  @override
  String get editProfileLogoutButton => 'Tancar sessió';

  @override
  String get editProfileDangerZone => 'Zona perillosa';

  @override
  String get editProfileDeleteAccount => 'Eliminar compte';

  @override
  String get editProfileFieldSave => 'Save';

  @override
  String get friendsScreenTitle => 'Amistats';

  @override
  String get friendsScreenSubtitle =>
      'Aquí pots veure les sol·licituds rebudes i les enviades pendents.';

  @override
  String get friendsScreenSectionReceived => 'Sol·licituds rebudes';

  @override
  String get friendsScreenSectionSent => 'Sol·licituds enviades';

  @override
  String get friendsScreenNoReceived =>
      'No tens cap sol·licitud rebuda pendent.';

  @override
  String get friendsScreenNoSent => 'No tens cap sol·licitud enviada pendent.';

  @override
  String get friendsScreenWantsFriend => 'Vol ser el teu amic';

  @override
  String get friendsScreenAcceptButton => 'Acceptar';

  @override
  String get friendsScreenRejectButton => 'Rebutjar';

  @override
  String get friendsScreenCancelButton => 'Cancel·lar';

  @override
  String get friendsScreenPendingRequest => 'Sol·licitud pendent';

  @override
  String get friendsScreenRetry => 'Reintentar';

  @override
  String get friendsScreenAcceptedSuccess =>
      'Sol·licitud acceptada correctament';

  @override
  String get friendsScreenRejectedSuccess =>
      'Sol·licitud rebutjada correctament';

  @override
  String get friendsScreenCanceledSuccess =>
      'Sol·licitud cancel·lada correctament';

  @override
  String get friendsListTitle => 'Amics';

  @override
  String get friendsListSearchHint => 'Cerca un amic...';

  @override
  String get friendsListNoResults => 'Cap amic coincideix amb la cerca.';

  @override
  String get friendsListNoneOwn => 'Encara no tens amics.';

  @override
  String get friendsListNoneOther => 'Aquest usuari no té amics.';

  @override
  String get friendsListRemoveTooltip => 'Eliminar amic';

  @override
  String get friendsListRemoveDialogTitle => 'Eliminar amic';

  @override
  String friendsListRemoveDialogContent(String nom) {
    return 'Vols eliminar $nom de la teva llista d\'amics?';
  }

  @override
  String get friendsListRemoveCancel => 'Cancel·lar';

  @override
  String get friendsListRemoveConfirm => 'Eliminar';

  @override
  String get friendsListRetry => 'Reintentar';

  @override
  String get relationshipRemoveFriend => 'Eliminar amic';

  @override
  String get relationshipAccept => 'Acceptar';

  @override
  String get relationshipReject => 'Rebutjar';

  @override
  String get relationshipRequestSent => 'Sol·licitud enviada';

  @override
  String get relationshipCancel => 'Cancel·lar';

  @override
  String get relationshipSendRequest => 'Enviar sol·licitud d\'amistat';

  @override
  String get relationshipRetry => 'Reintentar';

  @override
  String relationshipErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get searchTabAll => 'Tots';

  @override
  String get searchTabProfiles => 'Perfils';

  @override
  String get searchTabActivities => 'Activitats';

  @override
  String get searchTabSpaces => 'Espais';

  @override
  String get searchHint => 'Cerca activitats, espais...';

  @override
  String get searchFiltersTooltip => 'Filtres';

  @override
  String get searchRecentTitle => 'Cerques recents';

  @override
  String searchActivitiesHeader(int count) {
    return 'Activitats ($count)';
  }

  @override
  String searchSpacesHeader(int count) {
    return 'Espais ($count)';
  }

  @override
  String get filterTitle => 'Filtres';

  @override
  String get filterClear => 'Netejar filtres';

  @override
  String get filterPriceLabel => 'Preu';

  @override
  String get filterPriceAll => 'Tots';

  @override
  String get filterPriceFree => 'Gratuït';

  @override
  String get filterPricePaid => 'De pagament';

  @override
  String filterDistanceLabel(int km) {
    return 'Distància: $km km';
  }

  @override
  String get filterLocationPermissionNeeded =>
      'Cal concedir permisos d\'ubicació per usar aquest filtre.';

  @override
  String get filterDateLabel => 'Data';

  @override
  String get filterDateAll => 'Totes les dates';

  @override
  String get filterDateToday => 'Avui';

  @override
  String get filterDateWeekend => 'Cap de setmana';

  @override
  String get filterDateCalendar => '📅 Calendari';

  @override
  String get filterApply => 'Aplicar filtres';

  @override
  String get filterNoLocation =>
      'No s\'ha pogut obtenir la ubicació. El filtre de distància no s\'aplicarà.';

  @override
  String get emptySearchFilterTitle =>
      'Cap activitat coincideix amb els filtres';

  @override
  String get emptySearchSearchTitle => 'No s\'ha trobat cap coincidència';

  @override
  String get emptySearchFilterDescription =>
      'Prova d\'ampliar la distància, canviar les dates o modificar els filtres de preu.';

  @override
  String emptySearchSearchDescription(String terme) {
    return 'No hem trobat resultats per \"$terme\".\nProva amb un altre terme o explora les categories.';
  }

  @override
  String get emptySearchModifyFilters => 'Modificar filtres';

  @override
  String get emptySearchCategoryMusic => 'Música';

  @override
  String get emptySearchCategoryTheater => 'Teatre';

  @override
  String get emptySearchCategoryArt => 'Art';

  @override
  String get emptySearchCategoryCinema => 'Cinema';

  @override
  String get chatNotificationsTitle => 'Comunitat';

  @override
  String get chatTabChats => 'Xats';

  @override
  String get chatTabFriendships => 'Amistats';

  @override
  String get myChatsTitle => 'Els meus xats';

  @override
  String chatListError(String error) {
    return 'Error al carregar xats: $error';
  }

  @override
  String get chatListEmpty =>
      'Encara no tens cap xat actiu.\nUneix-te a una quedada!';

  @override
  String get chatDeleteDialogTitle => 'Eliminar xat';

  @override
  String chatDeleteDialogContent(String name) {
    return 'Estàs segur que vols eliminar \"$name\"? L\'historial de missatges desapareixerà per a tu.';
  }

  @override
  String get chatDeleteCancel => 'Cancel·lar';

  @override
  String get chatDeleteConfirm => 'Eliminar';

  @override
  String chatDeletedSnackbar(String name) {
    return '$name eliminat';
  }

  @override
  String get chatUnmuteAction => 'Dessilenciar xat';

  @override
  String get chatMuteAction => 'Silenciar xat';

  @override
  String chatUnmutedSnackbar(String name) {
    return '$name dessilenciat';
  }

  @override
  String chatMutedSnackbar(String name) {
    return '$name silenciat';
  }

  @override
  String chatRoomNotFoundError(String error) {
    return 'Error al enviar missatge: $error';
  }

  @override
  String chatRoomImagePickError(String error) {
    return 'Error al seleccionar imatge: $error';
  }

  @override
  String chatRoomImageCaptureError(String error) {
    return 'Error al capturar imatge: $error';
  }

  @override
  String get chatRoomTodayLabel => 'AVUI';

  @override
  String get chatRoomYesterdayLabel => 'AHIR';

  @override
  String get chatRoomAttachmentGallery => 'Galeria';

  @override
  String get chatRoomAttachmentCamera => 'Càmera';

  @override
  String get chatRoomNoMessages => 'Sense missatges encara';

  @override
  String get chatRoomStartConversation => 'Comença la conversa!';

  @override
  String get chatRoomLoadOlder => 'Cargar missatges més antics';

  @override
  String get chatRoomSomeoneTyping => 'Algú està escrivint...';

  @override
  String get chatRoomInactiveBannerTitle => 'Xat inactiu';

  @override
  String get chatRoomInactiveBannerBody =>
      'Aquest xat ja no permet enviar missatges. Pot ser per un d\'aquests motius:\n\n• La quedada va tenir lloc fa més de 48 hores i el xat s\'ha tancat automàticament.\n• Un administrador va cancel·lar la quedada i el xat va quedar bloquejat.';

  @override
  String get chatRoomReadOnlyNotice => 'Xat inactiu · Només lectura';

  @override
  String get chatRoomInputHint => 'Escriu un missatge...';

  @override
  String get chatRoomMuteUnmuteError => 'Error al canviar l\'estat de silenci';

  @override
  String get chatRoomMuteOff => 'Notificacions activades';

  @override
  String get chatRoomMuteOn => 'Xat silenciat';

  @override
  String get chatRoomActivityError => 'Error al cargar la activitat';

  @override
  String get chatRoomActivityNoTitle => 'Sense títol';

  @override
  String get chatRoomActivityNoLocation => 'Sense ubicació';

  @override
  String get chatRoomActivityCategoryOther => 'Altres';

  @override
  String get chatRoomViewActivity => 'Veure activitat';

  @override
  String get chatDetailsAppBarTitle => 'Detalls del xat';

  @override
  String get chatDetailsLoadError => 'Error al carregar els detalls del xat';

  @override
  String get chatDetailsFallbackTitle => 'Detalls';

  @override
  String get chatDetailsTypeFriendGroup => 'Grup d\'amics';

  @override
  String get chatDetailsTypeMeetup => 'Quedada';

  @override
  String get chatDetailsTypeIndividual => 'Xat Individual';

  @override
  String get chatDetailsPhotoUpdateNotice =>
      'L\'actualització de foto requereix suport del servidor (Properament)';

  @override
  String get chatDetailsPhotoUpdateSuccess =>
      'Foto del grup actualitzada correctament';

  @override
  String chatDetailsPhotoUpdateError(String error) {
    return 'Error actualitzant la foto: $error';
  }

  @override
  String get chatDetailsMembersHeader => 'MEMBRES DEL XAT';

  @override
  String get chatDetailsLeaveChat => 'Abandonar Xat';

  @override
  String get chatDetailsDeleteChat => 'Eliminar Xat';

  @override
  String get chatDetailsLeaveGroupDialogTitle => 'Abandonar Grup';

  @override
  String get chatDetailsDeleteChatDialogTitle => 'Eliminar Xat';

  @override
  String chatDetailsLeaveGroupDialogContent(String name) {
    return 'Estàs segur que vols abandonar \"$name\"? Deixaràs de rebre missatges d\'aquest grup.';
  }

  @override
  String chatDetailsDeleteChatDialogContent(String name) {
    return 'Estàs segur que vols eliminar \"$name\"? L\'historial desapareixerà.';
  }

  @override
  String get chatDetailsActionCancel => 'Cancel·lar';

  @override
  String get chatDetailsLeaveButton => 'Abandonar';

  @override
  String get chatDetailsDeleteButton => 'Eliminar';

  @override
  String get chatDetailsGroupLeftSnackbar => 'Has abandonat el grup';

  @override
  String get chatDetailsChatDeletedSnackbar => 'Xat eliminat';

  @override
  String get chatDetailsActionError => 'Error realitzant l\'acció';

  @override
  String get veurQuedades => 'Veure quedades';

  @override
  String get mostrarMes => 'Mostra més';

  @override
  String get mostrarMenys => 'Mostra menys';

  @override
  String get chatDetailsQuedadaInfoHeader => 'INFORMACIÓ DE LA QUEDADA';

  @override
  String get chatDetailsQuedadaActivity => 'Activitat';

  @override
  String get chatDetailsQuedadaDate => 'Data';

  @override
  String get chatDetailsQuedadaViewActivity => 'Veure activitat';

  @override
  String groupsActivityTitle(String titol) {
    return 'Quedades: $titol';
  }

  @override
  String groupsLoadError(String error) {
    return 'Error al carregar les quedades:\n$error';
  }

  @override
  String get groupsEmpty =>
      'Encara no hi ha quedades per aquesta activitat.\nSigues el primer en crear-ne una!';

  @override
  String get groupsCreateButton => 'Crear Quedada';

  @override
  String get groupFormEditTitle => 'Editar Quedada';

  @override
  String get groupFormCreateTitle => 'Crear Quedada';

  @override
  String get groupFormModifyHeader => 'Modifica els detalls de la quedada';

  @override
  String get groupFormConfigureHeader => 'Configura la teva quedada';

  @override
  String get groupFormTitleLabel => 'Títol de la quedada';

  @override
  String get groupFormTitleHint => 'Ex: Partida de Pàdel';

  @override
  String get groupFormDescriptionLabel => 'Descripció';

  @override
  String get groupFormMinLabel => 'Mínim';

  @override
  String get groupFormMaxLabel => 'Màxim';

  @override
  String get groupFormMinAtLeastOne => 'Ha de ser com a mínim 1';

  @override
  String get groupFormMaxGreaterEqualMin =>
      'Ha de ser igual o superior al mínim';

  @override
  String get groupFormPickDateTime => 'Triar data i hora';

  @override
  String groupFormDateValue(int dia, int mes, String hora) {
    return 'Data: $dia/$mes a les $hora';
  }

  @override
  String get groupFormDateRequired => 'Cal seleccionar data i hora';

  @override
  String get groupFormSaveButton => 'GUARDAR CANVIS';

  @override
  String get groupFormCreateButton => 'CREAR GRUP';

  @override
  String get groupFormRequiredField => 'Camp obligatori';

  @override
  String get groupFormNoUser => 'No s\'ha trobat l\'usuari autenticat';

  @override
  String get groupFormCreateSuccess => 'Grup creat correctament!';

  @override
  String get groupFormUpdateSuccess => 'Grup actualitzat correctament!';

  @override
  String groupFormErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get groupFormDatePast =>
      'La data i hora no pot ser anterior a l\'actual';

  @override
  String get groupFormAddPhoto => 'Afegir foto de la quedada';

  @override
  String get groupFormAddPhotoSubtitle => 'Opcional · Toca per seleccionar';

  @override
  String get groupFormChangePhoto => 'Canviar foto';

  @override
  String get groupCardNoUserError => 'No s\'ha trobat l\'usuari autenticat';

  @override
  String get groupCardDeleteDialogTitle => 'Eliminar grup?';

  @override
  String get groupCardDeleteDialogContent =>
      'Aquesta acció cancel·larà la trobada per a tothom.';

  @override
  String get groupCardDeleteBack => 'Enrere';

  @override
  String get groupCardDeleteConfirm => 'Eliminar';

  @override
  String get groupCardLeaveDialogTitle => 'Abandonar grup?';

  @override
  String get groupCardLeaveDialogContent => 'Segur que vols marxar del grup?';

  @override
  String get groupCardCreatorCannotLeave =>
      'Ets el creador. Si vols cancel·lar la quedada, elimina-la.';

  @override
  String get groupCardLeaveCancel => 'Cancel·lar';

  @override
  String get groupCardLeaveConfirm => 'Abandonar';

  @override
  String get groupCardConfirmAttendanceTitle => 'Confirmar assistència?';

  @override
  String get groupCardConfirmAttendanceContent =>
      'Vols confirmar la teva assistència a aquesta quedada?';

  @override
  String get groupCardConfirmAttendanceCancel => 'Cancel·lar';

  @override
  String get groupCardConfirmAttendanceConfirm => 'Confirmar';

  @override
  String get groupCardUnconfirmAttendanceTitle => 'Desconfirmar assistència?';

  @override
  String get groupCardUnconfirmAttendanceContent =>
      'Passaràs a estar en llista d\'espera. Podràs tornar a confirmar més endavant.';

  @override
  String get groupCardUnconfirmAttendanceCancel => 'Cancel·lar';

  @override
  String get groupCardUnconfirmAttendanceConfirm => 'Desconfirmar';

  @override
  String get groupCardGroupDeleted => 'Grup eliminat correctament';

  @override
  String get groupCardJoinedSuccess => 'T\'has unit a la quedada';

  @override
  String get groupCardLeftSuccess => 'Has abandonat la quedada';

  @override
  String get groupCardAttendanceConfirmed => 'Assistència confirmada';

  @override
  String get groupCardAttendanceUnconfirmed =>
      'Assistència desconfirmada. Estàs en llista d\'espera.';

  @override
  String groupCardConfirmedCount(int count, int max) {
    return '✅ $count / $max confirmats';
  }

  @override
  String groupCardPendingCount(int count) {
    return '🕓 $count pendents';
  }

  @override
  String get groupCardPendingAttendance =>
      'La teva assistència està pendent de confirmació';

  @override
  String get groupCardConfirmedAttendance => 'Assistència confirmada';

  @override
  String get groupCardFullButton => 'Grup ple';

  @override
  String get groupCardJoinButton => 'Unir-se';

  @override
  String get groupCardCreatedByYou => 'Creat per tu';

  @override
  String get groupCardUnconfirmButton => 'Desconfirmar';

  @override
  String get groupCardLeaveButton => 'Abandonar';

  @override
  String get groupCardConfirmButton => 'Confirmar assistència';

  @override
  String groupCardJoinedCount(int count, int max) {
    return '👥 $count / $max units';
  }

  @override
  String get groupCardValidatedText =>
      'Assistència validada per geolocalització ✓';

  @override
  String get validateAttendanceValidatedSnackbar =>
      'Assistència validada correctament ✓';

  @override
  String validateAttendanceTooFarKnown(String distance) {
    return 'Ets massa lluny de l\'activitat: ets a $distance metres. Cal estar a un màxim de 200 metres de l\'activitat per validar l\'assistència.';
  }

  @override
  String get validateAttendanceTooFar =>
      'Ets massa lluny de l\'activitat. Cal estar a un màxim de 200 metres de l\'activitat per validar l\'assistència.';

  @override
  String get validateAttendanceGenericError => 'Error validant l\'assistència';

  @override
  String get validateAttendanceValidatedButton => 'Assistència validada ✓';

  @override
  String get validateAttendanceOutsideWindow =>
      'No pots validar l\'assistència perquè estàs fora del període de l\'activitat';

  @override
  String get validateAttendanceLocationRequired =>
      'Cal activar la ubicació per validar l\'assistència';

  @override
  String get validateAttendanceButton => 'Validar assistència';

  @override
  String get mapLocationDenied =>
      'No has concedit la ubicació. Es mostra el mapa en una posició predefinida.';

  @override
  String get mapLocationServiceDisabled =>
      'La ubicació del dispositiu està desactivada. Es mostra el mapa en una posició predefinida.';

  @override
  String get mapLocationPermissionRequiredTitle =>
      'Permís d\'ubicació necessari';

  @override
  String get mapLocationPermissionRequiredContent =>
      'Has denegat el permís d\'ubicació de manera permanent. Si vols centrar el mapa a la teva posició, has d\'anar a la configuració del mòbil i habilitar-lo.';

  @override
  String get mapLocationDialogNotNow => 'Ara no';

  @override
  String get mapLocationDialogOpenSettings => 'Obrir configuració';

  @override
  String get mapInfoStart => 'Inici';

  @override
  String get mapInfoEnd => 'Fi';

  @override
  String get mapInfoSpace => 'Espai';

  @override
  String get mapInfoAddress => 'Adreça';

  @override
  String get mapDetailsButton => 'Detalls';

  @override
  String get mapGroupsButton => 'Quedades';

  @override
  String get mapAppBarTitle => 'Mapa d\'activitats';

  @override
  String get mapFavoritesTooltip => 'Preferides';

  @override
  String get mapNotificacionsTooltip => 'Notificacions';

  @override
  String get mapCategoryAll => 'Totes';

  @override
  String get preferitsAppBarTitle => 'Preferits';

  @override
  String preferitsLoadError(String error) {
    return 'Error carregant preferides: $error';
  }

  @override
  String get preferitsEmptyTitle => 'Encara no tens activitats preferides';

  @override
  String get preferitsEmptyDescription =>
      'Afegeix-les des del detall d\'una activitat.';

  @override
  String get buyTicketsFree => 'Enllaç no disponible';

  @override
  String get buyTicketsGratuit => 'Entrada gratuïta, no cal inscripció';

  @override
  String get buyTicketsLinkError =>
      'No s\'ha pogut obrir l\'enllaç. Torna-ho a intentar.';

  @override
  String get buyTicketsLabel => 'Comprar entrades';

  @override
  String get secureImageLoadError => 'Error carregant imatge';

  @override
  String get secureImageDownloadTooltip => 'Descarregar imatge';

  @override
  String get errorScreenTitle => 'Error!';

  @override
  String get passwordRequirementsHeader => 'Requisits de contrasenya:';

  @override
  String passwordRequirementMinLength(int min) {
    return 'Mínim $min caràcters';
  }

  @override
  String get passwordRequirementUppercase => 'Almenys una majúscula';

  @override
  String get passwordRequirementLowercase => 'Almenys una minúscula';

  @override
  String get passwordRequirementNumber => 'Almenys un número';

  @override
  String get passwordRequirementSpecialChar => 'Almenys un caràcter especial';

  @override
  String get categoriaExposicions => 'Exposicions';

  @override
  String get categoriaInfantil => 'Infantil';

  @override
  String get categoriaTeatre => 'Teatre';

  @override
  String get categoriaConcerts => 'Concerts';

  @override
  String get categoriaFestes => 'Festes';

  @override
  String get categoriaFestivalsIMostres => 'Festivals i mostres';

  @override
  String get categoriaConferencies => 'Conferències';

  @override
  String get categoriaRutesIVisites => 'Rutes i visites';

  @override
  String get categoriaAltres => 'Altres';

  @override
  String get categoriaActivitatsVirtuals => 'Activitats virtuals';

  @override
  String get categoriaDansa => 'Dansa';

  @override
  String get categoriaFiresIMercats => 'Fires i mercats';

  @override
  String get categoriaCarnavals => 'Carnavals';

  @override
  String get categoriaCicles => 'Cicles';

  @override
  String get categoriaSetmanaSanta => 'Setmana Santa';

  @override
  String get categoriaSardanes => 'Sardanes';

  @override
  String get categoriaGegants => 'Gegants';

  @override
  String get categoriaCirc => 'Circ';

  @override
  String get categoriaCommemoracions => 'Commemoracions';

  @override
  String get categoriaCursos => 'Cursos';

  @override
  String get categoriaNadal => 'Nadal';

  @override
  String get categoriaCulturaDigital => 'Cultura digital';

  @override
  String get categoriaAnyGaudi => 'Any Gaudí';

  @override
  String get gustosTitol => 'Els meus gustos';

  @override
  String get gustosSettingsSubtitol =>
      'Modifica les categories culturals que t\'interessen';

  @override
  String get gustosErrorCarregarCategories =>
      'No s\'han pogut carregar les categories';

  @override
  String get gustosTornaAIntentarHo => 'Torna a intentar-ho';

  @override
  String get gustosSeleccionaInteressos => 'Selecciona els teus interessos';

  @override
  String get gustosDesc =>
      'Tria les categories culturals que t\'agraden per rebre recomanacions personalitzades.';

  @override
  String gustosCategoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories seleccionades',
      one: '$count categoria seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get gustosContinuaButton => 'Guardar';

  @override
  String get gustosBenvingudaTitol => 'Defineix els teus gustos!';

  @override
  String get gustosBenvingudaDesc =>
      'Encara no has seleccionat cap interès cultural. Escull les teves preferències per rebre recomanacions d\'activitats personalitzades.';

  @override
  String get gustosBenvingudaAraNo => 'Ara no';

  @override
  String get gustosBenvingudaEscullButton => 'Escull gustos';

  @override
  String get searchHintWithProfiles => 'Cerca activitats, perfils, espais...';

  @override
  String get notificacionsTitol => 'Notificacions';

  @override
  String get notificacionsRetry => 'Tornar a intentar';

  @override
  String get notificacionsEmpty => 'No tens cap notificació';

  @override
  String notificacionsDataAvui(String hora) {
    return 'Avui a les $hora';
  }

  @override
  String notificacionsDataAhir(String hora) {
    return 'Ahir a les $hora';
  }

  @override
  String notificacionsDataDiaSetmana(String dia, String hora) {
    return '$dia a les $hora';
  }

  @override
  String get calendariTitol => 'El meu calendari';

  @override
  String get calendariSyncTooltip => 'Sincronitzar amb Google Calendar';

  @override
  String calendariSyncSuccess(int created, int updated, int deleted) {
    return 'Sincronitzat: $created creats, $updated actualitzats, $deleted eliminats';
  }

  @override
  String get calendariSyncSuccessNoResult => 'Sincronització completada';

  @override
  String get calendariSyncPermisDenega =>
      'Cal concedir permisos d\'accés al calendari des de Configuració';

  @override
  String calendariSyncError(String error) {
    return 'Error: $error';
  }

  @override
  String get calendariErrorDesconegut => 'Error desconegut';

  @override
  String get calendariFormatMes => 'Mes';

  @override
  String get calendariErrorCarregant => 'Error carregant les quedades';

  @override
  String get calendariSeleccionaDia =>
      'Selecciona un dia per veure les quedades';

  @override
  String get calendariCapQuedada => 'Cap quedada aquest dia';

  @override
  String get calendariLabelActivitat => 'Activitat';

  @override
  String get calendariLabelCategoria => 'Categoria';

  @override
  String get calendariLabelHora => 'Hora';

  @override
  String get calendariLabelRol => 'Rol';

  @override
  String get calendariLabelEstat => 'Estat';

  @override
  String get calendariRolAdministrador => 'Administrador';

  @override
  String get calendariRolMembre => 'Membre';

  @override
  String get calendariEstatConfirmat => 'Confirmat';

  @override
  String get calendariEstatPendent => 'Pendent';

  @override
  String get calendariEstatPendentConfirmacio => 'Pendent de confirmació';

  @override
  String get estatCreador => 'Creador';

  @override
  String get estatValidat => 'Validat';

  @override
  String get estatApuntat => 'Apuntat';

  @override
  String get estatAmic => 'Amic';

  @override
  String whatsappShareMessage(String titol, String url) {
    return 'Dona un cop d\'ull a aquesta activitat a PlanC: $titol. Pots veure més detalls aquí: $url';
  }

  @override
  String get postTooltipComentaris => 'Veure comentaris';

  @override
  String get modeFoscLabel => 'Mode fosc';

  @override
  String get modeFoscSubtitol => 'Canvia l\'aparença de l\'aplicació';

  @override
  String get qualitatAireTitol => 'Qualitat de l\'aire';

  @override
  String get qualitatAireBona => 'Bona';

  @override
  String get qualitatAireModerada => 'Moderada';

  @override
  String get qualitatAireDolentaGrups => 'Dolenta per a grups sensibles';

  @override
  String get qualitatAireDolenta => 'Dolenta';

  @override
  String get qualitatAireMoltDolenta => 'Molt dolenta';

  @override
  String qualitatAireEstacio(String nom) {
    return 'Estació: $nom';
  }

  @override
  String qualitatAireDistancia(String km) {
    return '$km km de l\'activitat';
  }

  @override
  String get qualitatAireNoDisponible =>
      'Dades no disponibles per a aquesta ubicació';

  @override
  String get valorarTitol => 'Deixa la teva valoració';

  @override
  String get valorarLabelQuedada => 'Quedada';

  @override
  String get valorarSelectQuedada => 'Selecciona una quedada';

  @override
  String get valorarLabelPuntuacio => 'Puntuació';

  @override
  String get valorarLabelComentari => 'Comentari (opcional)';

  @override
  String get valorarComentariHint => 'Escriu el teu comentari…';

  @override
  String valorarSuccessWithPoints(int punts) {
    return 'Valoració enviada! Has guanyat $punts punts de bonificació.';
  }

  @override
  String get valorarSuccess => 'Valoració enviada correctament.';

  @override
  String get valorarButtonNoPuntuacio => 'Selecciona una puntuació';

  @override
  String get valorarButtonEnviar => 'Enviar valoració';

  @override
  String get valorarButtonNoQuedada => 'Selecciona una quedada';

  @override
  String get valoracionsEmpty =>
      'Encara no hi ha ressenyes per a aquesta activitat';

  @override
  String valoracionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valoracions',
      one: '1 valoració',
    );
    return '$_temp0';
  }

  @override
  String get valoracionsMitjana => 'Puntuació mitjana';

  @override
  String get valoracionsLaTeva => '(la teva)';

  @override
  String get valoracionsCarregarMes => 'Carregar més';

  @override
  String get valoracionsTitol => 'Valoracions';

  @override
  String amicsApuntats(int count) {
    return '$count amics apuntats';
  }

  @override
  String mesAmics(int count) {
    return '+$count amics';
  }

  @override
  String nombreAssistents(int count) {
    return '$count assistents';
  }

  @override
  String get valoracionsEmptyQuedada =>
      'Encara no hi ha valoracions per a aquesta quedada.';

  @override
  String get seleccionaHora => 'Selecciona l\'hora';

  @override
  String get cancelLa => 'Cancel·la';

  @override
  String get dacord => 'D\'acord';

  @override
  String get filterAirQualityLabel => 'Qualitat de l\'aire';

  @override
  String get filterAirQualityToggle => 'Buscar per qualitat de l\'aire';

  @override
  String get filterAirQualityLevelAny => 'Qualsevol';

  @override
  String get filterAirQualityErrorNotFound =>
      'No s\'han trobat activitats amb aquesta qualitat d\'aire a la zona';

  @override
  String get filterAirQualityErrorUnavailable =>
      'El servei de qualitat de l\'aire no està disponible ara mateix';

  @override
  String get filterAirQualityDisabledTooltip =>
      'No disponible amb el filtre de qualitat de l\'aire';

  @override
  String get feedTabActivities => 'Activitats';

  @override
  String get feedTabPublications => 'Publicacions';

  @override
  String get feedNoPublications => 'Encara no hi ha publicacions';

  @override
  String get feedPublicationsError =>
      'No s\'han pogut carregar les publicacions';

  @override
  String get feedPublicationsRetry => 'Reintentar';

  @override
  String get createPublicacioTitle => 'Nova publicació';

  @override
  String get createPublicacioDescriptionHint => 'Escriu alguna cosa...';

  @override
  String get createPublicacioSelectActivity => 'Selecciona una activitat';

  @override
  String get createPublicacioLoadingActivities => 'Carregant activitats...';

  @override
  String get createPublicacioNoActivities =>
      'No estàs apuntat a cap activitat activa';

  @override
  String get createPublicacioAddImage => 'Afegir imatge';

  @override
  String get createPublicacioChangeImage => 'Canviar imatge';

  @override
  String get createPublicacioPublish => 'Publicar';

  @override
  String get createPublicacioRequiredDesc => 'Escriu una descripció';

  @override
  String get createPublicacioRequiredActivity => 'Selecciona una activitat';

  @override
  String get createPublicacioSuccess => 'Publicació creada correctament!';

  @override
  String get createPublicacioError => 'Error en crear la publicació';

  @override
  String get selectActivity => 'Selecciona sobre quina activitat vols publicar';

  @override
  String get searchActivity => 'Busca l\'activitat';

  @override
  String get noActivitiesFound => 'No s\'han trobat activitats recents';

  @override
  String get mentionFriends => 'Menciona a amics';

  @override
  String get done => 'Llest';

  @override
  String get searchFriends => 'Busca a amics';

  @override
  String get noFriendsFound => 'No s\'han trobat amics';

  @override
  String get createPost => 'Crear publicació';

  @override
  String get createPostWarning =>
      'Afegeix el tipus d\'activitat i almenys una imatge per publicar!';

  @override
  String get posting => 'Publicant';

  @override
  String get post => 'Publicar';

  @override
  String get writeMessage => 'Escriu el teu missatge aquí...';

  @override
  String get addMultimedia => 'Afegir multimèdia';

  @override
  String get editPost => 'Editar publicació';

  @override
  String get editPostWarning => 'La publicació ha de tenir almenys una imatge';

  @override
  String get saving => 'Desant';

  @override
  String get save => 'Desar';

  @override
  String get postTitle => 'Publicació';

  @override
  String get postDeleteMenuItem => 'Eliminar publicació';

  @override
  String get postEditMenuItem => 'Editar publicació';

  @override
  String get postDeleteDialogTitle => 'Eliminar publicació';

  @override
  String get postDeleteDialogBody =>
      'Estàs segur que vols eliminar aquesta publicació? Aquesta acció no es pot desfer.';

  @override
  String get postDeleteCancel => 'Cancel·lar';

  @override
  String get postDeleteConfirm => 'Eliminar';

  @override
  String get postDeletedSuccess => 'Publicació eliminada correctament';

  @override
  String postLikesCount(int count) {
    return '$count m\'agrades';
  }

  @override
  String postViewComments(int count) {
    return 'Veure els $count comentaris';
  }

  @override
  String get postSaveAction => 'Guardar';

  @override
  String get postUnsaveAction => 'Deixar de guardar';

  @override
  String get postSavedSuccess => 'Publicació guardada';

  @override
  String get postUnsavedSuccess => 'Publicació eliminada dels guardats';

  @override
  String get postSaveError => 'Error en guardar la publicació';

  @override
  String get postLikedByTitle => 'M\'agrades';

  @override
  String get postNoLikes => 'Sigues el primer en donar m\'agrada!';

  @override
  String get postLikesError => 'No s\'ha pogut carregar la llista';

  @override
  String get comentarisTitle => 'Comentaris';

  @override
  String get comentarisError => 'Error al carregar els comentaris';

  @override
  String get comentarisEmpty =>
      'Encara no hi ha comentaris.\nSigues el primer!';

  @override
  String get comentariResponder => 'Respondre';

  @override
  String comentariResponent(String nom) {
    return 'Responent a $nom';
  }

  @override
  String get comentariHint => 'Escriu un comentari...';

  @override
  String comentariHintReply(String nom) {
    return 'Respon a $nom...';
  }

  @override
  String get createPostTitle => 'Crear publicació';

  @override
  String get createPostRequiredFields =>
      'Afegeix el tipus d\'activitat i almenys una imatge per publicar!';

  @override
  String createPostImageError(String error) {
    return 'No s\'ha pogut carregar la imatge: $error';
  }

  @override
  String get createPostPublishing => 'Publicant...';

  @override
  String get createPostPublish => 'Publicar';

  @override
  String get createPostActivityPickerTitle => 'Què estàs fent?';

  @override
  String get createPostActivitySearch => 'Cerca activitat...';

  @override
  String get createPostActivityEmpty => 'No s\'han trobat activitats';

  @override
  String get createPostMentionTitle => 'Mencionar un amic';

  @override
  String get createPostMentionSearch => 'Cerca per nom o username...';

  @override
  String get createPostMentionEmpty => 'No s\'han trobat amics';

  @override
  String get createPostHint => 'Escriu el teu missatge aquí...';

  @override
  String get createPostAddMedia => 'Afegir multimèdia';

  @override
  String createPostErrorActivity(String error) {
    return 'Error en carregar activitats: $error';
  }

  @override
  String createPostErrorFriends(String error) {
    return 'Error en carregar amics: $error';
  }

  @override
  String createPostError(String error) {
    return 'Error en crear la publicació: $error';
  }

  @override
  String get timeJustNow => 'Ara';

  @override
  String timeMinutesAgo(int n) {
    return 'Fa $n min';
  }

  @override
  String timeHoursAgo(int n) {
    return 'Fa $n h';
  }

  @override
  String get timeYesterday => 'Ahir';

  @override
  String timeDaysAgo(int n) {
    return 'Fa $n dies';
  }

  @override
  String comentariShowReplies(int count) {
    return 'Veure $count respostes';
  }

  @override
  String get comentariHideReplies => 'Amagar respostes';

  @override
  String get preferitsTabActivitats => 'Activitats';

  @override
  String get preferitsTabPublicacions => 'Publicacions';

  @override
  String get preferitsPublicacionsEmptyTitle =>
      'Encara no tens publicacions guardades';

  @override
  String get preferitsPublicacionsEmptyDescription =>
      'Guarda publicacions per veure-les aquí.';

  @override
  String get verifyEmailTitle => 'Verifica el teu correu';

  @override
  String verifyEmailBody(String email) {
    return 'Hem enviat un correu de verificació a $email. Obre-l i fes clic a l\'enllaç per activar el compte.';
  }

  @override
  String get verifyEmailAlreadyVerified => 'Ja he verificat';

  @override
  String get verifyEmailResend => 'Reenviar correu';

  @override
  String get verifyEmailResendSuccess => 'Correu reenviat correctament';

  @override
  String get verifyEmailNotYet =>
      'Encara no has verificat el correu electrònic';

  @override
  String get verifyEmailBackToLogin => 'Tornar a l\'inici';
}
