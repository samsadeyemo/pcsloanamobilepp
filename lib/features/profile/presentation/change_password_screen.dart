// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_profile_app_bar.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _verifying = false;

  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String? _oldPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "Old password cannot be empty";
    return null;
  }

  String? _newPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "New password cannot be empty";
    if (value.length < 8) return "Password must be at least 8 characters";

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return "Password must include letters, numbers & special chars";
    }

    if (value == oldPassword) {
      return "New password must be different from old password";
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "Please confirm password";
    if (value != newPassword) return "Passwords do not match";
    return null;
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _verifying = true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual API call when endpoint is ready
      // final result = await _authService.changePassword(
      //   oldPassword: oldPassword,
      //   newPassword: newPassword,
      //   confirmPassword: confirmPassword,
      // );

      _showSnackBar("Password changed successfully");
      
      // Clear form
      setState(() {
        oldPassword = "";
        newPassword = "";
        confirmPassword = "";
      });
      _formKey.currentState?.reset();
      
    } catch (e) {
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: CustomProfileAppBar(title: "Change Password"),
      //
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text(
                    'Update your password to keep your account secure',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Old Password Field
                  const Text(
                    "Old Password",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F2D62),
                      fontFamily: "Inter",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    obscureText: _obscureOldPassword,
                    onChanged: (value) => oldPassword = value,
                    validator: _oldPasswordValidator,
                    hintText: 'Enter your old password',
                    onToggleVisibility: () {
                      setState(() => _obscureOldPassword = !_obscureOldPassword);
                    },
                  ),
                  const SizedBox(height: 30),

                  // New Password Field
                  const Text(
                    "New Password",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F2D62),
                      fontFamily: "Inter",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    obscureText: _obscureNewPassword,
                    onChanged: (value) => newPassword = value,
                    validator: _newPasswordValidator,
                    hintText: 'Create a strong password',
                    onToggleVisibility: () {
                      setState(() => _obscureNewPassword = !_obscureNewPassword);
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(Icons.info, color: Color(0xffA198FF), size: 12),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Password must be at least 8 characters long & include letters, numbers & special chars',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff4B5563),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Confirm New Password Field
                  const Text(
                    "Confirm New Password",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F2D62),
                      fontFamily: "Inter",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(
                    obscureText: _obscureConfirmPassword,
                    onChanged: (value) => confirmPassword = value,
                    validator: _confirmPasswordValidator,
                    hintText: 'Confirm your new password',
                    onToggleVisibility: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                  const SizedBox(height: 30),

                  // Submit Button
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: _gradientButton(
                        label: _verifying ? null : "Change Password",
                        onPressed: _verifying ? null : _changePassword,
                        loading: _verifying,
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

  Widget _buildPasswordField({
    required bool obscureText,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    required String hintText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.lock, color: Color(0xff6B7280), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              obscureText: obscureText,
              onChanged: onChanged,
              validator: validator,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFFADAEBC),
                  fontSize: 16,
                  fontFamily: "Inter",
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: IconButton(
                  onPressed: onToggleVisibility,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xff9CA3AF),
                    size: 20,
                  ),
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientButton({
    required String? label,
    required VoidCallback? onPressed,
    required bool loading,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff7C70DF), Color(0xffA198FF)],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Text(
                  label ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
        ),
      ),
    );
  }
}