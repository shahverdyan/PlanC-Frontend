import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';
import 'package:plan_c_frontend/core/providers/locale_provider.dart';
import 'package:plan_c_frontend/core/providers/theme_provider.dart';
import 'package:plan_c_frontend/features/auth/presentation/main_auth_wrapper.dart';
import 'package:plan_c_frontend/core/deep_link/deep_link_loader_screen.dart';
import 'package:plan_c_frontend/core/deep_link/deep_link_parser.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';

class _GencatTrustedHttpOverrides extends HttpOverrides {
  final SecurityContext _ctx;
  _GencatTrustedHttpOverrides(this._ctx);

  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(_ctx);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ctx = SecurityContext(withTrustedRoots: true);
  for (final path in [
    'assets/certs/gencat_ca.crt',
    'assets/certs/gencat_intermediate.cer',
  ]) {
    final bytes = await rootBundle.load(path);
    ctx.setTrustedCertificatesBytes(bytes.buffer.asUint8List());
  }
  HttpOverrides.global = _GencatTrustedHttpOverrides(ctx);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  debugPrint('🛑 PASO 1: Flutter inicializado correctamente');

  await Firebase.initializeApp();

  tzdata.initializeTimeZones();
  final String deviceTimezone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(deviceTimezone));
  try {
    await Supabase.initialize(
      // Credencials de Supabase. Solicita-les a l'equip.
      // Posa-les aquí per executar l'app en local.
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_SUPABASE_ANON_KEY',
    );
    debugPrint('🛑 PASO 2: Supabase inicializado perfectamente');
  } catch (e) {
    debugPrint('🛑 ERROR FATAL: Fallo al inicializar Supabase: $e');
  }

  debugPrint('🛑 PASO 3: Ejecutando runApp...');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentTheme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'PlanC',
      debugShowCheckedModeBanner: false,
      
      // Configuración de Localización
      locale: currentLocale, 
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      themeMode: currentTheme,
      theme: ThemeData(
        colorScheme: AppColorScheme.light,
        scaffoldBackgroundColor: AppColors.neutral50,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.neutral50,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        useMaterial3: true,
        fontFamily: 'Helvetica',
      ),
      darkTheme: ThemeData(
        colorScheme: AppColorScheme.dark,
        scaffoldBackgroundColor: AppColors.neutral850,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.neutral850,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        useMaterial3: true,
        fontFamily: 'Helvetica',
      ),
      
      // Flujo normal cuando la app se abre desde el launcher
      home: const MainAuthWrapper(),

      // Manejo de deep links nativos (planc://activitats/<id>).
      // El motor de Flutter entrega aquí el path del URI entrante
      // (p. ej. "/activitats/123"). También aceptamos URIs completas
      // por robustez ante orígenes externos.
      onGenerateRoute: (settings) {
        final route = parseDeepLink(settings.name);
        if (route.isActivitat) {
          debugPrint(
            '🔗 DeepLink reconocido → activitat id=${route.activitatId}',
          );
          return MaterialPageRoute(
            settings: settings,
            builder: (_) =>
                DeepLinkLoaderScreen(activitatId: route.activitatId!),
          );
        }
        // Ruta desconocida: dejamos que `home` (MainAuthWrapper) actúe.
        return null;
      },
    );
  }
}