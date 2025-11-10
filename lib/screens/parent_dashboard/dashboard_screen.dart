import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Parent dashboard screen - progress tracking and settings
class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/role-selection'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Progress summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Today\'s Progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _StatRow(
                    label: 'Math Practice',
                    value: '0 problems',
                    icon: Icons.calculate,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Accuracy',
                    value: 'N/A',
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(height: 8),
                  _StatRow(
                    label: 'Time Practiced',
                    value: '0 min',
                    icon: Icons.timer,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Upload school materials card
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                child: Icon(
                  Icons.upload_file,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: const Text('Upload School Materials'),
              subtitle: const Text('Add workbook pages or assignments'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Upload feature coming soon!'),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Settings card
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                child: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: const Text('Settings'),
              subtitle: const Text('Session limits, preferences'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings coming soon!'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
