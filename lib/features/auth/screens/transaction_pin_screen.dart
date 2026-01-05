// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pcsloan/common/widgets/custon_pin_code_field.dart';
import 'package:pcsloan/service/auth_service.dart';
import 'package:pcsloan/utils/local_storage.dart';

class TransactionPinScreen extends ConsumerStatefulWidget {
  const TransactionPinScreen({super.key});

  @override
  ConsumerState<TransactionPinScreen> createState() => _TransactionPinScreen();
}

class _TransactionPinScreen extends ConsumerState<TransactionPinScreen> {
  bool _verifying = false;
  final _authService = AuthService();


void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
}

  String pin = "";
  String confirmPin = "";

Future<void> _createPin() async {
    FocusScope.of(context).unfocus();
    final data = await LocalStorage.getUser();
    if (!mounted) return;
    final employeeId = data?['user']?['employee_id'] ?? '';
    if (employeeId == '') return;
    if (pin == confirmPin) {
        setState(() => _verifying = true);
        try{
          final result = await _authService.createTransactionPin(
            employeeId: employeeId,
            pin: pin,
            confirmPin: confirmPin,
          );
          if (!mounted) return;
          String resultMessage =
              result["message"] ?? "Transaction PIN created successfully";
          _showSnackBar(resultMessage, isError: false);
          await LocalStorage.setPinCreated(true);
           if (!mounted) return;
          setState(() => _verifying = false);
          context.go("/account-created-screen");
        } catch (e) {
          if (!mounted) return;
         _showSnackBar(
          e.toString().replaceFirst('Exception: ', ''),
          isError: true,
        );
          setState(() => _verifying = false); 
        }
    }else {
      _showSnackBar("Pins do not match", isError: true);
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E7EB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 25),

              Text(
                'Set Transaction PIN',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  color: Color(0xff0F2D62),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),
              Text(
                'Create a secure 4-digit PIN for your',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'transactions',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Create 4 -digit PIN',
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
                    pin = code;
                    // send to backend / verify
                    // print('User entered code: $code');
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Confirm 4-digit PIN',
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
                    confirmPin = code;
                    // send to backend / verify
                    // print('User entered code: $code');
                  },
                ),
              ),
              const SizedBox(height: 24),

              Container(
                // color: Color(0xffd9dbf1),
                width: 430,
                height: 70,

                decoration: BoxDecoration(
                  color: Color(0xffd9dbf1),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2.0, // Border thickness
                  ),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      const SizedBox(height: 25, width: 30),

                      Icon(
                        Icons.shield_sharp,
                        size: 20,
                        color: Color(0xffA198FF),
                      ),

                      Column(
                        children: [
                          const SizedBox(height: 12, width: 8),
                          Text(
                            'This PIN will be required to authorize',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
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

              Align(
                alignment: Alignment.center,
                child:
             
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, right: 0),
                    child: SizedBox(
                      width: 320,
                      height: 50,
                      child: _gradientButton(
                        label: _verifying ? null : "Continue",
                        onPressed: _verifying ? null : _createPin,
                        loading: _verifying,
                      ),
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
