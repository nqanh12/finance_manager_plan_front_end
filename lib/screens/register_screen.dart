import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isOtpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authProvider.notifier).sendOtp(_emailController.text);
      setState(() => _isOtpSent = true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your email')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authProvider.notifier).verifyOtpAndRegister(
        _emailController.text,
        _passwordController.text,
        _otpController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(); // Return to login screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onRegisterPress() {
    _handleRegister();
  }

  void _onSendOtpPress() {
    _handleSendOtp();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                horizontal: isDesktop ? 48 : isTablet ? 32 : 24,
                vertical: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isOtpSent && !authState.isLoading,
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
                    ),
                    SizedBox(height: isDesktop ? 24 : 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      enabled: !_isOtpSent && !authState.isLoading,
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
                    ),
                    SizedBox(height: isDesktop ? 24 : 16),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      enabled: !_isOtpSent && !authState.isLoading,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isDesktop ? 20 : 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: isDesktop ? 24 : 16),

                    // OTP field (visible after email verification)
                    if (_isOtpSent) ...[
                      TextFormField(
                        controller: _otpController,
                        enabled: !authState.isLoading,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: 'Enter OTP',
                          prefixIcon: const Icon(Icons.security_outlined),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: isDesktop ? 20 : 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter OTP';
                          }
                          if (value.length != 6) {
                            return 'OTP must be 6 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: isDesktop ? 24 : 16),
                    ],

                    // Action button (Send OTP or Register)
                    CustomButton(
                      onPressed: () {
                        if (!authState.isLoading) {
                          if (_isOtpSent) {
                            _onRegisterPress();
                          } else {
                            _onSendOtpPress();
                          }
                        }
                      },
                      text: _isOtpSent ? 'Register' : 'Send OTP',
                      isLoading: authState.isLoading,
                    ),

                    SizedBox(height: isDesktop ? 24 : 16),
                    // Login Link
                    TextButton(
                      onPressed: authState.isLoading 
                        ? null 
                        : () => Navigator.of(context).pop(),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            color: Colors.grey[600],
                          ),
                          children: [
                            TextSpan(
                              text: 'Login here',
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
      ),
    );
  }
} 