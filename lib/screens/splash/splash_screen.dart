import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/preferences/preferences_service.dart';

/// Splash screen shown during app initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if tutorial has been completed
    final prefsService = PreferencesService(userId: 'demo_user');
    final tutorialCompleted = await prefsService.isTutorialCompleted();

    if (mounted) {
      if (tutorialCompleted) {
        context.go('/role-selection');
      } else {
        context.go('/tutorial');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo/icon
            Icon(
              Icons.school,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            // App name
            Text(
              'Zara Coach',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
