/// Signup screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validation_utils.dart';
import '../../data/models/auth_request_models.dart';
import '../widgets/auth_widgets.dart';
import '../providers/auth_providers.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _confirmPasswordFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreeToTerms = false;
  String? _generalError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _generalError = 'You must agree to Terms of Service';
      });
      return;
    }

    setState(() => _generalError = null);

    final request = SignupRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    try {
      await ref.read(signupProvider(request).future);
      if (mounted) {
        context.go('/profile-setup');
      }
    } catch (e) {
      setState(() => _generalError = e.toString());
    }
  }

  void _handleGoogleSignUp() async {
    setState(() => _generalError = null);

    try {
      await ref.read(googleSignInProvider.future);
      if (mounted) {
        context.go('/profile-setup');
      }
    } catch (e) {
      setState(() => _generalError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupAsyncValue = ref.watch(signupProvider(SignupRequest(
      email: '',
      password: '',
      confirmPassword: '',
    )));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/welcome'),
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
                'Create Account',
                style: AppTextTheme.heading2,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Join CodeSync Arena to compete with developers',
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
                      focusNode: _emailFocusNode,
                      onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password Field
                    CustomTextField(
                      label: 'Password',
                      hint: 'At least 8 characters',
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      validator: ValidationUtils.validatePassword,
                      focusNode: _passwordFocusNode,
                      onChanged: (_) => setState(() {}), // Trigger rebuild for strength indicator
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textMuted,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Password Strength Indicator
                    if (_passwordController.text.isNotEmpty)
                      PasswordStrengthIndicator(
                        password: _passwordController.text,
                      ),
                    const SizedBox(height: AppSpacing.lg),

                    // Confirm Password Field
                    CustomTextField(
                      label: 'Confirm Password',
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      validator: (value) => ValidationUtils.validatePasswordConfirmation(
                        value,
                        _passwordController.text,
                      ),
                      focusNode: _confirmPasswordFocusNode,
                      onSubmitted: (_) => _handleSignup(),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.textMuted,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() => _showConfirmPassword = !_showConfirmPassword);
                        },
                        child: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Terms Agreement Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() => _agreeToTerms = value ?? false);
                    },
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.selected)) {
                        return AppColors.primary;
                      }
                      return AppColors.surface;
                    }),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _agreeToTerms = !_agreeToTerms);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: AppTextTheme.body2.copyWith(
                            color: AppColors.textMuted,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: AppTextTheme.body2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Signup Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Create Account',
                  onPressed: _handleSignup,
                  isLoading: signupAsyncValue.isLoading,
                  enabled: !signupAsyncValue.isLoading && _agreeToTerms,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Divider
              const DividerWithText(text: 'Or sign up with'),
              const SizedBox(height: AppSpacing.lg),

              // Google Sign-Up Button
              SizedBox(
                width: double.infinity,
                child: ref.watch(googleSignInProvider).when(
                  data: (_) => CustomButton(
                    text: 'Sign up with Google',
                    onPressed: _handleGoogleSignUp,
                    variant: ButtonVariant.outline,
                    icon: const Icon(Icons.g_mobiledata),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  loading: () => CustomButton(
                    text: 'Signing up...',
                    onPressed: () {},
                    isLoading: true,
                    variant: ButtonVariant.outline,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  error: (error, stack) => CustomButton(
                    text: 'Sign up with Google',
                    onPressed: _handleGoogleSignUp,
                    variant: ButtonVariant.outline,
                    icon: const Icon(Icons.g_mobiledata),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextTheme.body2.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/login'),
                      child: Text(
                        'Sign In',
                        style: AppTextTheme.body2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
