import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/signup_input_field.dart';
import 'package:pcsloan/features/auth/providers/signup_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScren();
}

class _SignUpScren extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers for editable fields
  final _staffIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _bvnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);
    ref.listen<SignupState>(signupProvider, (prev, next) {
      if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    // update controllers when data comes in
    if (state.employeeData != null) {
      _firstNameController.text = state.employeeData!['firstname'] ?? '';
      _lastNameController.text = state.employeeData!['lastname'] ?? '';
      _phoneController.text = state.employeeData!['phone'] ?? '';
      // these can still be edited by user
      _emailController.text = state.employeeData!['email'] ?? '';
      _bvnController.text = state.employeeData!['bvn'] ?? '';
    }

    return Scaffold(
      backgroundColor: const Color(0xffE5E7EB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    color: Color(0xff0F2D62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  'Please fill in your information below',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Staff ID (user enters, then fetch details)
                      SignupInputField(
                        icon: Icons.badge_outlined,
                        label: 'Staff ID',
                        hintText: 'Enter your Staff ID',
                        controller: _staffIdController,
                        validator:
                            (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Staff ID is required',
                      ),
                      const SizedBox(height: 8),
                      if (state.employeeData == null)
                        // ElevatedButton(
                        //   onPressed: () {
                        //     if (_staffIdController.text.isNotEmpty) {
                        //       notifier.fetchEmployee(_staffIdController.text);
                        //     }
                        //   },
                        //   child:
                        //       state.fetching
                        //           ? const SizedBox(
                        //             height: 20,
                        //             width: 20,
                        //             child: CircularProgressIndicator(
                        //               strokeWidth: 2,
                        //             ),
                        //           )
                        //           : const Text("Fetch Details"),
                        // ),
                        ElevatedButton(
                          onPressed: () {
                            if (_staffIdController.text.isNotEmpty) {
                              notifier.fetchEmployee(_staffIdController.text);
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
                                colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 24,
                              ),
                              child:
                                  state.fetching
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                      : const Text(
                                        "Fetch Details",
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
                      const SizedBox(height: 16),
                      // First Name (disabled)
                      SignupInputField(
                        icon: Icons.person,
                        label: 'First Name',
                        hintText: '',
                        controller: _firstNameController,
                        enabled: false,
                      ),

                      // Last Name (disabled)
                      SignupInputField(
                        icon: Icons.person,
                        label: 'Last Name',
                        hintText: '',
                        controller: _lastNameController,
                        enabled: false,
                      ),

                      // Phone Number (disabled, but we’ll save later)
                      SignupInputField(
                        icon: Icons.phone,
                        label: 'Phone Number',
                        hintText: '',
                        controller: _phoneController,
                        enabled: false,
                      ),

                      // Email (optional, user editable)
                      SignupInputField(
                        icon: Icons.email,
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        isOptional: true,
                      ),

                      // BVN (editable)
                      SignupInputField(
                        icon: Icons.shield_outlined,
                        label: 'BVN',
                        hintText: 'Enter your BVN',
                        controller: _bvnController,
                        keyboardType: TextInputType.phone,
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

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 1),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await savePhoneNumber(_phoneController.text);

                            await notifier.createAccount(
                              email: _emailController.text,
                              bvn: _bvnController.text,
                            );

                            if (state.error == null && state.accountCreated) {
                              context.go('/verify-phone');
                            } else if (state.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error!)),
                              );
                            }
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
                              colors: [Color(0xff7C70DF), Color(0xffA198FF)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child:
                                state.creating
                                    ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    )
                                    : const Text(
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
                        const Text(
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
                          child: const Text(
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
