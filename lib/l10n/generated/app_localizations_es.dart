// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get titolApp => 'PlanC';

  @override
  String holaUsuari(String nom) {
    return '¡Hola, $nom!';
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
  String get configuracioTitol => 'Configuración';

  @override
  String get seccioPreferencies => 'Preferencias';

  @override
  String get idiomaLabel => 'Idioma de la aplicación';

  @override
  String get errorGoogleMaps =>
      'No se ha podido abrir Google Maps en el dispositivo';

  @override
  String get detallActivitatTitol => 'Detalle de la actividad';

  @override
  String get compartirActivitatTooltip => 'Compartir actividad';

  @override
  String get treurePreferidesTooltip => 'Quitar de favoritos';

  @override
  String get afegirPreferidesTooltip => 'Añadir a favoritos';

  @override
  String get activitatAfegidaPreferides => 'Actividad añadida a favoritos';

  @override
  String get activitatEliminadaPreferides => 'Actividad eliminada de favoritos';

  @override
  String errorActualitzarPreferides(String error) {
    return 'No se han podido actualizar los favoritos: $error';
  }

  @override
  String get descripcioTitol => 'Descripción';

  @override
  String get quanTitol => 'Cuándo';

  @override
  String get iniciLabel => 'Inicio';

  @override
  String get fiLabel => 'Fin';

  @override
  String get onTitol => 'Dónde';

  @override
  String get espaiLabel => 'Espacio';

  @override
  String get adrecaLabel => 'Dirección';

  @override
  String get obrirGoogleMapsButton => 'Abrir en Google Maps';

  @override
  String get entradesTitol => 'Entradas';

  @override
  String get compartirXatTitol => 'Compartir en un chat';

  @override
  String get cercaXatHint => 'Busca un chat o grupo...';

  @override
  String activitatCompartidaExit(String chatName) {
    return 'Actividad compartida en: $chatName';
  }

  @override
  String errorCompartir(String error) {
    return 'Error al compartir: $error';
  }

  @override
  String errorCarregarXats(String error) {
    return 'Error al cargar chats: $error';
  }

  @override
  String get noXatsTrobats => 'No se han encontrado chats';

  @override
  String get enviarButton => 'Enviar';

  @override
  String get authDescubreixTitle => 'Descubre';

  @override
  String get authConnectaTitle => 'Conecta';

  @override
  String get authCreixTitle => 'Crece';

  @override
  String get authDescubreixDesc =>
      'Encuentra eventos culturales en Cataluña personalizados según tus intereses.';

  @override
  String get authConnectaDesc =>
      'Conoce a gente con tus mismos gustos culturales y haced piña.';

  @override
  String get authCreixDesc => 'Gana insignias disfrutando de la cultura.';

  @override
  String get authLoginButton => 'Iniciar Sesión';

  @override
  String get authCreateAccountButton => 'Crear una cuenta';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get loginWelcomeBack => 'Encantado de verte de nuevo';

  @override
  String get loginEmailOrUsernameLabel =>
      'Correo electrónico / Nombre de usuario';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginForgotPassword => '¿Has olvidado la contraseña?';

  @override
  String get loginLoadingButton => 'Cargando';

  @override
  String get loginSignInButton => 'Iniciar Sesión';

  @override
  String get loginContinueWith => 'o continúa con';

  @override
  String get loginGoogleButton => 'Continuar con Google';

  @override
  String get loginNoAccount => '¿No tienes cuenta?';

  @override
  String get loginSignUpHere => 'Regístrate aquí';

  @override
  String get loginRequiredField => 'Campo obligatorio';

  @override
  String get loginErrorFallback => 'Error de inicio de sesión';

  @override
  String get loginSuccessSnackbar => 'Sesión iniciada correctamente';

  @override
  String get registerCreateAccountTitle => 'Crea tu cuenta';

  @override
  String get registerUsernameLabel => 'Nombre de usuario';

  @override
  String get registerEmailLabel => 'Correo electrónico';

  @override
  String get registerPasswordLabel => 'Contraseña';

  @override
  String get registerRepeatPasswordLabel => 'Confirma la contraseña';

  @override
  String get registerLoadingButton => 'Cargando';

  @override
  String get registerSubmitButton => 'Regístrate';

  @override
  String get registerUsernameMinError =>
      'El nombre de usuario debe tener mínimo 3 caracteres';

  @override
  String get registerUsernameMaxError =>
      'El nombre de usuario debe tener máximo 20 caracteres';

  @override
  String get registerEmailInvalidError =>
      'El campo debe contener una dirección de correo válida';

  @override
  String get registerEmailTaken => 'Este correo ya está en uso';

  @override
  String get registerUsernameTaken => 'Este nombre de usuario ya está en uso';

  @override
  String get registerChecking => 'Comprobando...';

  @override
  String get registerPasswordInvalidError => 'Contraseña inválida';

  @override
  String get registerPasswordMismatchError => 'Las contraseñas no coinciden';

  @override
  String get registerErrorFallback => 'Error al registrarse';

  @override
  String get registerSuccessSnackbar => '¡Cuenta creada exitosamente!';

  @override
  String get registerVerificationTitle => '¡Cuenta creada!';

  @override
  String get registerVerificationSubtitle => 'Bienvenido/a a PlanC';

  @override
  String registerVerificationBody(String email) {
    return 'Hemos enviado un correo de verificación a $email. Verifica tu cuenta para disfrutar de todas las funcionalidades.';
  }

  @override
  String get registerVerificationButton => 'Entrar a la app';

  @override
  String get registerContinueButton => 'Continuar';

  @override
  String get registerSkipButton => 'Omitir';

  @override
  String get registerStep2Title => 'Sobre ti';

  @override
  String get registerStep3Title => 'Foto de perfil';

  @override
  String get registerNameLabel => 'Nombre';

  @override
  String get registerSurnameLabel => 'Apellidos';

  @override
  String get registerBioLabel => 'Biografía';

  @override
  String get registerBioHint => 'Cuéntanos algo sobre ti (opcional)...';

  @override
  String get registerAddPhotoButton => 'Añadir foto';

  @override
  String get registerNameRequiredError => 'El nombre es obligatorio';

  @override
  String get registerSurnameRequiredError => 'Los apellidos son obligatorios';

  @override
  String get registerBioMaxError => 'Máximo 160 caracteres';

  @override
  String registerStepOf(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get forgotPasswordTitle => 'Recupera tu contraseña';

  @override
  String get forgotPasswordDescription =>
      'Introduce tu correo y recibirás un correo electrónico con las indicaciones para restablecerla';

  @override
  String get forgotPasswordEmailInvalid => 'Introduce un correo válido';

  @override
  String get forgotPasswordButton => 'Recuperar contraseña';

  @override
  String get forgotPasswordEmailSent =>
      'Se ha enviado un correo a la dirección indicada';

  @override
  String get forgotPasswordGoToLogin => 'Ir al login';

  @override
  String get authWrapperCheckingSession => 'Comprobando sesión...';

  @override
  String get deleteAccountTitle => 'Eliminar cuenta';

  @override
  String get deleteAccountIrreversibleWarning => 'Esta acción es irreversible';

  @override
  String get deleteAccountWarningDetails =>
      'Se eliminarán permanentemente: tu perfil, publicaciones, comentarios, amistades y todos los datos personales.';

  @override
  String get deleteAccountTypeConfirmInstruction =>
      'Escribe \"ELIMINAR\" para confirmar';

  @override
  String get deleteAccountTypeConfirmLabel => 'Escribe ELIMINAR';

  @override
  String get deleteAccountTypeConfirmRequired =>
      'Escribe \"ELIMINAR\" para confirmar';

  @override
  String get deleteAccountPasswordLabel =>
      'Introduce tu contraseña para confirmar';

  @override
  String get deleteAccountPasswordRequired => 'Introduce tu contraseña';

  @override
  String get deleteAccountDialogTitle => '¿Estás seguro?';

  @override
  String get deleteAccountDialogContent =>
      'Esta acción no se puede deshacer. Todos tus datos se eliminarán permanentemente.';

  @override
  String get deleteAccountDialogCancel => 'Cancelar';

  @override
  String get deleteAccountDialogConfirm => 'Eliminar definitivamente';

  @override
  String get deleteAccountSuccess => 'Tu cuenta se ha eliminado correctamente';

  @override
  String get deleteAccountErrorFallback => 'Error eliminando la cuenta';

  @override
  String get homeTabFeed => 'Feed';

  @override
  String get homeTabExplora => 'Explorar';

  @override
  String get navInici => 'Inicio';

  @override
  String get feedDiscover => 'Descubre';

  @override
  String get feedTrending => 'Tendencias';

  @override
  String get feedCategories => 'Categorías';

  @override
  String get feedRecommended => 'Recomendado para ti';

  @override
  String get feedNearby => 'Cerca de ti';

  @override
  String get feedQuedades => 'Quedadas abiertas';

  @override
  String get feedQuedadesEmpty => 'No hay quedadas disponibles ahora';

  @override
  String feedQuedadesParticipants(int current, int max) {
    return '$current/$max participantes';
  }

  @override
  String get feedQuedadesJoin => 'Ver actividad';

  @override
  String get searchDiscoverTitle => 'Sugerencias';

  @override
  String get feedSeeAll => 'Ver todo';

  @override
  String get feedFree => 'Gratuito';

  @override
  String get feedInfoUnavailable => 'Info no disp.';

  @override
  String get feedLoadError => 'No se han podido cargar';

  @override
  String get activitatDetailError => 'No se ha podido cargar la actividad';

  @override
  String get feedEmpty => 'No hay actividades';

  @override
  String get feedNoMoreActivities => 'No hay más actividades';

  @override
  String get feedNoCategoryActivities => 'No hay actividades en esta categoría';

  @override
  String get feedRetry => 'Reintentar';

  @override
  String get feedLoadingMore => 'Cargando más...';

  @override
  String get homeTabMap => 'Mapa';

  @override
  String get homeTabSearch => 'Buscar';

  @override
  String get homeTabChat => 'Comunidad';

  @override
  String get homeTabNotifications => 'Notificaciones';

  @override
  String get homeTabCalendar => 'Calendario';

  @override
  String get homeTabProfile => 'Perfil';

  @override
  String get profileFriendsBox => 'Amigos';

  @override
  String get profilePostsBox => 'Publicaciones';

  @override
  String get profileNoDescription => 'Sin descripción todavía';

  @override
  String get profileEditButton => 'Editar perfil';

  @override
  String get profileNoPosts => 'Todavía no hay publicaciones';

  @override
  String get profileEnviarMissatge => 'Enviar mensaje';

  @override
  String get profileXatNoDisponible =>
      'No se encontró ningún chat con este usuario';

  @override
  String get profilePublicationsSection => 'Publicaciones';

  @override
  String get profileTrophiesSection => 'Trofeos';

  @override
  String get profileNoTrophies =>
      'Aún no tienes trofeos. ¡Participa en actividades para ganarlos!';

  @override
  String get trophyLevelLabel => 'Nivel';

  @override
  String get actualRankLabel => 'Rango actual';

  @override
  String get achievedLevelLabel => 'Nivel alcanzado';

  @override
  String get levelProgressLabel => 'Progreso de nivel';

  @override
  String get pointsForNextLevelLabel => ' puntos para llegar al nivel ';

  @override
  String get close => 'Cerrar';

  @override
  String get editProfileTitle => 'Editar Perfil';

  @override
  String get editProfileImageUpdated =>
      'Foto de perfil actualizada correctamente';

  @override
  String editProfileImageError(String error) {
    return 'Error al actualizar la foto: $error';
  }

  @override
  String get editProfileUsernameLabel => 'Usuario';

  @override
  String get editProfileDescriptionLabel => 'Descripción';

  @override
  String get editProfileNameLabel => 'Nombre';

  @override
  String get editProfileSurnameLabel => 'Apellido';

  @override
  String get editProfileLogoutButton => 'Cerrar sesión';

  @override
  String get editProfileDangerZone => 'Zona peligrosa';

  @override
  String get editProfileDeleteAccount => 'Eliminar cuenta';

  @override
  String get editProfileFieldSave => 'Guardar';

  @override
  String get friendsScreenTitle => 'Amistades';

  @override
  String get friendsScreenSubtitle =>
      'Aquí puedes ver las solicitudes recibidas y las enviadas pendientes.';

  @override
  String get friendsScreenSectionReceived => 'Solicitudes recibidas';

  @override
  String get friendsScreenSectionSent => 'Solicitudes enviadas';

  @override
  String get friendsScreenNoReceived =>
      'No tienes ninguna solicitud recibida pendiente.';

  @override
  String get friendsScreenNoSent =>
      'No tienes ninguna solicitud enviada pendiente.';

  @override
  String get friendsScreenWantsFriend => 'Quiere ser tu amigo';

  @override
  String get friendsScreenAcceptButton => 'Aceptar';

  @override
  String get friendsScreenRejectButton => 'Rechazar';

  @override
  String get friendsScreenCancelButton => 'Cancelar';

  @override
  String get friendsScreenPendingRequest => 'Solicitud pendiente';

  @override
  String get friendsScreenRetry => 'Reintentar';

  @override
  String get friendsScreenAcceptedSuccess => 'Solicitud aceptada correctamente';

  @override
  String get friendsScreenRejectedSuccess =>
      'Solicitud rechazada correctamente';

  @override
  String get friendsScreenCanceledSuccess =>
      'Solicitud cancelada correctamente';

  @override
  String get friendsListTitle => 'Amigos';

  @override
  String get friendsListSearchHint => 'Buscar un amigo...';

  @override
  String get friendsListNoResults => 'Ningún amigo coincide con la búsqueda.';

  @override
  String get friendsListNoneOwn => 'Aún no tienes amigos.';

  @override
  String get friendsListNoneOther => 'Este usuario no tiene amigos.';

  @override
  String get friendsListRemoveTooltip => 'Eliminar amigo';

  @override
  String get friendsListRemoveDialogTitle => 'Eliminar amigo';

  @override
  String friendsListRemoveDialogContent(String nom) {
    return '¿Quieres eliminar a $nom de tu lista de amigos?';
  }

  @override
  String get friendsListRemoveCancel => 'Cancelar';

  @override
  String get friendsListRemoveConfirm => 'Eliminar';

  @override
  String get friendsListRetry => 'Reintentar';

  @override
  String get relationshipRemoveFriend => 'Eliminar amigo';

  @override
  String get relationshipAccept => 'Aceptar';

  @override
  String get relationshipReject => 'Rechazar';

  @override
  String get relationshipRequestSent => 'Solicitud enviada';

  @override
  String get relationshipCancel => 'Cancelar';

  @override
  String get relationshipSendRequest => 'Enviar solicitud de amistad';

  @override
  String get relationshipRetry => 'Reintentar';

  @override
  String relationshipErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get searchTabAll => 'Todos';

  @override
  String get searchTabProfiles => 'Perfiles';

  @override
  String get searchTabActivities => 'Actividades';

  @override
  String get searchTabSpaces => 'Espacios';

  @override
  String get searchHint => 'Busca actividades, espacios...';

  @override
  String get searchFiltersTooltip => 'Filtros';

  @override
  String get searchRecentTitle => 'Búsquedas recientes';

  @override
  String searchActivitiesHeader(int count) {
    return 'Actividades ($count)';
  }

  @override
  String searchSpacesHeader(int count) {
    return 'Espacios ($count)';
  }

  @override
  String get filterTitle => 'Filtros';

  @override
  String get filterClear => 'Limpiar filtros';

  @override
  String get filterPriceLabel => 'Precio';

  @override
  String get filterPriceAll => 'Todos';

  @override
  String get filterPriceFree => 'Gratuito';

  @override
  String get filterPricePaid => 'De pago';

  @override
  String filterDistanceLabel(int km) {
    return 'Distancia: $km km';
  }

  @override
  String get filterLocationPermissionNeeded =>
      'Hay que conceder permisos de ubicación para usar este filtro.';

  @override
  String get filterDateLabel => 'Fecha';

  @override
  String get filterDateAll => 'Todas las fechas';

  @override
  String get filterDateToday => 'Hoy';

  @override
  String get filterDateWeekend => 'Fin de semana';

  @override
  String get filterDateCalendar => '📅 Calendario';

  @override
  String get filterApply => 'Aplicar filtros';

  @override
  String get filterNoLocation =>
      'No se ha podido obtener la ubicación. El filtro de distancia no se aplicará.';

  @override
  String get emptySearchFilterTitle =>
      'Ninguna actividad coincide con los filtros';

  @override
  String get emptySearchSearchTitle =>
      'No se ha encontrado ninguna coincidencia';

  @override
  String get emptySearchFilterDescription =>
      'Prueba a ampliar la distancia, cambiar las fechas o modificar los filtros de precio.';

  @override
  String emptySearchSearchDescription(String terme) {
    return 'No hemos encontrado resultados para \"$terme\".\nPrueba con otro término o explora las categorías.';
  }

  @override
  String get emptySearchModifyFilters => 'Modificar filtros';

  @override
  String get emptySearchCategoryMusic => 'Música';

  @override
  String get emptySearchCategoryTheater => 'Teatro';

  @override
  String get emptySearchCategoryArt => 'Arte';

  @override
  String get emptySearchCategoryCinema => 'Cine';

  @override
  String get chatNotificationsTitle => 'Comunidad';

  @override
  String get chatTabChats => 'Chats';

  @override
  String get chatTabFriendships => 'Amistades';

  @override
  String get myChatsTitle => 'Mis chats';

  @override
  String chatListError(String error) {
    return 'Error al cargar chats: $error';
  }

  @override
  String get chatListEmpty =>
      'Aún no tienes ningún chat activo.\n¡Únete a una quedada!';

  @override
  String get chatDeleteDialogTitle => 'Eliminar chat';

  @override
  String chatDeleteDialogContent(String name) {
    return '¿Estás seguro de que quieres eliminar \"$name\"? El historial de mensajes desaparecerá para ti.';
  }

  @override
  String get chatDeleteCancel => 'Cancelar';

  @override
  String get chatDeleteConfirm => 'Eliminar';

  @override
  String chatDeletedSnackbar(String name) {
    return '$name eliminado';
  }

  @override
  String get chatUnmuteAction => 'Activar notificaciones';

  @override
  String get chatMuteAction => 'Silenciar chat';

  @override
  String chatUnmutedSnackbar(String name) {
    return '$name con notificaciones activadas';
  }

  @override
  String chatMutedSnackbar(String name) {
    return '$name silenciado';
  }

  @override
  String chatRoomNotFoundError(String error) {
    return 'Error al enviar mensaje: $error';
  }

  @override
  String chatRoomImagePickError(String error) {
    return 'Error al seleccionar imagen: $error';
  }

  @override
  String chatRoomImageCaptureError(String error) {
    return 'Error al capturar imagen: $error';
  }

  @override
  String get chatRoomTodayLabel => 'HOY';

  @override
  String get chatRoomYesterdayLabel => 'AYER';

  @override
  String get chatRoomAttachmentGallery => 'Galería';

  @override
  String get chatRoomAttachmentCamera => 'Cámara';

  @override
  String get chatRoomNoMessages => 'Sin mensajes todavía';

  @override
  String get chatRoomStartConversation => '¡Empieza la conversación!';

  @override
  String get chatRoomLoadOlder => 'Cargar mensajes más antiguos';

  @override
  String get chatRoomSomeoneTyping => 'Alguien está escribiendo...';

  @override
  String get chatRoomInactiveBannerTitle => 'Chat inactivo';

  @override
  String get chatRoomInactiveBannerBody =>
      'Este chat ya no permite enviar mensajes. Puede deberse a:\n\n• La quedada tuvo lugar hace más de 48 horas y el chat se cerró automáticamente.\n• Un administrador canceló la quedada y el chat quedó bloqueado.';

  @override
  String get chatRoomReadOnlyNotice => 'Chat inactivo · Solo lectura';

  @override
  String get chatRoomInputHint => 'Escribe un mensaje...';

  @override
  String get chatRoomMuteUnmuteError =>
      'Error al cambiar el estado de silencio';

  @override
  String get chatRoomMuteOff => 'Notificaciones activadas';

  @override
  String get chatRoomMuteOn => 'Chat silenciado';

  @override
  String get chatRoomActivityError => 'Error al cargar la actividad';

  @override
  String get chatRoomActivityNoTitle => 'Sin título';

  @override
  String get chatRoomActivityNoLocation => 'Sin ubicación';

  @override
  String get chatRoomActivityCategoryOther => 'Otros';

  @override
  String get chatRoomViewActivity => 'Ver actividad';

  @override
  String get chatDetailsAppBarTitle => 'Detalles del chat';

  @override
  String get chatDetailsLoadError => 'Error al cargar los detalles del chat';

  @override
  String get chatDetailsFallbackTitle => 'Detalles';

  @override
  String get chatDetailsTypeFriendGroup => 'Grupo de amigos';

  @override
  String get chatDetailsTypeMeetup => 'Quedada';

  @override
  String get chatDetailsTypeIndividual => 'Chat Individual';

  @override
  String get chatDetailsPhotoUpdateNotice =>
      'La actualización de foto requiere soporte del servidor (Próximamente)';

  @override
  String get chatDetailsPhotoUpdateSuccess =>
      'Foto del grupo actualizada correctamente';

  @override
  String chatDetailsPhotoUpdateError(String error) {
    return 'Error actualizando la foto: $error';
  }

  @override
  String get chatDetailsMembersHeader => 'MIEMBRES DEL CHAT';

  @override
  String get chatDetailsLeaveChat => 'Abandonar Chat';

  @override
  String get chatDetailsDeleteChat => 'Eliminar Chat';

  @override
  String get chatDetailsLeaveGroupDialogTitle => 'Abandonar Grupo';

  @override
  String get chatDetailsDeleteChatDialogTitle => 'Eliminar Chat';

  @override
  String chatDetailsLeaveGroupDialogContent(String name) {
    return '¿Seguro que quieres abandonar \"$name\"? Dejarás de recibir mensajes de este grupo.';
  }

  @override
  String chatDetailsDeleteChatDialogContent(String name) {
    return '¿Seguro que quieres eliminar \"$name\"? El historial desaparecerá.';
  }

  @override
  String get chatDetailsActionCancel => 'Cancelar';

  @override
  String get chatDetailsLeaveButton => 'Abandonar';

  @override
  String get chatDetailsDeleteButton => 'Eliminar';

  @override
  String get chatDetailsGroupLeftSnackbar => 'Has abandonado el grupo';

  @override
  String get chatDetailsChatDeletedSnackbar => 'Chat eliminado';

  @override
  String get chatDetailsActionError => 'Error realizando la acción';

  @override
  String get veurQuedades => 'Ver quedadas';

  @override
  String get mostrarMes => 'Mostrar más';

  @override
  String get mostrarMenys => 'Mostrar menos';

  @override
  String get chatDetailsQuedadaInfoHeader => 'INFORMACIÓN DE LA QUEDADA';

  @override
  String get chatDetailsQuedadaActivity => 'Actividad';

  @override
  String get chatDetailsQuedadaDate => 'Fecha';

  @override
  String get chatDetailsQuedadaViewActivity => 'Ver actividad';

  @override
  String groupsActivityTitle(String titol) {
    return 'Quedadas: $titol';
  }

  @override
  String groupsLoadError(String error) {
    return 'Error al cargar las quedadas:\n$error';
  }

  @override
  String get groupsEmpty =>
      'Aún no hay quedadas para esta actividad.\n¡Sé el primero en crear una!';

  @override
  String get groupsCreateButton => 'Crear Quedada';

  @override
  String get groupFormEditTitle => 'Editar Quedada';

  @override
  String get groupFormCreateTitle => 'Crear Quedada';

  @override
  String get groupFormModifyHeader => 'Modifica los detalles de la quedada';

  @override
  String get groupFormConfigureHeader => 'Configura tu quedada';

  @override
  String get groupFormTitleLabel => 'Título de la quedada';

  @override
  String get groupFormTitleHint => 'Ej: Partida de Pádel';

  @override
  String get groupFormDescriptionLabel => 'Descripción';

  @override
  String get groupFormMinLabel => 'Mínimo';

  @override
  String get groupFormMaxLabel => 'Máximo';

  @override
  String get groupFormMinAtLeastOne => 'Debe ser como mínimo 1';

  @override
  String get groupFormMaxGreaterEqualMin =>
      'Debe ser igual o superior al mínimo';

  @override
  String get groupFormPickDateTime => 'Elegir fecha y hora';

  @override
  String groupFormDateValue(int dia, int mes, String hora) {
    return 'Fecha: $dia/$mes a las $hora';
  }

  @override
  String get groupFormDateRequired => 'Hay que seleccionar fecha y hora';

  @override
  String get groupFormSaveButton => 'GUARDAR CAMBIOS';

  @override
  String get groupFormCreateButton => 'CREAR GRUPO';

  @override
  String get groupFormRequiredField => 'Campo obligatorio';

  @override
  String get groupFormNoUser => 'No se ha encontrado el usuario autenticado';

  @override
  String get groupFormCreateSuccess => '¡Grupo creado correctamente!';

  @override
  String get groupFormUpdateSuccess => '¡Grupo actualizado correctamente!';

  @override
  String groupFormErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get groupFormDatePast =>
      'La fecha y hora no puede ser anterior a la actual';

  @override
  String get groupFormAddPhoto => 'Añadir foto de la quedada';

  @override
  String get groupFormAddPhotoSubtitle => 'Opcional · Toca para seleccionar';

  @override
  String get groupFormChangePhoto => 'Cambiar foto';

  @override
  String get groupCardNoUserError =>
      'No se ha encontrado el usuario autenticado';

  @override
  String get groupCardDeleteDialogTitle => '¿Eliminar grupo?';

  @override
  String get groupCardDeleteDialogContent =>
      'Esta acción cancelará la quedada para todos.';

  @override
  String get groupCardDeleteBack => 'Atrás';

  @override
  String get groupCardDeleteConfirm => 'Eliminar';

  @override
  String get groupCardLeaveDialogTitle => '¿Abandonar grupo?';

  @override
  String get groupCardLeaveDialogContent =>
      '¿Seguro que quieres salir del grupo?';

  @override
  String get groupCardCreatorCannotLeave =>
      'Eres el creador. Si quieres cancelar la quedada, elimínala.';

  @override
  String get groupCardLeaveCancel => 'Cancelar';

  @override
  String get groupCardLeaveConfirm => 'Abandonar';

  @override
  String get groupCardConfirmAttendanceTitle => '¿Confirmar asistencia?';

  @override
  String get groupCardConfirmAttendanceContent =>
      '¿Quieres confirmar tu asistencia a esta quedada?';

  @override
  String get groupCardConfirmAttendanceCancel => 'Cancelar';

  @override
  String get groupCardConfirmAttendanceConfirm => 'Confirmar';

  @override
  String get groupCardUnconfirmAttendanceTitle => '¿Desconfirmar asistencia?';

  @override
  String get groupCardUnconfirmAttendanceContent =>
      'Pasarás a estar en lista de espera. Podrás volver a confirmar más adelante.';

  @override
  String get groupCardUnconfirmAttendanceCancel => 'Cancelar';

  @override
  String get groupCardUnconfirmAttendanceConfirm => 'Desconfirmar';

  @override
  String get groupCardGroupDeleted => 'Grupo eliminado correctamente';

  @override
  String get groupCardJoinedSuccess => 'Te has unido a la quedada';

  @override
  String get groupCardLeftSuccess => 'Has abandonado la quedada';

  @override
  String get groupCardAttendanceConfirmed => 'Asistencia confirmada';

  @override
  String get groupCardAttendanceUnconfirmed =>
      'Asistencia desconfirmada. Estás en lista de espera.';

  @override
  String groupCardConfirmedCount(int count, int max) {
    return '✅ $count / $max confirmados';
  }

  @override
  String groupCardPendingCount(int count) {
    return '🕓 $count pendientes';
  }

  @override
  String get groupCardPendingAttendance =>
      'Tu asistencia está pendiente de confirmación';

  @override
  String get groupCardConfirmedAttendance => 'Asistencia confirmada';

  @override
  String get groupCardFullButton => 'Grupo lleno';

  @override
  String get groupCardJoinButton => 'Unirse';

  @override
  String get groupCardCreatedByYou => 'Creado por ti';

  @override
  String get groupCardUnconfirmButton => 'Desconfirmar';

  @override
  String get groupCardLeaveButton => 'Abandonar';

  @override
  String get groupCardConfirmButton => 'Confirmar asistencia';

  @override
  String groupCardJoinedCount(int count, int max) {
    return '👥 $count / $max apuntados';
  }

  @override
  String get groupCardValidatedText =>
      'Asistencia validada por geolocalización ✓';

  @override
  String get validateAttendanceValidatedSnackbar =>
      'Asistencia validada correctamente ✓';

  @override
  String validateAttendanceTooFarKnown(String distance) {
    return 'Estás demasiado lejos de la actividad: estás a $distance metros. Hay que estar a un máximo de 200 metros de la actividad para validar la asistencia.';
  }

  @override
  String get validateAttendanceTooFar =>
      'Estás demasiado lejos de la actividad. Hay que estar a un máximo de 200 metros de la actividad para validar la asistencia.';

  @override
  String get validateAttendanceGenericError => 'Error validando la asistencia';

  @override
  String get validateAttendanceValidatedButton => 'Asistencia validada ✓';

  @override
  String get validateAttendanceOutsideWindow =>
      'No puedes validar la asistencia porque estás fuera del período de la actividad';

  @override
  String get validateAttendanceLocationRequired =>
      'Hay que activar la ubicación para validar la asistencia';

  @override
  String get validateAttendanceButton => 'Validar asistencia';

  @override
  String get mapLocationDenied =>
      'No has concedido la ubicación. Se muestra el mapa en una posición predefinida.';

  @override
  String get mapLocationServiceDisabled =>
      'La ubicación del dispositivo está desactivada. Se muestra el mapa en una posición predefinida.';

  @override
  String get mapLocationPermissionRequiredTitle =>
      'Permiso de ubicación necesario';

  @override
  String get mapLocationPermissionRequiredContent =>
      'Has denegado el permiso de ubicación de manera permanente. Si quieres centrar el mapa en tu posición, debes ir a la configuración del móvil y habilitarlo.';

  @override
  String get mapLocationDialogNotNow => 'Ahora no';

  @override
  String get mapLocationDialogOpenSettings => 'Abrir configuración';

  @override
  String get mapInfoStart => 'Inicio';

  @override
  String get mapInfoEnd => 'Fin';

  @override
  String get mapInfoSpace => 'Espacio';

  @override
  String get mapInfoAddress => 'Dirección';

  @override
  String get mapDetailsButton => 'Detalles';

  @override
  String get mapGroupsButton => 'Quedadas';

  @override
  String get mapAppBarTitle => 'Mapa de actividades';

  @override
  String get mapFavoritesTooltip => 'Favoritos';

  @override
  String get mapNotificacionsTooltip => 'Notificaciones';

  @override
  String get mapCategoryAll => 'Todas';

  @override
  String get preferitsAppBarTitle => 'Guardados';

  @override
  String preferitsLoadError(String error) {
    return 'Error cargando favoritos: $error';
  }

  @override
  String get preferitsEmptyTitle => 'Aún no tienes actividades favoritas';

  @override
  String get preferitsEmptyDescription =>
      'Añádelas desde el detalle de una actividad.';

  @override
  String get buyTicketsFree => 'Enlace no disponible';

  @override
  String get buyTicketsGratuit =>
      'Entrada gratuita, no se requiere inscripción';

  @override
  String get buyTicketsLinkError =>
      'No se ha podido abrir el enlace. Inténtalo de nuevo.';

  @override
  String get buyTicketsLabel => 'Comprar entradas';

  @override
  String get secureImageLoadError => 'Error cargando imagen';

  @override
  String get secureImageDownloadTooltip => 'Descargar imagen';

  @override
  String get errorScreenTitle => '¡Error!';

  @override
  String get passwordRequirementsHeader => 'Requisitos de contraseña:';

  @override
  String passwordRequirementMinLength(int min) {
    return 'Mínim $min caracteres';
  }

  @override
  String get passwordRequirementUppercase => 'Al menos una mayúscula';

  @override
  String get passwordRequirementLowercase => 'Al menos una minúscula';

  @override
  String get passwordRequirementNumber => 'Al menos un número';

  @override
  String get passwordRequirementSpecialChar => 'Al menos un carácter especial';

  @override
  String get categoriaExposicions => 'Exposiciones';

  @override
  String get categoriaInfantil => 'Infantil';

  @override
  String get categoriaTeatre => 'Teatro';

  @override
  String get categoriaConcerts => 'Conciertos';

  @override
  String get categoriaFestes => 'Fiestas';

  @override
  String get categoriaFestivalsIMostres => 'Festivales y muestras';

  @override
  String get categoriaConferencies => 'Conferencias';

  @override
  String get categoriaRutesIVisites => 'Rutas y visitas';

  @override
  String get categoriaAltres => 'Otros';

  @override
  String get categoriaActivitatsVirtuals => 'Actividades virtuales';

  @override
  String get categoriaDansa => 'Danza';

  @override
  String get categoriaFiresIMercats => 'Ferias y mercados';

  @override
  String get categoriaCarnavals => 'Carnavales';

  @override
  String get categoriaCicles => 'Ciclos';

  @override
  String get categoriaSetmanaSanta => 'Semana Santa';

  @override
  String get categoriaSardanes => 'Sardanas';

  @override
  String get categoriaGegants => 'Gigantes';

  @override
  String get categoriaCirc => 'Circo';

  @override
  String get categoriaCommemoracions => 'Conmemoraciones';

  @override
  String get categoriaCursos => 'Cursos';

  @override
  String get categoriaNadal => 'Navidad';

  @override
  String get categoriaCulturaDigital => 'Cultura digital';

  @override
  String get categoriaAnyGaudi => 'Año Gaudí';

  @override
  String get gustosTitol => 'Mis gustos';

  @override
  String get gustosSettingsSubtitol =>
      'Modifica las categorías culturales que te interesan';

  @override
  String get gustosErrorCarregarCategories =>
      'No se han podido cargar las categorías';

  @override
  String get gustosTornaAIntentarHo => 'Volver a intentarlo';

  @override
  String get gustosSeleccionaInteressos => 'Selecciona tus intereses';

  @override
  String get gustosDesc =>
      'Elige las categorías culturales que te gustan para recibir recomendaciones personalizadas.';

  @override
  String gustosCategoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categorías seleccionadas',
      one: '$count categoría seleccionada',
    );
    return '$_temp0';
  }

  @override
  String get gustosContinuaButton => 'Guardar';

  @override
  String get gustosBenvingudaTitol => '¡Define tus gustos!';

  @override
  String get gustosBenvingudaDesc =>
      'Aún no has seleccionado ningún interés cultural. Elige tus preferencias para recibir recomendaciones de actividades personalizadas.';

  @override
  String get gustosBenvingudaAraNo => 'Ahora no';

  @override
  String get gustosBenvingudaEscullButton => 'Elegir gustos';

  @override
  String get searchHintWithProfiles =>
      'Buscar actividades, perfiles, espacios...';

  @override
  String get notificacionsTitol => 'Notificaciones';

  @override
  String get notificacionsRetry => 'Reintentar';

  @override
  String get notificacionsEmpty => 'No tienes ninguna notificación';

  @override
  String notificacionsDataAvui(String hora) {
    return 'Hoy a las $hora';
  }

  @override
  String notificacionsDataAhir(String hora) {
    return 'Ayer a las $hora';
  }

  @override
  String notificacionsDataDiaSetmana(String dia, String hora) {
    return '$dia a las $hora';
  }

  @override
  String get calendariTitol => 'Mi calendario';

  @override
  String get calendariSyncTooltip => 'Sincronizar con Google Calendar';

  @override
  String calendariSyncSuccess(int created, int updated, int deleted) {
    return 'Sincronizado: $created creados, $updated actualizados, $deleted eliminados';
  }

  @override
  String get calendariSyncSuccessNoResult => 'Sincronización completada';

  @override
  String get calendariSyncPermisDenega =>
      'Debes conceder permisos de acceso al calendario desde Configuración';

  @override
  String calendariSyncError(String error) {
    return 'Error: $error';
  }

  @override
  String get calendariErrorDesconegut => 'Error desconocido';

  @override
  String get calendariFormatMes => 'Mes';

  @override
  String get calendariErrorCarregant => 'Error cargando las quedadas';

  @override
  String get calendariSeleccionaDia =>
      'Selecciona un día para ver las quedadas';

  @override
  String get calendariCapQuedada => 'Sin quedadas este día';

  @override
  String get calendariLabelActivitat => 'Actividad';

  @override
  String get calendariLabelCategoria => 'Categoría';

  @override
  String get calendariLabelHora => 'Hora';

  @override
  String get calendariLabelRol => 'Rol';

  @override
  String get calendariLabelEstat => 'Estado';

  @override
  String get calendariRolAdministrador => 'Administrador';

  @override
  String get calendariRolMembre => 'Miembro';

  @override
  String get calendariEstatConfirmat => 'Confirmado';

  @override
  String get calendariEstatPendent => 'Pendiente';

  @override
  String get calendariEstatPendentConfirmacio => 'Pendiente de confirmación';

  @override
  String get estatCreador => 'Creador';

  @override
  String get estatValidat => 'Validado';

  @override
  String get estatApuntat => 'Apuntado';

  @override
  String get estatAmic => 'Amigo';

  @override
  String whatsappShareMessage(String titol, String url) {
    return 'Echa un vistazo a esta actividad en PlanC: $titol. Puedes ver más detalles aquí: $url';
  }

  @override
  String get postTooltipComentaris => 'Ver comentarios';

  @override
  String get modeFoscLabel => 'Modo oscuro';

  @override
  String get modeFoscSubtitol => 'Cambia la apariencia de la aplicación';

  @override
  String get qualitatAireTitol => 'Calidad del aire';

  @override
  String get qualitatAireBona => 'Buena';

  @override
  String get qualitatAireModerada => 'Moderada';

  @override
  String get qualitatAireDolentaGrups => 'Mala para grupos sensibles';

  @override
  String get qualitatAireDolenta => 'Mala';

  @override
  String get qualitatAireMoltDolenta => 'Muy mala';

  @override
  String qualitatAireEstacio(String nom) {
    return 'Estación: $nom';
  }

  @override
  String qualitatAireDistancia(String km) {
    return '$km km de la actividad';
  }

  @override
  String get qualitatAireNoDisponible =>
      'Datos no disponibles para esta ubicación';

  @override
  String get valorarTitol => 'Deja tu valoración';

  @override
  String get valorarLabelQuedada => 'Quedada';

  @override
  String get valorarSelectQuedada => 'Selecciona una quedada';

  @override
  String get valorarLabelPuntuacio => 'Puntuación';

  @override
  String get valorarLabelComentari => 'Comentario (opcional)';

  @override
  String get valorarComentariHint => 'Escribe tu comentario…';

  @override
  String valorarSuccessWithPoints(int punts) {
    return '¡Valoración enviada! Has ganado $punts puntos de bonificación.';
  }

  @override
  String get valorarSuccess => 'Valoración enviada correctamente.';

  @override
  String get valorarButtonNoPuntuacio => 'Selecciona una puntuación';

  @override
  String get valorarButtonEnviar => 'Enviar valoración';

  @override
  String get valorarButtonNoQuedada => 'Selecciona una quedada';

  @override
  String get valoracionsEmpty => 'Aún no hay reseñas para esta actividad';

  @override
  String valoracionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valoraciones',
      one: '1 valoración',
    );
    return '$_temp0';
  }

  @override
  String get valoracionsMitjana => 'Puntuación media';

  @override
  String get valoracionsLaTeva => '(la tuya)';

  @override
  String get valoracionsCarregarMes => 'Cargar más';

  @override
  String get valoracionsTitol => 'Valoraciones';

  @override
  String amicsApuntats(int count) {
    return '$count amigos apuntados';
  }

  @override
  String mesAmics(int count) {
    return '+$count amigos';
  }

  @override
  String nombreAssistents(int count) {
    return '$count asistentes';
  }

  @override
  String get valoracionsEmptyQuedada =>
      'Todavía no hay valoraciones para esta quedada.';

  @override
  String get seleccionaHora => 'Selecciona la hora';

  @override
  String get cancelLa => 'Cancelar';

  @override
  String get dacord => 'De acuerdo';

  @override
  String get filterAirQualityLabel => 'Calidad del aire';

  @override
  String get filterAirQualityToggle => 'Buscar por calidad del aire';

  @override
  String get filterAirQualityLevelAny => 'Cualquiera';

  @override
  String get filterAirQualityErrorNotFound =>
      'No se han encontrado actividades con esta calidad del aire en la zona';

  @override
  String get filterAirQualityErrorUnavailable =>
      'El servicio de calidad del aire no está disponible ahora mismo';

  @override
  String get filterAirQualityDisabledTooltip =>
      'No disponible con el filtro de calidad del aire';

  @override
  String get feedTabActivities => 'Actividades';

  @override
  String get feedTabPublications => 'Publicaciones';

  @override
  String get feedNoPublications => 'Todavía no hay publicaciones';

  @override
  String get feedPublicationsError =>
      'No se han podido cargar las publicaciones';

  @override
  String get feedPublicationsRetry => 'Reintentar';

  @override
  String get createPublicacioTitle => 'Nueva publicación';

  @override
  String get createPublicacioDescriptionHint => 'Escribe algo...';

  @override
  String get createPublicacioSelectActivity => 'Selecciona una actividad';

  @override
  String get createPublicacioLoadingActivities => 'Cargando actividades...';

  @override
  String get createPublicacioNoActivities =>
      'No estás apuntado a ninguna actividad activa';

  @override
  String get createPublicacioAddImage => 'Añadir imagen';

  @override
  String get createPublicacioChangeImage => 'Cambiar imagen';

  @override
  String get createPublicacioPublish => 'Publicar';

  @override
  String get createPublicacioRequiredDesc => 'Escribe una descripción';

  @override
  String get createPublicacioRequiredActivity => 'Selecciona una actividad';

  @override
  String get createPublicacioSuccess => '¡Publicación creada correctamente!';

  @override
  String get createPublicacioError => 'Error al crear la publicación';

  @override
  String get selectActivity =>
      'Selecciona sobre qué actividad quieres publicar';

  @override
  String get searchActivity => 'Busca la actividad';

  @override
  String get noActivitiesFound => 'No se han encontrado actividades recientes';

  @override
  String get mentionFriends => 'Menciona a amigos';

  @override
  String get done => 'Listo';

  @override
  String get searchFriends => 'Busca a amigos';

  @override
  String get noFriendsFound => 'No se han encontrado amigos';

  @override
  String get createPost => 'Crear publicación';

  @override
  String get createPostWarning =>
      '¡Añade el tipo de actividad y al menos una imagen para publicar!';

  @override
  String get posting => 'Publicando';

  @override
  String get post => 'Publicar';

  @override
  String get writeMessage => 'Escribe tu mensaje aquí...';

  @override
  String get addMultimedia => 'Añadir multimedia';

  @override
  String get editPost => 'Editar publicación';

  @override
  String get editPostWarning => 'La publicación debe tener al menos una imagen';

  @override
  String get saving => 'Guardando';

  @override
  String get save => 'Guardar';

  @override
  String get postTitle => 'Publicación';

  @override
  String get postDeleteMenuItem => 'Eliminar publicación';

  @override
  String get postEditMenuItem => 'Editar publicación';

  @override
  String get postDeleteDialogTitle => 'Eliminar publicación';

  @override
  String get postDeleteDialogBody =>
      '¿Estás seguro de que quieres eliminar esta publicación? Esta acción no se puede deshacer.';

  @override
  String get postDeleteCancel => 'Cancelar';

  @override
  String get postDeleteConfirm => 'Eliminar';

  @override
  String get postDeletedSuccess => 'Publicación eliminada correctamente';

  @override
  String postLikesCount(int count) {
    return '$count me gusta';
  }

  @override
  String postViewComments(int count) {
    return 'Ver los $count comentarios';
  }

  @override
  String get postSaveAction => 'Guardar';

  @override
  String get postUnsaveAction => 'Dejar de guardar';

  @override
  String get postSavedSuccess => 'Publicación guardada';

  @override
  String get postUnsavedSuccess => 'Publicación eliminada de guardados';

  @override
  String get postSaveError => 'Error al guardar la publicación';

  @override
  String get postLikedByTitle => 'Me gusta';

  @override
  String get postNoLikes => '¡Sé el primero en dar me gusta!';

  @override
  String get postLikesError => 'No se ha podido cargar la lista';

  @override
  String get comentarisTitle => 'Comentarios';

  @override
  String get comentarisError => 'Error al cargar los comentarios';

  @override
  String get comentarisEmpty => 'Aún no hay comentarios.\n¡Sé el primero!';

  @override
  String get comentariResponder => 'Responder';

  @override
  String comentariResponent(String nom) {
    return 'Respondiendo a $nom';
  }

  @override
  String get comentariHint => 'Escribe un comentario...';

  @override
  String comentariHintReply(String nom) {
    return 'Responde a $nom...';
  }

  @override
  String get createPostTitle => 'Crear publicación';

  @override
  String get createPostRequiredFields =>
      '¡Añade el tipo de actividad y al menos una imagen para publicar!';

  @override
  String createPostImageError(String error) {
    return 'No se pudo cargar la imagen: $error';
  }

  @override
  String get createPostPublishing => 'Publicando...';

  @override
  String get createPostPublish => 'Publicar';

  @override
  String get createPostActivityPickerTitle => '¿Qué estás haciendo?';

  @override
  String get createPostActivitySearch => 'Buscar actividad...';

  @override
  String get createPostActivityEmpty => 'No se encontraron actividades';

  @override
  String get createPostMentionTitle => 'Mencionar a un amigo';

  @override
  String get createPostMentionSearch => 'Buscar por nombre o username...';

  @override
  String get createPostMentionEmpty => 'No se encontraron amigos';

  @override
  String get createPostHint => 'Escribe tu mensaje aquí...';

  @override
  String get createPostAddMedia => 'Añadir multimedia';

  @override
  String createPostErrorActivity(String error) {
    return 'Error al cargar actividades: $error';
  }

  @override
  String createPostErrorFriends(String error) {
    return 'Error al cargar amigos: $error';
  }

  @override
  String createPostError(String error) {
    return 'Error al crear la publicación: $error';
  }

  @override
  String get timeJustNow => 'Ahora';

  @override
  String timeMinutesAgo(int n) {
    return 'Hace $n min';
  }

  @override
  String timeHoursAgo(int n) {
    return 'Hace $n h';
  }

  @override
  String get timeYesterday => 'Ayer';

  @override
  String timeDaysAgo(int n) {
    return 'Hace $n días';
  }

  @override
  String comentariShowReplies(int count) {
    return 'Ver $count respuestas';
  }

  @override
  String get comentariHideReplies => 'Ocultar respuestas';

  @override
  String get preferitsTabActivitats => 'Actividades';

  @override
  String get preferitsTabPublicacions => 'Publicaciones';

  @override
  String get preferitsPublicacionsEmptyTitle =>
      'Aún no tienes publicaciones guardadas';

  @override
  String get preferitsPublicacionsEmptyDescription =>
      'Guarda publicaciones para verlas aquí.';

  @override
  String get verifyEmailTitle => 'Verifica tu correo';

  @override
  String verifyEmailBody(String email) {
    return 'Hemos enviado un correo de verificación a $email. Ábrelo y haz clic en el enlace para activar la cuenta.';
  }

  @override
  String get verifyEmailAlreadyVerified => 'Ya he verificado';

  @override
  String get verifyEmailResend => 'Reenviar correo';

  @override
  String get verifyEmailResendSuccess => 'Correo reenviado correctamente';

  @override
  String get verifyEmailNotYet => 'Aún no has verificado el correo electrónico';

  @override
  String get verifyEmailBackToLogin => 'Volver al inicio';
}
