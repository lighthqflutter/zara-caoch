import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Child home screen - activity selection
class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

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
                subtitle: '2 problems ready',
                color: Colors.blue,
                onTap: () {
                  // TODO: Navigate to math practice
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Math practice coming soon!'),
                    ),
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
                backgroundColor: color.withOpacity(0.2),
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
