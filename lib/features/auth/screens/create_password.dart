// ignore_for_file: use_build_context_synchronously, unused_element, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool _obscurePassword = true;
  bool _obscurePassword1 = true;
  final _authService = AuthService();
    bool _verifying = false;


  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String password = "";
  String confirmPassword = "";

  Future<void> _createPassword() async {
    final data = await LocalStorage.getUser();
    final employeeId = data?['user']?['employee_id'] ?? '';
    if (employeeId == '') return;
    if (password == confirmPassword) {
      setState(() => _verifying = true);
      try {
        final result = await _authService.createPassword(
          employeeId: employeeId,
          password: password,
          confirmPassword: confirmPassword,
        );
        await LocalStorage.setPasswordCreated(true);

        String resultMessage =
            result["message"] ?? "Password created successfully";
        _showSnackBar(resultMessage, isError: false);
        setState(() => _verifying = false);
        await LocalStorage.setPasswordCreated(true);
        context.go("/transaction-screen");
      } catch (e) {
        _showSnackBar(
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
      }
    } else {
      // Show error message
      _showSnackBar("Passwords do not match", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text(
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
              Text(
                'Set a strong password to secure your account',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F2D62),
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Color(0xff6B7280), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        obscureText: _obscurePassword,
                        onChanged: (value) => password = value,
                        validator:
                            (value) =>
                                value != null && value.length >= 6
                                    ? null
                                    : "Password too short try again",
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Create a strong password',
                          hintStyle: TextStyle(
                            color: Color(0xFFADAEBC),
                            fontSize: 16,
                            fontFamily: "Inter",
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          // contentPadding: EdgeInsets.zero,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xff9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.info, color: Color(0xffA198FF), size: 12),
                  SizedBox(width: 10),
                  Text(
                    'Password must be at least 8 characters long',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4B5563),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F2D62),
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Color(0xff6B7280), size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        obscureText: _obscurePassword1,
                        onChanged: (value) => confirmPassword = value,
                        validator:
                            (value) =>
                                value != null && value.length >= 6
                                    ? null
                                    : "Password too short try again",
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Confirm your password',
                          hintStyle: TextStyle(
                            color: Color(0xFFADAEBC),
                            fontSize: 16,
                            fontFamily: "Inter",
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          // contentPadding: EdgeInsets.zero,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword1 = !_obscurePassword1;
                              });
                            },
                            icon: Icon(
                              _obscurePassword1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xff9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
                  // SizedBox(
                  //   width: 342,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       if (_obscurePassword == _obscurePassword1)
                  //         context.go("/transaction-screen");
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       padding: EdgeInsets.zero,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //     ),
                  //     child: Ink(
                  //       decoration: BoxDecoration(
                  //         gradient: const LinearGradient(
                  //           colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                  //         ),
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //       child: Container(
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           "Continue",
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w600,
                  //             fontFamily: 'Inter',
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                 
                // ],
              // ),
               Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, right: 0),
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
              ),
            ],
          ),
        ),
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
          child:
              loading
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
