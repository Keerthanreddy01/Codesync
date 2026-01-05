/// User profile setup screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validation_utils.dart';
import '../../data/models/auth_request_models.dart';
import '../widgets/auth_widgets.dart';
import '../providers/auth_providers.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _displayNameController;
  late TextEditingController _bioController;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? _generalError;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _displayNameController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      setState(() => _generalError = 'Failed to pick image: $e');
    }
  }

  void _handleProfileSetup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _generalError = null;
      _successMessage = null;
    });

    final user = ref.read(authStateProvider).maybeWhen(
      data: (state) => state.user,
      orElse: () => null,
    );

    if (user == null) {
      setState(() => _generalError = 'User not found');
      return;
    }

    try {
      // Note: Image upload would go to Firebase Storage here
      // For MVP, we'll just use the display name as placeholder

      await ref.read(updateProfileProvider((
        user.id,
        _usernameController.text.trim(),
        _displayNameController.text.trim(),
        _bioController.text.trim(),
        null, // photoUrl would be set after upload
      )).future);

      setState(() {
        _successMessage = 'Profile created successfully!';
      });

      // Navigate to onboarding after short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go('/onboarding');
        }
      });
    } catch (e) {
      setState(() => _generalError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Complete Your Profile',
                style: AppTextTheme.heading2,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Set up your profile so other developers can recognize you',
                style: AppTextTheme.body2.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Error Message
              if (_generalError != null) ...[
                ErrorMessage(
                  message: _generalError!,
                  onDismiss: () => setState(() => _generalError = null),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Success Message
              if (_successMessage != null) ...[
                SuccessMessage(
                  message: _successMessage!,
                  onDismiss: () => setState(() => _successMessage = null),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Avatar Selection
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.border,
                            width: 2,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.camera_alt_outlined,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    'Add Photo',
                                    style: AppTextTheme.caption1.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Tap to upload profile picture',
                      style: AppTextTheme.caption1.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username Field
                    CustomTextField(
                      label: 'Username',
                      hint: 'e.g., john_dev',
                      controller: _usernameController,
                      validator: ValidationUtils.validateUsername,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Display Name Field
                    CustomTextField(
                      label: 'Display Name',
                      hint: 'e.g., John Developer',
                      controller: _displayNameController,
                      validator: ValidationUtils.validateDisplayName,
                      prefixIcon: const Icon(
                        Icons.badge_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Bio Field
                    CustomTextField(
                      label: 'Bio (Optional)',
                      hint: 'Tell us about yourself...',
                      controller: _bioController,
                      maxLines: 3,
                      minLines: 3,
                      validator: ValidationUtils.validateBio,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(top: AppSpacing.lg),
                        child: Icon(
                          Icons.description_outlined,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Character count
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${_bioController.text.length}/500',
                        style: AppTextTheme.caption1.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              authState.maybeWhen(
                data: (state) {
                  final isLoading = ref.watch(updateProfileProvider((
                    state.user?.id ?? '',
                    '',
                    '',
                    '',
                    null,
                  ))).isLoading;

                  return SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Continue to Onboarding',
                      onPressed: _handleProfileSetup,
                      isLoading: isLoading,
                      enabled: !isLoading,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    ),
                  );
                },
                orElse: () => SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Loading...',
                    onPressed: () {},
                    isLoading: true,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Skip Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Skip for Now',
                  onPressed: () => context.go('/onboarding'),
                  variant: ButtonVariant.outline,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
