// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custom_profile_app_bar.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';
import 'package:pcsloan/service/auth_service.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  bool _verifying = false;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  final _authService = AuthService();
  String oldPin = "";
  String newPin = "";
  String confirmNewPin = "";

  Future<void> _changePin() async {
    FocusScope.of(context).unfocus();

    if (oldPin.isEmpty || newPin.isEmpty || confirmNewPin.isEmpty) {
      _showSnackBar("Please fill all PIN fields", isError: true);
      return;
    }

    if (newPin != confirmNewPin) {
      _showSnackBar("New PINs do not match", isError: true);
      return;
    }

    if (oldPin == newPin) {
      _showSnackBar("New PIN must be different from old PIN", isError: true);
      return;
    }

    setState(() => _verifying = true);


    try {
      final result = await _authService.editUserPin(
        oldPin: oldPin,
        newPin: newPin,
        confirmNewPin: confirmNewPin,
      );
      if (!mounted) return;
      context.push('/user-profile');

      _showSnackBar(
        result["message"],
        isError: false,
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        e.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
    } finally {
      if(mounted) setState(() => _verifying = false);
    }

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5E7EB),
      appBar: CustomProfileAppBar(title: "Change Pin"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Update your transaction PIN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),

                // Old PIN
                const Text(
                  'Enter old PIN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.center,
                  child: PinCodeFields(
                    length: 4,
                    boxSize: 60,
                    onCompleted: (code) {
                      oldPin = code;
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // New PIN
                const Text(
                  'Enter new 4-digit PIN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.center,
                  child: PinCodeFields(
                    length: 4,
                    boxSize: 60,
                    onCompleted: (code) {
                      newPin = code;
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Confirm New PIN
                const Text(
                  'Confirm new 4-digit PIN',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.center,
                  child: PinCodeFields(
                    length: 4,
                    boxSize: 60,
                    onCompleted: (code) {
                      confirmNewPin = code;
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Info Box
                Container(
                  width: 430,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xffd9dbf1),
                    border: Border.all(color: Colors.transparent, width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        const SizedBox(height: 25, width: 30),
                        const Icon(
                          Icons.shield_sharp,
                          size: 20,
                          color: Color(0xffA198FF),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 12, width: 8),
                            const Text(
                              'This PIN will be required to authorize',
                              style: TextStyle(fontSize: 14),
                            ),
                            const Text(
                              "any financial activity on your account",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0),
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: _gradientButton(
                        label: _verifying ? null : "Change PIN",
                        onPressed: _verifying ? null : _changePin,
                        loading: _verifying,
                      ),
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
