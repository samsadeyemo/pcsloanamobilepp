import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/signup_input_field.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  // controllers
  final _staffIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _bvnController = TextEditingController();

  bool _fetching = false;
  bool _creating = false;
  Map<String, dynamic>? _employeeData;

  @override
  void initState() {
    super.initState();

    // Clear fields when staff ID is cleared
    _staffIdController.addListener(() {
      if (_staffIdController.text.isEmpty) {
        setState(() {
          _employeeData = null;
          _firstNameController.clear();
          _lastNameController.clear();
          _phoneController.clear();
          _emailController.clear();
          _bvnController.clear();
        });
      }
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _fetchEmployee() async {
    if (_staffIdController.text.isEmpty) {
      _showSnackBar("Staff ID is required", isError: true);
      return;
    }

    setState(() => _fetching = true);
    try {
      final data = await _authService.fetchEmployee(_staffIdController.text);

      setState(() {
  _employeeData = data;
  _firstNameController.text = data['first_name'] ?? data['firstname'] ?? '';
  _lastNameController.text = data['last_name'] ?? data['lastname'] ?? '';
  _phoneController.text = data['phone_number'] ?? data['phone'] ?? '';
  _emailController.text = data['email'] ?? '';
  _bvnController.text = data['bvn'] ?? '';
});

      _showSnackBar("Employee found successfully");
    } catch (e) {
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''), isError: true);
    } finally {
      setState(() => _fetching = false);
    }
  }

  Future<void> _createAccount() async {
    // final prefs = await SharedPreferences.getInstance();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _creating = true);
    try {
      final result = await _authService.registerUser(
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        bvn: _bvnController.text,
        employeeId: _staffIdController.text,
      );

      await LocalStorage.saveUser(result["data"]);
      // await LocalStorage.setFlag('account_created', true);
      String resultMessage = result["message"] ?? "Account created successfully";
      await LocalStorage.setAccountCreated(true);
      // await prefs.setBool('account_created', true);
      _showSnackBar(resultMessage);

      context.go('/verify-phone');
    } catch (e) {
     _showSnackBar(e.toString().replaceFirst('Exception: ', ''), isError: true);
    } finally {
      setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      SignupInputField(
                        icon: Icons.badge_outlined,
                        label: 'Staff ID',
                        hintText: 'Enter your Staff ID',
                        controller: _staffIdController,
                        validator: (value) =>
                            value != null && value.isNotEmpty
                                ? null
                                : 'Staff ID is required',
                      ),
                      const SizedBox(height: 8),

                      if (_employeeData == null)
                        _gradientButton(
                          label: _fetching ? null : "Fetch Details",
                          onPressed: _fetching ? null : _fetchEmployee,
                          loading: _fetching,
                        ),

                      const SizedBox(height: 16),

                      SignupInputField(
                        icon: Icons.person,
                         hintText: '',
                        label: 'First Name',
                        controller: _firstNameController,
                        enabled: false,
                      ),
                      SignupInputField(
                        icon: Icons.person,
                        label: 'Last Name',
                         hintText: '',
                        controller: _lastNameController,
                        enabled: false,
                      ),
                      SignupInputField(
                        icon: Icons.phone,
                        label: 'Phone Number',
                         hintText: '',
                        controller: _phoneController,
                        enabled: false,
                      ),
                      SignupInputField(
                        icon: Icons.email,
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        isOptional: true,
                      ),
                      SignupInputField(
                        icon: Icons.shield_outlined,
                        label: 'BVN',
                        hintText: 'Enter your BVN',
                        controller: _bvnController,
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
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
                      child: _gradientButton(
                        label: _creating ? null : "Continue",
                        onPressed: _creating ? null : _createAccount,
                        loading: _creating,
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
                          onPressed: () => context.go('/signIn'),
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

  Widget _gradientButton({
    required String? label,
    required VoidCallback? onPressed,
    required bool loading,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
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
