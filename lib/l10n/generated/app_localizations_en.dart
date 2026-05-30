// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titolApp => 'PlanC';

  @override
  String holaUsuari(String nom) {
    return 'Hello, $nom!';
  }

  @override
  String get seleccionaIdioma => 'Select a language:';

  @override
  String get catala => 'Català';

  @override
  String get espanol => 'Español';

  @override
  String get angles => 'English';

  @override
  String get configuracioTitol => 'Settings';

  @override
  String get seccioPreferencies => 'Preferences';

  @override
  String get idiomaLabel => 'Application language';

  @override
  String get errorGoogleMaps => 'Could not open Google Maps on this device';

  @override
  String get detallActivitatTitol => 'Activity details';

  @override
  String get compartirActivitatTooltip => 'Share activity';

  @override
  String get treurePreferidesTooltip => 'Remove from favorites';

  @override
  String get afegirPreferidesTooltip => 'Add to favorites';

  @override
  String get activitatAfegidaPreferides => 'Activity added to favorites';

  @override
  String get activitatEliminadaPreferides => 'Activity removed from favorites';

  @override
  String errorActualitzarPreferides(String error) {
    return 'Could not update favorites: $error';
  }

  @override
  String get descripcioTitol => 'Description';

  @override
  String get quanTitol => 'When';

  @override
  String get iniciLabel => 'Start';

  @override
  String get fiLabel => 'End';

  @override
  String get onTitol => 'Where';

  @override
  String get espaiLabel => 'Venue';

  @override
  String get adrecaLabel => 'Address';

  @override
  String get obrirGoogleMapsButton => 'Open in Google Maps';

  @override
  String get entradesTitol => 'Tickets';

  @override
  String get compartirXatTitol => 'Share to a chat';

  @override
  String get cercaXatHint => 'Search for a chat or group...';

  @override
  String activitatCompartidaExit(String chatName) {
    return 'Activity shared to: $chatName';
  }

  @override
  String errorCompartir(String error) {
    return 'Error sharing: $error';
  }

  @override
  String errorCarregarXats(String error) {
    return 'Error loading chats: $error';
  }

  @override
  String get noXatsTrobats => 'No chats found';

  @override
  String get enviarButton => 'Send';

  @override
  String get authDescubreixTitle => 'Discover';

  @override
  String get authConnectaTitle => 'Connect';

  @override
  String get authCreixTitle => 'Grow';

  @override
  String get authDescubreixDesc =>
      'Find cultural events in Catalonia tailored to your interests.';

  @override
  String get authConnectaDesc =>
      'Meet people with the same cultural tastes and team up.';

  @override
  String get authCreixDesc => 'Earn badges by enjoying culture.';

  @override
  String get authLoginButton => 'Sign In';

  @override
  String get authCreateAccountButton => 'Create an account';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginWelcomeBack => 'Nice to see you again';

  @override
  String get loginEmailOrUsernameLabel => 'Email / Username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginLoadingButton => 'Loading';

  @override
  String get loginSignInButton => 'Sign In';

  @override
  String get loginContinueWith => 'or continue with';

  @override
  String get loginGoogleButton => 'Continue with Google';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginSignUpHere => 'Sign up here';

  @override
  String get loginRequiredField => 'Required field';

  @override
  String get loginErrorFallback => 'Sign-in error';

  @override
  String get loginSuccessSnackbar => 'Signed in successfully';

  @override
  String get registerCreateAccountTitle => 'Create your account';

  @override
  String get registerUsernameLabel => 'Username';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerRepeatPasswordLabel => 'Confirm password';

  @override
  String get registerLoadingButton => 'Loading';

  @override
  String get registerSubmitButton => 'Register';

  @override
  String get registerUsernameMinError =>
      'Username must be at least 3 characters';

  @override
  String get registerUsernameMaxError =>
      'Username must be at most 20 characters';

  @override
  String get registerEmailInvalidError =>
      'The field must contain a valid email address';

  @override
  String get registerEmailTaken => 'This email is already in use';

  @override
  String get registerUsernameTaken => 'This username is already taken';

  @override
  String get registerChecking => 'Checking...';

  @override
  String get registerPasswordInvalidError => 'Invalid password';

  @override
  String get registerPasswordMismatchError => 'Passwords do not match';

  @override
  String get registerErrorFallback => 'Registration error';

  @override
  String get registerSuccessSnackbar => 'Account created successfully!';

  @override
  String get registerVerificationTitle => 'Account created!';

  @override
  String get registerVerificationSubtitle => 'Welcome to PlanC';

  @override
  String registerVerificationBody(String email) {
    return 'We sent a verification email to $email. Verify your account to enjoy all features.';
  }

  @override
  String get registerVerificationButton => 'Enter the app';

  @override
  String get registerContinueButton => 'Continue';

  @override
  String get registerSkipButton => 'Skip';

  @override
  String get registerStep2Title => 'About you';

  @override
  String get registerStep3Title => 'Profile photo';

  @override
  String get registerNameLabel => 'First name';

  @override
  String get registerSurnameLabel => 'Last name(s)';

  @override
  String get registerBioLabel => 'Biography';

  @override
  String get registerBioHint => 'Tell us about yourself (optional)...';

  @override
  String get registerAddPhotoButton => 'Add photo';

  @override
  String get registerNameRequiredError => 'Name is required';

  @override
  String get registerSurnameRequiredError => 'Surnames are required';

  @override
  String get registerBioMaxError => 'Maximum 160 characters';

  @override
  String registerStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get forgotPasswordTitle => 'Recover your password';

  @override
  String get forgotPasswordDescription =>
      'Enter your email and you will receive an email with instructions to reset it';

  @override
  String get forgotPasswordEmailInvalid => 'Enter a valid email';

  @override
  String get forgotPasswordButton => 'Recover password';

  @override
  String get forgotPasswordEmailSent =>
      'An email has been sent to the given address';

  @override
  String get forgotPasswordGoToLogin => 'Go to login';

  @override
  String get authWrapperCheckingSession => 'Checking session...';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountIrreversibleWarning => 'This action is irreversible';

  @override
  String get deleteAccountWarningDetails =>
      'The following will be permanently deleted: your profile, posts, comments, friendships and all personal data.';

  @override
  String get deleteAccountTypeConfirmInstruction =>
      'Type \"ELIMINAR\" to confirm';

  @override
  String get deleteAccountTypeConfirmLabel => 'Type ELIMINAR';

  @override
  String get deleteAccountTypeConfirmRequired => 'Type \"ELIMINAR\" to confirm';

  @override
  String get deleteAccountPasswordLabel => 'Enter your password to confirm';

  @override
  String get deleteAccountPasswordRequired => 'Enter your password';

  @override
  String get deleteAccountDialogTitle => 'Are you sure?';

  @override
  String get deleteAccountDialogContent =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get deleteAccountDialogCancel => 'Cancel';

  @override
  String get deleteAccountDialogConfirm => 'Delete permanently';

  @override
  String get deleteAccountSuccess =>
      'Your account has been deleted successfully';

  @override
  String get deleteAccountErrorFallback => 'Error deleting account';

  @override
  String get homeTabFeed => 'Feed';

  @override
  String get homeTabExplora => 'Explore';

  @override
  String get navInici => 'Home';

  @override
  String get feedDiscover => 'Discover';

  @override
  String get feedTrending => 'Trending';

  @override
  String get feedCategories => 'Categories';

  @override
  String get feedRecommended => 'Recommended for you';

  @override
  String get feedNearby => 'Near you';

  @override
  String get feedQuedades => 'Open meetups';

  @override
  String get feedQuedadesEmpty => 'No meetups available right now';

  @override
  String feedQuedadesParticipants(int current, int max) {
    return '$current/$max participants';
  }

  @override
  String get feedQuedadesJoin => 'View activity';

  @override
  String get searchDiscoverTitle => 'Suggestions';

  @override
  String get feedSeeAll => 'See all';

  @override
  String get feedFree => 'Free';

  @override
  String get feedInfoUnavailable => 'Info unavail.';

  @override
  String get feedLoadError => 'Could not load';

  @override
  String get activitatDetailError => 'Could not load the activity';

  @override
  String get feedEmpty => 'No activities';

  @override
  String get feedNoMoreActivities => 'No more activities';

  @override
  String get feedNoCategoryActivities => 'No activities in this category';

  @override
  String get feedRetry => 'Retry';

  @override
  String get feedLoadingMore => 'Loading more...';

  @override
  String get homeTabMap => 'Map';

  @override
  String get homeTabSearch => 'Search';

  @override
  String get homeTabChat => 'Community';

  @override
  String get homeTabNotifications => 'Notifications';

  @override
  String get homeTabCalendar => 'Calendar';

  @override
  String get homeTabProfile => 'Profile';

  @override
  String get profileFriendsBox => 'Friends';

  @override
  String get profilePostsBox => 'Posts';

  @override
  String get profileNoDescription => 'No description yet';

  @override
  String get profileEditButton => 'Edit profile';

  @override
  String get profileNoPosts => 'No publications yet';

  @override
  String get profileEnviarMissatge => 'Send message';

  @override
  String get profileXatNoDisponible => 'No chat found with this user';

  @override
  String get profilePublicationsSection => 'Posts';

  @override
  String get profileTrophiesSection => 'Trophies';

  @override
  String get profileNoTrophies =>
      'No trophies yet. Participate in activities to earn some!';

  @override
  String get trophyLevelLabel => 'Level';

  @override
  String get actualRankLabel => 'Current rank';

  @override
  String get achievedLevelLabel => 'Level achieved';

  @override
  String get levelProgressLabel => 'Level progress';

  @override
  String get pointsForNextLevelLabel => ' points to reach level ';

  @override
  String get close => 'Close';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileImageUpdated => 'Profile picture updated successfully';

  @override
  String editProfileImageError(String error) {
    return 'Error updating picture: $error';
  }

  @override
  String get editProfileUsernameLabel => 'Username';

  @override
  String get editProfileDescriptionLabel => 'Biography';

  @override
  String get editProfileNameLabel => 'Name';

  @override
  String get editProfileSurnameLabel => 'Surname';

  @override
  String get editProfileLogoutButton => 'Log out';

  @override
  String get editProfileDangerZone => 'Danger zone';

  @override
  String get editProfileDeleteAccount => 'Delete account';

  @override
  String get editProfileFieldSave => 'Save';

  @override
  String get friendsScreenTitle => 'Friendships';

  @override
  String get friendsScreenSubtitle =>
      'Here you can see incoming requests and pending outgoing ones.';

  @override
  String get friendsScreenSectionReceived => 'Received requests';

  @override
  String get friendsScreenSectionSent => 'Sent requests';

  @override
  String get friendsScreenNoReceived =>
      'You have no pending received requests.';

  @override
  String get friendsScreenNoSent => 'You have no pending sent requests.';

  @override
  String get friendsScreenWantsFriend => 'Wants to be your friend';

  @override
  String get friendsScreenAcceptButton => 'Accept';

  @override
  String get friendsScreenRejectButton => 'Reject';

  @override
  String get friendsScreenCancelButton => 'Cancel';

  @override
  String get friendsScreenPendingRequest => 'Pending request';

  @override
  String get friendsScreenRetry => 'Retry';

  @override
  String get friendsScreenAcceptedSuccess => 'Request accepted successfully';

  @override
  String get friendsScreenRejectedSuccess => 'Request rejected successfully';

  @override
  String get friendsScreenCanceledSuccess => 'Request canceled successfully';

  @override
  String get friendsListTitle => 'Friends';

  @override
  String get friendsListSearchHint => 'Search a friend...';

  @override
  String get friendsListNoResults => 'No friends match your search.';

  @override
  String get friendsListNoneOwn => 'You don\'t have any friends yet.';

  @override
  String get friendsListNoneOther => 'This user has no friends.';

  @override
  String get friendsListRemoveTooltip => 'Remove friend';

  @override
  String get friendsListRemoveDialogTitle => 'Remove friend';

  @override
  String friendsListRemoveDialogContent(String nom) {
    return 'Do you want to remove $nom from your friends list?';
  }

  @override
  String get friendsListRemoveCancel => 'Cancel';

  @override
  String get friendsListRemoveConfirm => 'Remove';

  @override
  String get friendsListRetry => 'Retry';

  @override
  String get relationshipRemoveFriend => 'Remove friend';

  @override
  String get relationshipAccept => 'Accept';

  @override
  String get relationshipReject => 'Reject';

  @override
  String get relationshipRequestSent => 'Request sent';

  @override
  String get relationshipCancel => 'Cancel';

  @override
  String get relationshipSendRequest => 'Send friend request';

  @override
  String get relationshipRetry => 'Retry';

  @override
  String relationshipErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get searchTabAll => 'All';

  @override
  String get searchTabProfiles => 'Profiles';

  @override
  String get searchTabActivities => 'Activities';

  @override
  String get searchTabSpaces => 'Venues';

  @override
  String get searchHint => 'Search activities, venues...';

  @override
  String get searchFiltersTooltip => 'Filters';

  @override
  String get searchRecentTitle => 'Recent searches';

  @override
  String searchActivitiesHeader(int count) {
    return 'Activities ($count)';
  }

  @override
  String searchSpacesHeader(int count) {
    return 'Venues ($count)';
  }

  @override
  String get filterTitle => 'Filters';

  @override
  String get filterClear => 'Clear filters';

  @override
  String get filterPriceLabel => 'Price';

  @override
  String get filterPriceAll => 'All';

  @override
  String get filterPriceFree => 'Free';

  @override
  String get filterPricePaid => 'Paid';

  @override
  String filterDistanceLabel(int km) {
    return 'Distance: $km km';
  }

  @override
  String get filterLocationPermissionNeeded =>
      'Location permissions are required to use this filter.';

  @override
  String get filterDateLabel => 'Date';

  @override
  String get filterDateAll => 'All dates';

  @override
  String get filterDateToday => 'Today';

  @override
  String get filterDateWeekend => 'Weekend';

  @override
  String get filterDateCalendar => '📅 Calendar';

  @override
  String get filterApply => 'Apply filters';

  @override
  String get filterNoLocation =>
      'Could not get location. The distance filter will not be applied.';

  @override
  String get emptySearchFilterTitle => 'No activity matches the filters';

  @override
  String get emptySearchSearchTitle => 'No matches found';

  @override
  String get emptySearchFilterDescription =>
      'Try widening the distance, changing the dates or modifying price filters.';

  @override
  String emptySearchSearchDescription(String terme) {
    return 'We found no results for \"$terme\".\nTry a different term or explore the categories.';
  }

  @override
  String get emptySearchModifyFilters => 'Modify filters';

  @override
  String get emptySearchCategoryMusic => 'Music';

  @override
  String get emptySearchCategoryTheater => 'Theatre';

  @override
  String get emptySearchCategoryArt => 'Art';

  @override
  String get emptySearchCategoryCinema => 'Cinema';

  @override
  String get chatNotificationsTitle => 'Community';

  @override
  String get chatTabChats => 'Chats';

  @override
  String get chatTabFriendships => 'Friendships';

  @override
  String get myChatsTitle => 'My chats';

  @override
  String chatListError(String error) {
    return 'Error loading chats: $error';
  }

  @override
  String get chatListEmpty =>
      'You don\'t have any active chats yet.\nJoin a meetup!';

  @override
  String get chatDeleteDialogTitle => 'Delete chat';

  @override
  String chatDeleteDialogContent(String name) {
    return 'Are you sure you want to delete \"$name\"? The message history will disappear for you.';
  }

  @override
  String get chatDeleteCancel => 'Cancel';

  @override
  String get chatDeleteConfirm => 'Delete';

  @override
  String chatDeletedSnackbar(String name) {
    return '$name deleted';
  }

  @override
  String get chatUnmuteAction => 'Unmute chat';

  @override
  String get chatMuteAction => 'Mute chat';

  @override
  String chatUnmutedSnackbar(String name) {
    return '$name unmuted';
  }

  @override
  String chatMutedSnackbar(String name) {
    return '$name muted';
  }

  @override
  String chatRoomNotFoundError(String error) {
    return 'Error sending message: $error';
  }

  @override
  String chatRoomImagePickError(String error) {
    return 'Error selecting image: $error';
  }

  @override
  String chatRoomImageCaptureError(String error) {
    return 'Error capturing image: $error';
  }

  @override
  String get chatRoomTodayLabel => 'TODAY';

  @override
  String get chatRoomYesterdayLabel => 'YESTERDAY';

  @override
  String get chatRoomAttachmentGallery => 'Gallery';

  @override
  String get chatRoomAttachmentCamera => 'Camera';

  @override
  String get chatRoomNoMessages => 'No messages yet';

  @override
  String get chatRoomStartConversation => 'Start the conversation!';

  @override
  String get chatRoomLoadOlder => 'Load older messages';

  @override
  String get chatRoomSomeoneTyping => 'Someone is typing...';

  @override
  String get chatRoomInactiveBannerTitle => 'Inactive chat';

  @override
  String get chatRoomInactiveBannerBody =>
      'This chat no longer allows sending messages. This may be because:\n\n• The meetup took place more than 48 hours ago and the chat was automatically closed.\n• An administrator cancelled the meetup and the chat was blocked.';

  @override
  String get chatRoomReadOnlyNotice => 'Inactive chat · Read only';

  @override
  String get chatRoomInputHint => 'Write a message...';

  @override
  String get chatRoomMuteUnmuteError => 'Error changing mute state';

  @override
  String get chatRoomMuteOff => 'Notifications enabled';

  @override
  String get chatRoomMuteOn => 'Chat muted';

  @override
  String get chatRoomActivityError => 'Error loading the activity';

  @override
  String get chatRoomActivityNoTitle => 'No title';

  @override
  String get chatRoomActivityNoLocation => 'No location';

  @override
  String get chatRoomActivityCategoryOther => 'Other';

  @override
  String get chatRoomViewActivity => 'View activity';

  @override
  String get chatDetailsAppBarTitle => 'Chat details';

  @override
  String get chatDetailsLoadError => 'Error loading chat details';

  @override
  String get chatDetailsFallbackTitle => 'Details';

  @override
  String get chatDetailsTypeFriendGroup => 'Friend group';

  @override
  String get chatDetailsTypeMeetup => 'Meetup';

  @override
  String get chatDetailsTypeIndividual => 'Individual chat';

  @override
  String get chatDetailsPhotoUpdateNotice =>
      'Photo update requires server support (Coming soon)';

  @override
  String get chatDetailsPhotoUpdateSuccess =>
      'Group photo updated successfully';

  @override
  String chatDetailsPhotoUpdateError(String error) {
    return 'Error updating photo: $error';
  }

  @override
  String get chatDetailsMembersHeader => 'CHAT MEMBERS';

  @override
  String get chatDetailsLeaveChat => 'Leave Chat';

  @override
  String get chatDetailsDeleteChat => 'Delete Chat';

  @override
  String get chatDetailsLeaveGroupDialogTitle => 'Leave Group';

  @override
  String get chatDetailsDeleteChatDialogTitle => 'Delete Chat';

  @override
  String chatDetailsLeaveGroupDialogContent(String name) {
    return 'Are you sure you want to leave \"$name\"? You will stop receiving messages from this group.';
  }

  @override
  String chatDetailsDeleteChatDialogContent(String name) {
    return 'Are you sure you want to delete \"$name\"? The history will disappear.';
  }

  @override
  String get chatDetailsActionCancel => 'Cancel';

  @override
  String get chatDetailsLeaveButton => 'Leave';

  @override
  String get chatDetailsDeleteButton => 'Delete';

  @override
  String get chatDetailsGroupLeftSnackbar => 'You have left the group';

  @override
  String get chatDetailsChatDeletedSnackbar => 'Chat deleted';

  @override
  String get chatDetailsActionError => 'Error performing the action';

  @override
  String get veurQuedades => 'View meetups';

  @override
  String get mostrarMes => 'Show more';

  @override
  String get mostrarMenys => 'Show less';

  @override
  String get chatDetailsQuedadaInfoHeader => 'MEETUP INFORMATION';

  @override
  String get chatDetailsQuedadaActivity => 'Activity';

  @override
  String get chatDetailsQuedadaDate => 'Date';

  @override
  String get chatDetailsQuedadaViewActivity => 'View activity';

  @override
  String groupsActivityTitle(String titol) {
    return 'Meetups: $titol';
  }

  @override
  String groupsLoadError(String error) {
    return 'Error loading meetups:\n$error';
  }

  @override
  String get groupsEmpty =>
      'There are no meetups for this activity yet.\nBe the first to create one!';

  @override
  String get groupsCreateButton => 'Create Meetup';

  @override
  String get groupFormEditTitle => 'Edit Meetup';

  @override
  String get groupFormCreateTitle => 'Create Meetup';

  @override
  String get groupFormModifyHeader => 'Edit the meetup details';

  @override
  String get groupFormConfigureHeader => 'Configure your meetup';

  @override
  String get groupFormTitleLabel => 'Meetup title';

  @override
  String get groupFormTitleHint => 'E.g.: Padel match';

  @override
  String get groupFormDescriptionLabel => 'Description';

  @override
  String get groupFormMinLabel => 'Minimum';

  @override
  String get groupFormMaxLabel => 'Maximum';

  @override
  String get groupFormMinAtLeastOne => 'Must be at least 1';

  @override
  String get groupFormMaxGreaterEqualMin =>
      'Must be equal to or greater than the minimum';

  @override
  String get groupFormPickDateTime => 'Pick date and time';

  @override
  String groupFormDateValue(int dia, int mes, String hora) {
    return 'Date: $dia/$mes at $hora';
  }

  @override
  String get groupFormDateRequired => 'You must select a date and time';

  @override
  String get groupFormSaveButton => 'SAVE CHANGES';

  @override
  String get groupFormCreateButton => 'CREATE GROUP';

  @override
  String get groupFormRequiredField => 'Required field';

  @override
  String get groupFormNoUser => 'Authenticated user not found';

  @override
  String get groupFormCreateSuccess => 'Group created successfully!';

  @override
  String get groupFormUpdateSuccess => 'Group updated successfully!';

  @override
  String groupFormErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get groupFormDatePast => 'The date and time cannot be in the past';

  @override
  String get groupFormAddPhoto => 'Add a group photo';

  @override
  String get groupFormAddPhotoSubtitle => 'Optional · Tap to select';

  @override
  String get groupFormChangePhoto => 'Change photo';

  @override
  String get groupCardNoUserError => 'Authenticated user not found';

  @override
  String get groupCardDeleteDialogTitle => 'Delete group?';

  @override
  String get groupCardDeleteDialogContent =>
      'This action will cancel the meetup for everyone.';

  @override
  String get groupCardDeleteBack => 'Back';

  @override
  String get groupCardDeleteConfirm => 'Delete';

  @override
  String get groupCardLeaveDialogTitle => 'Leave group?';

  @override
  String get groupCardLeaveDialogContent =>
      'Are you sure you want to leave the group?';

  @override
  String get groupCardCreatorCannotLeave =>
      'You are the creator. If you want to cancel the meetup, delete it.';

  @override
  String get groupCardLeaveCancel => 'Cancel';

  @override
  String get groupCardLeaveConfirm => 'Leave';

  @override
  String get groupCardConfirmAttendanceTitle => 'Confirm attendance?';

  @override
  String get groupCardConfirmAttendanceContent =>
      'Do you want to confirm your attendance to this meetup?';

  @override
  String get groupCardConfirmAttendanceCancel => 'Cancel';

  @override
  String get groupCardConfirmAttendanceConfirm => 'Confirm';

  @override
  String get groupCardUnconfirmAttendanceTitle => 'Unconfirm attendance?';

  @override
  String get groupCardUnconfirmAttendanceContent =>
      'You will be placed on the waiting list. You will be able to confirm again later.';

  @override
  String get groupCardUnconfirmAttendanceCancel => 'Cancel';

  @override
  String get groupCardUnconfirmAttendanceConfirm => 'Unconfirm';

  @override
  String get groupCardGroupDeleted => 'Group deleted successfully';

  @override
  String get groupCardJoinedSuccess => 'You have joined the meetup';

  @override
  String get groupCardLeftSuccess => 'You have left the meetup';

  @override
  String get groupCardAttendanceConfirmed => 'Attendance confirmed';

  @override
  String get groupCardAttendanceUnconfirmed =>
      'Attendance unconfirmed. You are on the waiting list.';

  @override
  String groupCardConfirmedCount(int count, int max) {
    return '✅ $count / $max confirmed';
  }

  @override
  String groupCardPendingCount(int count) {
    return '🕓 $count pending';
  }

  @override
  String get groupCardPendingAttendance =>
      'Your attendance is pending confirmation';

  @override
  String get groupCardConfirmedAttendance => 'Attendance confirmed';

  @override
  String get groupCardFullButton => 'Group full';

  @override
  String get groupCardJoinButton => 'Join';

  @override
  String get groupCardCreatedByYou => 'Created by you';

  @override
  String get groupCardUnconfirmButton => 'Unconfirm';

  @override
  String get groupCardLeaveButton => 'Leave';

  @override
  String get groupCardConfirmButton => 'Confirm attendance';

  @override
  String groupCardJoinedCount(int count, int max) {
    return '👥 $count / $max joined';
  }

  @override
  String get groupCardValidatedText => 'Attendance validated by geolocation ✓';

  @override
  String get validateAttendanceValidatedSnackbar =>
      'Attendance validated successfully ✓';

  @override
  String validateAttendanceTooFarKnown(String distance) {
    return 'You are too far from the activity: you are $distance meters away. You must be within 200 meters of the activity to validate attendance.';
  }

  @override
  String get validateAttendanceTooFar =>
      'You are too far from the activity. You must be within 200 meters of the activity to validate attendance.';

  @override
  String get validateAttendanceGenericError => 'Error validating attendance';

  @override
  String get validateAttendanceValidatedButton => 'Attendance validated ✓';

  @override
  String get validateAttendanceOutsideWindow =>
      'You can\'t validate attendance because you are outside the activity window';

  @override
  String get validateAttendanceLocationRequired =>
      'Location must be enabled to validate attendance';

  @override
  String get validateAttendanceButton => 'Validate attendance';

  @override
  String get mapLocationDenied =>
      'Location not granted. The map is shown at a default position.';

  @override
  String get mapLocationServiceDisabled =>
      'Device location is disabled. The map is shown at a default position.';

  @override
  String get mapLocationPermissionRequiredTitle =>
      'Location permission required';

  @override
  String get mapLocationPermissionRequiredContent =>
      'You have permanently denied location permission. If you want to center the map on your position, go to your device settings and enable it.';

  @override
  String get mapLocationDialogNotNow => 'Not now';

  @override
  String get mapLocationDialogOpenSettings => 'Open settings';

  @override
  String get mapInfoStart => 'Start';

  @override
  String get mapInfoEnd => 'End';

  @override
  String get mapInfoSpace => 'Venue';

  @override
  String get mapInfoAddress => 'Address';

  @override
  String get mapDetailsButton => 'Details';

  @override
  String get mapGroupsButton => 'Meetups';

  @override
  String get mapAppBarTitle => 'Activities map';

  @override
  String get mapFavoritesTooltip => 'Favorites';

  @override
  String get mapNotificacionsTooltip => 'Notifications';

  @override
  String get mapCategoryAll => 'All';

  @override
  String get preferitsAppBarTitle => 'Saved';

  @override
  String preferitsLoadError(String error) {
    return 'Error loading favorites: $error';
  }

  @override
  String get preferitsEmptyTitle =>
      'You don\'t have any favorite activities yet';

  @override
  String get preferitsEmptyDescription =>
      'Add them from the activity detail screen.';

  @override
  String get buyTicketsFree => 'Link not available';

  @override
  String get buyTicketsGratuit => 'Free entry, no registration required';

  @override
  String get buyTicketsLinkError =>
      'Could not open the link. Please try again.';

  @override
  String get buyTicketsLabel => 'Buy tickets';

  @override
  String get secureImageLoadError => 'Error loading image';

  @override
  String get secureImageDownloadTooltip => 'Download image';

  @override
  String get errorScreenTitle => 'Error!';

  @override
  String get passwordRequirementsHeader => 'Password requirements:';

  @override
  String passwordRequirementMinLength(int min) {
    return 'At least $min characters';
  }

  @override
  String get passwordRequirementUppercase => 'At least one uppercase letter';

  @override
  String get passwordRequirementLowercase => 'At least one lowercase letter';

  @override
  String get passwordRequirementNumber => 'At least one number';

  @override
  String get passwordRequirementSpecialChar => 'At least one special character';

  @override
  String get categoriaExposicions => 'Exhibitions';

  @override
  String get categoriaInfantil => 'Kids';

  @override
  String get categoriaTeatre => 'Theatre';

  @override
  String get categoriaConcerts => 'Concerts';

  @override
  String get categoriaFestes => 'Parties';

  @override
  String get categoriaFestivalsIMostres => 'Festivals & Shows';

  @override
  String get categoriaConferencies => 'Conferences';

  @override
  String get categoriaRutesIVisites => 'Tours & Visits';

  @override
  String get categoriaAltres => 'Other';

  @override
  String get categoriaActivitatsVirtuals => 'Virtual activities';

  @override
  String get categoriaDansa => 'Dance';

  @override
  String get categoriaFiresIMercats => 'Fairs & Markets';

  @override
  String get categoriaCarnavals => 'Carnavals';

  @override
  String get categoriaCicles => 'Cycles';

  @override
  String get categoriaSetmanaSanta => 'Holy Week';

  @override
  String get categoriaSardanes => 'Sardanes';

  @override
  String get categoriaGegants => 'Giants';

  @override
  String get categoriaCirc => 'Circus';

  @override
  String get categoriaCommemoracions => 'Commemorations';

  @override
  String get categoriaCursos => 'Courses';

  @override
  String get categoriaNadal => 'Christmas';

  @override
  String get categoriaCulturaDigital => 'Digital culture';

  @override
  String get categoriaAnyGaudi => 'Gaudí Year';

  @override
  String get gustosTitol => 'My interests';

  @override
  String get gustosSettingsSubtitol =>
      'Modify the cultural categories that interest you';

  @override
  String get gustosErrorCarregarCategories => 'Could not load categories';

  @override
  String get gustosTornaAIntentarHo => 'Try again';

  @override
  String get gustosSeleccionaInteressos => 'Select your interests';

  @override
  String get gustosDesc =>
      'Choose the cultural categories you like to receive personalized recommendations.';

  @override
  String gustosCategoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories selected',
      one: '$count category selected',
    );
    return '$_temp0';
  }

  @override
  String get gustosContinuaButton => 'Save';

  @override
  String get gustosBenvingudaTitol => 'Define your interests!';

  @override
  String get gustosBenvingudaDesc =>
      'You haven\'t selected any cultural interests yet. Choose your preferences to receive personalized activity recommendations.';

  @override
  String get gustosBenvingudaAraNo => 'Not now';

  @override
  String get gustosBenvingudaEscullButton => 'Choose interests';

  @override
  String get searchHintWithProfiles => 'Search activities, profiles, spaces...';

  @override
  String get notificacionsTitol => 'Notifications';

  @override
  String get notificacionsRetry => 'Retry';

  @override
  String get notificacionsEmpty => 'You have no notifications';

  @override
  String notificacionsDataAvui(String hora) {
    return 'Today at $hora';
  }

  @override
  String notificacionsDataAhir(String hora) {
    return 'Yesterday at $hora';
  }

  @override
  String notificacionsDataDiaSetmana(String dia, String hora) {
    return '$dia at $hora';
  }

  @override
  String get calendariTitol => 'My calendar';

  @override
  String get calendariSyncTooltip => 'Sync with Google Calendar';

  @override
  String calendariSyncSuccess(int created, int updated, int deleted) {
    return 'Synced: $created created, $updated updated, $deleted deleted';
  }

  @override
  String get calendariSyncSuccessNoResult => 'Sync completed';

  @override
  String get calendariSyncPermisDenega =>
      'Calendar access permission must be granted from Settings';

  @override
  String calendariSyncError(String error) {
    return 'Error: $error';
  }

  @override
  String get calendariErrorDesconegut => 'Unknown error';

  @override
  String get calendariFormatMes => 'Month';

  @override
  String get calendariErrorCarregant => 'Error loading meetups';

  @override
  String get calendariSeleccionaDia => 'Select a day to see meetups';

  @override
  String get calendariCapQuedada => 'No meetups this day';

  @override
  String get calendariLabelActivitat => 'Activity';

  @override
  String get calendariLabelCategoria => 'Category';

  @override
  String get calendariLabelHora => 'Time';

  @override
  String get calendariLabelRol => 'Role';

  @override
  String get calendariLabelEstat => 'Status';

  @override
  String get calendariRolAdministrador => 'Administrator';

  @override
  String get calendariRolMembre => 'Member';

  @override
  String get calendariEstatConfirmat => 'Confirmed';

  @override
  String get calendariEstatPendent => 'Pending';

  @override
  String get calendariEstatPendentConfirmacio => 'Pending confirmation';

  @override
  String get estatCreador => 'Creator';

  @override
  String get estatValidat => 'Validated';

  @override
  String get estatApuntat => 'Signed up';

  @override
  String get estatAmic => 'Friend';

  @override
  String whatsappShareMessage(String titol, String url) {
    return 'Check out this activity on PlanC: $titol. You can see more details here: $url';
  }

  @override
  String get postTooltipComentaris => 'View comments';

  @override
  String get modeFoscLabel => 'Dark mode';

  @override
  String get modeFoscSubtitol => 'Change the app appearance';

  @override
  String get qualitatAireTitol => 'Air quality';

  @override
  String get qualitatAireBona => 'Good';

  @override
  String get qualitatAireModerada => 'Moderate';

  @override
  String get qualitatAireDolentaGrups => 'Unhealthy for sensitive groups';

  @override
  String get qualitatAireDolenta => 'Unhealthy';

  @override
  String get qualitatAireMoltDolenta => 'Very unhealthy';

  @override
  String qualitatAireEstacio(String nom) {
    return 'Station: $nom';
  }

  @override
  String qualitatAireDistancia(String km) {
    return '$km km from the activity';
  }

  @override
  String get qualitatAireNoDisponible => 'Data not available for this location';

  @override
  String get valorarTitol => 'Leave your review';

  @override
  String get valorarLabelQuedada => 'Meetup';

  @override
  String get valorarSelectQuedada => 'Select a meetup';

  @override
  String get valorarLabelPuntuacio => 'Rating';

  @override
  String get valorarLabelComentari => 'Comment (optional)';

  @override
  String get valorarComentariHint => 'Write your comment…';

  @override
  String valorarSuccessWithPoints(int punts) {
    return 'Review sent! You earned $punts bonus points.';
  }

  @override
  String get valorarSuccess => 'Review sent successfully.';

  @override
  String get valorarButtonNoPuntuacio => 'Select a rating';

  @override
  String get valorarButtonEnviar => 'Submit review';

  @override
  String get valorarButtonNoQuedada => 'Select a meetup';

  @override
  String get valoracionsEmpty => 'No reviews yet for this activity';

  @override
  String valoracionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get valoracionsMitjana => 'Average rating';

  @override
  String get valoracionsLaTeva => '(yours)';

  @override
  String get valoracionsCarregarMes => 'Load more';

  @override
  String get valoracionsTitol => 'Ratings';

  @override
  String amicsApuntats(int count) {
    return '$count friends signed up';
  }

  @override
  String mesAmics(int count) {
    return '+$count friends';
  }

  @override
  String nombreAssistents(int count) {
    return '$count attendees';
  }

  @override
  String get valoracionsEmptyQuedada =>
      'There are no ratings for this event yet.';

  @override
  String get seleccionaHora => 'Select time';

  @override
  String get cancelLa => 'Cancel';

  @override
  String get dacord => 'OK';

  @override
  String get filterAirQualityLabel => 'Air quality';

  @override
  String get filterAirQualityToggle => 'Search by air quality';

  @override
  String get filterAirQualityLevelAny => 'Any';

  @override
  String get filterAirQualityErrorNotFound =>
      'No activities found with this air quality in the area';

  @override
  String get filterAirQualityErrorUnavailable =>
      'The air quality service is not available right now';

  @override
  String get filterAirQualityDisabledTooltip =>
      'Not available with air quality filter';

  @override
  String get feedTabActivities => 'Activities';

  @override
  String get feedTabPublications => 'Publications';

  @override
  String get feedNoPublications => 'There are no publications yet';

  @override
  String get feedPublicationsError => 'Could not load publications';

  @override
  String get feedPublicationsRetry => 'Retry';

  @override
  String get createPublicacioTitle => 'New post';

  @override
  String get createPublicacioDescriptionHint => 'Write something...';

  @override
  String get createPublicacioSelectActivity => 'Select an activity';

  @override
  String get createPublicacioLoadingActivities => 'Loading activities...';

  @override
  String get createPublicacioNoActivities =>
      'You are not enrolled in any active activity';

  @override
  String get createPublicacioAddImage => 'Add image';

  @override
  String get createPublicacioChangeImage => 'Change image';

  @override
  String get createPublicacioPublish => 'Publish';

  @override
  String get createPublicacioRequiredDesc => 'Write a description';

  @override
  String get createPublicacioRequiredActivity => 'Select an activity';

  @override
  String get createPublicacioSuccess => 'Post created successfully!';

  @override
  String get createPublicacioError => 'Error creating the post';

  @override
  String get selectActivity => 'Select which activity you want to post about';

  @override
  String get searchActivity => 'Search for the activity';

  @override
  String get noActivitiesFound => 'No recent activities found';

  @override
  String get mentionFriends => 'Mention friends';

  @override
  String get done => 'Done';

  @override
  String get searchFriends => 'Search for friends';

  @override
  String get noFriendsFound => 'No friends found';

  @override
  String get createPost => 'Create post';

  @override
  String get createPostWarning =>
      'Add the activity type and at least one image to post!';

  @override
  String get posting => 'Posting';

  @override
  String get post => 'Post';

  @override
  String get writeMessage => 'Write your message here...';

  @override
  String get addMultimedia => 'Add multimedia';

  @override
  String get editPost => 'Edit post';

  @override
  String get editPostWarning => 'The post must have at least one image';

  @override
  String get saving => 'Saving';

  @override
  String get save => 'Save';

  @override
  String get postTitle => 'Post';

  @override
  String get postDeleteMenuItem => 'Delete post';

  @override
  String get postEditMenuItem => 'Edit post';

  @override
  String get postDeleteDialogTitle => 'Delete post';

  @override
  String get postDeleteDialogBody =>
      'Are you sure you want to delete this post? This action cannot be undone.';

  @override
  String get postDeleteCancel => 'Cancel';

  @override
  String get postDeleteConfirm => 'Delete';

  @override
  String get postDeletedSuccess => 'Post deleted successfully';

  @override
  String postLikesCount(int count) {
    return '$count likes';
  }

  @override
  String postViewComments(int count) {
    return 'View $count comments';
  }

  @override
  String get postSaveAction => 'Save';

  @override
  String get postUnsaveAction => 'Unsave';

  @override
  String get postSavedSuccess => 'Post saved';

  @override
  String get postUnsavedSuccess => 'Post removed from saved';

  @override
  String get postSaveError => 'Error saving the post';

  @override
  String get postLikedByTitle => 'Likes';

  @override
  String get postNoLikes => 'Be the first to like this!';

  @override
  String get postLikesError => 'Could not load the list';

  @override
  String get comentarisTitle => 'Comments';

  @override
  String get comentarisError => 'Error loading comments';

  @override
  String get comentarisEmpty => 'No comments yet.\nBe the first!';

  @override
  String get comentariResponder => 'Reply';

  @override
  String comentariResponent(String nom) {
    return 'Replying to $nom';
  }

  @override
  String get comentariHint => 'Write a comment...';

  @override
  String comentariHintReply(String nom) {
    return 'Reply to $nom...';
  }

  @override
  String get createPostTitle => 'Create post';

  @override
  String get createPostRequiredFields =>
      'Add the activity type and at least one image to publish!';

  @override
  String createPostImageError(String error) {
    return 'Could not load the image: $error';
  }

  @override
  String get createPostPublishing => 'Publishing...';

  @override
  String get createPostPublish => 'Publish';

  @override
  String get createPostActivityPickerTitle => 'What are you doing?';

  @override
  String get createPostActivitySearch => 'Search activity...';

  @override
  String get createPostActivityEmpty => 'No activities found';

  @override
  String get createPostMentionTitle => 'Mention a friend';

  @override
  String get createPostMentionSearch => 'Search by name or username...';

  @override
  String get createPostMentionEmpty => 'No friends found';

  @override
  String get createPostHint => 'Write your message here...';

  @override
  String get createPostAddMedia => 'Add media';

  @override
  String createPostErrorActivity(String error) {
    return 'Error loading activities: $error';
  }

  @override
  String createPostErrorFriends(String error) {
    return 'Error loading friends: $error';
  }

  @override
  String createPostError(String error) {
    return 'Error creating the post: $error';
  }

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String timeHoursAgo(int n) {
    return '$n h ago';
  }

  @override
  String get timeYesterday => 'Yesterday';

  @override
  String timeDaysAgo(int n) {
    return '$n days ago';
  }

  @override
  String comentariShowReplies(int count) {
    return 'View $count replies';
  }

  @override
  String get comentariHideReplies => 'Hide replies';

  @override
  String get preferitsTabActivitats => 'Activities';

  @override
  String get preferitsTabPublicacions => 'Publications';

  @override
  String get preferitsPublicacionsEmptyTitle => 'No saved publications yet';

  @override
  String get preferitsPublicacionsEmptyDescription =>
      'Save publications to see them here.';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String verifyEmailBody(String email) {
    return 'We sent a verification email to $email. Open it and click the link to activate your account.';
  }

  @override
  String get verifyEmailAlreadyVerified => 'I have verified';

  @override
  String get verifyEmailResend => 'Resend email';

  @override
  String get verifyEmailResendSuccess => 'Email resent successfully';

  @override
  String get verifyEmailNotYet => 'You haven\'t verified your email yet';

  @override
  String get verifyEmailBackToLogin => 'Back to login';
}
