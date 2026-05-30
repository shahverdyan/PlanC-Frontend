import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plan_c_frontend/core/theme/app_colors.dart';
import 'package:plan_c_frontend/features/auth/domain/auth_provider.dart';
import 'package:plan_c_frontend/features/auth/presentation/register_screen.dart';
import 'package:plan_c_frontend/features/auth/presentation/login_screen.dart';
import 'package:plan_c_frontend/l10n/generated/app_localizations.dart';

const _gradientTop    = Color(0xFFFF5C35);
const _gradientBottom = Color(0xFFFF9A00);

class AuthMainScreen extends ConsumerStatefulWidget {
  const AuthMainScreen({super.key});

  @override
  ConsumerState<AuthMainScreen> createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends ConsumerState<AuthMainScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  // Cada card: fade + slide amb delay escalonat de 150 ms (150/600 = 0.25)
  late final Animation<double> _fade0;
  late final Animation<double> _fade1;
  late final Animation<double> _fade2;
  late final Animation<Offset> _slide0;
  late final Animation<Offset> _slide1;
  late final Animation<Offset> _slide2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade0  = _buildFade(0.00, 0.50);
    _fade1  = _buildFade(0.25, 0.75);
    _fade2  = _buildFade(0.50, 1.00);
    _slide0 = _buildSlide(0.00, 0.50);
    _slide1 = _buildSlide(0.25, 0.75);
    _slide2 = _buildSlide(0.50, 1.00);

    _controller.forward();
  }

  Animation<double> _buildFade(double begin, double end) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ));

  Animation<Offset> _buildSlide(double begin, double end) =>
      Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, end, curve: Curves.easeOut),
      ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_gradientTop, _gradientBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Logo + cards (ocupa tot l'espai disponible) ──────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Títol
                    const Text(
                      'PlanC',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.neutral0,
                        fontFamily: 'Helvetica',
                        letterSpacing: -1.5,
                      ),
                    ),

                    // Feature cards animades
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _AnimatedFeatureCard(
                            fade: _fade0,
                            slide: _slide0,
                            icon: Icons.explore_outlined,
                            title: t.authDescubreixTitle,
                            description: t.authDescubreixDesc,
                          ),
                          const SizedBox(height: 12),
                          _AnimatedFeatureCard(
                            fade: _fade1,
                            slide: _slide1,
                            icon: Icons.people_outline,
                            title: t.authConnectaTitle,
                            description: t.authConnectaDesc,
                          ),
                          const SizedBox(height: 12),
                          _AnimatedFeatureCard(
                            fade: _fade2,
                            slide: _slide2,
                            icon: Icons.trending_up,
                            title: t.authCreixTitle,
                            description: t.authCreixDesc,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Botons ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Iniciar sessió — outline blanc
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.neutral0,
                        side: const BorderSide(color: AppColors.neutral0, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                          pageBuilder: (context, a, b) => const LoginScreen(),
                          transitionsBuilder: (context, animation, secondary, child) => child,
                        ),
                      ),
                      child: Text(
                        t.authLoginButton,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Helvetica',
                          color: AppColors.neutral0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Crea un compte — blanc ple
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neutral0,
                        foregroundColor: _gradientTop,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                          pageBuilder: (context, a, b) => const RegisterScreen(),
                          transitionsBuilder:
                              (context, animation, secondary, child) => child,
                        ),
                      ),
                      child: Text(
                        t.authCreateAccountButton,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Helvetica',
                          color: _gradientTop,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Google ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.loginContinueWith,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.neutral0.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () =>
                          ref.read(authProvider.notifier).signInWithGoogle(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.neutral0,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset('assets/images/google_logo.svg'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedFeatureCard extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;
  final IconData icon;
  final String title;
  final String description;

  const _AnimatedFeatureCard({
    required this.fade,
    required this.slide,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.neutral0.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.neutral0.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.neutral0.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.neutral0, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral0,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.neutral0.withValues(alpha: 0.75),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
