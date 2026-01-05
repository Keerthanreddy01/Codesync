/// Team Join Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/team_providers.dart';

class TeamJoinScreen extends ConsumerStatefulWidget {
  const TeamJoinScreen({super.key});

  @override
  ConsumerState<TeamJoinScreen> createState() => _TeamJoinScreenState();
}

class _TeamJoinScreenState extends ConsumerState<TeamJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _teamCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final teamActions = ref.read(teamActionsProvider);
      final team = await teamActions.joinTeam(
        _teamCodeController.text.trim().toUpperCase(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined team: ${team.name}'),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context, team);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Team'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Icon(
                Icons.login,
                size: 80,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 24),
              Text(
                'Join a Team',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Enter the 6-character team code shared by your team leader.',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Team Code Input
              TextFormField(
                controller: _teamCodeController,
                decoration: const InputDecoration(
                  labelText: 'Team Code',
                  hintText: 'ABCD12',
                  prefixIcon: Icon(Icons.key),
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter team code';
                  }
                  if (value.trim().length != 6) {
                    return 'Team code must be 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Get the team code from your team leader',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Join Button
              ElevatedButton(
                onPressed: _isLoading ? null : _joinTeam,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Join Team'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
