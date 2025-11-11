import 'package:flutter/material.dart';
import '../../services/preferences/preferences_service.dart';
import '../../services/voice/tts_service.dart';
import '../../models/user_preferences.dart';
import '../../models/problem.dart';

/// Settings screen for app preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final PreferencesService _prefsService =
      PreferencesService(userId: 'demo_user');
  final TTSService _tts = TTSService();

  UserPreferences? _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _prefsService.getPreferences();
    if (mounted) {
      setState(() {
        _preferences = prefs;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleVoice(bool value) async {
    await _prefsService.toggleVoice(value);
    _tts.setEnabled(value);

    if (mounted) {
      setState(() {
        _preferences = _preferences?.copyWith(voiceEnabled: value);
      });

      if (value) {
        await _tts.speak("Voice is now enabled!");
      }
    }
  }

  Future<void> _resetTutorial() async {
    await _prefsService.resetTutorial();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tutorial reset! It will show on next app launch.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Voice Settings Section
                _buildSectionHeader('Voice'),
                Card(
                  child: SwitchListTile(
                    title: const Text('Enable Voice Guidance'),
                    subtitle: const Text(
                      'AI will speak encouragement and instructions',
                    ),
                    secondary: Icon(
                      Icons.volume_up,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    value: _preferences?.voiceEnabled ?? true,
                    onChanged: _toggleVoice,
                  ),
                ),

                const SizedBox(height: 24),

                // Session Settings Section
                _buildSectionHeader('Session Length'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekday: ${_preferences?.weekdaySessionMinutes ?? 40} minutes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Slider(
                          value: (_preferences?.weekdaySessionMinutes ?? 40)
                              .toDouble(),
                          min: 10,
                          max: 60,
                          divisions: 10,
                          label: '${_preferences?.weekdaySessionMinutes ?? 40} min',
                          onChanged: (value) {
                            setState(() {
                              _preferences = _preferences?.copyWith(
                                weekdaySessionMinutes: value.toInt(),
                              );
                            });
                          },
                          onChangeEnd: (value) {
                            _prefsService.updateSessionLengths(
                              weekday: value.toInt(),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Weekend: ${_preferences?.weekendSessionMinutes ?? 120} minutes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Slider(
                          value: (_preferences?.weekendSessionMinutes ?? 120)
                              .toDouble(),
                          min: 30,
                          max: 180,
                          divisions: 15,
                          label:
                              '${_preferences?.weekendSessionMinutes ?? 120} min',
                          onChanged: (value) {
                            setState(() {
                              _preferences = _preferences?.copyWith(
                                weekendSessionMinutes: value.toInt(),
                              );
                            });
                          },
                          onChangeEnd: (value) {
                            _prefsService.updateSessionLengths(
                              weekend: value.toInt(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Difficulty Settings Section
                _buildSectionHeader('Difficulty'),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.school,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Manual Difficulty Override'),
                    subtitle: Text(
                      _preferences?.manualDifficultyOverride != null
                          ? _preferences!.manualDifficultyOverride!.description
                          : 'Automatic (based on performance)',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _showDifficultyDialog();
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Tutorial Settings Section
                _buildSectionHeader('Tutorial'),
                Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: const Text('Reset Tutorial'),
                    subtitle: const Text('Show tutorial again on next launch'),
                    trailing: const Icon(Icons.refresh),
                    onTap: _resetTutorial,
                  ),
                ),

                const SizedBox(height: 24),

                // About Section
                _buildSectionHeader('About'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: const Text('Zara Coach'),
                        subtitle: const Text('Version 1.0.0 (MVP)'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.description_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: const Text('AI-Powered Math Coach'),
                        subtitle: const Text(
                          'Adaptive learning for children with ADHD',
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          Icons.code,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: const Text('Built with Flutter'),
                        subtitle: const Text('Firebase • OpenAI • Google ML Kit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Future<void> _showDifficultyDialog() async {
    final result = await showDialog<DifficultyLevel?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Difficulty Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Automatic'),
              subtitle: const Text('Based on performance (recommended)'),
              leading: const Icon(Icons.auto_awesome),
              onTap: () => Navigator.pop(context, null),
            ),
            const Divider(),
            ...DifficultyLevel.values.map((level) {
              return ListTile(
                title: Text('Level ${level.level}'),
                subtitle: Text(level.description),
                onTap: () => Navigator.pop(context, level),
              );
            }),
          ],
        ),
      ),
    );

    if (result != null || result == null) {
      // Save preference
      final newPrefs = _preferences?.copyWith(
        manualDifficultyOverride: result,
        clearDifficultyOverride: result == null,
      );

      await _prefsService.savePreferences(newPrefs!);

      if (mounted) {
        setState(() {
          _preferences = newPrefs;
        });
      }
    }
  }
}
