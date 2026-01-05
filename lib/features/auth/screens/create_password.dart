// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';

class CreatePasswordScreen extends ConsumerStatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  ConsumerState<CreatePasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _verifying = false;

  String password = "";
  String confirmPassword = "";

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Password cannot be empty";
    if (value.length < 8) return "Password must be at least 8 characters";

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return "Password must include letters, numbers & special chars";
    }

    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "Please confirm password";
    if (value != password) return "Passwords do not match";
    return null;
  }

  Future<void> _createPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final data = await LocalStorage.getUser();
     if (!mounted) return;

    final employeeId = data?['user']?['employee_id'] ?? '';
    if (employeeId.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() => _verifying = true);

    try {
      final result = await _authService.createPassword(
        employeeId: employeeId,
        password: password,
        confirmPassword: confirmPassword,
      );
       if (!mounted) return;

      await LocalStorage.setPasswordCreated(true);
       if (!mounted) return;

      _showSnackBar(result["message"] ?? "Password created successfully");
      context.go("/transaction-screen");
    } catch (e) {
       if (!mounted) return;
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''), isError: true);
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    title: const Text(
                      'Create Password',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        color: Color(0xff0F2D62),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Set a strong password to secure your account',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Password Field
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F2D62),
                      fontFamily: "Inter",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPasswordField(),
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

                  // Confirm Password Field
                  const Text(
                    "Confirm Password",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F2D62),
                      fontFamily: "Inter",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 30),

                  // Submit Button
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: _gradientButton(
                        label: _verifying ? null : "Continue",
                        onPressed: _verifying ? null : _createPassword,
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

  Widget _buildPasswordField() {
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
              obscureText: _obscurePassword,
              onChanged: (value) => password = value,
              validator: _passwordValidator,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Create a strong password',
                hintStyle: const TextStyle(
                  color: Color(0xFFADAEBC),
                  fontSize: 16,
                  fontFamily: "Inter",
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
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

  Widget _buildConfirmPasswordField() {
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
              obscureText: _obscureConfirmPassword,
              onChanged: (value) => confirmPassword = value,
              validator: _confirmPasswordValidator,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Confirm your password',
                hintStyle: const TextStyle(
                  color: Color(0xFFADAEBC),
                  fontSize: 16,
                  fontFamily: "Inter",
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
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
