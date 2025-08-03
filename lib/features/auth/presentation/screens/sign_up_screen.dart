import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScren();
}

class _SignUpScren extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String staffId = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String bvn = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E7EB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(0xff0F2D62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Please fill in your information below',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInputField(
                        icon: Icons.badge_outlined,
                        label: 'Staff ID',
                        hintText: 'Enter your Staff ID',
                        onChanged: (value) => staffId = value,
                        validator:
                            (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Staff ID is required',
                      ),

                      CustomInputField(
                        icon: Icons.person,
                        label: 'First Name',
                        hintText: 'Enter your first name',
                        onChanged: (value) => firstName = value,
                        validator:
                            (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'First name is required',
                      ),

                      CustomInputField(
                        icon: Icons.person,
                        label: 'Last Name',
                        hintText: 'Enter your last name',
                        onChanged: (value) => lastName = value,
                        validator:
                            (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Last name is required',
                      ),

                      CustomInputField(
                        icon: Icons.phone,
                        label: 'Phone Number',
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => phoneNumber = value,
                        validator:
                            (value) =>
                                value != null && value.length >= 10
                                    ? null
                                    : 'Phone number must be at least 10 digits',
                      ),

                      CustomInputField(
                        icon: Icons.email,
                        label: 'Email',
                        hintText: 'Enter your email',
                        isOptional: true,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => email = value,
                        
                      ),

                      CustomInputField(
                        icon: Icons.shield_outlined,
                        label: 'BVN',
                        hintText: 'Enter your BVN',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => bvn = value,
                        validator:
                            (value) =>
                                value != null && value.length == 11
                                    ? null
                                    : 'BVN must be 11 digits',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // authState.status == AuthStatus.authenticating
                //     ? const CircularProgressIndicator()
                //     : 
                Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 1),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                savePhoneNumber(phoneNumber);
                                context.go('/verify-phone');
                                // try {
                                //   await ref
                                //       .read(authControllerProvider.notifier)
                                //       .signUp(
                                //         SignUpRequest(
                                //           firstName: firstName,
                                //           lastName: lastName,
                                //           staffId: staffId,
                                //           bvn: bvn,
                                //           phoneNumber: phoneNumber,
                                //         ),
                                //       );
                                //   context.go('/verify-phone');
                                // } catch (e) {
                                //   showDialog(
                                //     context: context,
                                //     builder:
                                //         (context) => AlertDialog(
                                //           backgroundColor: Colors.white,
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(10),
                                //           ),
                                //           content: Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             children: [
                                //               const Icon(
                                //                 Icons.error,
                                //                 color: Colors.red,
                                //                 size: 48,
                                //               ),
                                //               const SizedBox(height: 16),
                                //               Text(
                                //                 authState.errorMessage ??
                                //                     'Sign-up failed: Invalid data',
                                //                 style: const TextStyle(
                                //                   color: Color(0xff0F2D62),
                                //                   fontFamily: 'Inter',
                                //                   fontSize: 16,
                                //                   fontWeight: FontWeight.w500,
                                //                 ),
                                //                 textAlign: TextAlign.center,
                                //               ),
                                //             ],
                                //           ),
                                //           actions: [
                                //             TextButton(
                                //               onPressed:
                                //                   () => Navigator.of(context).pop(),
                                //               child: const Text(
                                //                 'OK',
                                //                 style: TextStyle(
                                //                   color: Color(0xffA198FF),
                                //                   fontFamily: 'Inter',
                                //                   fontSize: 14,
                                //                 ),
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //   );
                                // }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff7C70DF),
                                    Color(0xffA198FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Color(0xff4B5563),
                            fontSize: 14,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            context.go('/signIn');
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xffA198FF),
                              fontFamily: "Inter",
                            ),
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
    );
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
  }
}
