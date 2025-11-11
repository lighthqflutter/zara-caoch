import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/session/session_service.dart';
import '../../models/problem.dart';

/// Parent dashboard screen - progress tracking and settings
class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  final SessionService _sessionService = SessionService(userId: 'demo_user');
  Map<String, dynamic>? _todayStats;
  DifficultyLevel _currentLevel = DifficultyLevel.level1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _sessionService.getTodayStats();
      final level = await _sessionService.getCurrentDifficultyLevel();

      if (mounted) {
        setState(() {
          _todayStats = stats;
          _currentLevel = level;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _todayStats = {
            'problemsCompleted': 0,
            'accuracy': 0,
            'timeSpent': 0,
            'sessionsCompleted': 0,
          };
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadData();
  }

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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Current difficulty level badge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Level',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              _currentLevel.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

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
                            value:
                                '${_todayStats?['problemsCompleted'] ?? 0} problems',
                            icon: Icons.calculate,
                          ),
                          const SizedBox(height: 8),
                          _StatRow(
                            label: 'Accuracy',
                            value: _todayStats?['problemsCompleted'] == 0
                                ? 'N/A'
                                : '${_todayStats?['accuracy'] ?? 0}%',
                            icon: Icons.check_circle,
                          ),
                          const SizedBox(height: 8),
                          _StatRow(
                            label: 'Time Practiced',
                            value: '${_todayStats?['timeSpent'] ?? 0} min',
                            icon: Icons.timer,
                          ),
                          const SizedBox(height: 8),
                          _StatRow(
                            label: 'Sessions',
                            value: '${_todayStats?['sessionsCompleted'] ?? 0}',
                            icon: Icons.assignment_turned_in,
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
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.2),
                        child: Icon(
                          Icons.settings,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: const Text('Settings'),
                      subtitle: const Text('Voice, session limits, preferences'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.push('/settings');
                      },
                    ),
                  ),
                ],
              ),
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
