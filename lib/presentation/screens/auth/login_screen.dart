/// Login screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validation_utils.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/auth_request_models.dart';
import '../widgets/auth_widgets.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  String? _generalError;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _generalError = null);

    final request = LoginRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    try {
      await ref.read(loginProvider(request).future);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() => _generalError = e.toString());
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => _generalError = null);

    try {
      await ref.read(googleSignInProvider.future);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() => _generalError = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginAsyncValue = ref.watch(loginProvider(LoginRequest(email: '', password: '')));

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
                'Welcome Back',
                style: AppTextTheme.heading2,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sign in to your account to continue competing',
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
                      hint: '••••••••',
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      focusNode: _passwordFocusNode,
                      onSubmitted: (_) => _handleLogin(),
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
                    const SizedBox(height: AppSpacing.lg),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => context.push('/forgot-password'),
                        child: Text(
                          'Forgot Password?',
                          style: AppTextTheme.body2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Sign In',
                  onPressed: _handleLogin,
                  isLoading: loginAsyncValue.isLoading,
                  enabled: !loginAsyncValue.isLoading,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Divider
              const DividerWithText(text: 'Or continue with'),
              const SizedBox(height: AppSpacing.lg),

              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                child: ref.watch(googleSignInProvider).when(
                  data: (_) => CustomButton(
                    text: 'Sign in with Google',
                    onPressed: _handleGoogleSignIn,
                    variant: ButtonVariant.outline,
                    icon: const Icon(Icons.g_mobiledata),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  loading: () => CustomButton(
                    text: 'Signing in...',
                    onPressed: () {},
                    isLoading: true,
                    variant: ButtonVariant.outline,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                  error: (error, stack) => CustomButton(
                    text: 'Sign in with Google',
                    onPressed: _handleGoogleSignIn,
                    variant: ButtonVariant.outline,
                    icon: const Icon(Icons.g_mobiledata),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Sign Up Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextTheme.body2.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: Text(
                        'Sign Up',
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
