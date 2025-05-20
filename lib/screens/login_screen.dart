import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../routes/route_names.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (!mounted) return;
        await ref.read(authProvider.notifier).signInWithEmail(
              _emailController.text,
              _passwordController.text,
            );
        if (mounted) {
          context.pushReplacement(RouteNames.home); // Use pushReplacement instead of go
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      if (!mounted) return;
      await ref.read(authProvider.notifier).signInWithGoogle();
      if (mounted) {
        context.pushReplacement(RouteNames.home); // Use pushReplacement instead of go
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _handleFacebookLogin() async {
    try {
      if (!mounted) return;
      await ref.read(authProvider.notifier).signInWithFacebook();
      if (mounted) {
        context.pushReplacement(RouteNames.home); // Use pushReplacement instead of go
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: isDesktop 
                ? size.width * 0.4
                : isTablet 
                  ? size.width * 0.6 
                  : size.width,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop 
                  ? 48
                  : isTablet 
                    ? 32
                    : 24,
                vertical: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: isDesktop ? 40 : 20),
                  // Logo
                  Center(
                    child: Image.asset(
                      'images/logo.png',
                      height: isDesktop 
                        ? 250
                        : isTablet 
                          ? 220
                          : 180,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: isDesktop 
                            ? 250
                            : isTablet 
                              ? 220 
                              : 180,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.account_balance_wallet,
                              size: 64,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: isDesktop ? 48 : 32),
                  // App Name
                  Text(
                    'Finance Manager',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop 
                        ? 40
                        : isTablet 
                          ? 36
                          : 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your finances with ease',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isDesktop 
                        ? 18
                        : isTablet 
                          ? 17
                          : 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 48 : 32),
                  // Social Login Buttons
                  CustomButton.icon(
                    onPressed: _handleGoogleLogin,
                    text: 'Continue with Google',
                    icon: const FaIcon(FontAwesomeIcons.google),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: 12),
                  CustomButton.icon(
                    onPressed: _handleFacebookLogin,
                    text: 'Continue with Facebook',
                    icon: const FaIcon(FontAwesomeIcons.facebook),
                    backgroundColor: const Color(0xFF1877F2),
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Email Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: isDesktop ? 20 : 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        SizedBox(height: isDesktop ? 24 : 16),
                        TextFormField(
                          controller: _passwordController,
                          autofillHints: const [AutofillHints.password],
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: isDesktop ? 20 : 16,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            _handleEmailLogin();
                          },
                        ),
                        SizedBox(height: isDesktop ? 32 : 24),
                        CustomButton(
                          onPressed: _handleEmailLogin,
                          text: 'Login',
                          isLoading: authState.isLoading,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isDesktop ? 24 : 16),
                  // Register Link
                  TextButton(
                    onPressed: () {
                      context.go(RouteNames.register);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          color: Colors.grey[600],
                        ),
                        children: [
                          TextSpan(
                            text: 'Register here',
                            style: TextStyle(
                              fontSize: isDesktop ? 16 : 14,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
}