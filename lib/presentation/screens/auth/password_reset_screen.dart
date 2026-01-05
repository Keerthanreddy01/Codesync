/// Password reset screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validation_utils.dart';
import '../widgets/auth_widgets.dart';
import '../providers/auth_providers.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  String? _generalError;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _generalError = null);

    try {
      await ref.read(passwordResetProvider(_emailController.text.trim()).future);
      setState(() => _emailSent = true);
    } catch (e) {
      setState(() => _generalError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Reset Password',
                style: AppTextTheme.heading2,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                _emailSent
                    ? 'Check your email for password reset instructions'
                    : 'Enter your email address and we\'ll send you a link to reset your password',
                style: AppTextTheme.body2.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              if (_emailSent)
                // Success State
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Sent Successfully',
                            style: AppTextTheme.subheading2.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'We\'ve sent a password reset link to ${_emailController.text}. Please check your email and follow the instructions to reset your password.',
                            style: AppTextTheme.body2.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Didn\'t receive the email? Check your spam folder or try again.',
                            style: AppTextTheme.caption1.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Back to Login',
                        onPressed: () => context.go('/login'),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                    ),
                  ],
                )
              else
                // Form State
                Column(
                  children: [
                    // Error Message
                    if (_generalError != null) ...[
                      ErrorMessage(
                        message: _generalError!,
                        onDismiss: () => setState(() => _generalError = null),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          CustomTextField(
                            label: 'Email Address',
                            hint: 'you@example.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: ValidationUtils.validateEmail,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ref.watch(passwordResetProvider(_emailController.text)).when(
                        data: (_) => CustomButton(
                          text: 'Send Reset Email',
                          onPressed: _handlePasswordReset,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                        loading: () => CustomButton(
                          text: 'Sending...',
                          onPressed: () {},
                          isLoading: true,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                        error: (error, stack) => CustomButton(
                          text: 'Send Reset Email',
                          onPressed: _handlePasswordReset,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Back to Login
                    Center(
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          'Back to Login',
                          style: AppTextTheme.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
