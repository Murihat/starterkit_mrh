import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../app/themes/app_typography.dart';
import '../../../../core/extensions/localization_extension.dart';
import '../../../../core/extensions/theme_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    // TODO: Hubungkan ke AuthCubit/AuthRepository kamu
    // context.read<AuthCubit>().login(
    //   email: _emailController.text.trim(),
    //   password: _passwordController.text,
    // );
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    context.goNamed(AppRouteName.home);
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    // TODO: Hubungkan ke AuthCubit.loginWithGoogle()
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);

    context.goNamed(AppRouteName.home);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.authLoginTitle),
        // leading: Navigator.canPop(context)
        //     ? IconButton(
        //         icon: const Icon(Icons.arrow_back_ios_new_rounded),
        //         onPressed: () => Navigator.pop(context),
        //       )
        //     : null,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. BRAND LOGO
                  Center(
                    child: Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        width: 40.w,
                        height: 40.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    context.l10n.authLoginSubtitle,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // 3. EMAIL INPUT FIELD
                  Text(
                    context.l10n.authEmailLabel,
                    style: context.textTheme.labelLarge,
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: context.l10n.authEmailHint,
                      prefixIcon: const Icon(Icons.mail_outline_rounded),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.l10n.authEmailEmpty;
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return context.l10n.authEmailInvalid;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18.h),

                  // 4. PASSWORD INPUT FIELD
                  Text(
                    context.l10n.authPasswordLabel,
                    style: context.textTheme.labelLarge,
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    enabled: !_isLoading,
                    onFieldSubmitted: (_) => _handleEmailLogin(),
                    decoration: InputDecoration(
                      hintText: context.l10n.authPasswordHint,
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.authPasswordEmpty;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),

                  // 5. FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              // context.pushNamed(AppRouteName.forgotPassword);
                            },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        context.l10n.authForgotPassword,
                        style: context.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // 6. SIGN IN BUTTON
                  FilledButton(
                    onPressed: _isLoading ? null : _handleEmailLogin,
                    child: _isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Text(context.l10n.authBtnSignIn),
                  ),
                  SizedBox(height: 28.h),

                  // 7. DIVIDER
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: colorScheme.outlineVariant),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          context.l10n.authOrDivider,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: colorScheme.outline,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: colorScheme.outlineVariant),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // 8. GOOGLE SIGN-IN BUTTON
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.onSurface,
                      side: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.8,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      minimumSize: Size(double.infinity, 48.h),
                    ),
                    onPressed: _isLoading ? null : _handleGoogleLogin,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomPaint(
                          size: Size(20.w, 20.w),
                          painter: _GoogleIconPainter(),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          context.l10n.authBtnGoogle,
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: AppTypography.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // 9. SIGN UP REDIRECT FOOTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.authNoAccount,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                // context.pushNamed(AppRouteName.register);
                              },
                        child: Text(
                          context.l10n.authBtnSignUp,
                          style: TextStyle(fontWeight: AppTypography.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // Blue
    paint.color = const Color(0xFF4285F4);
    final Path bluePath = Path()
      ..moveTo(w * 0.95, h * 0.51)
      ..cubicTo(w * 0.95, h * 0.47, w * 0.94, h * 0.44, w * 0.93, h * 0.41)
      ..lineTo(w * 0.5, h * 0.41)
      ..lineTo(w * 0.5, h * 0.59)
      ..lineTo(w * 0.76, h * 0.59)
      ..cubicTo(w * 0.74, h * 0.67, w * 0.69, h * 0.74, w * 0.62, h * 0.79)
      ..lineTo(w * 0.78, h * 0.91)
      ..cubicTo(w * 0.87, h * 0.83, w * 0.95, h * 0.69, w * 0.95, h * 0.51);
    canvas.drawPath(bluePath, paint);

    // Green
    paint.color = const Color(0xFF34A853);
    final Path greenPath = Path()
      ..moveTo(w * 0.5, h * 0.98)
      ..cubicTo(w * 0.64, h * 0.98, w * 0.75, h * 0.93, w * 0.83, h * 0.85)
      ..lineTo(w * 0.67, h * 0.73)
      ..cubicTo(w * 0.62, h * 0.76, w * 0.57, h * 0.78, w * 0.5, h * 0.78)
      ..cubicTo(w * 0.37, h * 0.78, w * 0.26, h * 0.69, w * 0.22, h * 0.57)
      ..lineTo(w * 0.06, h * 0.69)
      ..cubicTo(w * 0.14, h * 0.86, w * 0.31, h * 0.98, w * 0.5, h * 0.98);
    canvas.drawPath(greenPath, paint);

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    final Path yellowPath = Path()
      ..moveTo(w * 0.22, h * 0.57)
      ..cubicTo(w * 0.21, h * 0.53, w * 0.21, h * 0.47, w * 0.21, h * 0.43)
      ..cubicTo(w * 0.21, h * 0.39, w * 0.22, h * 0.33, w * 0.23, h * 0.29)
      ..lineTo(w * 0.07, h * 0.17)
      ..cubicTo(w * 0.02, h * 0.26, 0, h * 0.34, 0, h * 0.43)
      ..cubicTo(0, h * 0.52, w * 0.02, h * 0.61, w * 0.07, h * 0.7)
      ..lineTo(w * 0.22, h * 0.57);
    canvas.drawPath(yellowPath, paint);

    // Red
    paint.color = const Color(0xFFEA4335);
    final Path redPath = Path()
      ..moveTo(w * 0.5, h * 0.18)
      ..cubicTo(w * 0.58, h * 0.18, w * 0.64, h * 0.21, w * 0.69, h * 0.25)
      ..lineTo(w * 0.83, h * 0.11)
      ..cubicTo(w * 0.75, h * 0.04, w * 0.63, 0, w * 0.5, 0)
      ..cubicTo(w * 0.31, 0, w * 0.14, h * 0.12, w * 0.06, h * 0.29)
      ..lineTo(w * 0.22, h * 0.41)
      ..cubicTo(w * 0.26, h * 0.29, w * 0.37, h * 0.18, w * 0.5, h * 0.18);
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
