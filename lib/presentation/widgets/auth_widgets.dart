/// Reusable authentication widgets
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// Custom text input field
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final FocusNode? focusNode;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines = 1,
    this.enabled = true,
    this.focusNode,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextTheme.subheading2,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          enabled: widget.enabled,
          focusNode: _focusNode,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          style: AppTextTheme.body1,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextTheme.body2.copyWith(
              color: AppColors.textHint,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: widget.prefixIcon,
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: widget.suffixIcon,
                  )
                : null,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom button
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final EdgeInsets? padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.large,
    this.icon,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || !enabled;
    final backgroundColor = _getBackgroundColor();
    final foregroundColor = _getForegroundColor();

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          child: Container(
            padding: _getPadding(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: _getBorder(),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(foregroundColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          text,
                          style: AppTextTheme.button.copyWith(
                            color: foregroundColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isLoading || !enabled) {
      return variant == ButtonVariant.primary
          ? AppColors.primary.withOpacity(0.5)
          : AppColors.surface;
    }

    return switch (variant) {
      ButtonVariant.primary => AppColors.primary,
      ButtonVariant.secondary => AppColors.secondary,
      ButtonVariant.outline => AppColors.background,
      ButtonVariant.ghost => Colors.transparent,
    };
  }

  Color _getForegroundColor() {
    if (isLoading || !enabled) {
      return AppColors.textMuted;
    }

    return switch (variant) {
      ButtonVariant.primary => AppColors.textPrimary,
      ButtonVariant.secondary => AppColors.textPrimary,
      ButtonVariant.outline => AppColors.primary,
      ButtonVariant.ghost => AppColors.primary,
    };
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      ButtonSize.small => const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ButtonSize.large => const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
    };
  }

  Border? _getBorder() {
    if (variant == ButtonVariant.outline && (isLoading || !enabled)) {
      return Border.all(
        color: AppColors.border.withOpacity(0.5),
        width: 1.5,
      );
    }

    if (variant == ButtonVariant.outline) {
      return Border.all(
        color: AppColors.primary,
        width: 1.5,
      );
    }

    return null;
  }
}

enum ButtonVariant { primary, secondary, outline, ghost }
enum ButtonSize { small, medium, large }

/// Password strength indicator
class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final TextStyle? labelStyle;

  const PasswordStrengthIndicator({
    Key? key,
    required this.password,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = _getPasswordStrength(password);
    final label = _getPasswordStrengthLabel(score);
    final color = _getPasswordStrengthColor(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                child: LinearProgressIndicator(
                  value: (score + 1) / 5,
                  minHeight: 4,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: labelStyle ??
                  AppTextTheme.caption1.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  int _getPasswordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    return score;
  }

  String _getPasswordStrengthLabel(int score) {
    return switch (score) {
      0 => 'Very Weak',
      1 => 'Weak',
      2 => 'Fair',
      3 => 'Good',
      4 => 'Strong',
      _ => 'Unknown',
    };
  }

  Color _getPasswordStrengthColor(int score) {
    return switch (score) {
      0 => AppColors.error,
      1 => Color(0xFFF59E0B),
      2 => Color(0xFFEAB308),
      3 => Color(0xFF84CC16),
      4 => AppColors.success,
      _ => AppColors.textMuted,
    };
  }
}

/// Social sign-in button
class SocialSignInButton extends StatelessWidget {
  final String provider;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialSignInButton({
    Key? key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerLower = provider.toLowerCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/${providerLower}_logo.png',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Continue with ${provider.replaceFirst(provider[0], provider[0].toUpperCase())}',
                        style: AppTextTheme.body2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Divider with text
class DividerWithText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const DividerWithText({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.border,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            text,
            style: textStyle ??
                AppTextTheme.caption1.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.border,
            height: 1,
          ),
        ),
      ],
    );
  }
}

/// Error message widget
class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorMessage({
    Key? key,
    required this.message,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextTheme.body2.copyWith(color: AppColors.error),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close, color: AppColors.error, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}

/// Success message widget
class SuccessMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const SuccessMessage({
    Key? key,
    required this.message,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextTheme.body2.copyWith(color: AppColors.success),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(Icons.close, color: AppColors.success, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
