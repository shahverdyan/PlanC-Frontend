import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavTab { home, map, chat, notifications, calendar, profile }

final navigationProvider = StateProvider<NavTab>((ref) {
  return NavTab.home;
});

// 0 = Xats, 1 = Amistats
final chatSubTabProvider = StateProvider<int>((ref) => 0);

// S'incrementa quan l'usuari toca la pestanya Feed estant ja al Feed.
final feedScrollToTopProvider = StateProvider<int>((ref) => 0);