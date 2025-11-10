import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/problem.dart';
import '../../services/session/session_service.dart';

/// Child home screen - activity selection
class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  DifficultyLevel _currentLevel = DifficultyLevel.level1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLevel();
  }

  Future<void> _loadCurrentLevel() async {
    // TODO: Get actual user ID from auth
    final sessionService = SessionService(userId: 'demo_user');
    final level = await sessionService.getCurrentDifficultyLevel();

    if (mounted) {
      setState(() {
        _currentLevel = level;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi Zara! 👋'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/role-selection'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ready to Learn?',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 48),
              // Math Practice card
              _ActivityCard(
                icon: Icons.calculate,
                title: 'Math Practice',
                subtitle: _isLoading
                    ? 'Loading...'
                    : '${_currentLevel.description} - 2 problems ready',
                color: Colors.blue,
                isLocked: _isLoading,
                onTap: () {
                  context.push(
                    '/math-practice/problems',
                    extra: {
                      'difficultyLevel': _currentLevel,
                      'problemCount': 2,
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Placeholder for future activities
              _ActivityCard(
                icon: Icons.book,
                title: 'Reading',
                subtitle: 'Coming soon',
                color: Colors.green,
                isLocked: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isLocked;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.isLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(
                  isLocked ? Icons.lock : icon,
                  size: 32,
                  color: isLocked ? Colors.grey : color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              if (!isLocked)
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
