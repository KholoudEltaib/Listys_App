import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listys_app/core/localization/app_localizations.dart';
import 'package:listys_app/core/utils/storage_helper.dart';
import 'package:listys_app/core/routes/app_routes.dart';  // ✅ Import routes
import 'package:listys_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:listys_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:listys_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:listys_app/features/splash/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _iconAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
    _iconController.repeat(reverse: true);

    // Wait for animation, then check auth status
    Future.delayed(const Duration(seconds: 3), () {
      _checkAppStatus();
    });
  }

  Future<void> _checkAppStatus() async {
    // ✅ Check if onboarding is completed
    final isOnboardingCompleted = await StorageHelper.isOnboardingCompleted();
    
    if (!isOnboardingCompleted) {
      // First time - show onboarding
      await StorageHelper.setOnboardingCompleted(true);
      _navigateToOnboarding();
    } else {
      // ✅ Check authentication status using AuthBloc
      if (!mounted) return;
      context.read<AuthBloc>().add(AuthCheckRequested());
    }
  }

  void _navigateToOnboarding() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  void _navigateToLogin() {
    if (!mounted) return;
    // ✅ Use named route instead of direct navigation
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  void _navigateToHome() {
    if (!mounted) return;
    // ✅ Use named route instead of direct navigation
    Navigator.pushReplacementNamed(context, AppRoutes.mainScreen);
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // ✅ Navigate based on authentication state
        if (state is AuthAuthenticated) {
          _navigateToHome();
        } else if (state is AuthUnauthenticated) {
          _navigateToLogin();
        } else if (state is AuthError) {
          // If there's an error checking auth, go to login
          _navigateToLogin();
        }
        // AuthLoading state doesn't trigger navigation
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              Image.asset(
                'assets/images/splash/listys_logo.png',
                width: 190,
                height: 110,
              ),
              const SizedBox(height: 24),
              Text(
                loc.splash_screen_title,
                style: TextStyle(
                  fontFamily: 'Instrument Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}