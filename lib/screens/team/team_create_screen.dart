/// Team Create Screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../providers/team_providers.dart';

class TeamCreateScreen extends ConsumerStatefulWidget {
  const TeamCreateScreen({super.key});

  @override
  ConsumerState<TeamCreateScreen> createState() => _TeamCreateScreenState();
}

class _TeamCreateScreenState extends ConsumerState<TeamCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final teamActions = ref.read(teamActionsProvider);
      final team = await teamActions.createTeam(_teamNameController.text.trim());

      if (mounted) {
        // Show success message with team code
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Team created! Code: ${team.teamCode}'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 5),
          ),
        );

        // Navigate back
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
        title: const Text('Create Team'),
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
                Icons.group_add,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Create Your Team',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Start competing by creating a team. Share the team code with your teammates to let them join.',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Team Name Input
              TextFormField(
                controller: _teamNameController,
                decoration: const InputDecoration(
                  labelText: 'Team Name',
                  hintText: 'Enter your team name',
                  prefixIcon: Icon(Icons.people),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a team name';
                  }
                  if (value.trim().length < 3) {
                    return 'Team name must be at least 3 characters';
                  }
                  if (value.trim().length > 30) {
                    return 'Team name must be less than 30 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'What happens next?',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem('You will be the team leader'),
                    _buildInfoItem('A unique 6-digit team code will be generated'),
                    _buildInfoItem('Share the code with teammates to join'),
                    _buildInfoItem('Max 4 members per team'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Create Button
              ElevatedButton(
                onPressed: _isLoading ? null : _createTeam,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Team'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
