import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/preferences/preferences_service.dart';

/// Onboarding tutorial screen for first-time users
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController = PageController();
  final PreferencesService _prefsService =
      PreferencesService(userId: 'demo_user');
  int _currentPage = 0;

  final List<TutorialPage> _pages = [
    TutorialPage(
      title: 'Welcome to Zara Coach! 👋',
      description:
          'I\'m here to help Zara learn math with AI-powered practice!',
      icon: Icons.waving_hand,
      color: Colors.blue,
    ),
    TutorialPage(
      title: 'How It Works',
      description:
          'Zara solves problems in her notebook, takes a photo, and gets instant feedback from me!',
      icon: Icons.camera_alt,
      color: Colors.green,
    ),
    TutorialPage(
      title: 'Child Mode',
      description:
          'In Child Mode, Zara practices math independently. I\'ll guide her every step of the way!',
      icon: Icons.face,
      color: Colors.purple,
    ),
    TutorialPage(
      title: 'Parent Mode',
      description:
          'In Parent Mode, you can track progress, upload school materials, and adjust settings.',
      icon: Icons.supervisor_account,
      color: Colors.orange,
    ),
    TutorialPage(
      title: 'Let\'s Begin!',
      description:
          'Ready to start? Choose Child Mode to practice, or Parent Mode to set up!',
      icon: Icons.rocket_launch,
      color: Colors.pink,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeTutorial() async {
    await _prefsService.completeTutorial();
    if (mounted) {
      context.go('/role-selection');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeTutorial();
    }
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipTutorial,
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(TutorialPage page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 64,
              color: page.color,
            ),
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TutorialPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const TutorialPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
