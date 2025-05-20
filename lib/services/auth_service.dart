import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/index.dart';
import '../models/user_model.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  Future<User> signInWithGoogle() async {
    // TODO: Implement Google sign in
    throw UnimplementedError();
  }

  Future<User> signInWithFacebook() async {
    // TODO: Implement Facebook sign in
    throw UnimplementedError();
  }

  Future<User> signInWithEmail(String email, String password) async {
    try {
      // Validate email format
      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }

      // Validate password length
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // TODO: Replace with actual API call
      // For now return mock user data
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      return User(
        id: 1,
        fullName: email.split('@')[0], // Use email prefix as name
        email: email,
        passwordHash: password, // In real app, this should be hashed
        role: UserRole.user,
        createdAt: DateTime.now(),
      );

    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> sendOtp(String email) async {
    // TODO: Implement send OTP
    // This should:
    // 1. Validate email format
    // 2. Generate OTP
    // 3. Send OTP to email
    // 4. Store OTP with email and expiration time in backend
    throw UnimplementedError();
  }

  Future<User> verifyOtpAndRegister(String email, String password, String otp) async {
    // TODO: Implement OTP verification and registration
    // This should:
    // 1. Verify OTP is valid and not expired
    // 2. Create new user account
    // 3. Return user data
    throw UnimplementedError();
  }
} 